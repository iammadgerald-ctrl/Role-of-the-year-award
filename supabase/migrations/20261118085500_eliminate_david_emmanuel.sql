create or replace function public.reject_eliminated_nominee_votes()
returns trigger
language plpgsql
set search_path = ''
as $$
begin
  if new.nominee_id in (1, 2, 6, 7) then
    raise exception using
      errcode = '23514',
      message = 'This nominee has been eliminated from voting.';
  end if;

  return new;
end;
$$;

drop trigger if exists reject_eliminated_nominee_votes on public.award_votes;

create trigger reject_eliminated_nominee_votes
before insert or update of nominee_id on public.award_votes
for each row
execute function public.reject_eliminated_nominee_votes();

revoke all on function public.reject_eliminated_nominee_votes() from public, anon, authenticated;
grant execute on function public.reject_eliminated_nominee_votes() to service_role;
