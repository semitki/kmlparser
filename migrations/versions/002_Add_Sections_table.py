from sqlalchemy import *
from migrate import *
from geoalchemy2 import Geometry

meta = MetaData()

secciones_geojson = Table(
    'secciones_geojson', meta,
    Column('id', Integer, primary_key=True),
    Column('geojson', JSON),
    Column('wkb', Geometry(geometry_type='POLYGON', srid=4326)),
)


def upgrade(migrate_engine):
    meta.bind = migrate_engine
    secciones_geojson.create()

def downgrade(migrate_engine):
    meta.bind = migrate_engine
    secciones_geojson.drop()
