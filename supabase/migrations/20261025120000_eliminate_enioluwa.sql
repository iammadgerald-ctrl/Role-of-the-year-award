create or replace function public.reject_enioluwa_votes()
returns trigger
language plpgsql
set search_path = ''
as $$
begin
  if new.nominee_id = 7 then
    raise exception using
      errcode = '23514',
      message = 'Enioluwa has been eliminated from voting.';
  end if;

  return new;
end;
$$;

drop trigger if exists reject_enioluwa_votes on public.award_votes;

create trigger reject_enioluwa_votes
before insert or update of nominee_id on public.award_votes
for each row
execute function public.reject_enioluwa_votes();

revoke all on function public.reject_enioluwa_votes() from public, anon, authenticated;
grant execute on function public.reject_enioluwa_votes() to service_role;
