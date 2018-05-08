create or replace function update_seccion_manzanas(manzana_id integer, seccion_id integer) returns integer as $$
BEGIN
  if (
    select st_coveredby(manzana, seccion) as maninsec
    from (
      select st_buffer(
        (select geom
          from manzanas_geo where id=manzana_id
        ), 1) as manzana,
      st_buffer(
        (select geom
          from secciones_geo where id = seccion_id
        ), 1.5) as seccion
    ) as foo
  )
  then
    update manzanas_geojson set seccion = seccion_id where id = manzana_id;
    return 1;
  else
    select 'no';
    return 0;
  end if;
END;
$$ LANGUAGE PLPGSQL;
