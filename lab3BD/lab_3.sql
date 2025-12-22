-- ñîðòèðîâêà ïî äâóì ïîëÿì
SELECT * FROM Doctor
ORDER BY Speciality ASC, Full_name DESC;
GO

-- where
SELECT * FROM Doctor
WHERE Speciality = N'Òåðàïåâò';
GO

-- where ñ íåñêîëüêèìè óñëîâèÿìè
SELECT Full_name, Age, District_Id FROM Patient
WHERE Age >= 40 AND District_Id = 5;
GO

-- àãðåãàòíûå ôóíêöèè áåç ãðóïïèðîâêè
SELECT 
    COUNT(*) AS [Êîëè÷åñòâî ïàöèåíòîâ],
    AVG(Age) AS [Ñðåäíèé âîçðàñò]
FROM Patient;
GO

-- àãðåãàòíûå ôóíêöèè ñ ãðóïïèðîâêîé
SELECT 
    District_Id,
    COUNT(*) AS [Êîë-âî ïàöèåíòîâ],
    MIN(Age) AS [Ìèíèìàëüíûé âîçðàñò]
FROM Patient
GROUP BY District_Id;
GO

-- rollup
SELECT 
    COALESCE(Speciality, 'Èòîãî') AS [Ñïåöèàëüíîñòü],
    COALESCE(CAST(Office_number AS NVARCHAR(20)), 'Âñå êàáèíåòû') AS [Íîìåð êàáèíåòà],
    COUNT(*) AS [Êîëè÷åñòâî âðà÷åé]
FROM Doctor
GROUP BY ROLLUP (Speciality, Office_number)
ORDER BY Speciality, Office_number;
GO

-- cube
SELECT 
    COALESCE(Diagnosis, 'Âñå äèàãíîçû') AS [Äèàãíîç],
    COALESCE(CAST(Doctor_Id AS NVARCHAR(20)), 'Âñå âðà÷è') AS [ID âðà÷à],
    COUNT(*) AS [Êîëè÷åñòâî ïðèåìîâ]
FROM Reception
GROUP BY CUBE (Diagnosis, Doctor_Id)
ORDER BY Diagnosis, Doctor_Id;
GO

-- like
SELECT * FROM Patient
WHERE Full_name NOT LIKE N'%îâà%';
GO

-- where
SELECT 
    r.Reception_time,
    r.Diagnosis,
    p.Full_name AS [Ïàöèåíò],
    d.Full_name AS [Âðà÷]
FROM Reception r, Patient p, Doctor d
WHERE r.Patient_ID = p.Id AND r.Doctor_Id = d.Id;
GO

-- inner join
SELECT 
    p.Full_name AS Ïàöèåíò,
    p.Age AS Âîçðàñò,
    d.Number AS Ó÷àñòîê,
    dr.Full_name AS [Ó÷àñòêîâûé âðà÷]
FROM Patient p
INNER JOIN District d ON p.District_Id = d.Id
INNER JOIN Doctor dr ON d.Doctor_Id = dr.Id;
GO

-- inner join 2
SELECT 
    d.Full_name AS Âðà÷,
    d.Speciality AS Ñïåöèàëüíîñòü,
    COUNT(r.Id) AS [Êîëè÷åñòâî ïðèåìîâ]
FROM Doctor d
INNER JOIN Reception r ON d.Id = r.Doctor_Id
GROUP BY d.Full_name, d.Speciality;
GO

-- left join
SELECT 
    d.Full_name,
    d.Speciality,
    s.Day_of_the_week,
    s.Start_time
FROM Doctor d
LEFT JOIN Schedule s ON d.Id = s.Doctor_Id;
GO

-- left join 2
SELECT 
    p.Full_name AS Ïàöèåíò,
    p.Age AS Âîçðàñò,
    r.Reception_time AS [Äàòà ïðèåìà],
    r.Diagnosis AS Äèàãíîç
