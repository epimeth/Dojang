import { redirect } from '@sveltejs/kit'

import type { Actions } from './$types'

export const actions: Actions = {
  signup: async ({ request, locals: { supabaseAdmin } }) => {
    const formData = await request.formData()
    const email = formData.get('email') as string

    const { error } = await supabaseAdmin.auth.admin.inviteUserByEmail(email, {
      redirectTo: 'http://localhost:5173/app'
    })
    if (error) {
      console.error(error)
      redirect(303, '/auth/error')
    } else {
      redirect(303, '/')
    }
  },
  login: async ({ request, locals: { supabase } }) => {
    const formData = await request.formData()
    const email = formData.get('email') as string

    const { error } = await supabase.auth.signInWithOtp({ email, options: {
        emailRedirectTo: 'http://localhost:5173/auth/callback',
        shouldCreateUser: false
    } })

    if (error) {
      console.error(error)
      redirect(303, '/auth/error')
    } else {
      redirect(303, '/auth/mail-sent')
    }
  },
}