import { error } from '@sveltejs/kit';
import { getCategory } from '$lib/categories.js';

export const load = async ({ parent, params }) => {
	const category = getCategory(params.slug);
	if (!category) {
		throw error(404, 'Forum tidak ditemukan');
	}

	const { supabase } = await parent();

	const { data: questions, error: qError } = await supabase
		.from('questions')
		.select('id, title, description, image_url, created_at, user_id, profiles(username), answers(count)')
		.eq('category', params.slug)
		.order('created_at', { ascending: false });

	if (qError) {
		console.error(qError);
	}

	return {
		category,
		questions: questions ?? []
	};
};
