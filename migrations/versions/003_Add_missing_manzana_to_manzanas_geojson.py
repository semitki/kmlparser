from sqlalchemy import *
from migrate import *

def upgrade(migrate_engine):
    meta = MetaData(bind=migrate_engine)
    manzanas_geojson = Table('manzanas_geojson', meta, autoload=True)
    mza = Column('manzana', Integer)
    mza.create(manzanas_geojson)


def downgrade(migrate_engine):
    meta = MetaData(bind=migrate_engine)
    manzanas_geojson = Table('manzanas_geojson', meta, autoload=True)
    manzanas_geojson.c.manzana.drop()

