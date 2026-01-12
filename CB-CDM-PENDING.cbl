       IDENTIFICATION DIVISION.
       PROGRAM-ID. CB-CDM-PENDING.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       EXEC SQL INCLUDE SQLCA END-EXEC.

       01 WS-NO-REK     PIC X(6).
       01 WS-AMOUNT     PIC S9(11)V99 COMP-3.

       PROCEDURE DIVISION USING WS-NO-REK WS-AMOUNT.

           EXEC SQL
              INSERT INTO CDM_TRX
              (ID_TRX, NO_REK, JUMLAH, STATUS, WAKTU)
              VALUES
              (CURRENT TIMESTAMP,
               :WS-NO-REK,
               :WS-AMOUNT,
               'P',
               CURRENT TIMESTAMP)
           END-EXEC

           EXEC SQL
              UPDATE REKENING
              SET SALDO = SALDO + :WS-AMOUNT
              WHERE NO_REK = :WS-NO-REK
           END-EXEC

           EXEC SQL COMMIT END-EXEC
           GOBACK.
