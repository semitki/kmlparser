drop table if exists manzanas_geo;

create table manzanas_geo(
  id integer primary key,
  cvegeo varchar(255),
  geom geometry(Polygon, 4326)); -- 0 defaults to 4326 WSG834

insert into manzanas_geo (id, cvegeo, geom)
select id, geojson->'properties'->>'CVEGEO' as cvegeo,
  ST_GEOMFROMTEXT(
  'POLYGON(('||replace(replace(replace(geojson->'geometry'->>'coordinates','"',''),'[',''),']','')||'))',4326)
  as geom
from manzanas_geojson;


drop table if exists secciones_geo;

create table secciones_geo(
  gid integer primary key,
  geom geometry(Polygon, 4326));

insert into secciones_geo (gid, geom)
select gid,
  ST_GEOMFROMTEXT('POLYGON(('||replace(replace(replace(geojson->'geometry'->>'coordinates','"',''),'[',''),']','')||'))',4326)
  as geom
  from secciones_geojson;


