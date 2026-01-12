       IDENTIFICATION DIVISION.
       PROGRAM-ID. CB-CHECKER-L1.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       EXEC SQL INCLUDE SQLCA END-EXEC.

       01 WS-ID-TRX    PIC X(20).
       01 WS-ACTION    PIC X(1).   *> A=Approve, R=Reject
       01 WS-USER      PIC X(10).

       PROCEDURE DIVISION.
           ACCEPT WS-ID-TRX
           ACCEPT WS-ACTION
           ACCEPT WS-USER

           IF WS-ACTION = 'A'
              EXEC SQL
                 UPDATE TRX_QUEUE
                 SET STATUS = 'C1',
                     CHECKER1_ID = :WS-USER,
                     UPDATED_TS = CURRENT TIMESTAMP
                 WHERE ID_TRX = :WS-ID-TRX
                   AND STATUS = 'M'
              END-EXEC
           ELSE
              EXEC SQL
                 UPDATE TRX_QUEUE
                 SET STATUS = 'R',
                     UPDATED_TS = CURRENT TIMESTAMP
                 WHERE ID_TRX = :WS-ID-TRX
              END-EXEC
           END-IF

           EXEC SQL COMMIT END-EXEC
           STOP RUN.
