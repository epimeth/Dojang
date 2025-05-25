// BeltLevel is the definition of a belt type (e.g., White, Yellow)
// It's used for current_belt and within BeltAwardWithDetails.
// The b64svg can be null if not provided in the database.
export type BeltLevel = {
  id: number; // Corresponds to belts.id
  name: string;
  color: string;
  order: number; // Corresponds to belts.rank
  b64svg?: string | null;
};

// Represents an individual belt award given to a student, including full belt details
export type BeltAwardWithDetails = {
  id: string; // belt_awards.id (UUID of the award itself)
  student_id: string;
  event_id: string | null;
  belt_id: number; // Foreign key to belts.id
  awarded_on: string; // Date string
  notes: string | null;
  belts: BeltLevel | null; // Joined details from the 'belts' table. Null if belt_id was null.
};

export type StudentManagerRelation = {
  manager_id: string;
};

export type StudentTeamRelation = {
  id: string; // team_id
  name: string;
};

// Defines the structure of a student object returned by the API
export type Student = {
  id: string;
  academy_id: string;
  full_name: string;
  date_of_birth: string | null;
  email: string | null;
  phone_number: string | null;
  address: string | null;
  emergency_contact_name: string | null;
  emergency_contact_phone: string | null;
  joined_at: string;
  status: string;
  last_class_attended?: string;
  profile_image_url: string | null;
  notes: string | null;
  created_at: string;

  // Relations
  student_managers: StudentManagerRelation[];
  teams: StudentTeamRelation[];
  belt_awards: BeltAwardWithDetails[]; // Array of all historical awards

  // Derived property added by the API
  current_belt?: BeltLevel | null;
};

export type StudentFilters = {
  search?: string;
  belt?: number;
  ageGroup?: string;
};