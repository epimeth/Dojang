import { redirect } from '@sveltejs/kit';
import type { PageServerLoad } from './$types';

export const load: PageServerLoad = async ({ locals }) => {
  const { session } = locals;

  if (!session) {
    throw redirect(303, '/login');
  }

  return {
    user: {
      role: session.user.user_metadata.role,
      id: session.user.id
    }
  };
};