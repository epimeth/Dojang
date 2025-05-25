import type { PageLoad } from './$types';
import type { Student, StudentFilters, BeltLevel } from '$lib/types/student';
import { studentsService } from '$lib/services/students';
import { beltsService } from '$lib/services/belts';

export const load: PageLoad = async ({ url }) => {
  const search = url.searchParams.get('search') || undefined;
  const beltId = url.searchParams.get('belt') || undefined;

  const filters: StudentFilters = {};
  if (search) filters.search = search;
  if (beltId) filters.belt = beltId;

  try {
    // Fetch students based on filters from URL
    const students = await studentsService.getStudents(filters);
    
    // Fetch all belt levels for the filter dropdown
    const allBelts = beltsService.getAllBelts().sort((a, b) => a.order - b.order);

    return {
      students,
      allBelts,
      filters, // Return the filters used, so UI can be consistent
      error: null
    };
  } catch (err) {
    console.error('Error loading student data:', err);
    return {
      students: [],
      allBelts: [],
      filters,
      error: err instanceof Error ? err.message : 'An unknown error occurred while loading student data.'
    };
  }
};