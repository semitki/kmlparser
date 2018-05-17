create or replace function update_sec_blocks(block_id integer, section_id integer) returns integer as $$
-- 1594 sectio
-- 46680, 46687
BEGIN
  if (
    select st_coveredby(manzana, seccion) as man_sec
    from (select st_buffer((select wkb from manzanas_geojson where id = block_id), 1.005) as manzana,
      st_buffer((select wkb from secciones_geojson where id = section_id), 1.05) as seccion
    ) as foo
  )
  then
    update manzanas_geojson set seccion = section_id where id = block_id;
    return 1;
  else
    perform 'no';
    return 0;
  end if;
END;
$$ LANGUAGE PLPGSQL;
