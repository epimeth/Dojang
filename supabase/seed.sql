-- Supabase Seed SQL
-- Clear existing data in reverse order of dependencies (or table creation with FKs)
DELETE FROM belt_awards; -- belt_awards references belts, so delete first or defer constraints
DELETE FROM belt_awards;
DELETE FROM attendance_intentions;
DELETE FROM event_invitations;
DELETE FROM team_students;
DELETE FROM teams;
DELETE FROM events;
DELETE FROM class_templates;
DELETE FROM belts; -- Clear belts table
DELETE FROM student_managers;
DELETE FROM students;
DELETE FROM user_academy_roles;
DELETE FROM locations;
DELETE FROM academies;
DELETE FROM users;

-- Use a DO block to declare variables for UUIDs for clarity and reusability
DO $$
DECLARE
    -- Core Entities
    user_admin_id uuid := 'a1970154-7033-406a-801e-d55081b8f09c';
    user_parent_id uuid := 'b2970154-7033-406a-801e-d55081b8f09d';
    user_instructor_id uuid := 'c3970154-7033-406a-801e-d55081b8f09e';
    user_parent_smith_id uuid := '0f970154-7033-406a-801e-d55081b8f0aa'; -- New Parent Smith

    academy_main_id uuid := 'd4970154-7033-406a-801e-d55081b8f09f';

    location_main_id uuid := 'e5970154-7033-406a-801e-d55081b8f0a0';
    location_annex_id uuid := 'f6970154-7033-406a-801e-d55081b8f0a1';

    -- Student Management
    student_alice_id uuid := '17970154-7033-406a-801e-d55081b8f0a2';
    student_bob_id uuid := '28970154-7033-406a-801e-d55081b8f0a3';
    student_charlie_id uuid := '39970154-7033-406a-801e-d55081b8f0a4';
    student_david_smith_id uuid := '99970154-7033-406a-801e-d55081b8f0ab'; -- New Student David Smith
    student_emily_smith_id uuid := 'aa970154-7033-406a-801e-d55081b8f0ac'; -- New Student Emily Smith

    -- Student Teams
    team_tiger_id uuid := 'bba70154-7033-406a-801e-d55081b8f0ad'; -- New Team Tiger ID

    -- Schedule & Calendar
    class_template_kids_id uuid := '4a970154-7033-406a-801e-d55081b8f0a5';
    class_template_adults_id uuid := '5b970154-7033-406a-801e-d55081b8f0a6';

    event_belt_test_id uuid := '6c970154-7033-406a-801e-d55081b8f0a7';
    event_holiday_id uuid := '7d970154-7033-406a-801e-d55081b8f0a8';
    event_tournament_id uuid := '8e970154-7033-406a-801e-d55081b8f0a9';

BEGIN

-- Core Entities

INSERT INTO users (id, email, full_name, created_at) VALUES
(user_admin_id, 'admin@dojang.com', 'Admin User', now()),
(user_parent_id, 'parent@example.com', 'Parent User', now()),
(user_instructor_id, 'instructor@dojang.com', 'Instructor Kim', now()),
(user_parent_smith_id, 'parent.smith@example.com', 'Parent Smith', now()); -- New Parent Smith

INSERT INTO academies (id, name, created_at) VALUES
(academy_main_id, 'Main Street Dojang', now());

INSERT INTO locations (id, academy_id, name, address) VALUES
(location_main_id, academy_main_id, 'Main Hall', '123 Main St, Anytown, USA'),
(location_annex_id, academy_main_id, 'Annex Building', '125 Main St, Anytown, USA');

-- User Organization Roles (e.g., 1: Admin, 2: Instructor, 3: Member/Parent)
INSERT INTO user_academy_roles (user_id, academy_id, roles) VALUES
(user_admin_id, academy_main_id, 1),
(user_instructor_id, academy_main_id, 2),
(user_parent_id, academy_main_id, 3), -- Parent User is associated with the academy
(user_parent_smith_id, academy_main_id, 3); -- Parent Smith is associated with the academy

-- Student Management
INSERT INTO students (
    id, academy_id, full_name, date_of_birth, email, phone_number, address,
    emergency_contact_name, emergency_contact_phone, joined_at, status,
    profile_image_url, notes
) VALUES
(
    student_alice_id, academy_main_id, 'Alice Wonderland', '2015-05-15',
    'alice.w@example.com', '555-0110', '10 Wonderland Ave',
    'Queen of Hearts', '555-0111', '2024-01-10', 'active',
    NULL, 'Curious student.'
),
(
    student_bob_id, academy_main_id, 'Bob The Builder', '2014-08-20',
    'bob.b@example.com', '555-0112', '20 Construction Rd',
    'Wendy', '555-0113', '2024-02-15', 'active',
    'https://example.com/profiles/bob.png', 'Can he kick it? Yes, he can!'
),
(
    student_charlie_id, academy_main_id, 'Charlie Brown', '2008-02-10',
    'charlie.b@example.com', '555-0114', '30 Good Grief Ln',
    'Snoopy (unofficial)', '555-0115', '2023-09-01', 'on_hold',
    NULL, 'Good grief. Needs encouragement.'
),
(
    student_david_smith_id, academy_main_id, 'David Smith', '2016-03-10',
    'david.s@example.com', '555-0116', '40 Smith Residence',
    'Parent Smith', '555-0100', '2025-01-05', 'trial',
    NULL, 'New trial student.'
),
(
    student_emily_smith_id, academy_main_id, 'Emily Smith', '2013-11-22',
    'emily.s@example.com', '555-0117', '40 Smith Residence',
    'Parent Smith', '555-0100', '2025-01-05', 'active',
    NULL, 'Eager to learn.'
);

