DATA  SEGMENT
          X  DW  8000H
DATA  ENDS
CODE  SEGMENT
          ASSUME  CS: CODE, DS: DATA
START: MOV  AX, DATA
            MOV  DS, AX
            MOV AX, 836BH
            TEST  AX, X
            MOV  AX, 4C00H
            INT     21H
CODE  ENDS
      END  START