format PE console
entry start

include 'win32a.inc'

;--------------------------------------------------------------------------
section '.data' data readable writable

        strVecElemI  db '[F(%d)]: --------> ', 0                        ;������ ��� ������������� n-��� ����� ������������ ������������������
        strScanInt   db '%d',13,10, 0                                   ;������ ��� ������ �������� n-��� ����� ������������ ������������������
        nextStr      db '',13,10, 0                                     ;������ ������ ��� ���������� ������
        minElem      db 'Min Element of the sequence: = %d', 13, 10, 0  ;������ ��� ������������� ������������ ���������� � ����������� �������� ������������ ������������������
        maxElem      db 'Max Element of the sequence: = %d', 13, 10, 0  ;������ ��� ������������� ������������ ���������� � ������������ �������� ������������ ������������������


        index        dd ?                                               ;����������� ���������� ��� �������� ������ ����� ������������������ (n)

        maxAbs       dd 1000000000                                      ;�������, �������� �� ������� 10^9
        n_n0         dd 0                                               ;f(n+2)
        n_n1         dd 1                                               ;f(n+1)

;--------------------------------------------------------------------------�������� ����� ���������------------------------------------------------------
section '.code' code readable executable
start:
        call SpecialFib
finish:
        call [getch]

        push 0
        call [ExitProcess]

SpecialFib:
                                                                         ;������� �������� ��� ������������� � ����� �������
        xor eax, eax                                                     ;������ ������� ������������ ��� �������� f(n+2)
        xor ebx, ebx                                                     ;������ ������� ������������ ��� �������� f(n+1)
        xor ecx, ecx                                                     ;������ ������� ������������ ��� �������� ������� (n)
        xor edx, edx
                                                                         ;�������������� ������ ��� �������� ������������������ ��� ���������� ����������� ������ ������������ �������
                                                                         ;f(0) = 0
                                                                         ;f(-1) = 1
                                                                         ;f(n) = f(n+2) - f(n+1)
InitSequence:

        mov [index], eax                                                 ;�������������� ������ ������� ���������

                                                                         ;���������� ������ ������� � ����������� �����
        push [index]
        push strVecElemI
        call [printf]
        add esp, 8

                                                                         ;���������� ������ �������� f(0) = 0
        push [n_n0]
        push strScanInt
        call [printf]
        add esp, 8

                                                                         ;������� ������ �� -1
        mov eax, [index]
        dec eax
        mov [index], eax

                                                                         ;���������� ������ �������� f(-1) = 1
        push [index]
        push strVecElemI
        call [printf]
        add esp, 8

        push [n_n1]
        push strScanInt
        call [printf]
        add esp, 8

;--------------------------------------------------------------------------�������� ���� ���������-------------------------------------------------------
printLoop:
                                                                         ;�� ����� �����, ��� � ������ ��� - ��������������� - ������ ������� ��� ������ ��������, ������� � -2 ����� �������������
                                                                         ;������� �� ������ ��� ��������� �� ������������
        mov ebx, [n_n1]

                                                                         ;��������� ������
        mov eax, [index]
        dec eax
        mov [index], eax

                                                                         ;���������� ���������� ��������
        mov eax, [n_n0]
        sub eax, ebx

        mov edx, eax
                                                                         ;���� ���������� �������� ������ ���� - ���������� � ������ �� ���������
        cmp eax, 0
        jge comparison
                                                                         ;���������� ������ � ������� edx
        neg eax

comparison:
                                                                         ;���������� � ��������� �������� �������� �������� �������� ������������������
        cmp eax, [maxAbs]
        jge endPrint
                                                                         ;���������� ����� ��������� � ������������������
                                                                         ;� �������� edx �������� ������� f(n+1)
        mov [n_n1], edx
        ;���������� edx �� ������ ������� (������!)
                                                                         ;� �������� ebx �������� ������� f(n+2)
        mov [n_n0], ebx
                                                                         ;������ �������
        push [index]
        push strVecElemI
        call [printf]
        add esp, 8
                                                                         ;������ ������ �������� �������� ������������������
        push [n_n1]
        push strScanInt
        call [printf]
        add esp, 8
                                                                         ;����������� ��� ������� �� 1, ����� ��� ���� �� ���������� ��������������
        inc ecx
                                                                         ;���������� loop �������� ������������
        loop  printLoop
;-------------------------------------------------------------------------------����� ���������-------------------------------------------------------
endPrint:
                                                                         ;����������� ����� ������� ������������������ � �������
       push nextStr
       call [printf]
       add esp, 4
                                                                         ;����� ���� ������ � ����������� �� ����� �������� ������������������
       cmp [n_n0],1
       jge firstMaxThenMin

firstMinThenMax:
        push [n_n0]
        push minElem
        call [printf]
        add esp, 8

        push [n_n1]
        push maxElem
        call [printf]
        add esp, 8

        ret

firstMaxThenMin:
        push [n_n1]
        push minElem
        call [printf]
        add esp,8

        push [n_n0]
        push maxElem
        call [printf]
        add esp, 8


        ret
;-------------------------------HeapApi--------------------------------------------------------------------
                                                 
section '.idata' import data readable
    library kernel, 'kernel32.dll',\
            msvcrt, 'msvcrt.dll',\
            user32,'USER32.DLL'

include 'api\user32.inc'
include 'api\kernel32.inc'
    import kernel,\
           ExitProcess, 'ExitProcess',\
           HeapCreate,'HeapCreate',\
           HeapAlloc,'HeapAlloc'
  include 'api\kernel32.inc'
    import msvcrt,\
           printf, 'printf',\
           scanf, 'scanf',\
           getch, '_getch'