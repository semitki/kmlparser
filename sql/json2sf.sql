---
--- Blocks pivot table GIS enabled
---
drop table if exists manzanas_geo;

create table manzanas_geo(
  id integer primary key,
  cvegeo varchar(255),
  manzana integer,
  geom geometry(Polygon, 4326)); -- 0 defaults to 4326 WSG834

-- Raw data as importe from KML sources is dirty, some replace magi for cleanup
insert into manzanas_geo (id, cvegeo, manzana, geom)
select id, geojson->'properties'->>'CVEGEO' as cvegeo, manzana,
  ST_GEOMFROMTEXT(
  'POLYGON(('||replace(replace(replace(geojson->'geometry'->>'coordinates','"',''),'[',''),']','')||'))',4326)
  as geom
from manzanas_geojson;

-- UPDATE blocks table with WKB and GeoJSON encoded data
update manzanas_geojson set wkb = m.geom
from (
  select id, geom from manzanas_geo
) as m where manzanas_geojson.id = m.id;
update manzanas_geojson set geojson = st_asgeojson(m.geom)::json
from (
  select id, geom from manzanas_geo
) as m where manzanas_geojson.id = m.id;


---
--- Sections pivot gis enabled
---
drop table if exists secciones_geo;

create table secciones_geo(
  id integer primary key,
  geom geometry(Polygon, 4326));

-- Raw data as importe from KML sources is dirty, some replace magi for cleanup
insert into secciones_geo (id, geom)
select id,
  ST_GEOMFROMTEXT('POLYGON(('||replace(replace(replace(geojson->'geometry'->>'coordinates','"',''),'[',''),']','')||'))',4326)
  as geom
  from secciones_geojson;

update secciones_geojson set wkb = s.geom
from(
  select id, geom from secciones_geo
) as s where secciones_geojson.id = s.id;
update secciones_geojson set geojson = st_asgeojson(s.geom)::json
from (select id, geom from secciones_geo) as s where secciones_geojson.id = s.id;
