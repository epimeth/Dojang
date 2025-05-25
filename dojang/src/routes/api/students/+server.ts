import { json } from '@sveltejs/kit';
import type { RequestHandler } from './$types';
import type { BeltLevel, Student } from '$lib/types/student';

export const GET: RequestHandler = async ({ locals, url }) => {
  const { supabase, session } = locals;
  
  if (!session) {
    return new Response('Unauthorized', { status: 401 });
  }

  const search = url.searchParams.get('search');
  const belt = url.searchParams.get('belt');

  let query = supabase
    .from('students')
    .select(`
      *,
      student_managers(manager_id),
      teams(id, name),
      belt_awards(*, belts(*))
    `)
    .order('awarded_on', { foreignTable: 'belt_awards', ascending: false }); // Pre-sort for easier current_belt determination

  // Apply role-based filters
  if (session.user.user_metadata.role === 'parent') {
    query = query.eq('student_managers.manager_id', session.user.id);
  }

  // Apply search filters
  if (search) {
    query = query.ilike('full_name', `%${search}%`);
  }
  if (belt) {
    // Filter students who have at least one belt_award matching the given belt_id
    query = query.eq('belt_awards.belt_id', Number(belt));
  }

  const { data, error } = await query;

  if (error) {
    console.error('Error fetching students:', error);
    return new Response(error.message, { status: 400 });
  }

  // Process data to add current_belt
  const processedData = data?.map(student => {
    let currentBelt: BeltLevel | null = null;
    // Ensure belt_awards is an array and has items
    if (Array.isArray(student.belt_awards) && student.belt_awards.length > 0) {
      // Awards are pre-sorted by 'awarded_on' descending by the query
      const latestAward = student.belt_awards[0];
      if (latestAward && latestAward.belts) {
        // latestAward.belts is the joined 'belts' table record
        currentBelt = latestAward.belts as BeltLevel;
      }
    }
    return {
      ...student,
      current_belt: currentBelt
    } as Student; // Asserting the type after adding current_belt
  }) || [];

  return json(processedData);
};


export const POST: RequestHandler = async ({ locals, request }) => {
  const { supabase, session } = locals;
  
  if (!session || session.user.user_metadata.role !== 'admin') {
    return new Response('Unauthorized', { status: 401 });
  }

  const student = await request.json();
  
  const { data, error } = await supabase
    .from('students')
    .insert(student)
    .select()
    .single();

  if (error) {
    return new Response(error.message, { status: 400 });
  }

  return json(data);
};