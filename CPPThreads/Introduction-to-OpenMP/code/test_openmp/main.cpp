#include <iostream>
#include <vector>
#include <unistd.h>
#include <omp.h>
using namespace std;

//метод для обработки аргументов, введенных пользователем
int getArgs() {
    cout << "Please input amount of sectors in the forest (0 < x < 10 000): ";
    int amount;
    cin >> amount;
    while (amount <= 0 or amount > 10000) {
        cout << "Incorrect input, please try again: ";
        cin >> amount;
    }
    return amount;
}

//метод для получения количества потоков
int getThreadsNum(){
    cout << "Please input amount of bee squads (1 < x < 10): ";
    int threadAmount;
    cin >> threadAmount;
    while(threadAmount <= 0 or threadAmount > 10){
        cout << "Error: incorrect number of threads, please try again: ";
        cin >> threadAmount;
    }
    return threadAmount;
}

//инициализируем лес, разбитый по секторам
int* sectors;
//сектор, который подлежит рассмотрению прямо сейчас
int currentSector = 0;
//количество секторов
int sectors_amount;
//разыскивается ли Винни Пух сейчас или нет
bool wanted = true;
//поток, который нашел Винни
int thredThatFound = -1;


int main() {
    //устанавливаем сид для рандома
    srand(time(0));
    //получаем количество секторов
    sectors_amount = getArgs();
    //получаем количество потоков от пользователя
    omp_set_num_threads(getThreadsNum());
    //инициалищируем секторы леса
    sectors = new int[sectors_amount] {0};
    //расчитываем в каком секторе прячется Винни (случайно)
    int sector = rand() % sectors_amount;
    //помещаем винни в сектор леса
    sectors[1] = 1;
    //выводим сектор на экран для информирования
    cout << "Winnie the Pooh is in the " << sector << "th sector" << endl << "////////////////////////////////////////"
                                                                             "///" << endl;
    //блок предназначенный для выполнения параллельно
#pragma omp parallel shared(wanted, currentSector) default(shared)
    {
        //получение номера потока
        int rNum = omp_get_thread_num();
        //выполянем наш поиск до тех пор пока Винни не найден
        while (wanted) {
            int i, sector;
            //критическая секция
#pragma omp critical
            {
                if(currentSector < sectors_amount){
                    //получаем значение данного сектора в массиве (есть там Винни или нет) 1 - присутствует 0 - отсутсвует
                    sector = sectors[currentSector++];
                    i = currentSector - 1;
                }
                else{
                    sleep(100);
                }

            }

            //если в данном секторе присутствует Винни - пчелы его находят
            if (sector == 1) {
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
  //          sleep(1); для тестов (более равномерного распредления - раскомментировать)
        }
    }

    //вывод результатов
    cout << "///////////////////////////////////////////" << endl << "Bees squad " << thredThatFound
         << " found Winnie! MISSION COMPLETED" <<
         endl;
    return 0;

}
