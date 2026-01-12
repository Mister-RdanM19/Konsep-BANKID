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

## 📖 KONSEP

┌──────────────────────────────┐
│        NASABAH / USER         │
│  ATM | Mobile | Teller | API │
└───────────────┬──────────────┘
                │
                ▼
┌──────────────────────────────┐
│        CHANNEL LAYER          │
│  - UI only                   │
│  - No saldo logic            │
└───────────────┬──────────────┘
                │  ISO 8583
                ▼
┌──────────────────────────────┐
│     ATM / CHANNEL SWITCH     │
│  - ISO 8583 parser           │
│  - Routing                   │
│  - Timeout / Reversal        │
└───────┬───────────────┬──────┘
        │               │
        │               ▼
        │     ┌─────────────────┐
        │     │       HSM        │
        │     │ - PIN Verify     │
        │     │ - Key Mgmt       │
        │     └─────────────────┘
        │
        ▼
┌──────────────────────────────┐
│   CORE BANKING ONLINE        │
│   (COBOL + DB2 + CICS)       │
│  - Auth                      │
│  - Business Rule             │
│  - Limit & Fraud Check       │
│  - Commit / Rollback         │
└───────────────┬──────────────┘
                │
      ┌─────────┴──────────┐
      │                    │
      ▼                    ▼
┌───────────────┐   ┌────────────────┐
│ MAKER–CHECKER │   │ CDM (SETOR)     │
│ MULTI LEVEL   │   │ STATUS=PENDING  │
│ M → C1 → C2   │   └────────────────┘
└───────┬───────┘
        │
        ▼
┌──────────────────────────────┐
│     EXECUTION ENGINE         │
│  - Posting saldo final       │
│  - Dual control              │
└───────────────┬──────────────┘
                │
                ▼
┌──────────────────────────────┐
│   ACTIVE–ACTIVE DATABASE     │
│  DC A  ⇄  DC B               │
│  - Synchronous commit        │
└───────────────┬──────────────┘
                │
                ▼
┌──────────────────────────────┐
│        AUDIT & LOG           │
│  - Immutable                │
│  - Regulator ready          │
└───────────────┬──────────────┘
                │
                ▼
┌──────────────────────────────┐
│     END OF DAY (BATCH)       │
│  - Reconciliation            │
│  - Finalize CDM              │
│  - GL Posting                │
└───────────────┬──────────────┘
                │
                ▼
┌──────────────────────────────┐
│   REGULATOR / BASEL REPORT   │
│  - LCR                       │
│  - Risk Event                │
│  - Exposure                  │
└──────────────────────────────┘


## AUTHOR 
Mr.Rm19 - n3i 
