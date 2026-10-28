-- The Focus Game: one table for anonymous round scores.
-- Paste this whole file into Supabase > SQL Editor > New query, then click Run.

create table if not exists public.plays (
  id          bigint generated always as identity primary key,
  created_at  timestamptz not null default now(),
  session     text not null check (char_length(session) between 1 and 40),
  r1_score    int  not null check (r1_score between 0 and 500),
  r1_focus    int  not null check (r1_focus between 0 and 100),
  r2_score    int  not null check (r2_score between 0 and 500),
  r2_focus    int  not null check (r2_focus between 0 and 100),
  r3_score    int  not null check (r3_score between 0 and 500),
  r3_focus    int  not null check (r3_focus between 0 and 100),
  r2_taps     int  not null check (r2_taps between 0 and 1000),
  attempt     int  not null default 1 check (attempt between 1 and 1000)
);

-- For a table created before replays were tracked (1 = first play on that phone).
alter table public.plays add column if not exists attempt int not null default 1 check (attempt between 1 and 1000);

alter table public.plays enable row level security;

-- Anyone with the game link may add one anonymous row and read the room's rows.
-- Nobody can change or delete rows from the browser.
drop policy if exists "anyone can add a play" on public.plays;
create policy "anyone can add a play" on public.plays
  for insert to anon with check (true);

drop policy if exists "anyone can read plays" on public.plays;
create policy "anyone can read plays" on public.plays
  for select to anon using (true);

create index if not exists plays_session_idx on public.plays (session, created_at);
