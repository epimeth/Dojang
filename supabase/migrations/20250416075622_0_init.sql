-- 20250417T000000_0_init.sql

-- Core Entities

create table users (
  id uuid primary key default gen_random_uuid(),
  email text not null unique,
  full_name text,
  created_at timestamp with time zone default now()
);

create table academies (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  created_at timestamp with time zone default now()
);

create table locations (
  id uuid primary key default gen_random_uuid(),
  organization_id uuid references academies(id) on delete cascade,
  name text not null,
  address text
);

create table user_organization_roles (
  user_id uuid references users(id) on delete cascade,
  organization_id uuid references academies(id) on delete cascade,
  roles integer not null,
  primary key (user_id, organization_id)
);

-- Student Management

create table students (
  id uuid primary key default gen_random_uuid(),
  organization_id uuid references academies(id) on delete cascade,
  full_name text not null,
  date_of_birth date
);

create table student_parents (
  student_id uuid references students(id) on delete cascade,
  parent_user_id uuid references users(id) on delete cascade,
  primary key (student_id, parent_user_id)
);

create table belt_awards (
  id uuid primary key default gen_random_uuid(),
  student_id uuid references students(id) on delete cascade,
  event_id uuid references events(id) on delete set null,
  belt_level text not null,
  awarded_on date not null,
  notes text
);

-- Schedule & Calendar

create table class_templates (
  id uuid primary key default gen_random_uuid(),
  organization_id uuid references academies(id) on delete cascade,
  location_id uuid references locations(id) on delete cascade,
  name text not null,
  weekday smallint check (weekday between 0 and 6),
  start_time time,
  end_time time,
  starts_on date,
  ends_on date
);

create table events (
  id uuid primary key default gen_random_uuid(),
  organization_id uuid references academies(id) on delete cascade,
  location_id uuid references locations(id) on delete set null,
  title text not null,
  description text,
  start_datetime timestamp with time zone,
  end_datetime timestamp with time zone,
  is_public boolean default false,
  is_paid boolean default false,
  event_type text check (event_type in ('belt_test', 'holiday', 'tournament', 'other'))
);

create table event_invitations (
  event_id uuid references events(id) on delete cascade,
  student_id uuid references students(id) on delete cascade,
  primary key (event_id, student_id)
);

create table attendance_intentions (
  class_template_id uuid references class_templates(id) on delete cascade,
  date date,
  student_id uuid references students(id) on delete cascade,
  marked_by_user_id uuid references users(id) on delete set null,
  timestamp timestamp with time zone default now(),
  primary key (class_template_id, date, student_id)
);
