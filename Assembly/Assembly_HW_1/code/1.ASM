format PE console
entry start

include 'win32a.inc'

;--------------------------------------------------------------------------
section '.data' data readable writable

        strVecSize   db 'Please enter size of the future array? ', 0
        strIncorSize db 'Incorrect size of the array = %d', 10, 0
        strVecElemI  db '[%d]? ', 0
        strScanInt   db '%d', 0
        nextStr      db '',13,10, 0
        previousArray db 'Original Array: ', 13, 10 ,0
        modifiedArray db 'Modified Array: ', 13, 10, 0
        strSumValue  db 'Summa = %d', 10, 0
        strVecElemOut  db '[%d] = %d', 10, 0
        strNone        db 'No elements!',0

        vec_size     dd 0  ;������ ������������ �������
        i            dd ?  ;����������� ���������� (������������� ��� �������� �������� �� ��������� �������)
        tmp          dd ?  ;��������� ����������
        last         dd 0  ;���������� ��� �������� ���������� �������� �������
        first        dd 0  ;���������� ��� �������� ������� �������� �������
        newArraySize dd 0  ;����� ����� ������� � ������ ������� (�� ��������� �� ������ ���������� � ������� �������� ������������ �������)
        tmpStack     dd ?  ;����������, ������� ����� ������� ��������� �� ������� �����
        vec          rd 100 ;����������� ������ ��� ������ �������
        vecb         rd 100 ;����������� ������ ��� ���������������� �������

;--------------------------------------------------------------------------�������� ����� ���������------------------------------------------------------
section '.code' code readable executable
start:
; 1) vector input
        call VectorInput
; 2) get new vector
        call letsFindElements
; 3) original vector out
        push previousArray
        call [printf]
        add esp, 4

        call VectorOut

        push nextStr
        call[printf]
        add esp, 4
; 4) test vector out
        push modifiedArray
        call [printf]
        add esp, 4

        call NewVectorOut
finish:
        call [getch]

        push 0
        call [ExitProcess]

;-----------------------------------------------------------------------���� �������--------------------------------------------------------------------
VectorInput:
        push strVecSize ;�� ������� ������ � ������ ������� (������� ������ �������)
        call [printf]   ;�������� ������� �� �����  � ��� ������ ������ ��������� � �������
        add esp, 4      ;esp - �������, ��������� �� ������� �����, �������� ���� �� ������� ����� (�������� �� �����, ������� ����� 4 �����)

        push vec_size   ;��� �������� ������� �������
        push strScanInt ;������ ������ ����� (����������� ������-������ �����)
        call [scanf]    ;�������� ������� ��� ���������� �����, ���������� �������������
        add esp, 8      ;������� �� ��� ������� ����� (��� ��������� �� 4 �����), �������, ����� �� �������� ���������,  ����������������� ��� ��������� ������ �������

        mov eax, [vec_size] ;� ������� ���������� ������ ������� (������ ������, � �� ������), ����� � ���������� �������� � cmp
        cmp eax, 0          ;���������� � 0, ����� ������ ����� ����� ���� ������������ (��� ����� ������ >0)
        jg  getVector       ;jump greater - �������� ���� ������ (��� ���� jne, je) - ���� ���� ������� ��������� - ����������� � ������ ������� ����
; fail size
        push [vec_size]       ;������ ��������� - ������������ ������ �������
        push strIncorSize
        call [printf]
        jmp finish
; else continue...
getVector:
        xor ecx, ecx            ; ecx = 0   ;���� ��� ������� - ������� ����, ecx ������� ��� ���������� ������
        mov ebx, vec            ; ebx = &vec  ;���������� ��������� �� ������ ������� ������� (������ ���������)
getVecLoop:
       ;  mov [tmp], ebx              ;� tmp - ��������� ���������� �������� ����� �� ������� ������� (� ������ ������ ��� �������, �� ��� ����� ���������� �������)
        cmp ecx, [vec_size]         ;���������� ������� �������� � �������� �������
        jge endInputVector          ;to end of loop ���� ������ ���� ����� - ����� �� ����� � ����� �� ������� (������ ��� endInputVector ������� �� �������)

        ; input element
        mov [i], ecx                ;����������� �������� ��������

        ;�������
        push ecx
        push strVecElemI            ;������� ������ ��� ���������� ������ ����� (����� [0]?..)
        call [printf]

        add esp, 8                  ;�������� ���� �� 2 ������� ����� (��� ��� �������� ecx � strVecElemI)

        ;��������� ���� �����
        push ebx
        push strScanInt
        call [scanf]
        add esp, 8


        ;����������� �������� �� 1 (��������� ������)
        mov ecx, [i]                ;����� ���������� � ecx �������� ��������� ���������� i
        inc ecx
        ;����������� �������� i  �� 1 (������� ��������)

        cmp ecx, [vec_size]         ;��� ����� ������������� ������� ������� - ��� ��������� ������ ��� ����, ����� � ������ ������ � vec_size �������� ������� ��� �������
        jge endInputVector

        add ebx, 4                  ;�������� ������ �� �������
        jmp getVecLoop              ;��������� ��� ���� - ������� �� �����

