       IDENTIFICATION DIVISION.
       PROGRAM-ID. CB-EXECUTOR.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       EXEC SQL INCLUDE SQLCA END-EXEC.

       01 WS-ID-TRX PIC X(20).
       01 WS-SRC    PIC X(6).
       01 WS-DST    PIC X(6).
       01 WS-AMT    PIC S9(13)V99 COMP-3.

       PROCEDURE DIVISION.
           EXEC SQL
              DECLARE Q CURSOR FOR
              SELECT ID_TRX, NO_REK_SRC, NO_REK_DST, AMOUNT
              FROM TRX_QUEUE
              WHERE STATUS = 'C2'
           END-EXEC

           EXEC SQL OPEN Q END-EXEC

           PERFORM UNTIL SQLCODE NOT = 0
              EXEC SQL
                 FETCH Q INTO :WS-ID-TRX, :WS-SRC, :WS-DST, :WS-AMT
              END-EXEC

              IF SQLCODE = 0
                 EXEC SQL
                    UPDATE REKENING
                    SET SALDO = SALDO - :WS-AMT
                    WHERE NO_REK = :WS-SRC
                 END-EXEC

                 EXEC SQL
                    UPDATE REKENING
                    SET SALDO = SALDO + :WS-AMT
                    WHERE NO_REK = :WS-DST
                 END-EXEC

                 EXEC SQL
                    UPDATE TRX_QUEUE
                    SET STATUS = 'S',
                        UPDATED_TS = CURRENT TIMESTAMP
                    WHERE ID_TRX = :WS-ID-TRX
                 END-EXEC

                 EXEC SQL COMMIT END-EXEC
              END-IF
           END-PERFORM

           EXEC SQL CLOSE Q END-EXEC
           STOP RUN.
