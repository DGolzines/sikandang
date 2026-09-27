import { fail, redirect } from '@sveltejs/kit';

export const actions = {
	default: async ({ request, locals: { supabase } }) => {
		const formData = await request.formData();
		const username = String(formData.get('username') || '').trim();
		const email = String(formData.get('email') || '').trim();
		const password = String(formData.get('password') || '');

		if (!username || !email || !password) {
			return fail(400, { error: 'Semua kolom wajib diisi.', username, email });
		}
		if (password.length < 6) {
			return fail(400, { error: 'Kata sandi minimal 6 karakter.', username, email });
		}

		const { data, error } = await supabase.auth.signUp({
			email,
			password,
			options: {
				data: { username }
			}
		});

		if (error) {
			return fail(400, { error: error.message, username, email });
		}

		if (data.session) {
			// Konfirmasi email tidak diaktifkan di project Supabase -> langsung login
			throw redirect(303, '/');
		}

		return {
			success: true,
			message: 'Pendaftaran berhasil! Silakan cek email Anda untuk konfirmasi sebelum masuk.'
		};
	}
};
