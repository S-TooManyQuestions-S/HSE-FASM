#include <iostream>
#include <vector>
#include <zconf.h>

using namespace std;

//метод для обработки аргументов, введенных пользователем
int getArgs()
{
    cout << "Please input amount of sectors in the forest (0 < x < 10 000): ";
    int amount;
    cin >> amount;
    while(amount <= 0 or amount > 10000)
    {
        cout << "Incorrect input, please try again: ";
        cin >> amount;
    }
    return amount;
}

pthread_rwlock_t rwlock; //блокировка чтения-записи

//инициализируем лес, разбитый по секторам
int  *sectors;
//сектор, который подлежит рассмотрению прямо сейчас
int currentSector = 0;
//количество секторов
int sectors_amount;
//разыскивается ли Винни Пух сейчас или нет
bool wanted = true;
//поток, который нашел Винни
int thredThatFound = -1;

//метод для поиска Винни Пуха в лесу
void *findWinnie(void *param)
{
    //получение номера потока
    int rNum = *((int*)param);
    //выполянем наш поиск до тех пор пока Винни не найден
    while(wanted) {
            //применяем парадигму портфеля задач - берем сектор из списка секторов, которые необходимо проверить
            //блокируем для чтения
            pthread_rwlock_wrlock(&rwlock);
            //считываем сектор, который проверяет данный поток и сдвигаем указатель на следующий сектор
            int i = currentSector++;
            //получаем значение данного сектора в массиве (есть там Винни или нет) 1 - присутствует 0 - отсутсвует
            int sector  = sectors[i];
            //разблокируем для чтения
            pthread_rwlock_unlock(&rwlock);
            //если в данном секторе присутствует Винни - пчелы его находят
            if(sector == 1){
                //выыводится соотвественная информация о поимке Винни
                fprintf(stdout, "Bees squad <%d> found the Pooh in the <%d>th sector and executed him!\n", rNum, i);
                //винни больше не разыскивается
                wanted = false;
                //запоминаем, какой поток нашел Винни
                thredThatFound = rNum;
        }
            else {
                //если винни не окозалось в лесу - выводится соответствующее предупреждение
                fprintf(stdout,
                        "Bees squad <%d> did not find the Pooh in the <%d>th sector and coming back in the hive!\n",
                        rNum, i);
            }
    }
    return nullptr;
}


int main() {
    //устанавливаем сид для рандома
    srand(time(0));
    //получаем количество секторов
    sectors_amount = getArgs();
    //инициалищируем секторы леса
    sectors = new int [sectors_amount]{0};
    //расчитываем в каком секторе прячется Винни (случайно)
    int sector = rand() % sectors_amount;
    //помещаем винни в сектор леса
    sectors[sector] = 1;
    //выводим сектор на экран для информирования
    cout <<"Winnie the Pooh is in the " << sector <<"th sector" << endl << "////////////////////////////////////////"
                                                                           "///" << endl;
    //инициализация блокировки чтения
    pthread_rwlock_init(&rwlock, NULL);
    //создание 4 потоков
    pthread_t threads[4];
    int numbers[4];
    for (int i = 0; i < 4; ++i) {
        //присваиваем номера каждому потоку
        numbers[i] = i + 1;
        pthread_create(&threads[i], NULL, findWinnie, (void *) (numbers + i));
    }

    //вызываем нашу функцию для поиска Винни
    findWinnie((void *) &numbers[0]);
    //главный поток ждет выполнения всех остальных
    for (int i = 0; i < 4; ++i) {
        pthread_join(threads[i], NULL);
    }
    //вывод результатов
    cout <<
            "///////////////////////////////////////////" << endl << "Bees squad "<< thredThatFound << " found Winnie! MISSION COMPLETED" << endl;
    return 0;
}
