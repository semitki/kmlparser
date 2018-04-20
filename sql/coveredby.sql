create or replace function update_seccion_manzanas(manzana_id integer, seccion_gid integer) returns integer as $$
BEGIN
  if (
    select st_coveredby(manzana, seccion) as maninsec
    from (
      select st_buffer(
        (select geom
          from manzanas_geo where id=manzana_id
        ), 0.1) as manzana,
      st_buffer(
        (select geom
          from secciones_geo where gid = seccion_gid
        ), 0.1) as seccion
    ) as foo
  )
  then
    update manzanas_geojson set seccion = seccion_gid where id = manzana_id;
    return 1;
  else
    update manzanas_geojson set seccion = null where id = manzana_id;
    return 0;
  end if;
END;
$$ LANGUAGE PLPGSQL;
