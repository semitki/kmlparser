# -*- coding: UTF-8 -*-
import os
import sys
import json
import logging
from pykml.factory import write_python_script_for_kml_document
from pykml import parser
import urllib
from sqlalchemy import create_engine
from sqlalchemy import Column, Integer, String, JSON, ForeignKey
from sqlalchemy.orm import relationship, backref, sessionmaker
from sqlalchemy.ext.declarative import declarative_base

#log = logging.getLogger()

src = sys.argv[1]
outfile = src.split('.')[0] + '.py'

## DB stuff
Base = declarative_base()

def engine():
    echo = False
    if 'PYTHON_ENV' in os.environ and os.environ['PYTHON_ENV'] == 'development':
        echo=True
        return create_engine(os.environ['GERRI_DBURL'],
                         echo=echo)


class Manzana(Base):
    __tablename__ = 'manzanas_geojson'
    id = Column(Integer, primary_key=True)
    name = Column(String)
    seccion = Column(Integer, nullable=True)
    #seccion = Column(Integer, ForeignKey('public.api_seccion.id'), nullable=True)
    geoJSON = Column(JSON)


def insert(JSONpolygon, session):
    manzanas = []
    for poly in JSONpolygon:
        manzanas.append(Manzana(name=poly['properties']['CVEGEO'],
                geoJSON=poly))
    session.add_all(manzanas)
    session.commit()


def build_url (path, scheme='http'):
    return scheme + '://' + path


def parse(src):
    kml_file = urllib.urlopen(build_url(os.path.join(os.environ['GERRI_DATA'],
                                                       src),
                                          'file'))
    doc = parser.parse(kml_file).getroot()

    JSONpolygon = []

    try:
        for el in doc.Document.Folder.Placemark:
            polygon = el.Polygon.outerBoundaryIs.LinearRing
            data = el.ExtendedData.SchemaData[0].SimpleData
            props = {}
            for prop in data:
                    props.update({prop.attrib['name']: prop.text})

            JSONpolygon.append({
                'type': 'Feature',
                'geometry': {
                    'type': 'Polygon',
                    'coordinates': polygon.coordinates.text.strip().split(',')
                },
                'properties': props
            })

    except Exception:
        print(Exception)


    return JSONpolygon

def kml2py(doc):
    script = write_python_script_for_kml_document(doc)
    output = open(outfile, 'w')
    output.write(script)
    output.close()

def main():
    Session = sessionmaker()
    eng = engine()
    Session.configure(bind=eng)
    session = Session()
    if 'GERRI_BOOTSTRAP' in os.environ:
        Base.metadata.create_all(eng)
    insert(parse(src), session)

if __name__ == '__main__':
    main()
