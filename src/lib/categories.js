// Data forum & konten edukasi peternakan SIKANDANG.
// Setiap kategori punya artikel edukasi yang tampil di halaman forum-nya.

export const categories = [
	{
		slug: 'stres-musim-hujan',
		title: 'Cara Mengatasi Ternak Stres Saat Musim Hujan',
		short: 'Kenali tanda stres pada ternak saat cuaca ekstrem dan cara menanganinya sebelum jadi penyakit.',
		icon: '🌧️',
		image:
			'https://images.unsplash.com/photo-1516467508483-a7212febe31a?auto=format&fit=crop&w=1200&q=80',
		article: {
			intro:
				'Musim hujan membawa udara lembap, suhu kandang yang naik-turun drastis, dan pakan yang lebih cepat basi. Ketiganya adalah pemicu utama stres pada sapi, kambing, dan unggas. Ternak yang stres cenderung menurun nafsu makannya, lebih rentan diare, dan produksinya (susu, telur, bobot badan) ikut anjlok.',
			points: [
				{
					heading: 'Jaga kandang tetap kering',
					text: 'Genangan air dan lantai basah adalah sumber stres nomor satu. Pastikan kemiringan lantai kandang minimal 3-5% ke arah saluran pembuangan, dan tambahkan alas jerami kering di area istirahat ternak.'
				},
				{
					heading: 'Atur sirkulasi udara, bukan sekadar menutup kandang',
					text: 'Menutup kandang rapat saat hujan justru menaikkan kelembapan dan amonia. Gunakan tirai/terpal yang bisa dibuka-tutup, cukup untuk menahan tampias tapi tetap membiarkan udara bertukar.'
				},
				{
					heading: 'Beri jeda sebelum & sesudah hujan deras',
					text: 'Hindari memandikan atau menggembalakan ternak tepat sebelum hujan turun. Jika ternak sudah basah kuyup, keringkan bagian punggung dan kaki, lalu berikan pakan hangat/tambahan energi seperti dedak.'
				},
				{
					heading: 'Tambahkan vitamin dan elektrolit',
					text: 'Berikan vitamin B kompleks atau elektrolit pada air minum 2-3 hari saat cuaca ekstrem untuk menjaga imunitas dan mengganti cairan tubuh yang hilang akibat perubahan suhu.'
				},
				{
					heading: 'Pantau tanda-tanda stres secara harian',
					text: 'Ternak yang stres biasanya menggigil, berdiri mematung di sudut kandang, bulu berdiri (piloereksi), atau kehilangan nafsu makan lebih dari 1 hari. Segera pisahkan dan hangatkan bila ditemukan tanda ini.'
				}
			],
			tips: [
				'Sediakan lampu pijar/pemanas kecil di sudut kandang anak ternak (pedet/anak kambing/DOC).',
				'Bersihkan tempat pakan dari sisa pakan basah setiap hari agar tidak jadi sumber jamur.',
				'Gunakan alas kandang (sekam, jerami) setebal 5-10 cm dan ganti saat sudah lembap.',
				'Jangan biarkan ternak berdiri lama di lumpur — becek adalah jalan masuk bakteri kaki (foot rot).'
			]
		}
	},
	{
		slug: 'membersihkan-kandang',
		title: 'Cara Membersihkan Kandang yang Baik',
		short: 'Kandang bersih adalah pondasi kesehatan ternak. Ini urutan dan jadwal pembersihan yang direkomendasikan.',
		icon: '🧹',
		image:
			'https://images.unsplash.com/photo-1500595046743-cd271d694d30?auto=format&fit=crop&w=1200&q=80',
		article: {
			intro:
				'Kandang yang kotor bukan cuma soal bau — ia menjadi sarang bakteri, parasit, dan gas amonia yang merusak saluran pernapasan ternak. Membersihkan kandang yang baik bukan sekadar menyapu, tapi mengikuti urutan dan jadwal yang konsisten.',
			points: [
				{
					heading: 'Buat jadwal harian, mingguan, dan bulanan',
					text: 'Harian: buang kotoran & sisa pakan. Mingguan: sikat lantai dan tempat minum dengan disinfektan. Bulanan: kuras total, jemur alas kandang, dan periksa struktur kandang (atap bocor, kayu lapuk).'
				},
				{
					heading: 'Pisahkan zona kotor dan zona bersih',
					text: 'Tempatkan area pembuangan kotoran (biogas/kompos) berjarak dari tempat pakan dan minum agar lalat dan bakteri tidak berpindah dengan mudah.'
				},
				{
					heading: 'Gunakan disinfektan yang tepat dan aman',
					text: 'Kapur tohor (CaOH) efektif dan murah untuk lantai kandang setelah dicuci. Untuk peralatan pakan/minum gunakan disinfektan food-grade lalu bilas sampai bersih sebelum dipakai lagi.'
				},
				{
					heading: 'Manfaatkan kotoran ternak sebagai pupuk/biogas',
					text: 'Kotoran yang menumpuk bukan cuma limbah — bisa diolah jadi pupuk kompos atau biogas. Ini sekaligus mengurangi timbunan kotoran yang jadi sumber penyakit.'
				},
				{
					heading: 'Kontrol hama dan vektor penyakit',
					text: 'Lalat, tikus, dan nyamuk berkembang biak di kandang lembap dan kotor. Pasang perangkap sederhana dan pastikan tidak ada air tergenang di sekitar kandang.'
				}
			],
			tips: [
				'Bersihkan tempat pakan & minum setiap hari, jangan menunggu sampai berlumut.',
				'Gunakan sikat berbeda untuk lantai dan untuk peralatan pakan agar tidak silang kontaminasi.',
				'Jemur alas kandang (sekam/jerami) minimal 1 kali seminggu di bawah sinar matahari langsung.',
				'Catat tanggal pembersihan besar di papan kandang agar tidak terlewat.'
			]
		}
	},
	{
		slug: 'memilih-bibit-unggul',
		title: 'Tips Memilih Bibit Ternak Unggul',
		short: 'Bibit yang baik menentukan 50% keberhasilan usaha ternak. Ini ciri-ciri yang wajib dicek sebelum membeli.',
		icon: '🐐',
		image:
			'https://images.unsplash.com/photo-1560468660-6c11a19d7330?auto=format&fit=crop&w=1200&q=80',
		article: {
			intro:
				'Banyak peternak pemula rugi bukan karena salah cara pelihara, tapi karena salah pilih bibit dari awal. Bibit unggul punya keturunan (genetik) yang baik, sehat, dan sesuai tujuan usaha (potong, perah, atau bibit lanjutan).',
			points: [
				{
					heading: 'Tentukan tujuan dulu: potong, perah, atau bibit',
					text: 'Ciri bibit unggul berbeda tergantung tujuan. Sapi potong dicari yang cepat gemuk dan berotot, sapi perah dicari keturunan produksi susu tinggi, ayam petelur dicari yang cepat mulai bertelur.'
				},
				{
					heading: 'Periksa riwayat keturunan (silsilah)',
					text: 'Tanyakan riwayat induk dan pejantan pada penjual/kelompok ternak terpercaya. Bibit dari induk dengan produktivitas tinggi biasanya menurunkan sifat yang sama.'
				},
				{
					heading: 'Cek kondisi fisik secara langsung',
					text: 'Mata bersih dan cerah, hidung tidak berlendir, bulu/rambut mengkilap tidak kusam, gerakan lincah, nafsu makan baik, dan tidak ada cacat pada kaki atau tulang belakang.'
				},
				{
					heading: 'Perhatikan umur dan bobot ideal',
					text: 'Bibit yang terlalu muda berisiko tinggi saat dipindahkan (stres transportasi), sementara yang terlalu tua sudah melewati masa pertumbuhan optimal. Sesuaikan dengan standar umur/bobot komoditas masing-masing.'
				},
				{
					heading: 'Beli dari sumber dengan riwayat kesehatan jelas',
					text: 'Pastikan bibit sudah divaksin dan bebas penyakit menular (SKKH/surat keterangan kesehatan hewan) dari peternakan asal, terutama jika didatangkan dari luar daerah.'
				}
			],
			tips: [
				'Datang langsung ke kandang penjual, jangan hanya lihat foto atau video.',
				'Amati ternak saat bergerak bebas, bukan saat diam ditambatkan.',
				'Hindari membeli bibit yang baru saja tiba dari perjalanan jauh — beri jeda istirahat dulu.',
				'Karantina bibit baru terpisah dari ternak lama selama 1-2 minggu sebelum digabung.'
			]
		}
	},
	{
		slug: 'cek-kesehatan-ternak',
		title: 'Cara Mengecek Kesehatan Ternak',
		short: 'Deteksi dini adalah kunci. Pelajari cara pemeriksaan harian sederhana yang bisa dilakukan sendiri.',
		icon: '🩺',
		image:
			'https://images.unsplash.com/photo-1500595046743-dc271e694b23?auto=format&fit=crop&w=1200&q=80',
		article: {
			intro:
				'Pemeriksaan kesehatan tidak harus menunggu ternak sakit parah. Pengecekan rutin harian selama 5-10 menit bisa mendeteksi masalah sejak dini, sebelum menular ke ternak lain atau menyebabkan kerugian besar.',
			points: [
				{
					heading: 'Amati perilaku dan nafsu makan',
					text: 'Ternak sehat aktif, responsif terhadap suara/gerakan di sekitarnya, dan segera mendatangi pakan. Penurunan nafsu makan lebih dari satu waktu makan adalah tanda peringatan awal.'
				},
				{
					heading: 'Periksa suhu tubuh',
					text: 'Suhu normal sapi sekitar 38-39°C, kambing/domba 38.5-39.5°C, dan ayam 40-42°C. Suhu tubuh yang naik signifikan biasanya menandakan infeksi.'
				},
				{
					heading: 'Cek kondisi kotoran (feses)',
					text: 'Kotoran encer, berlendir, atau berdarah menandakan gangguan pencernaan atau infeksi parasit/bakteri. Kotoran normal biasanya berbentuk dan tidak berbau menyengat berlebihan.'
				},
				{
					heading: 'Amati hidung, mata, dan mulut',
					text: 'Cairan hidung berlebih, mata berair/merah, atau air liur berlebihan bisa jadi tanda penyakit pernapasan atau infeksi mulut & kuku.'
				},
				{
					heading: 'Rasakan denyut nadi dan pernapasan',
					text: 'Napas yang cepat dan dangkal atau justru berat/tersengal, serta denyut nadi tidak teratur, adalah indikasi yang perlu segera dikonsultasikan ke petugas kesehatan hewan setempat.'
				}
			],
			tips: [
				'Lakukan pengecekan di jam yang sama tiap hari agar mudah membandingkan perubahan.',
				'Sediakan termometer khusus ternak dan catat suhu dalam buku log kandang.',
				'Pisahkan (karantina) ternak yang menunjukkan gejala sakit sebelum menyebar ke kandang lain.',
				'Simpan nomor kontak petugas/dokter hewan terdekat untuk kondisi darurat.'
			]
		}
	}
];

export function getCategory(slug) {
	return categories.find((c) => c.slug === slug);
}
