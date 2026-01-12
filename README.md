#  Konsep-BANKID

**Konsep Script Isi Program Bank di Indonesia**

Repo ini berisi kumpulan **script COBOL** untuk **mensimulasikan arsitektur sistem perbankan** secara konseptual — mulai dari request ATM, core banking, approval, hingga batch end-of-day.  
Cocok sebagai *reference* belajar arsitektur perbankan*

---

## 🚀 Ringkasan Proyek

📁 **Bahasa Utama:** COBOL  
🎯 **Tujuan:**  
- Menyediakan skrip konsep sistem bank berbasis COBOL & DB2
- Menyimulasikan alur core banking nyata  
-  arsitektur perbankan modern

---

## 📂 Struktur Repository

| File | Deskripsi |
|------|-----------|
| `CB-ATM-REQ.cbl` | Simulasi input transaksi dari ATM/Channel |
| `CB-ATM-SWITCH.cbl` | Routing request & validation |
| `CB-CORE-ONLINE.cbl` | Core banking logic (debit/credit) |
| `CB-MAKER-INPUT.cbl` | Maker level transaction queue |
| `CB-CHECKER-L1.cbl` | Checker level 1 (supervisor) |
| `CB-CHECKER-L2.cbl` | Checker level 2 (risk/HO) |
| `CB-EXECUTOR.cbl` | Posting final transaksi |
| `CB-CDM-PENDING.cbl` | Setor tunai (pending) |
| `CB-EOD-BATCH.cbl` | End of Day processing |
| `AUDIT-LOG.cbl` | Menyimpan audit trail | :contentReference[oaicite:2]{index=2}

---

## 🧠 Konsep Utama

### 💳 1. Alur Transaksi
1. Nasabah melakukan **request dari ATM / aplikasi**
2. Dialihkan ke **switch**
3. Validasi & routing ke **core banking**
4. Jika perlu, masuk ke **maker/checker flow**
5. Posting ke saldo
6. Batch **EOD** untuk finalisasi


### 📦 2. End-of-Day (Batch)

Digunakan untuk:
- Rekonsiliasi CDM (setor tunai)
- Finalisasi transaksi tertunda
- Generate audit log & laporan

---

## 📖 Alur Transaksi Nyata (End-to-End)

Nasabah
<br>
CB-ATM-REQ.cbl
<br>
CB-ATM-SWITCH.cbl
<br>
CB-CORE-ONLINE.cbl
<br>
Maker → Checker L1 → Checker L2
<br>
CB-EXECUTOR.cbl
<br>
AUDIT-LOG.cbl
 <br>
CB-EOD-BATCH.cbl


## AUTHOR 
Mr.Rm19 - n3i 
