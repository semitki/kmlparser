# -*- coding: UTF-8 -*-
import os
import sys
import json
import logging
import traceback
from pykml.factory import write_python_script_for_kml_document
from pykml import parser
import urllib
from sqlalchemy import Column, Integer, String, JSON, ForeignKey
from sqlalchemy.orm import relationship, backref, sessionmaker
from sqlalchemy.ext.declarative import declarative_base
from util import build_url, engine

#log = logging.getLogger()

src = sys.argv[1]
outfile = src.split('.')[0] + '.py'

## DB stuff
Base = declarative_base()

class Section(Base):
    __tablename__ = 'secciones_geojson'
    gid = Column(Integer, primary_key=True)
    geojson = Column(JSON)


def insert(JSONpolygon, session):
    sections = []
    for poly in JSONpolygon:
        sections.append(Section(geojson=poly))
    session.add_all(sections)
    session.commit()


def parse(src):
    kml_file = urllib.urlopen(build_url(os.path.join(os.environ['KML_DATA'],
                                                       src),
                                          'file'))
    doc = parser.parse(kml_file).getroot()

    JSONpolygon = []

    try:
        for el in doc.Document.Placemark:
            polygon = el.Polygon.outerBoundaryIs.LinearRing
            data = el.ExtendedData.Data
            props = {}
            for prop in data:
                    props.update({prop.attrib['name']: prop.value.text})
            # Clean coordinates data
            c_coords = [float(c) for c in polygon.coordinates.text.strip().replace('\n', ',').replace(' ', '').split(',') if c != '0']
            coords = [str(lat)+' '+str(lon) for lat,lon in zip(c_coords[0::2],c_coords[1::2])]
            JSONpolygon.append({
                'type': 'Feature',
                'geometry': {
                    'type': 'Polygon',
                    'coordinates': coordinates
                },
                'properties': props
            })

    except Exception:
        print(traceback.format_exc())

    return JSONpolygon

def main():
    Session = sessionmaker()
    eng = engine()
    Session.configure(bind=eng)
    session = Session()
    if 'KML_BOOTSTRAP' in os.environ:
        Base.metadata.create_all(eng)
    insert(parse(src), session)

if __name__ == '__main__':
    main()
