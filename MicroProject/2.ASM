format PE console
entry start

include 'win32a.inc'

;--------------------------------------------------------------------------
section '.data' data readable writable

        strVecElemI  db '[F(%d)]: --------> ', 0                        ;строка для представления n-ого члена рекуррентной последовательности
        strScanInt   db '%d',13,10, 0                                   ;строка для вывода значения n-ого члена рекуррентной последовательности
        nextStr      db '',13,10, 0                                     ;пустая строка для разделения данных
        minElem      db 'Min Element of the sequence: = %d', 13, 10, 0  ;строка для представления пользователю информации о минимальном элементе рекуррентной последовательности
        maxElem      db 'Max Element of the sequence: = %d', 13, 10, 0  ;строка для представления пользователю информации о максимальном элементе рекуррентной последовательности


        index        dd ?                                               ;итерируемая переменная для подсчета номера члена последовательности (n)
        ;программа также может работать для любого числа в отрезке [1:2^31-1]
        maxAbs       dd 1000000000                                      ;граница, заданная по условию 10^9
        n_n0         dd 0                                               ;f(n+2)
        n_n1         dd 1                                               ;f(n+1)

;--------------------------------------------------------------------------Основная часть программы------------------------------------------------------
section '.code' code readable executable
start:
        call SpecialFib
finish:
        call [getch]

        push 0
        call [ExitProcess]

SpecialFib:
                                                                         ;очищаем регистры для использования в нашей функции
        xor eax, eax                                                     ;данный регистр предназначен для хранения f(n+2)
        xor ebx, ebx                                                     ;данный регистр предназначен для хранения f(n+1)
        xor ecx, ecx                                                     ;данный регистр предназначен для хранения индекса (n)
        xor edx, edx
                                                                         ;инициализируем первые два элемента последовательности для вычисления последующих членов рекуррентной функции
                                                                         ;f(0) = 0
                                                                         ;f(-1) = 1
                                                                         ;f(n) = f(n+2) - f(n+1)
InitSequence:

        mov [index], eax                                                 ;инициализируем индекс нулевым значением

                                                                         ;производим печать индекса в специальной форме
        push [index]
        push strVecElemI
        call [printf]
        add esp, 8

                                                                         ;производим печать значения f(0) = 0
        push [n_n0]
        push strScanInt
        call [printf]
        add esp, 8

                                                                         ;смещаем индекс на -1
        mov eax, [index]
        dec eax
        mov [index], eax

                                                                         ;производим печать значения f(-1) = 1
        push [index]
        push strVecElemI
        call [printf]
        add esp, 8

        push [n_n1]
        push strScanInt
        call [printf]
        add esp, 8

;--------------------------------------------------------------------------Основной цикл программы-------------------------------------------------------
printLoop:
                                                                         ;мы точно знаем, что в данный ряд - знакопеременный - каждый элемент под четным индексом, начиная с -2 будет отрицательным
                                                                         ;поэтому мы каждый раз проверяем на переполнение
        mov ebx, [n_n1]

                                                                         ;уменьшаем индекс
        mov eax, [index]
        dec eax
        mov [index], eax

                                                                         ;производим вычисление элемента
        mov eax, [n_n0]
        sub eax, ebx

        mov edx, eax
                                                                         ;если полученное значение больше нуля - приведение к модулю не требуется
        cmp eax, 0
        jge comparison
                                                                         ;записываем модуль в регистр edx
        neg eax

comparison:
                                                                         ;сравниваем с граничным значенем значение текущего элемента последовательности
        cmp eax, [maxAbs]
        jge endPrint
                                                                         ;происходит сдвиг элементов в последовательности
                                                                         ;в регистре edx хранится элемент f(n+1)
        mov [n_n1], edx
        ;используем edx до вызова функций (строго!)
                                                                         ;в регистре ebx хранится элемент f(n+2)
        mov [n_n0], ebx
                                                                         ;печать индекса
        push [index]
        push strVecElemI
        call [printf]
        add esp, 8
                                                                         ;печать самого значения элемента последовательности
        push [n_n1]
        push strScanInt
        call [printf]
        add esp, 8
                                                                         ;увеличиваем наш каунтер на 1, чтобы наш цикл не завершился преждевременно
        inc ecx
                                                                         ;используем loop согласно рекомендации
        loop  printLoop
;-------------------------------------------------------------------------------Вывод программы-------------------------------------------------------
endPrint:
                                                                         ;разделитель между выводом последовательности и ответом
       push nextStr
       call [printf]
       add esp, 4
                                                                         ;выбор типа вывода в зависимости от знака элемента последовательности
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