FROM Patient p
LEFT JOIN Reception r ON p.Id = r.Patient_ID;
GO

-- right join
SELECT 
    s.Day_of_the_week,
    s.Start_time,
    d.Full_name,
    d.Speciality
FROM Doctor d
RIGHT JOIN Schedule s ON d.Id = s.Doctor_Id;
GO

-- right join 2
SELECT 
    s.Day_of_the_week AS Äåíü,
    s.Start_time AS [Âðåìÿ íà÷àëà],
    d.Speciality AS Ñïåöèàëüíîñòü,
    d.Office_number AS Êàáèíåò
FROM Schedule s
RIGHT JOIN Doctor d ON s.Doctor_Id = d.Id
ORDER BY s.Day_of_the_week, s.Start_time;
GO

-- àãðåãàòíûå ôóíêöèè
SELECT 
    d.Full_name AS [Âðà÷],
    COUNT(r.Patient_ID) AS [Êîëè÷åñòâî ïðèåìîâ]
FROM Doctor d
LEFT JOIN Reception r ON d.Id = r.Doctor_Id
GROUP BY d.Full_name;
GO

-- àãðåãàòíûå ôóíêöèè 2
SELECT 
    Day_of_the_week AS Äåíü,
    COUNT(*) AS [Êîëè÷åñòâî ñëîòîâ],
    MIN(Start_time) AS [Ñàìîå ðàííåå âðåìÿ],
    MAX(Start_time) AS [Ñàìîå ïîçäíåå âðåìÿ]
FROM Schedule
GROUP BY Day_of_the_week;
GO

-- having
SELECT 
    Doctor_Id,
    COUNT(*) AS [Êîëè÷åñòâî ïðèåìîâ]
FROM Reception
GROUP BY Doctor_Id
HAVING COUNT(*) >= 1;
GO

-- having 2
SELECT 
    Day_of_the_week AS Äåíü,
    COUNT(*) AS [Êîëè÷åñòâî çàïèñåé]
FROM Schedule
GROUP BY Day_of_the_week
HAVING COUNT(*) > 1;
GO

-- in
SELECT * FROM Patient
WHERE District_Id IN (
    SELECT Id FROM District 
    WHERE Doctor_Id IN (
        SELECT Id FROM Doctor WHERE Speciality = N'Òåðàïåâò'
    )
);
GO

-- in 2
SELECT 
    Full_name AS Ïàöèåíò,
    Age AS Âîçðàñò,
    District_Id AS Ó÷àñòîê
FROM Patient
WHERE District_Id IN (1, 2, 3);
GO


-- exists
SELECT * FROM Doctor d
WHERE EXISTS (
    SELECT 1 FROM Schedule s 
    WHERE s.Doctor_Id = d.Id AND s.Day_of_the_week = N'Ïîíåäåëüíèê'
);
GO

-- ïðåäñòàâëåíèå
IF OBJECT_ID('vw_ReceptionDetails', 'V') IS NOT NULL
    DROP VIEW vw_ReceptionDetails;
GO

CREATE VIEW vw_ReceptionDetails AS
SELECT 
    r.Id,
    r.Reception_time,
    r.Diagnosis,
    p.Full_name AS PatientName,
    p.Age,
    d.Full_name AS DoctorName,
    d.Speciality
FROM Reception r
INNER JOIN Patient p ON r.Patient_ID = p.Id
INNER JOIN Doctor d ON r.Doctor_Id = d.Id;
GO

SELECT * FROM vw_ReceptionDetails WHERE Diagnosis = N'Ïíåâìîíèÿ';
GO

-- ïðåäñòàâëåíèå 2
IF OBJECT_ID('vw_DistrictPatientCount', 'V') IS NOT NULL
    DROP VIEW vw_DistrictPatientCount;
GO

CREATE VIEW vw_DistrictPatientCount AS
SELECT 
    d.Number AS DistrictNumber,
    COUNT(p.Id) AS PatientCount
