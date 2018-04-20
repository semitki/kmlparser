create or replace function pointpeer(elem integer) returns text as $$
select m.id, s.gid from \n
