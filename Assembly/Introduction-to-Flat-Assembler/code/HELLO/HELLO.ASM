
; example of simplified Windows programming using complex macro features

include 'win64ax.inc' ; you can simply switch between win32ax, win32wx, win64ax and win64wx here

.code

  start:

        invoke  MessageBox,HWND_DESKTOP,"���� ���-������ �����?",invoke GetCommandLine,MB_YESNO

        .if eax = IDYES
                invoke  MessageBox,HWND_DESKTOP,"�������-��, � ��������� ��������� ��.....!","CONNECTION LOST",MB_OK
        .else
                invoke MessageBox,HWND_DESKTOP,"������� � ������� ���������� ����... ���� ���!","CONNECTION LOST",MB_OK
        .endif

        invoke  ExitProcess,0

.end start
