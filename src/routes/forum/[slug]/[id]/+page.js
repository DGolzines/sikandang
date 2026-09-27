import { error } from '@sveltejs/kit';
import { getCategory } from '$lib/categories.js';

export const load = async ({ parent, params }) => {
	const category = getCategory(params.slug);
	if (!category) {
		throw error(404, 'Forum tidak ditemukan');
	}

	const { supabase } = await parent();

	const { data: question, error: qErr } = await supabase
		.from('questions')
		.select('*, profiles(username)')
		.eq('id', params.id)
		.single();

	if (qErr || !question) {
		throw error(404, 'Pertanyaan tidak ditemukan');
	}

	const { data: answers } = await supabase
		.from('answers')
		.select('*, profiles(username)')
		.eq('question_id', params.id)
		.order('created_at', { ascending: true });

	return {
		category,
		question,
		answers: answers ?? []
	};
};
