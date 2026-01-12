       IDENTIFICATION DIVISION.
       PROGRAM-ID. CB-AUDIT-LOG.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       EXEC SQL INCLUDE SQLCA END-EXEC.

       01 WS-NO-REK     PIC X(6).
       01 WS-TRX        PIC X(2).
       01 WS-AMOUNT     PIC S9(11)V99 COMP-3.
       01 WS-RESP       PIC X(2).

       PROCEDURE DIVISION USING
            WS-NO-REK WS-TRX WS-AMOUNT WS-RESP.

           EXEC SQL
              INSERT INTO AUDIT_LOG
              (NO_REK, TRX_CODE, AMOUNT, RESP_CODE, WAKTU)
              VALUES
              (:WS-NO-REK,
               :WS-TRX,
               :WS-AMOUNT,
               :WS-RESP,
               CURRENT TIMESTAMP)
           END-EXEC

           GOBACK.
