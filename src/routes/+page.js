export const load = async ({ parent }) => {
	const { supabase } = await parent();

	const { data: recentQuestions } = await supabase
		.from('questions')
		.select('id, title, description, category, image_url, created_at, profiles(username), answers(count)')
		.order('created_at', { ascending: false })
		.limit(6);

	return {
		recentQuestions: recentQuestions ?? []
	};
};
