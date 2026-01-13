<h1 name="content" align="center"><a href=""><img src="https://github.com/user-attachments/assets/e080adec-6af7-4bd2-b232-d43cb37024ac" width="20" height="20"/></a> MSSQL</h1>

<p align="center">
  <a href="#-lab1"><img alt="lab1" src="https://img.shields.io/badge/Lab1-blue"></a> 
  <a href="#-lab2"><img alt="lab2" src="https://img.shields.io/badge/Lab2-red"></a>
  <a href="#-lab3"><img alt="lab3" src="https://img.shields.io/badge/Lab3-green"></a>
   <a href="#-lab4"><img alt="lab4" src="https://img.shields.io/badge/Lab4-pink"></a>
  <a href="#-lab5"><img alt="lab5" src="https://img.shields.io/badge/Lab5-black"></a>
  <a href="#-lab6"><img alt="lab6" src="https://img.shields.io/badge/Lab6-purple"></a>
  <a href="#-lab7"><img alt="lab7" src="https://img.shields.io/badge/Lab7-white"></a>
  <a href="#-lab8"><img alt="lab8" src="https://img.shields.io/badge/Lab8-cyan"></a>
</p>

# <img src="https://github.com/user-attachments/assets/e080adec-6af7-4bd2-b232-d43cb37024ac" width="20" height="20"/> Lab1

[Назад](#content)
<h3 align="center">
  <a href="#client"></a>
  1.1 Разработать ER-модель данной предметной области: выделить сущности, их атрибуты, связи между сущностями. 
</h3>

![image](/Lab1BD/lab1er.png)

<h3 align="center">
  <a href="#client"></a>
  1.2 По имеющейся ER-модели создать реляционную модель данных и отобразить ее в виде списка сущностей с их атрибутами и типами атрибутов,  для атрибутов указать, явл. ли он первичным или внешним ключом 
</h3>

![image](/Lab1BD/lab1er.png)

# <img src="https://github.com/user-attachments/assets/e080adec-6af7-4bd2-b232-d43cb37024ac" width="20" height="20"/> Lab2

[Назад](#content) 

<h3 align="center"> 
  <a href="#client"></a>
  2 В соответствии с реляционной моделью данных, разработанной в Лаб.№1, создать реляционную БД на учебном сервере БД :
- создать таблицы, определить первичные ключи и иные ограничения
- определить связи между таблицами
- создать диаграмму
- заполнить все таблицы адекватной информацией (не меньше 10 записей в таблицах, наличие примеров для связей типа 1:M )
</h3>

Создание таблицы

```tsql
CREATE TABLE Doctor (
    id INT IDENTITY(1,1) PRIMARY KEY,
    office_number INT,
    full_name NVARCHAR(50) NOT NULL,
    phone NVARCHAR(20),
    speciality NVARCHAR(30)
);

CREATE TABLE District (
    id INT IDENTITY(1,1) PRIMARY KEY ,
    number INT NOT NULL,
    doctor_id INT REFERENCES Doctor(id) ON DELETE SET NULL
);

CREATE TABLE Schedule (
    id INT IDENTITY(1,1) PRIMARY KEY,
    day_of_the_week NVARCHAR(15) NOT NULL,
    start_time TIME NOT NULL,
    duration INT NOT NULL,
    doctor_id INT REFERENCES Doctor(id) ON DELETE CASCADE
);

CREATE TABLE Patient (
    id INT IDENTITY(1,1) PRIMARY KEY,
    phone NVARCHAR(20),
    full_name NVARCHAR(50) NOT NULL,
    district_Id INT REFERENCES District(id) ON DELETE SET NULL
);

CREATE TABLE Reception (
    id INT IDENTITY(1,1) PRIMARY KEY,
    reception_time DATETIME NOT NULL,
    diagnosis NVARCHAR(100),
    patient_id INT REFERENCES Patient(id) ON DELETE CASCADE,
    doctor_id INT REFERENCES Doctor(id) ON DELETE NO ACTION
);

CREATE TABLE Stattalon (
    id INT IDENTITY(1,1) PRIMARY KEY,
    purpose NVARCHAR(100),
    schedule_id INT REFERENCES Schedule(id) ON DELETE CASCADE,
    doctor_id INT REFERENCES Doctor(id) ON DELETE NO ACTION,
    patient_id INT REFERENCES Patient(id) ON DELETE NO ACTION
);
```

Диаграмма

![image](/lab2BD/lab2diagram.png)

Заполненные данными таблицы:

Doctor

![image](/lab2BD/lab2doctor.png)

Patient

![image](/lab2BD/lab2patient.png)

Reception

![image](/lab2BD/lab2reception.png)

Schedule

![image](/lab2BD/lab2schedule.png)

Stattalon

![image](/lab2BD/lab2stattalon.png)

District

![image](/lab2BD/lab2district.png)


# <img src="https://github.com/user-attachments/assets/e080adec-6af7-4bd2-b232-d43cb37024ac" width="20" height="20"/> Lab3

[Назад](#content)

<h3 align="center">
  [otchet](/lab3BD/Kudryavcev_PMI32.docx)
</h3>
[otchet](/lab3BD/Kudryavcev_PMI32.docx)

# <img src="https://github.com/user-attachments/assets/e080adec-6af7-4bd2-b232-d43cb37024ac" width="20" height="20"/> Lab4

[Назад](#content)\
  <a href="#client"></a>
  
  Процедуры:
a) Процедура без параметров, возвращающая расписание работы врачей на текущую дату: ФИО врача, кабинет, время начала работы, количество записавшихся на этот день пациентов

  ![image](/lab4BD/proc_a.jpg)

b) Процедура, на входе получающая номер участка и формирующая список улиц, находящихся на этом участке

  ![image](/lab4BD/proc_b.jpg)
  
  ![image](/lab4BD/proc_b_test.jpg)

c) Процедура, получающая номер участка как входной параметр, формирующая выходной параметр  – ФИО врача, обслуживающего данный участок
  
  ![image](/lab4BD/proc_c.jpg)
  
  ![image](/lab4BD/proc_c_test.jpg)

d) Процедура, находящая один из участков с максимальным количеством домов и возвращающая ФИО врача, обслуживающего данный участок (с использованием вызова предыдущей процедуры)
  
  ![image](/lab4BD/proc_d.jpg)
  
  ![image](/lab4BD/proc_d_test.jpg)
  
  Функции:
