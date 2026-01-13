-- rollback
begin transaction;
save transaction beforeinsert;

-- добавляем нового пациента
insert into patient (phone, full_name, district_id, age) 
values (N'+79101112233', N'тестовый пациент иванов', 1, 35);

-- проверяем количество пациентов с таким именем
select count(*) from patient 
where full_name = N'тестовый пациент иванов';

-- добавляем запись о приеме для этого пациента
declare @new_patient_id int = scope_identity();

insert into reception (reception_time, diagnosis, patient_id, doctor_id, stattalon_id)
values ('2025-12-12 10:00:00', N'первичный осмотр', @new_patient_id, 1, 1);

select top 1 * from reception order by id desc;

rollback transaction;

select count(*) as patients_after_rollback from patient 
where full_name = N'тестовый пациент иванов';

select count(*) as total_patients_after_rollback from patient;

go

--commit
begin transaction;
save transaction beforenewdata;

insert into patient (phone, full_name, district_id, age) 
values (N'+79101112233', N'тестовый пациент петров', 1, 40);

declare @committed_patient_id int = scope_identity();

insert into reception (reception_time, diagnosis, patient_id, doctor_id, stattalon_id)
values ('2025-12-12 11:00:00', N'профилактический осмотр', @committed_patient_id, 2, 2);

declare @new_reception_id int = scope_identity();

update reception 
set diagnosis = N'транзакция успешно зафиксирована' 
where id = @new_reception_id;

select p.full_name, p.phone, r.reception_time, r.diagnosis
from patient p
left join reception r on p.id = r.patient_id
where p.id = @committed_patient_id;

commit transaction;

-- проверяем данные после коммита
select count(*) from patient 
where full_name = N'тестовый пациент петров';

select top 1 id, full_name, phone, district_id, age
from patient order by id desc;

go

-- internal transactions
select count(*) from patient 
where full_name = N'тестовый пациент сидоров';

begin transaction outertx;

save transaction sp1;

insert into patient (phone, full_name, district_id, age) 
values (N'+79101113344', N'тестовый пациент сидоров', 2, 45);

declare @patientid int = scope_identity();

-- начинаем внутреннюю транзакцию
begin transaction innertx;

save transaction sp2;

insert into reception (reception_time, diagnosis, patient_id, doctor_id, stattalon_id)
values (getdate(), N'консультация', @patientid, 3, 3);

select top 1 * from reception order by id desc;

rollback transaction sp2;

select top 1 * from reception order by id desc;

-- фиксируем внутреннюю транзакцию
commit transaction innertx;

-- откатываем внешнюю транзакцию
rollback transaction outertx;

select count(*) from patient 
where full_name = N'тестовый пациент сидоров';

go