INSERT INTO student_managers (student_id, manager_id) VALUES
(student_alice_id, user_parent_id),
(student_david_smith_id, user_parent_smith_id), -- David linked to Parent Smith
(student_emily_smith_id, user_parent_smith_id); -- Emily linked to Parent Smith

-- Student Teams
INSERT INTO teams (id, academy_id, name, description, created_at) VALUES
(team_tiger_id, academy_main_id, 'Team Tiger', 'Competitive Poomsae and Sparring Team for dedicated students.', now());

INSERT INTO team_students (team_id, student_id, joined_at) VALUES
(team_tiger_id, student_alice_id, current_date),    -- Alice joins Team Tiger
(team_tiger_id, student_bob_id, current_date),      -- Bob joins Team Tiger
(team_tiger_id, student_david_smith_id, current_date); -- David Smith joins Team Tiger

-- Schedule & Calendar

-- weekday: 0=Sunday, 1=Monday, ..., 6=Saturday
INSERT INTO class_templates (id, academy_id, location_id, name, weekday, start_time, end_time, starts_on, ends_on) VALUES
(class_template_kids_id, academy_main_id, location_main_id, 'Little Dragons (Ages 5-7)', 1, '16:00:00', '17:00:00', '2024-01-01', NULL), -- Mondays 4-5 PM
(class_template_adults_id, academy_main_id, location_main_id, 'Adult Taekwondo (All Levels)', 2, '19:00:00', '20:30:00', '2024-01-01', NULL); -- Tuesdays 7-8:30 PM

INSERT INTO events (id, academy_id, location_id, title, description, start_datetime, end_datetime, is_public, is_paid, event_type) VALUES
(event_belt_test_id, academy_main_id, location_main_id, 'Quarterly Belt Test', 'Belt promotion test for eligible students.', '2025-06-21 10:00:00+00', '2025-06-21 13:00:00+00', false, true, 'belt_test'),
(event_holiday_id, academy_main_id, NULL, 'Independence Day Closure', 'Dojang closed for Independence Day.', '2025-07-04 00:00:00+00', '2025-07-04 23:59:59+00', true, false, 'holiday'),
(event_tournament_id, academy_main_id, location_annex_id, 'Annual Intramural Tournament', 'Friendly competition for all students. Spectators welcome!', '2025-09-20 09:00:00+00', '2025-09-20 17:00:00+00', true, true, 'tournament');

INSERT INTO event_invitations (event_id, student_id) VALUES
(event_belt_test_id, student_alice_id),
(event_belt_test_id, student_bob_id),
(event_tournament_id, student_alice_id),
(event_tournament_id, student_bob_id),
(event_tournament_id, student_charlie_id);

-- Attendance Intentions
-- Assuming Alice intends to attend the Little Dragons class on Monday, April 21, 2025
-- (2025-04-21 is a Monday)
INSERT INTO attendance_intentions (class_template_id, date, student_id, marked_by_user_id, timestamp) VALUES
(class_template_kids_id, '2025-04-21', student_alice_id, user_parent_id, now()),
(class_template_kids_id, '2025-04-28', student_alice_id, user_parent_id, now());