FROM District d
LEFT JOIN Patient p ON d.Id = p.District_Id
GROUP BY d.Number;
GO

SELECT * FROM vw_DistrictPatientCount ORDER BY PatientCount DESC;
GO

-- cte ñ ðàíæèðîâàíèåì
WITH DoctorReceptionCount AS (
    SELECT 
        Doctor_Id,
        COUNT(*) as ReceptionCount
    FROM Reception
    GROUP BY Doctor_Id
)
SELECT 
    d.Full_name,
    d.Speciality,
    rc.ReceptionCount,
    RANK() OVER (ORDER BY rc.ReceptionCount DESC) AS Rank
FROM DoctorReceptionCount rc
INNER JOIN Doctor d ON rc.Doctor_Id = d.Id;
GO

-- ðåêóðñèâíîå cte
WITH RankedDoctors AS (
    SELECT 
        Id,
        Full_name,
        Office_number,
        1 AS Level
    FROM Doctor
    WHERE Office_number BETWEEN 101 AND 105
    UNION ALL
    SELECT 
        d.Id,
        d.Full_name,
        d.Office_number,
        rd.Level + 1
    FROM Doctor d
    INNER JOIN RankedDoctors rd ON d.Office_number = rd.Office_number + 100
)
SELECT * FROM RankedDoctors;
GO

-- row_number
SELECT 
    Full_name,
    Age,
    District_Id,
    ROW_NUMBER() OVER (PARTITION BY District_Id ORDER BY Age DESC) AS RowNum
FROM Patient;
GO

-- rank è dense_rank
WITH ScheduleCount AS (
    SELECT 
        Doctor_Id,
        COUNT(*) AS ScheduleEntries
    FROM Schedule
    GROUP BY Doctor_Id
)
SELECT 
    d.Full_name,
    sc.ScheduleEntries,
    RANK() OVER (ORDER BY sc.ScheduleEntries DESC) AS [Rank],
    DENSE_RANK() OVER (ORDER BY sc.ScheduleEntries DESC) AS [DenseRank]
FROM ScheduleCount sc
INNER JOIN Doctor d ON sc.Doctor_Id = d.Id;
GO

-- union all
SELECT Speciality AS [Íàçâàíèå] FROM Doctor
UNION ALL
SELECT Diagnosis FROM Reception;
GO

-- except
SELECT Id, Full_name FROM Patient
EXCEPT
SELECT DISTINCT p.Id, p.Full_name
FROM Patient p
INNER JOIN Reception r ON p.Id = r.Patient_ID
INNER JOIN Doctor d ON r.Doctor_Id = d.Id
WHERE d.Speciality = N'Òåðàïåâò';
GO

-- intersect
SELECT Full_name AS [Ïàöèåíòû, ïîñåùàâøèå òåðàïåâòà]
FROM Patient
WHERE Id IN (
    SELECT Patient_ID FROM Reception WHERE Doctor_Id IN (SELECT Id FROM Doctor WHERE Speciality = N'Òåðàïåâò')
)
ORDER BY Full_name;
GO

-- case
SELECT 
    District_Id,
    COUNT(CASE WHEN Age BETWEEN 0 AND 18 THEN 1 END) AS [0-18],
    COUNT(CASE WHEN Age BETWEEN 19 AND 40 THEN 1 END) AS [19-40],
    COUNT(CASE WHEN Age > 40 THEN 1 END) AS [40+]
FROM Patient
GROUP BY District_Id;
GO

-- pivot
WITH ReceptionsByDay AS (
    SELECT 
        FORMAT(Reception_time, 'dddd', 'ru-ru') AS DayOfWeek,
        Id
    FROM Reception
)
SELECT * FROM (
    SELECT DayOfWeek FROM ReceptionsByDay
) AS SourceTable
PIVOT (
    COUNT(DayOfWeek) FOR DayOfWeek IN ([ïîíåäåëüíèê], [âòîðíèê], [ñðåäà], [÷åòâåðã], [ïÿòíèöà], [ñóááîòà], [âîñêðåñåíüå])
) AS PivotTable;
GO

