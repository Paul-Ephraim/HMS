create database hos_ms;

use hos_ms;

CREATE TABLE
    Patients (
        Patient_Id INT PRIMARY KEY AUTO_INCREMENT,
        Patient_Name VARCHAR(20),
        DoB DATE,
        Gender CHAR(1),
        Phone_Number VARCHAR(15),
        Guardian VARCHAR(20),
        Alt_Number VARCHAR(15),
        Aadhaar VARCHAR(12)
    );

CREATE TABLE
    Departments (
        Department_Id INT PRIMARY KEY,
        Department VARCHAR(25),
        Block VARCHAR(30),
        Floor INT,
        Dept_Type VARCHAR(20),
        Dept_contact VARCHAR(15),
        Alt_Contact VARCHAR(15),
        Head_Doctor INT,
        Head_Nurse INT,
        Dept_Mail VARCHAR(20)
    );

CREATE TABLE
    Staff (
        Staff_Id INT PRIMARY KEY,
        Name VARCHAR(30),
        DoB DATE,
        DOJ DATE,
        Mobile_No VARCHAR(15),
        Role VARCHAR(15),
        Gender CHAR(1),
        Alt_Num VARCHAR(15)
    );

CREATE TABLE
    Equipments (
        Equipment_Id INT PRIMARY KEY,
        Equipment_Name VARCHAR(20),
        Equipment_Class VARCHAR(25),
        Brand VARCHAR(20),
        Model VARCHAR(20),
        Dept_Id INT,
        FOREIGN KEY (Dept_Id) REFERENCES Departments (Department_Id)
    );

CREATE TABLE
    Attendance (
        Att_Id INT PRIMARY KEY,
        Employee_ID INT,
        Department INT,
        Date DATE,
        Time_in TIME,
        Time_out TIME,
        Status VARCHAR(10),
        FOREIGN KEY (Employee_ID) REFERENCES Staff (Staff_Id)
    );

CREATE TABLE
    Doctors (
        Doctor_Id INT PRIMARY KEY,
        Doctor_Name VARCHAR(30),
        Speciality VARCHAR(15),
        Department_Id INT,
        FOREIGN KEY (Doctor_Id) REFERENCES Staff (Staff_Id),
        FOREIGN KEY (Department_Id) REFERENCES Departments (Department_Id)
    );

CREATE TABLE
    Doctors_Schedule (
        Sch_Id INT PRIMARY KEY,
        Dr_Id INT,
        Hours VARCHAR(50),
        Visiting_Days VARCHAR(12),
        Fee INT,
        FOREIGN KEY (Dr_Id) REFERENCES Doctors (Doctor_Id)
    );

CREATE TABLE
    Nurses (
        Nurse_Id INT PRIMARY KEY,
        Dept_Id INT,
        FOREIGN KEY (Nurse_Id) REFERENCES Staff (Staff_Id),
        FOREIGN KEY (Dept_Id) REFERENCES Departments (Department_Id)
    );

CREATE TABLE
    Rooms (
        Room_Id INT PRIMARY KEY AUTO_INCREMENT,
        Room_Number VARCHAR(10),
        Room_Type VARCHAR(20),
        Department_Id INT,
        FOREIGN KEY (Department_Id) REFERENCES Departments (Department_Id)
    );

CREATE TABLE
    Beds (
        Bed_Id INT PRIMARY KEY AUTO_INCREMENT,
        Room_Id INT,
        Bed_Identifier VARCHAR(5),
        Is_Occupied BOOLEAN DEFAULT FALSE,
        Daily_Charge DECIMAL(10, 2),
        FOREIGN KEY (Room_Id) REFERENCES Rooms (Room_Id)
    );

CREATE TABLE
    Reception (
        Receptionist_Id INT PRIMARY KEY,
        Block VARCHAR(20),
        FOREIGN KEY (Receptionist_Id) REFERENCES Staff (Staff_Id)
    );

CREATE TABLE
    Admissions (
        Admission_No INT PRIMARY KEY AUTO_INCREMENT,
        Patient_Id INT,
        Admission_Date DATETIME,
        Is_Discharged BOOLEAN,
        Discharge_Date DATETIME,
        Doctor_assigned INT,
        Bed_No INT,
        FOREIGN KEY (Patient_Id) REFERENCES Patients (Patient_Id),
        FOREIGN KEY (Doctor_assigned) REFERENCES Doctors (Doctor_Id),
        FOREIGN KEY (Bed_No) REFERENCES Beds (Bed_Id)
    );

CREATE TABLE
    OT (
        OT_Id INT PRIMARY KEY,
        Dept_Id INT,
        Block VARCHAR(30),
        Occupied BOOLEAN,
        Occupied_time DATETIME,
        Next_slot DATETIME,
        FOREIGN KEY (Dept_Id) REFERENCES Departments (Department_Id)
    );

CREATE TABLE
    OT_Technician (
        Tech_Id INT PRIMARY KEY,
        Dept_Id INT,
        FOREIGN KEY (Dept_Id) REFERENCES Departments (Department_Id)
    );

CREATE TABLE
    Sub_dept (
        Sub_Dept_ID INT PRIMARY KEY,
        Sub_Dept_name VARCHAR(30),
        Dept_Id INT,
        Sub_Head INT,
        Floor VARCHAR(10),
        FOREIGN KEY (Dept_Id) REFERENCES Departments (Department_Id),
        FOREIGN KEY (Sub_Head) REFERENCES Doctors (Doctor_Id)
    );

CREATE TABLE
    Lab (
        Lab_id INT PRIMARY KEY,
        Lab_Name VARCHAR(20),
        Sub_Dept_ID INT,
        FOREIGN KEY (Sub_Dept_Id) REFERENCES Sub_dept (Sub_Dept_Id)
    );

