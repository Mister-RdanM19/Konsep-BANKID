       IDENTIFICATION DIVISION.
       PROGRAM-ID. CB-ATM-SWITCH.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       EXEC SQL INCLUDE SQLCA END-EXEC.

       01 WS-REQ.
          05 WS-NO-KARTU    PIC X(16).
          05 WS-PIN         PIC X(4).
          05 WS-TRX-CODE    PIC X(2).
          05 WS-AMOUNT      PIC S9(11)V99 COMP-3.
       01 WS-NO-REK         PIC X(6).
       01 WS-RESP-CODE     PIC X(2).

       PROCEDURE DIVISION USING WS-REQ WS-RESP-CODE.

           EXEC SQL
              SELECT NO_REK
              INTO :WS-NO-REK
              FROM KARTU_ATM
              WHERE NO_KARTU = :WS-NO-KARTU
                AND PIN      = :WS-PIN
                AND STATUS   = 'A'
           END-EXEC

           IF SQLCODE NOT = 0
              MOVE '55' TO WS-RESP-CODE
              GOBACK
           END-IF

           CALL 'CB-CORE-ONLINE'
             USING WS-NO-REK
                   WS-TRX-CODE
                   WS-AMOUNT
                   WS-RESP-CODE

           GOBACK.