-- unpivot
WITH PivotData AS (
    SELECT 
        District_Id,
        COUNT(CASE WHEN Age < 18 THEN 1 END) AS [Äåòè],
        COUNT(CASE WHEN Age BETWEEN 18 AND 60 THEN 1 END) AS [Âçðîñëûå],
        COUNT(CASE WHEN Age > 60 THEN 1 END) AS [Ïåíñèîíåðû]
    FROM Patient
    GROUP BY District_Id
)
SELECT District_Id, AgeGroup, PatientCount
FROM PivotData
UNPIVOT (
    PatientCount FOR AgeGroup IN ([Äåòè], [Âçðîñëûå], [Ïåíñèîíåðû])
) AS Unpivot_test;
GO

-- ÷àñòü 2 à
SELECT 
    s.Day_of_the_week,
    s.Start_time,
    s.Duration,
    d.Full_name AS Doctor
FROM Schedule s
INNER JOIN Doctor d ON s.Doctor_Id = d.Id
WHERE d.Id = 1 
    AND s.Day_of_the_week = N'Ïîíåäåëüíèê'
    AND NOT EXISTS (
        SELECT 1 FROM Reception r 
        WHERE r.Doctor_Id = s.Doctor_Id 
          AND CAST(r.Reception_time AS TIME) = s.Start_time
          AND DATEPART(weekday, r.Reception_time) = 2
    );
GO

-- ÷àñòü 2 á
SELECT 
    r.Reception_time,
    r.Diagnosis,
    d.Full_name AS Doctor,
    d.Speciality
FROM Reception r
INNER JOIN Patient p ON r.Patient_ID = p.Id
INNER JOIN Doctor d ON r.Doctor_Id = d.Id
WHERE p.Full_name = N'Ñìèðíîâ Êîíñòàíòèí Äìèòðèåâè÷'
    AND r.Reception_time >= '2024-01-01'
ORDER BY r.Reception_time;
GO

-- ÷àñòü 2 c
SELECT DISTINCT
    d.Full_name,
    d.Speciality,
    s.Day_of_the_week,
    s.Start_time
FROM Schedule s
INNER JOIN Doctor d ON s.Doctor_Id = d.Id
WHERE s.Day_of_the_week = DATENAME(weekday, GETDATE());
GO

-- ÷àñòü 2 d
SELECT 
    CASE 
        WHEN p.Age BETWEEN 14 AND 18 THEN '14-18'
        WHEN p.Age BETWEEN 19 AND 45 THEN '19-45'
        WHEN p.Age BETWEEN 46 AND 65 THEN '46-65'
        WHEN p.Age >= 66 THEN '66+'
        ELSE 'Äðóãîå'
    END AS AgeGroup,
    COUNT(*) AS PneumoniaCount
FROM Reception r
INNER JOIN Patient p ON r.Patient_ID = p.Id
WHERE r.Diagnosis = N'Ïíåâìîíèÿ'
    AND r.Reception_time >= '2024-01-01'
GROUP BY 
    CASE 
        WHEN p.Age BETWEEN 14 AND 18 THEN '14-18'
        WHEN p.Age BETWEEN 19 AND 45 THEN '19-45'
        WHEN p.Age BETWEEN 46 AND 65 THEN '46-65'
        WHEN p.Age >= 66 THEN '66+'
        ELSE 'Äðóãîå'
    END
ORDER BY AgeGroup;
GO

-- ÷àñòü 2 e
SELECT 
    dist.Number AS DistrictNumber,
    COUNT(r.Id) AS VisitCount
FROM District dist
LEFT JOIN Patient p ON dist.Id = p.District_Id
LEFT JOIN Reception r ON p.Id = r.Patient_ID 
    AND CAST(r.Reception_time AS DATE) = '2024-01-17'
GROUP BY dist.Number
ORDER BY VisitCount DESC;
GO
