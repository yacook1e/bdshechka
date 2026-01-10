-- Create, Insert
CREATE TABLE DoctorNode (
    id INT PRIMARY KEY,
    office_number INT,
    full_name NVARCHAR(50) NOT NULL,
    phone NVARCHAR(20),
    speciality NVARCHAR(30)
) AS NODE;

CREATE TABLE DistrictNode (
    id INT PRIMARY KEY,
    number INT NOT NULL
) AS NODE;

CREATE TABLE ScheduleNode (
    id INT PRIMARY KEY,
    day_of_the_week NVARCHAR(15) NOT NULL,
    start_time TIME NOT NULL,
    duration INT NOT NULL
) AS NODE;

CREATE TABLE PatientNode (
    id INT PRIMARY KEY,
    phone NVARCHAR(20),
    full_name NVARCHAR(50) NOT NULL,
    age INT,
    district_Id INT
) AS NODE;

CREATE TABLE ReceptionNode (
    id INT PRIMARY KEY,
    reception_time DATETIME NOT NULL,
    diagnosis NVARCHAR(100)
) AS NODE;

CREATE TABLE StattalonNode (
    id INT PRIMARY KEY,
    purpose NVARCHAR(100)
) AS NODE;

CREATE TABLE StreetNode (
    id INT PRIMARY KEY,
    name NVARCHAR(100) NOT NULL
) AS NODE;

CREATE TABLE HouseNode (
    id INT PRIMARY KEY,
    number NVARCHAR(20) NOT NULL
) AS NODE;

CREATE TABLE works_in AS EDGE; 
CREATE TABLE has_schedule AS EDGE; 
CREATE TABLE belongs_to AS EDGE;
CREATE TABLE attended AS EDGE; 
CREATE TABLE conducted_by AS EDGE; 
CREATE TABLE has_stattalon AS EDGE;
CREATE TABLE prescribed_for AS EDGE; 
CREATE TABLE issued_by AS EDGE;
CREATE TABLE issued_to AS EDGE;
CREATE TABLE located_in AS EDGE; 
CREATE TABLE has_house AS EDGE; 

INSERT INTO DoctorNode (id, office_number, full_name, phone, speciality)
SELECT id, office_number, full_name, phone, speciality FROM Doctor;

INSERT INTO DistrictNode (id, number)
SELECT id, number FROM District;

INSERT INTO ScheduleNode (id, day_of_the_week, start_time, duration)
SELECT id, day_of_the_week, start_time, duration FROM Schedule;

INSERT INTO PatientNode (id, phone, full_name, district_Id, age)
SELECT id, phone, full_name, district_Id, age FROM Patient;

INSERT INTO ReceptionNode (id, reception_time, diagnosis)
SELECT id, reception_time, diagnosis FROM Reception;

INSERT INTO StattalonNode (id, purpose)
SELECT id, purpose FROM Stattalon;

INSERT INTO StreetNode (id, name)
SELECT id, name FROM Street;

INSERT INTO HouseNode (id, number)
SELECT id, number FROM House;

INSERT INTO works_in ($from_id, $to_id)
SELECT d.$node_id, dist.$node_id
FROM DoctorNode d
INNER JOIN District dist ON d.id = dist.doctor_id;

INSERT INTO has_schedule ($from_id, $to_id)
SELECT d.$node_id, s.$node_id
FROM DoctorNode d
INNER JOIN Schedule s ON d.id = s.doctor_id;

INSERT INTO belongs_to ($from_id, $to_id)
SELECT p.$node_id, dist.$node_id
FROM PatientNode p
INNER JOIN DistrictNode dist ON p.district_Id = dist.id;

INSERT INTO attended ($from_id, $to_id)
SELECT r.$node_id, p.$node_id
FROM ReceptionNode r
INNER JOIN Patient p ON r.id = p.id;

INSERT INTO conducted_by ($from_id, $to_id)
SELECT r.$node_id, d.$node_id
FROM ReceptionNode r
INNER JOIN Doctor d ON r.id = d.id;

