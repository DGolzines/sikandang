import { redirect, error } from '@sveltejs/kit';
import { getCategory } from '$lib/categories.js';

export const load = async ({ parent, params }) => {
	const category = getCategory(params.slug);
	if (!category) {
		throw error(404, 'Forum tidak ditemukan');
	}

	const { user } = await parent();
	if (!user) {
		throw redirect(303, '/login');
	}

	return { category };
};
