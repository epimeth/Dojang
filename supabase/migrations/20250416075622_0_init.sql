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
  academy_id uuid references academies(id) on delete cascade,
  name text not null,
  address text
);

create table user_academy_roles (
  user_id uuid references users(id) on delete cascade,
  academy_id uuid references academies(id) on delete cascade,
  roles integer not null,
  primary key (user_id, academy_id)
);

-- Student Management

create table students (
  id uuid primary key default gen_random_uuid(),
  academy_id uuid references academies(id) on delete cascade not null,
  full_name text not null,
  date_of_birth date,
  email text,
  phone_number text,
  address text,
  emergency_contact_name text,
  emergency_contact_phone text,
  joined_at date default current_date,
  status text not null default 'active' check (status in ('active', 'inactive', 'trial', 'on_hold', 'graduated')),
  profile_image_url text,
  notes text,
  created_at timestamp with time zone default now()
);


create table student_managers (
  student_id uuid references students(id) on delete cascade,
  manager_id uuid references users(id) on delete set null,
  primary key (student_id, manager_id)
);

-- Student Teams
create table teams (
  id uuid primary key default gen_random_uuid(),
  academy_id uuid references academies(id) on delete cascade not null,
  name text not null,
  description text,
  created_at timestamp with time zone default now()
);

create table team_students (
  team_id uuid references teams(id) on delete cascade,
  student_id uuid references students(id) on delete cascade,
  joined_at date default current_date,
  primary key (team_id, student_id)
);

-- Schedule & Calendar

create table class_templates (
  id uuid primary key default gen_random_uuid(),
  academy_id uuid references academies(id) on delete cascade,
  location_id uuid references locations(id) on delete cascade, -- Assuming locations are tied to an academy, this might need academy_id too or be fine if location_id implies academy_id
  name text not null,
  weekday smallint check (weekday between 0 and 6),
  start_time time,
  end_time time,
  starts_on date,
  ends_on date
);

create table events (
  id uuid primary key default gen_random_uuid(),
  academy_id uuid references academies(id) on delete cascade,
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

create table belts (
  id serial primary key, -- Using serial for auto-incrementing integer ID
  name text not null unique,
  color text not null, -- Hex color code
  rank smallint not null unique, -- For ordering
  b64svg text -- For storing base64 encoded SVG for the belt
);

create table belt_awards (
  id uuid primary key default gen_random_uuid(),
  student_id uuid references students(id) on delete cascade,
  event_id uuid references events(id) on delete set null,
  belt_id integer references belts(id) on delete set null,
  awarded_on date not null,
  notes text
);

-- Note: You might want to add an index on belt_awards(belt_id)
-- and on belts(rank) for performance if these tables grow large.