INSERT INTO has_stattalon ($from_id, $to_id)
SELECT r.$node_id, s.$node_id
FROM ReceptionNode r
INNER JOIN Stattalon s ON r.id = s.id;

INSERT INTO prescribed_for ($from_id, $to_id)
SELECT st.$node_id, sc.$node_id
FROM StattalonNode st
INNER JOIN Schedule sc ON st.id = sc.id;

INSERT INTO issued_by ($from_id, $to_id)
SELECT st.$node_id, d.$node_id
FROM StattalonNode st
INNER JOIN Doctor d ON st.id = d.id;

INSERT INTO issued_to ($from_id, $to_id)
SELECT st.$node_id, p.$node_id
FROM StattalonNode st
INNER JOIN Patient p ON st.id = p.id;

INSERT INTO located_in ($from_id, $to_id)
SELECT st.$node_id, d.$node_id
FROM StreetNode st
INNER JOIN District d ON st.id = d.id;

INSERT INTO has_house ($from_id, $to_id)
SELECT st.$node_id, h.$node_id
FROM StreetNode st
INNER JOIN House h ON st.id = h.street_id;


-- 3.2 Requests
-- 2a
SELECT 
    s.day_of_the_week,
    s.start_time,
    s.duration,
    d.full_name AS Doctor
FROM DoctorNode d, has_schedule hs, ScheduleNode s
WHERE MATCH(d-(hs)->s)
    AND d.id = 1 
    AND s.day_of_the_week = N'Понедельник'
    AND NOT EXISTS (
        SELECT 1 
        FROM ReceptionNode r, conducted_by cb, DoctorNode d2
        WHERE MATCH(r-(cb)->d2)
            AND d2.id = 1
            AND CAST(r.reception_time AS TIME) = s.start_time
            AND DATEPART(weekday, r.reception_time) = 2
    );

-- 2b
SELECT 
    r.reception_time,
    r.diagnosis,
    d.full_name AS Doctor,
    d.speciality
FROM PatientNode p, attended a, ReceptionNode r, conducted_by cb, DoctorNode d
WHERE MATCH(p-(a)->r-(cb)->d)
    AND p.full_name = N'Смирнов Константин Дмитриевич'
    AND r.reception_time >= '2024-01-01'
ORDER BY r.reception_time;

-- 2c
SELECT DISTINCT
    d.full_name,
    d.speciality,
    s.day_of_the_week,
    s.start_time
FROM DoctorNode d, has_schedule hs, ScheduleNode s
WHERE MATCH(d-(hs)->s)
    AND s.day_of_the_week = DATENAME(weekday, GETDATE());

-- 2d
SELECT 
    CASE 
        WHEN p.age BETWEEN 14 AND 18 THEN '14-18'
        WHEN p.age BETWEEN 19 AND 45 THEN '19-45'
        WHEN p.age BETWEEN 46 AND 65 THEN '46-65'
        WHEN p.age >= 66 THEN '66+'
        ELSE 'Другое'
    END AS AgeGroup,
    COUNT(*) AS PneumoniaCount
FROM PatientNode p, attended a, ReceptionNode r
WHERE MATCH(p-(a)->r)
    AND r.diagnosis = N'Пневмония'
    AND r.reception_time >= '2024-01-01'
GROUP BY 
    CASE 
        WHEN p.age BETWEEN 14 AND 18 THEN '14-18'
        WHEN p.age BETWEEN 19 AND 45 THEN '19-45'
        WHEN p.age BETWEEN 46 AND 65 THEN '46-65'
        WHEN p.age >= 66 THEN '66+'
        ELSE 'Другое'
    END
ORDER BY AgeGroup;

-- 2e
SELECT 
    dist.number AS DistrictNumber,
    COUNT(r.id) AS VisitCount
FROM DistrictNode dist, belongs_to bt, PatientNode p, attended a, ReceptionNode r
WHERE MATCH(dist<-(bt)-p-(a)->r)
    AND CAST(r.reception_time AS DATE) = '2024-01-17'
GROUP BY dist.number
ORDER BY VisitCount DESC;