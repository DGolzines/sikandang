export function timeAgo(dateStr) {
	const diff = Date.now() - new Date(dateStr).getTime();
	const mins = Math.floor(diff / 60000);
	if (mins < 1) return 'baru saja';
	if (mins < 60) return `${mins} menit lalu`;
	const hrs = Math.floor(mins / 60);
	if (hrs < 24) return `${hrs} jam lalu`;
	const days = Math.floor(hrs / 24);
	if (days < 30) return `${days} hari lalu`;
	const months = Math.floor(days / 30);
	if (months < 12) return `${months} bulan lalu`;
	return `${Math.floor(months / 12)} tahun lalu`;
}
