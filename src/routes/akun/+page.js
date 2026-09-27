import { redirect } from '@sveltejs/kit';

export const load = async ({ parent }) => {
	const { user, supabase } = await parent();
	if (!user) {
		throw redirect(303, '/login');
	}

	const { data: myQuestions } = await supabase
		.from('questions')
		.select('id, title, category, created_at')
		.eq('user_id', user.id)
		.order('created_at', { ascending: false });

	return { myQuestions: myQuestions ?? [] };
};