a) Скалярная функция, возвращающая по адресу (улица, дом) номер участка
  
  ![image](/lab4BD/func_a.jpg)
  
  ![image](/lab4BD/func_a_test.jpg)

b) Inline-функция, возвращающая все посещения заданного пациента за текущий год
  
  ![image](/lab4BD/func_b.jpg)

c) Multi-statement-функция, возвращающая список свободных явок на текущую неделю к заданному врачу в формате день недели, время 
  
  ![image](/lab4BD/func_c.jpg)
  
  ![image](/lab4BD/func_c2.jpg)
  
  ![image](/lab4BD/func_c_test.jpg)
 
  Тригеры:
a) Триггер любого типа на добавление нового врача – если это терапевт и номер участка не заполнен, то выводится сообщение об этом, и запись не добавляется
  
  ![image](/lab4BD/trig_a.jpg)
  
  ![image](/lab4BD/trig_a_testjpg.jpg)
  
b)  Последующий триггер на изменение номера кабинета у врача – если этот кабинет проставлен у другого врача и он пересекается по дням недели хотя бы в 1 день с данным врачом, то отменить изменение
  
  ![image](/lab4BD/trig_b.jpg)
  
  ![image](/lab4BD/trig_b_test.jpg)

c) Замещающий триггер на операцию удаления строки из графика приема врача – если на даты, соответствующие дню недели удаляемой строки, выданы талоны, то строка не удаляется
  
   ![image](/lab4BD/trig_c.jpg)
 
   ![image](/lab4BD/trig_c_test.jpg)



# <img src="https://github.com/user-attachments/assets/e080adec-6af7-4bd2-b232-d43cb37024ac" width="20" height="20"/> Lab5

