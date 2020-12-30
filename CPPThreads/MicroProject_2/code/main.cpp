#include <pthread.h>
#include <semaphore.h>
#include <cstdlib>
#include <cstdio>
#include <unistd.h>

using namespace std;

//количество программ которые могут быть написаны одновременно
const int amountOfWork = 3;
//массив содержащий программы, программа представляет собой целое положительное число на отрезке [2:100]
int works[3]{0};

//сколько осталось написать программ
sem_t  workToDo ;
//сколько осталось проверить программ
sem_t  checkToDo ;
//минимальное количество программ, которые должны быть выполнены программистами в течение сессии
const int limit = 25;

//общее количество написанных программ
unsigned int total_written = 0;

pthread_mutex_t mutexWork ; /*мьютекс для создания/переписывания программы конкретным программистом,
 * а также проверки переданной задачи*/
unsigned int seed = 47; /*сид для генератора случайных чисел*/


void *WriteAProgram(void *param) {
    //номер потока, который использует данный метод
    int pNum = *((int*)param);
    //пока число всех написанных студией программ меньше 50 - программист будет работать над новой
    while (total_written <= limit) {
        //входим в опасную секцию
        pthread_mutex_lock(&mutexWork) ;
        /*пока есть работа - пишем или исправляем неправильную, иначе ждем пока работа появится или придут правки*/
        sem_wait(&workToDo) ;
        /*сама программа - представляет собой число на отрезке [2:100]*/
        int data = (rand() + 2) % 100 ;
        //проверяем состояние проверки
        switch (works[pNum]) {
            //программист еще не писал программ - значение по умолчанию
            case 0:
                //программист пишет новую программу
                works[pNum] = data;
                //уведомление о написании программы
                printf("Programmer <%d> created his first program! Code: %d\n",pNum, data);
                //общее количество программ увеличивается
                total_written++;
                sem_post(&checkToDo);
                break;
                //программисту пришли правки, предыдущая программа написана неверно
            case -1:
                //программист переписывает работу
                works[pNum] = data;
                //уведомление о том, что работа переделана
                printf("Programmer <%d> rewrote his previous program! Code: %d\n",pNum,data);
                //общее число программ увеличивается
                total_written++;
                sem_post(&checkToDo);
                break;
                //программист написал программу успешно и готов писать следующую
            case 1:
                //программист пишет новую работу
                works[pNum] = data;
                //уведомление об успешной проверке и создании новой программы
                printf("Programmer <%d> successfully wrote his previous program and created a new one! Code: %d\n", pNum, data);
                //общее количество программ увеличивается
                total_written++;
                sem_post(&checkToDo);
                break;
        }
        //ожидание работы для проверки
        sem_wait(&checkToDo);
        //если разбкженный программист - действительно тот, которому передали работу
        if(works[(pNum + 1) % 3] != 0 and works[(pNum + 1) % 3] != -1 and works[(pNum + 1) % 3]!= 1) {
            //проверка на правильность
            switch (works[(pNum + 1) % 3] % 2) {
                case 0:
                    //1 - сигнал автору о том, что программа написана верно
                    works[(pNum + 1) % 3] = 1;
                    printf("Programmer <%d> checked program of the <%d> programmer -> GOOD JOB\n", pNum,
                           (pNum + 1) % 3);
                    break;
                case 1:
                    //-1 - сигнал автору о том, что программа написано неверно
                    works[(pNum + 1) % 3] = -1;
                    printf("Programmer <%d> checked program of the <%d> programmer -> WRONG\n", pNum, (pNum + 1) % 3);
                    break;
            }
        }
        else{
            //если разбуженный программист не имеет работ для проверки - он засыпает, а работа передается
            // нужному программисту
            sem_post(&checkToDo);
        }
        //выход из критической секции
        pthread_mutex_unlock(&mutexWork);
        sleep(1); //для более быстрой работы возможно закомментировать
    }
    return nullptr;
}

int main() {
    srand(seed);
    int i ;
    //инициализация мутексов и семафоров
    pthread_mutex_init(&mutexWork, nullptr) ;
    sem_init(&workToDo, 0, amountOfWork) ; //количество свободных ячеек равно bufSize
    sem_init(&checkToDo, 0, 0) ; //количество занятых ячеек равно 0

    //запуск производителей
    pthread_t pWriters[3] ;
    int numbersOfProg[3];
    for (i=0 ; i< 2 ; i++) {
        numbersOfProg[i] = i;
        pthread_create(&pWriters[i], nullptr, WriteAProgram, (void *) (numbersOfProg + i)) ;
    }
    //главный поток также будет являться программистом
    int mNum = 2;
    WriteAProgram((void *) &mNum);
    sleep(1);
    //вывод информации о количестве написанных программ
    printf("Total programms written: <%d>", total_written);
    return 0;
}