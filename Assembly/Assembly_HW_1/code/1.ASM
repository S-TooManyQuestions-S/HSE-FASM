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

        vec_size     dd 0  ;размер изначального массива
        i            dd ?  ;итерируемая переменная (предназначена для успешной итерации по элементам массива)
        tmp          dd ?  ;временная переменная
        last         dd 0  ;переменная для хранения последнего элемента массива
        first        dd 0  ;переменная для хранения первого элемента массива
        newArraySize dd 0  ;новая длина массива с учетом условия (из элементов не равных последнему и первому элементу изначального массива)
        tmpStack     dd ?  ;переменная, которая будет хранить указатель на вершину стэка
        vec          rd 100 ;резервируем память для нашего массива
        vecb         rd 100 ;резервируем память для отфильтрованного массива

;--------------------------------------------------------------------------Основная часть программы------------------------------------------------------
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

;-----------------------------------------------------------------------Ввод вектора--------------------------------------------------------------------
VectorInput:
        push strVecSize ;мы выводим строку о выводе массива (введите размер массива)
        call [printf]   ;вызываем функцию из языка  С для вывода нашего обращения в консоль
        add esp, 4      ;esp - регистр, указывает на вершину стэка, сдвигаем стэк на двойное слово (сдвигаем на слово, которое весит 4 байта)

        push vec_size   ;для хранения размера массива
        push strScanInt ;вводим именно число (специальная строка-формат ввода)
        call [scanf]    ;вызываем функцию для считывания числа, введенного пользователем
        add esp, 8      ;двигаем на два двойных слова (две перменные по 4 байта), двигаем, чтобы не обнулять указатели,  зарезервированные под результат других функций

        mov eax, [vec_size] ;в регистр засовываем размер вектора (именно размер, а не ссылку), чтобы в дальнейшем работать с cmp
        cmp eax, 0          ;сравниваем с 0, чтобы понять какое число ввел пользователь (нам нужно строго >0)
        jg  getVector       ;jump greater - прыгнуть если больше (еще есть jne, je) - если наше условие сработало - пермещаемся в нужный участок кода
; fail size
        push [vec_size]       ;ошибка сравнения - некорректный размер массива
        push strIncorSize
        call [printf]
        jmp finish
; else continue...
getVector:
        xor ecx, ecx            ; ecx = 0   ;если все успешно - прыгаем сюда, ecx очищаем для дальнейшей работы
        mov ebx, vec            ; ebx = &vec  ;засовываем указатель на первый элемент вектора (именно указатель)
getVecLoop:
       ;  mov [tmp], ebx              ;в tmp - временную переменную помещаем адрес на элемент массива (в ланном случае это излишне, но так можно освободить регистр)
        cmp ecx, [vec_size]         ;сравниваем счетчик проходов с размером массива
        jge endInputVector          ;to end of loop если больше либо равно - выход из цикла а потом из функции (потому что endInputVector выводит из функции)

        ; input element
        mov [i], ecx                ;присваиваем счетчику значение

        ;выводим
        push ecx
        push strVecElemI            ;выводим строку для считывания нашего слова (форму [0]?..)
        call [printf]

        add esp, 8                  ;сдвигаем стэк на 2 двойных слова (так так запушили ecx и strVecElemI)

        ;считываем наше число
        push ebx
        push strScanInt
        call [scanf]
        add esp, 8


        ;увеличиваем итератор на 1 (следующий проход)
        mov ecx, [i]                ;снова засовываем в ecx значение временной переменной i
        inc ecx
        ;увеличиваем значение i  на 1 (счетчик проходов)

        cmp ecx, [vec_size]         ;нам нужен предпоследний элемент массива - это сравнение именно для того, чтобы в нужный момент в vec_size итерацию забрать наш элемент
        jge endInputVector

        add ebx, 4                  ;сдвигаем массив на элемент
        jmp getVecLoop              ;повторяем наш цикл - прыгаем на метку

endInputVector:                     ;завершение считывания вектора
        ;запоминаем последний элемент нашего вектора (массива)
        mov ecx, [ebx]              ;добавляем его значение в регистр ebx
        mov [last], ecx             ;добавляем значение из регистра ecx, в которое мы ранее записали наше необходимое последнее значение, в переменную last

        ret
;------------------------------------------------------------Поиск элементов-----------------------------------------------------------
letsFindElements:
        xor ecx, ecx                ;обнуляем наш регистр ecx
        mov ebx, vec                ;записываем ссылку на первый элемент начального массива в регистр ebx
        mov edx, vecb               ;записываем ссылку на первый элемент нового массива в регистр edx

        ;запоминаем первый элемент изначального массива
        mov eax, [ebx]              ;передаем значение первого элемента старого массива в регистр eax
        mov [first], eax            ;передаем значение из регистра eax в переменную first


iteration:
        cmp ecx, [vec_size]         ;итерируемся по нашему изначальному массиву (если текущий элемент больше чем длина нашего вектора - прыгаем на заврешение)
        je endIteration

        mov [i], ecx                ;сохраняем наш регистр в переменную i, чтобы использовать его в теле цикла

        mov eax, [ebx]              ;сохраняем текущий элемент изначального массива в регистр


        ;проверяем равен ли текущий элемент последнему и первому элементу нашего массива (изначального)
        cmp eax, [last]
        je ifEqual
        cmp eax, [first]
        je ifEqual                  ;если текущий элемент равен хотя бы одному из пограничных элементов - переходим по флагу, минуя добавление текущего вектора в новый вектор


        ;добавляем элемент в новый массив
        mov [edx], eax              ;если все впорядке и данные элемент не равен ни одному из граничных - добавляем его в новый массив (значение записываем в ссылку)
        add edx, 4                  ;сдвигаем указатель на следующую позицию (4 байта)

        ;увеличиваем значение перменной, отвечающей за количество элементов в новом массиве на 1 (при добавлении нового элемента)
        mov ecx, [newArraySize]
        inc ecx
        mov [newArraySize], ecx

ifEqual:
        ;увеличваем итерируемую переменную
        mov ecx, [i]
        inc ecx

        ;сдвигаем указатель на следующий элемент изначального массива
        add ebx, 4
        jmp iteration               ;повторяем итерацию


endIteration:

        ret
;--------------------------------------------------------------------------Вывод Изначального вектора--------------------------------------------------------
VectorOut:
        mov [tmpStack], esp         ;сохраняем указатель на вершину стэка в переменную tmpStack
        xor ecx, ecx                ;освобождаем регистр
        mov ebx, vec                ;помещаем указатель на начало изначального вектора
putVecLoop:
        cmp ecx, [vec_size]         ;итерация по элементам массива
        je endOutputVector
        mov [i], ecx                ;помещаем номер итерируемого элемента массива в переменную i

        ;вывод элемента массива в консоль
        push dword [ebx]
        push ecx
        push strVecElemOut
        call [printf]

        ;увеличиваем итерационную переменную
        mov ecx, [i]
        inc ecx
        add ebx, 4

        jmp putVecLoop
endOutputVector:
        ;очищаем стэк
        mov esp, [tmpStack]
        ret

;-------------------------------------------------------------------------Вывод изменного векотра в консоль--------------------------------------------------
NoElements:
        push strNone
        call [printf]
        add esp, 4
        jmp endOutputVector      ;если длина массива (измененного) будет равна 0, то выведется соответственное сообщение
NewVectorOut:
        mov [tmpStack], esp ;                                     ;тут все анолоогично предыдущей функции, кроме самого вектора для вывода
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