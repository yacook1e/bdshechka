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
    doctor_id INT REFERENCES Doctor(id) ON DELETE NO ACTION
);

CREATE TABLE Schedule (
    id INT IDENTITY(1,1) PRIMARY KEY,
    day_of_the_week NVARCHAR(15) NOT NULL,
    start_time TIME NOT NULL,
    duration INT NOT NULL CHECK (Duration > 0),
    doctor_id INT REFERENCES Doctor(id) ON DELETE CASCADE
);

CREATE TABLE Patient (
    id INT IDENTITY(1,1) PRIMARY KEY,
    phone NVARCHAR(20),
    full_name NVARCHAR(50) NOT NULL,
    district_Id INT REFERENCES District(id) ON DELETE NO ACTION
);

CREATE TABLE Reception (
    id INT IDENTITY(1,1) PRIMARY KEY,
    reception_time DATETIME NOT NULL,
    diagnosis NVARCHAR(100),
    patient_id INT REFERENCES Patient(id) ON DELETE NO ACTION,
    doctor_id INT REFERENCES Doctor(id) ON DELETE NO ACTION,
    stattalon_id INT REFERENCES Stattalon(id) ON DELETE NO ACTION -- Новый столбец
);

CREATE TABLE Stattalon (
    id INT IDENTITY(1,1) PRIMARY KEY,
    purpose NVARCHAR(100),
    schedule_id INT REFERENCES Schedule(id) ON DELETE CASCADE,
    doctor_id INT REFERENCES Doctor(id) ON DELETE NO ACTION,
    patient_id INT REFERENCES Patient(id) ON DELETE NO ACTION

);
