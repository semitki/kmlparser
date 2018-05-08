from sqlalchemy import *
from migrate import *
from geoalchemy2 import Geometry


meta = MetaData()

manzanas_geojson = Table(
    'manzanas_geojson', meta,
    Column('id', Integer, primary_key=True),
    Column('cvegeo', String(255)),
    Column('seccion', Integer),
    Column('geojson', JSON),
    Column('wkb', Geometry(geometry_type='POLYGON', srid=4326)),
    Column('properties', JSON),
)


def upgrade(migrate_engine):
    meta.bind = migrate_engine
    manzanas_geojson.create()


def downgrade(migrate_engine):
    meta.bind = migrate_engine
    manzanas_geojson.drop()
