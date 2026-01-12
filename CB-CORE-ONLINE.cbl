       IDENTIFICATION DIVISION.
       PROGRAM-ID. CB-CORE-ONLINE.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       EXEC SQL INCLUDE SQLCA END-EXEC.

       01 WS-NO-REK        PIC X(6).
       01 WS-TRX-CODE      PIC X(2).
       01 WS-AMOUNT        PIC S9(11)V99 COMP-3.
       01 WS-SALDO         PIC S9(13)V99 COMP-3.
       01 WS-RESP-CODE    PIC X(2).

       PROCEDURE DIVISION USING
            WS-NO-REK WS-TRX-CODE WS-AMOUNT WS-RESP-CODE.

           EXEC SQL
              SELECT SALDO
              INTO :WS-SALDO
              FROM REKENING
              WHERE NO_REK = :WS-NO-REK
              FOR UPDATE
           END-EXEC

           IF SQLCODE NOT = 0
              MOVE '96' TO WS-RESP-CODE
              EXEC SQL ROLLBACK END-EXEC
              GOBACK
           END-IF

           EVALUATE WS-TRX-CODE
             WHEN '01'
                MOVE '00' TO WS-RESP-CODE

             WHEN '02'
                IF WS-AMOUNT <= WS-SALDO
                   EXEC SQL
                      UPDATE REKENING
                      SET SALDO = SALDO - :WS-AMOUNT
                      WHERE NO_REK = :WS-NO-REK
                   END-EXEC
                   EXEC SQL COMMIT END-EXEC
                   MOVE '00' TO WS-RESP-CODE
                ELSE
                   MOVE '51' TO WS-RESP-CODE
                   EXEC SQL ROLLBACK END-EXEC
                END-IF

             WHEN '03'
                CALL 'CB-CDM-PENDING'
                     USING WS-NO-REK WS-AMOUNT
                MOVE '00' TO WS-RESP-CODE

             WHEN OTHER
                MOVE '96' TO WS-RESP-CODE
           END-EVALUATE

           CALL 'CB-AUDIT-LOG'
             USING WS-NO-REK WS-TRX-CODE WS-AMOUNT WS-RESP-CODE

           GOBACK.
