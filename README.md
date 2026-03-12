<img width="736" height="454" alt="image" src="https://github.com/user-attachments/assets/f31b997c-c112-4169-989c-28dfe277741c" /># 📊 Olist E-Commerce Analytics: Driving Growth through Data

![SQL](https://img.shields.io/badge/SQL-PostgreSQL%2FMySQL-blue)
![Tableau](https://img.shields.io/badge/Tableau-Data%20Visualization-e97627)
![Data Modeling](https://img.shields.io/badge/Data%20Modeling-ERD-brightgreen)
![Status](https://img.shields.io/badge/Status-Completed-success)

## 📌 Project Overview
Proyek ini adalah **End-to-End Data Analytics Portfolio** yang menganalisis dataset Olist (platform e-commerce terbesar di Brazil) yang berisi lebih dari 100.000 pesanan dari tahun 2016 hingga 2018. 

Tujuan utama dari proyek ini adalah memberikan rekomendasi strategis (*actionable insights*) yang berfokus pada 3 pilar bisnis utama:
1. **Sales & Revenue:** Menganalisis pertumbuhan bulanan dan menemukan produk *Cash Cow*.
2. **Customer Retention:** Menganalisis tingkat retensi, *Cohort*, dan segmentasi pelanggan (RFM Analysis).
3. **Logistics & Operations:** Mengevaluasi efisiensi pengiriman dan dampaknya terhadap pembatalan pesanan dan kepuasan pelanggan.

---

## 🛠️ Tools & Skills
- **Data Extraction & Transformation:** SQL (CTEs, Window Functions `LAG()`, Aggregations, CASE WHEN)
- **Data Modeling:** Pemetaan Entity-Relationship Diagram (ERD) dari 9 tabel database relasional.
- **Data Visualization & BI:** Tableau (Interactive Executive Dashboards)

---

## 📂 Repository Structure
Repository ini menyimpan seluruh *query* SQL yang digunakan untuk mengekstrak dan memproses raw data menjadi *summary tables* yang siap divisualisasikan.

- `/sql` : Berisi *query* utama untuk pemodelan data dan analisis (Macro View, RFM Analysis, Logistics, dll).
- `/sql/export_csv` : Berisi hasil *export* data agregasi (*summary tables*) yang dihubungkan ke Tableau.
- `ERD_E-commerce.png` : Visualisasi skema relasi database Olist.

---

## 💡 Key Business Insights

### 1. Sales & Revenue Strategy
- Kategori `health_beauty` adalah penyumbang *revenue* terbesar, sementara `bed_bath_table` memiliki kuantitas barang terjual paling tinggi. 
- **Rekomendasi:** Gunakan produk bervolume tinggi seperti `bed_bath_table` sebagai *Loss Leader* untuk menarik *traffic*, dan terapkan *promo bundling* untuk menaikkan nilai rata-rata transaksi (AOV).

### 2. Customer Retention (RFM Segmentation)
- *Repeat order rate* sangat rendah (3%). Namun, Olist memiliki basis pelanggan "Potential Loyalists" yang sangat masif (35.000+ pengguna).
- **Rekomendasi:** Terapkan *loyalty program* berbasis *tier* dan *Win-back campaign* via email berisi diskon agresif untuk mencegah pelanggan *At Risk* berpindah ke kompetitor.

### 3. Logistics Efficiency
- Terdapat korelasi unik: Pelanggan yang menggunakan **Ongkos Kirim Murah** justru memiliki tingkat pembatalan (*cancellation rate*) tertinggi (0,79%). *Late delivery* juga menghancurkan *Review Score* hingga ke angka 2.2.
- **Rekomendasi:** Evaluasi SLA kurir berbiaya rendah dan terapkan *Service Recovery Protocol* (kompensasi otomatis) untuk pesanan yang terdeteksi terlambat di sistem sebelum barang tiba.

---

## 🔗 Links & Dashboards
Silakan kunjungi tautan di bawah ini untuk melihat narasi lengkap dan mencoba *Interactive Dashboard*-nya:

- **[Notion Portfolio: Full Project Narrative & Storytelling]** *(https://rectangular-galliform-e74.notion.site/Olist-E-Commerce-Analytics-Driving-Growth-through-Data-3210bd466aa480419ebff7af7aaa395a?source=copy_link)*
- **[Tableau Public: Sales & Revenue Dashboard]** *(https://public.tableau.com/app/profile/yafet.pontoh/viz/OlistE-CommercePerformanceDashboard_17732231528880/Dashboard1)*
- **[Tableau Public: Customer Retention Dashboard]** *(https://public.tableau.com/app/profile/yafet.pontoh/viz/CustomerRetentionSegmentationDashboard/Dashboard2)*
- **[Tableau Public: Logistics & Operations Dashboard]** *(https://public.tableau.com/app/profile/yafet.pontoh/viz/LogisticsOperationsDashboard_17732866530850/Dashboard3)*
