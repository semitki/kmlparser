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

update manzanas_geojson set wkb = m.geom
from (
  select id, geom from manzanas_geo
) as m where manzanas_geojson.id = m.id;

update manzanas_geojson set geojson = st_asgeojson(m.geom)::json
from (
  select id, geom from manzanas_geo
) as m where manzanas_geojson.id = m.id;


--drop table if exists secciones_geo;

--create table secciones_geo(
--  gid integer primary key,
--  geom geometry(Polygon, 4326));

--insert into secciones_geo (gid, geom)
--select gid,
--  ST_GEOMFROMTEXT('POLYGON(('||replace(replace(replace(geojson->'geometry'->>'coordinates','"',''),'[',''),']','')||'))',4326)
--  as geom
--  from secciones_geojson;


