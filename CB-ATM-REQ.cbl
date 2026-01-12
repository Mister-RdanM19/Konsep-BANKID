       IDENTIFICATION DIVISION.
       PROGRAM-ID. CB-ATM-REQ.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 WS-REQ.
          05 WS-NO-KARTU    PIC X(16).
          05 WS-PIN         PIC X(4).
          05 WS-TRX-CODE    PIC X(2).
          05 WS-AMOUNT      PIC S9(11)V99 COMP-3.
       01 WS-RESP-CODE      PIC X(2).

       PROCEDURE DIVISION.
           DISPLAY "NO KARTU   : " ACCEPT WS-NO-KARTU
           DISPLAY "PIN        : " ACCEPT WS-PIN
           DISPLAY "TRX CODE   : " ACCEPT WS-TRX-CODE
           DISPLAY "AMOUNT     : " ACCEPT WS-AMOUNT

           CALL 'CB-ATM-SWITCH'
             USING WS-REQ WS-RESP-CODE

           DISPLAY "RESP CODE : " WS-RESP-CODE
           STOP RUN.