[Назад](#content)
  <a href="#client"></a>
  1-я роль должна иметь доступ к таблицам, хр. процедурам и др. объектам БД, требующийся для руководителя фирмы . Некоторые права необходимо предоставить с возможностью дальнейшей передачи.
2-я роль должна иметь доступ, требующийся для простого сотрудника.
Выполнить маскирование некоторых поле Ваших таблиц  2-мя различными методами. 
1. ALTER COLUMN LastName ADD MASKED WITH (FUNCTION = 'partial(2,"xxxx",0)')
2. Используя механизмы представлений, хранимых процедур и функций.

![image](/lab5BD/script_1.jpg)
![image](/lab5BD/script_2.jpg)

# <img src="https://github.com/user-attachments/assets/e080adec-6af7-4bd2-b232-d43cb37024ac" width="20" height="20"/> Lab6

[Назад](#content)
  <a href="#client"></a>
  Используйте реляционную БД из лабораторной работы №2.
  
Продумайте и создайте графовые таблицы по реляционной БД, заполните графовые таблицы используя данные в реляционных таблицах.

Напишите запросы из задания 3.2 используя паттерн MATCH.


![image](/Lab6BD/Node_Table_.jpg)

[script](/Lab6BD/Lab_6.sql)


# <img src="https://github.com/user-attachments/assets/e080adec-6af7-4bd2-b232-d43cb37024ac" width="20" height="20"/> Lab7

[Назад](#content)
  <a href="#client"></a>
  Используя базу, полученную в лабораторной 2, создать транзакцию, произвести ее откат и фиксацию. Показать, что данные существовали до отката, удалились после отката, снова были добавлены, и затем были успешно зафиксированы. При необходимости используйте точки сохранения и вложенные транзакции.

[script](/Lab7BD/1_script_.sql)

1.1 Rollback

Добавляем тестового пациента и провереям его существовани

![image](/Lab7BD/rollback/roll1.jpg)
![image](/Lab7BD/rollback/roll2.jpg)

Откатим транзакцию

![image](/Lab7BD/rollback/roll3.jpg)

1.2 Commit

Снова добавим тестового пациента

![image](/Lab7BD/commit/comm1.jpg)

Проверим данные после коммита, пациеннт был записан

![image](/Lab7BD/commit/comm1.jpg)

1.3 Внутренние транзакции

Добавим тестового пациента

![image](/Lab7BD/inner/inn1.jpg)

Откатим внутренюю транзакцию, последний пример не записывается

![image](/Lab7BD/inner/inn2.jpg)

Откатим внешнюю транзакцию, тестовый пациент не существует

![image](/Lab7BD/inner/inn3.jpg)
  
Подготовить SQL-скрипты для выполнения проверок изолированности транзакций. Ваши скрипты должны работать с одной из таблиц, созданных в лабораторной работе №2.


READ UNCOMMITED

![image](/Lab7BD/readuncommited/lost_1.jpg)
![image](/Lab7BD/readuncommited/lost_2.jpg)

Изменения первой транзакции потеряны, вторая транзакция перезаписала данные до фиксации первой

![image](/Lab7BD/readuncommited/dirty_1.jpg)
![image](/Lab7BD/readuncommited/dirty_2.jpg)

Вторая транзакция прочитала незафиксированные данные из первой транзакции


READ COMMITED

![image](/Lab7BD/readcommited/dirty_1.jpg)
![image](/Lab7BD/readcommited/dirty_2.jpg)

Грязное чтение предотвращено, вторая транзакция не видит незафиксированных изменений

![image](/Lab7BD/readcommited/unrepeat_1.jpg)
![image](/Lab7BD/readcommited/unrepeat_2.jpg)

Второе чтение в первой транзакции показало измененные данные


REPEATABLE READ

![image](/Lab7BD/repeatableread/unrepeat_1.jpg)

![image](/Lab7BD/repeatableread/unrepeat_2.jpg)

Неповторяющееся чтение предотвращено, вторая транзакция ожидает завершения первой

![image](/Lab7BD/repeatableread/phant_1.jpg)
![image](/Lab7BD/repeatableread/phant_2.jpg)

Появились новые строки при повторном чтении.


SERIALIZABLE

![image](/Lab7BD/repeatableread/phant_1.jpg)
![image](/Lab7BD/repeatableread/phant_2.jpg)

Serializable защитил от фантомного чтения, вторая транзакция ожидает завершения первой.


# <img src="https://github.com/user-attachments/assets/e080adec-6af7-4bd2-b232-d43cb37024ac" width="20" height="20"/> Lab8

[Назад](#content)
  <a href="#client"></a>

  [otchet](/Lab8BD/Lab8BD_.docx)
