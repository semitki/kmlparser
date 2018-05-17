

    -- Extract only coordinates from the string
    select replace(
      replace(
        replace(geojson->'geometry'->>'coordinates','"',''),
      '[',''),
    ']','')
    from manzanas_geojson
    where id = 884;


    -- Get a Block PostGIS Polygon
    select ST_GEOMFROMTEXT(
      'POLYGON(('||replace(replace(replace(geojson->'geometry'->>'coordinates','"',''),'[',''),']','')||'))')
      as manzana
    from manzanas_geojson
    where id = 883;


    -- Get a Section PostGIS Polygon
    select
    ST_GEOMFROMTEXT('POLYGON(('||replace(replace(replace(geojson->'geometry'->>'coordinates','"',''),'[',''),']','')||'))')
    as seccion
    from secciones_geojson where gid = 221;


    -- Return true if manzana is covered by seccion
    select st_coveredby(manzana, seccion) as maninsec
    from (
      select st_buffer(
        (select st_geomfromtext(
          'POLYGON(('||replace(replace(replace(geojson->'geometry'->>'coordinates','"',''),'[',''),']','')||'))')
          from manzanas_geojson where id=883
        ), 10) as manzana,
      st_buffer(
        (select st_geomfromtext(
          'POLYGON(('||replace(replace(replace(geojson->'geometry'->>'coordinates','"',''),'[',''),']','')||'))')
          from secciones_geojson where gid = 1
        ), 20) as seccion
    ) as foo;


    -- Return GoeJSON from spatial query
    select m.seccion, m.geojson->'properties' as prop,
      st_asgeojson(s.geom) as geom
    from manzanas_geo s
      join manzanas_geojson m on m.id = s.id


    -- Update api_seccion with gis data
    update api_seccion set "GeoJson"=s.geojson, "Wkb"=s.wkb
    from (select id,geojson,wkb from secciones_geojson) as s
    where api_seccion."Seccion" = s.id;

    -- Populate api_manzana
    insert into api_manzana
      ("Seccion_id","GeoJson","Wkb","Properties", "Manzana")
    select s.id,m.geojson,m.wkb,m.properties,
      (m.properties->>'MZA')::int as manzana
      from manzanas_geojson m join api_seccion s on s."Seccion" = m.seccion;

