SELECT * FROM Patient WHERE id = 11;

BEGIN TRANSACTION;

INSERT INTO Patient (phone, full_name, district_Id, Age) 
VALUES (N'+79101112233', N'Петров Иван Сергеевич', 1, 35);

SELECT * FROM Patient WHERE phone = N'+79101112233';

ROLLBACK TRANSACTION;

SELECT * FROM Patient WHERE phone = N'+79101112233';

BEGIN TRANSACTION;

INSERT INTO Patient (phone, full_name, district_Id, Age) 
VALUES (N'+79101112233', N'Петров Иван Сергеевич', 1, 35);

COMMIT TRANSACTION;

SELECT * FROM Patient WHERE phone = N'+79101112233';