-- Belts (Order: White, Yellow, Senior Yellow, Green, Senior Green, Blue, Senior Blue, Red, Senior Red, Black)
INSERT INTO belts (name, color, rank, b64svg) VALUES
('White','#FFFFFF', 1, 'B64PHN2Zz48cmVjdCB3aWR0aD0iMTAwJSIgaGVpZ2h0PSIxMDAlIiBmaWxsPSJnaG9zdHdoaXRlIiAvPjwvc3ZnPgo='),
('Yellow','#FFFF00', 2, 'PHN2Zz48cmVjdCB3aWR0aD0iMTAwJSIgaGVpZ2h0PSIxMDAlIiBmaWxsPSJnb2xkIiAvPjwvc3ZnPgo='),
('Senior Yellow','#FDEE00', 3, 'PHN2Zz48cmVjdCB3aWR0aD0iMTAwJSIgaGVpZ2h0PSIzMy4zMzMlIiBmaWxsPSJnb2xkIiAvPjxyZWN0IHk9IjMzLjMzMyUiIHdpZHRoPSIxMDAlIiBoZWlnaHQ9IjMzLjMzMyUiIGZpbGw9ImdyZWVuIiAvPjxyZWN0IHk9IjY2LjY2NiUiIHdpZHRoPSIxMDAlIiBoZWlnaHQ9IjMzLjMzMyUiIGZpbGw9ImdvbGQiIC8+PC9zdmc+Cg=='),
('Green', '#008000', 4, 'PHN2Zz48cmVjdCB3aWR0aD0iMTAwJSIgaGVpZ2h0PSIxMDAlIiBmaWxsPSJncmVlbiIgLz48L3N2Zz4K'),
('Senior Green','#006400', 5, 'PHN2Zz48cmVjdCB3aWR0aD0iMTAwJSIgaGVpZ2h0PSIzMy4zMzMlIiBmaWxsPSJncmVlbiIgLz48cmVjdCB5PSIzMy4zMzMlIiB3aWR0aD0iMTAwJSIgaGVpZ2h0PSIzMy4zMzMlIiBmaWxsPSJtZWRpdW1ibHVlIiAvPjxyZWN0IHk9IjY2LjY2NiUiIHdpZHRoPSIxMDAlIiBoZWlnaHQ9IjMzLjMzMyUiIGZpbGw9ImdyZWVuIiAvPjwvc3ZnPgo='),
('Blue', '#0000FF', 6, 'PHN2Zz48cmVjdCB3aWR0aD0iMTAwJSIgaGVpZ2h0PSIxMDAlIiBmaWxsPSJtZWRpdW1ibHVlIiAvPjwvc3ZnPgo='),
('Senior Blue', '#0000CD', 7, 'PHN2Zz48cmVjdCB3aWR0aD0iMTAwJSIgaGVpZ2h0PSIzMy4zMzMlIiBmaWxsPSJtZWRpdW1ibHVlIiAvPjxyZWN0IHk9IjMzLjMzMyUiIHdpZHRoPSIxMDAlIiBoZWlnaHQ9IjMzLjMzMyUiIGZpbGw9ImZpcmVicmljayIgLz48cmVjdCB5PSI2Ni42NjYlIiB3aWR0aD0iMTAwJSIgaGVpZ2h0PSIzMy4zMzMlIiBmaWxsPSJtZWRpdW1ibHVlIiAvPjwvc3ZnPgo='),
('Red', '#FF0000', 8, 'PHN2Zz48cmVjdCB3aWR0aD0iMTAwJSIgaGVpZ2h0PSIxMDAlIiBmaWxsPSJmaXJlYnJpY2siIC8+PC9zdmc+Cg=='),
('Senior Red', '#DC143C', 9, 'PHN2Zz48cmVjdCB3aWR0aD0iMTAwJSIgaGVpZ2h0PSI1MCUiIGZpbGw9ImJsYWNrIiAvPjxyZWN0IHk9IjUwJSIgd2lkdGg9IjEwMCUiIGhlaWdodD0iNTAlIiBmaWxsPSJmaXJlYnJpY2siIC8+PC9zdmc+Cg=='),
('Black', '#000000', 10, 'PHN2Zz48cmVjdCB3aWR0aD0iMTAwJSIgaGVpZ2h0PSIxMDAlIiBmaWxsPSJibGFjayIgLz48L3N2Zz4K');

-- Belt Awards
-- Using gen_random_uuid() for IDs as they are not referenced elsewhere in this seed script.
-- We will use the rank as a proxy for ID here, assuming belts are inserted in order and IDs are 1-10.
-- A more robust seed would SELECT the ID based on belt name.

INSERT INTO belt_awards (id, student_id, event_id, belt_id, awarded_on, notes) VALUES
(gen_random_uuid(), student_alice_id, NULL, 1, '2024-09-01', 'Initial belt upon joining.'),
(gen_random_uuid(), student_bob_id, NULL, 2, '2024-10-15', 'Initial belt upon joining.'),
(gen_random_uuid(), student_charlie_id, NULL, 3, '2024-12-10', 'Progressing well.'),
(gen_random_uuid(), student_david_smith_id, NULL, 1, '2025-01-05', 'Initial belt upon joining.'),
(gen_random_uuid(), student_emily_smith_id, NULL, 2, '2025-01-05', 'Initial belt upon joining.');

-- Example of a belt awarded at an event
-- This assumes student_alice_id was promoted at event_belt_test_id.
-- For this to be logical, the event_belt_test_id date should be after her 'White Belt' award.
-- The current event_belt_test_id is '2025-06-21', which is after '2024-09-01'.
INSERT INTO belt_awards (id, student_id, event_id, belt_id, awarded_on, notes) VALUES
(gen_random_uuid(), student_alice_id, event_belt_test_id, 2, '2025-06-21', 'Promoted to Yellow at quarterly belt test.');


END $$;

-- You can add more data as needed following the patterns above.
-- Remember to respect foreign key constraints and data types.

-- To run this seed file with Supabase CLI:
-- 1. Make sure your Supabase local development server is running: `supabase start`
-- 2. Apply migrations if you haven't: `supabase db reset` (this will also run seed.sql if it exists)
--    OR, to run only the seed file against a running local db: `psql -U postgres -h localhost -p 54322 -d postgres -f supabase/seed.sql`
--    (Adjust port if necessary, check `supabase status`)

-- For a deployed Supabase instance, you can run this SQL directly in the Supabase Studio SQL Editor.