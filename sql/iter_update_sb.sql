create function iter_usb() returns integer as'
declare
section record;

begin
	for section in
		select id from secciones_geojson
	loop
		perform update_sec_blocks(m.id, section.id)
		from manzanas_geojson m;
	end loop;
	return 1;
end
' language 'plpgsql';