CREATE TABLE
    Technicians (
        Technician_Id INT PRIMARY KEY,
        Lab_Id INT,
        Role VARCHAR(50),
        FOREIGN KEY (Lab_Id) REFERENCES Lab (Lab_Id),
        FOREIGN KEY (Technician_Id) REFERENCES Staff (Staff_Id)
    );

CREATE TABLE
    Test (
        Test_Id INT PRIMARY KEY,
        Test_name VARCHAR(20),
        Cost INT,
        Lower_limit INT,
        Upper_limit INT,
        Min_time VARCHAR(10)
    );

CREATE TABLE
    Lab_Test (
        Test_No INT PRIMARY KEY,
        Patient_Id INT,
        Test_Id INT,
        Test_time TIME,
        Obtained_value INT,
        Result BOOLEAN,
        Result_time TIME,
        FOREIGN KEY (Test_Id) REFERENCES Test (Test_Id),
        FOREIGN KEY (Patient_Id) REFERENCES Patients (Patient_Id)
    );

CREATE TABLE
    Bill_Desk (
        Bill_No INT PRIMARY KEY,
        Biller_ID INT,
        Pat_Id INT,
        Bill_Date DATETIME,
        Amount INT,
        Paid INT,
        FOREIGN KEY (Pat_Id) REFERENCES Patients (Patient_Id),
        FOREIGN KEY (Biller_ID) REFERENCES Staff (Staff_Id)
    );

CREATE TABLE
    Bill_Description (
        Descrp_Id INT PRIMARY KEY,
        Bill_No INT,
        Description VARCHAR(30),
        Amount INT,
        FOREIGN KEY (Bill_No) REFERENCES Bill_Desk (Bill_No)
    );

CREATE TABLE
    CSSD (
        Equp_Id INT,
        Sterlization_Date DATETIME,
        CS_Staff_Id INT,
        CSSD_Section VARCHAR(20),
        CSSD_Category VARCHAR(20),
        Dept_Id INT,
        PRIMARY KEY (Equp_Id, CS_Staff_Id, Sterlization_Date),
        FOREIGN KEY (CS_Staff_Id) REFERENCES Staff (Staff_Id),
        FOREIGN KEY (Equp_Id) REFERENCES Equipments (Equipment_Id),
        FOREIGN KEY (Dept_Id) REFERENCES Departments (Department_Id)
    );

CREATE TABLE
    Blood_Inventory (
        Blood_Unit_Id INT PRIMARY KEY AUTO_INCREMENT,
        Blood_Group VARCHAR(5),
        Component_Type VARCHAR(20),
        Collection_Date DATE,
        Expiry_Date DATE,
        Status VARCHAR(15) DEFAULT 'Available',
        Dept_Id INT,
        FOREIGN KEY (Dept_Id) REFERENCES Departments (Department_Id)
    );

CREATE TABLE
    Blood_Transfusion (
        Transfusion_Id INT PRIMARY KEY AUTO_INCREMENT,
        Blood_Unit_Id INT,
        Patient_Id INT,
        Doctor_Id INT,
        Transfusion_Date DATETIME,
        FOREIGN KEY (Blood_Unit_Id) REFERENCES Blood_Inventory (Blood_Unit_Id),
        FOREIGN KEY (Patient_Id) REFERENCES Patients (Patient_Id),
        FOREIGN KEY (Doctor_Id) REFERENCES Doctors (Doctor_Id)
    );

CREATE TABLE
    Hygiene (
        Cleaner_Id INT PRIMARY KEY,
        Dept_Id INT,
        Shift VARCHAR(10),
        is_Incharge BOOLEAN,
        FOREIGN KEY (Cleaner_Id) REFERENCES Staff (Staff_Id),
        FOREIGN KEY (Dept_Id) REFERENCES Departments (Department_Id)
    );

CREATE TABLE
    Mortuary (
        Mort_Id INT PRIMARY KEY,
        Death_time DATETIME,
        Reason VARCHAR(75),
        Dept_Id INT,
        Original_Dept_Id INT,
        FOREIGN KEY (Dept_Id) REFERENCES Departments (Department_Id),
        FOREIGN KEY (Original_Dept_Id) REFERENCES Departments (Department_Id),
        FOREIGN KEY (Mort_Id) REFERENCES Patients (Patient_Id)
    );

CREATE TABLE
    Stock (
        Stock_Id INT PRIMARY KEY,
        Equip_Id INT,
        FOREIGN KEY (Equip_Id) REFERENCES Equipments (Equipment_Id)
    );

CREATE TABLE
    Inter_Department_Transit (
        Transit_ID INT PRIMARY KEY,
        Transit_Time DATETIME,
        Equip_Department_ID INT,
        Recieved_Dept_Id INT,
        Equip_Id INT,
        FOREIGN KEY (Equip_Id) REFERENCES Equipments (Equipment_Id),
        FOREIGN KEY (Equip_Department_ID) REFERENCES Departments (Department_Id),
        FOREIGN KEY (Recieved_Dept_Id) REFERENCES Departments (Department_Id)
    );

CREATE TABLE
    Biomedical (
        Invoice_No INT PRIMARY KEY AUTO_INCREMENT,
        Category VARCHAR(20),
        Equip_Id INT,
        Dept_Id INT,
        Down_Time DATETIME,
        Resolved_Time DATETIME,
        Repair_Cost DECIMAL(10, 2),
        Company_Incharge VARCHAR(20),
        Company_No VARCHAR(15),
        FOREIGN KEY (Equip_Id) REFERENCES Equipments (Equipment_Id),
        FOREIGN KEY (Dept_Id) REFERENCES Departments (Department_Id)
    );

use hos_ms;

select