endInputVector:                     ;���������� ���������� �������
        ;���������� ��������� ������� ������ ������� (�������)
        mov ecx, [ebx]              ;��������� ��� �������� � ������� ebx
        mov [last], ecx             ;��������� �������� �� �������� ecx, � ������� �� ����� �������� ���� ����������� ��������� ��������, � ���������� last

        ret
;------------------------------------------------------------����� ���������-----------------------------------------------------------
letsFindElements:
        xor ecx, ecx                ;�������� ��� ������� ecx
        mov ebx, vec                ;���������� ������ �� ������ ������� ���������� ������� � ������� ebx
        mov edx, vecb               ;���������� ������ �� ������ ������� ������ ������� � ������� edx

        ;���������� ������ ������� ������������ �������
        mov eax, [ebx]              ;�������� �������� ������� �������� ������� ������� � ������� eax
        mov [first], eax            ;�������� �������� �� �������� eax � ���������� first


iteration:
        cmp ecx, [vec_size]         ;����������� �� ������ ������������ ������� (���� ������� ������� ������ ��� ����� ������ ������� - ������� �� ����������)
        je endIteration

        mov [i], ecx                ;��������� ��� ������� � ���������� i, ����� ������������ ��� � ���� �����

        mov eax, [ebx]              ;��������� ������� ������� ������������ ������� � �������


        ;��������� ����� �� ������� ������� ���������� � ������� �������� ������ ������� (������������)
        cmp eax, [last]
        je ifEqual
        cmp eax, [first]
        je ifEqual                  ;���� ������� ������� ����� ���� �� ������ �� ����������� ��������� - ��������� �� �����, ����� ���������� �������� ������� � ����� ������


        ;��������� ������� � ����� ������
        mov [edx], eax              ;���� ��� �������� � ������ ������� �� ����� �� ������ �� ��������� - ��������� ��� � ����� ������ (�������� ���������� � ������)
        add edx, 4                  ;�������� ��������� �� ��������� ������� (4 �����)

        ;����������� �������� ���������, ���������� �� ���������� ��������� � ����� ������� �� 1 (��� ���������� ������ ��������)
        mov ecx, [newArraySize]
        inc ecx
        mov [newArraySize], ecx

ifEqual:
        ;���������� ����������� ����������
        mov ecx, [i]
        inc ecx

        ;�������� ��������� �� ��������� ������� ������������ �������
        add ebx, 4
        jmp iteration               ;��������� ��������


endIteration:

        ret
;--------------------------------------------------------------------------����� ������������ �������--------------------------------------------------------
VectorOut:
        mov [tmpStack], esp         ;��������� ��������� �� ������� ����� � ���������� tmpStack
        xor ecx, ecx                ;����������� �������
        mov ebx, vec                ;�������� ��������� �� ������ ������������ �������
putVecLoop:
        cmp ecx, [vec_size]         ;�������� �� ��������� �������
        je endOutputVector
        mov [i], ecx                ;�������� ����� ������������ �������� ������� � ���������� i

        ;����� �������� ������� � �������
        push dword [ebx]
        push ecx
        push strVecElemOut
        call [printf]

        ;����������� ������������ ����������
        mov ecx, [i]
        inc ecx
        add ebx, 4

        jmp putVecLoop
endOutputVector:
        ;������� ����
        mov esp, [tmpStack]
        ret

;-------------------------------------------------------------------------����� ��������� ������� � �������--------------------------------------------------
NoElements:
        push strNone
        call [printf]
        add esp, 4
        jmp endOutputVector      ;���� ����� ������� (�����������) ����� ����� 0, �� ��������� ��������������� ���������
NewVectorOut:
        mov [tmpStack], esp ;                                     ;��� ��� ����������� ���������� �������, ����� ������ ������� ��� ������
        xor ecx, ecx
        mov ebx, vecb
        cmp [newArraySize], 0
        je NoElements
putNewVecLoop:
        cmp ecx, [newArraySize]
        je endOutputNewVector
        mov [i], ecx

        ; output element
        push dword [ebx]
        push ecx
        push strVecElemOut
        call [printf]

        mov ecx, [i]
        inc ecx
        add ebx, 4

        jmp putNewVecLoop
endOutputNewVector:
        mov esp, [tmpStack]
        ret
;-------------------------------third act - including HeapApi--------------------------
                                                 
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