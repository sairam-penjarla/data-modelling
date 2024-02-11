-- Create Employees Table with Primary Key
CREATE TABLE dbo.Employees (
    EmployeeID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Email VARCHAR(100),
    Department VARCHAR(50),
    HireDate DATE,
    PhoneNumber VARCHAR(15),
    Address VARCHAR(100),
    ReportingManagerID VARCHAR(100)
);

-- Create Salaries Table with Primary Key and Foreign Key Constraint
CREATE TABLE sls.Salaries (
    SalaryID INT PRIMARY KEY,
    EmployeeID INT,
    Salary DECIMAL(10,2),
    Currency VARCHAR(10),
    PaymentDate DATE,
    PaymentMethod VARCHAR(50),
    BankAccount VARCHAR(50),
    FOREIGN KEY (EmployeeID) REFERENCES dbo.Employees(EmployeeID) ON DELETE CASCADE
);

-- Create Departments Table with Primary Key
CREATE TABLE dbo.Departments (
    DepartmentID INT PRIMARY KEY,
    DepartmentName VARCHAR(50)
);

-- Create TimeOffRequests Table with Primary Key and Foreign Key Constraint
CREATE TABLE sls.TimeOffRequests (
    RequestID INT PRIMARY KEY,
    EmployeeID INT,
    RequestDate DATE,
    StartTime DATETIME,
    EndTime DATETIME,
    Status VARCHAR(20),
    Reason VARCHAR(100),
    FOREIGN KEY (EmployeeID) REFERENCES dbo.Employees(EmployeeID) ON DELETE CASCADE
);

-- Create PerformanceReviews Table with Primary Key and Foreign Key Constraint
CREATE TABLE dbo.PerformanceReviews (
    ReviewID INT PRIMARY KEY,
    EmployeeID INT,
    ReviewDate DATE,
    Reviewer VARCHAR(100),
    Rating INT,
    Comments TEXT,
    FOREIGN KEY (EmployeeID) REFERENCES dbo.Employees(EmployeeID) ON DELETE CASCADE
);

-- Create Index on EmployeeID in Salaries Table
CREATE INDEX idx_EmployeeID ON sls.Salaries(EmployeeID);

-- Create View to Retrieve Employee Information and Salary
CREATE VIEW EmployeeSalaryView AS
SELECT e.EmployeeID, e.FirstName, e.LastName, e.Email, e.Department, s.Salary, s.Currency
FROM dbo.Employees e
INNER JOIN sls.Salaries s ON e.EmployeeID = s.EmployeeID;

-- Parametereised view
CREATE VIEW EmployeesByDepartment AS
SELECT *
FROM dbo.Employees
WHERE dbo.Department = :department;
-- SELECT * FROM EmployeesByDepartment WHERE department = 'HR';

-- Create Stored Procedure to Insert Employee and Salary Information
CREATE PROCEDURE InsertEmployeeAndSalary (
    @FirstName VARCHAR(50),
    @LastName VARCHAR(50),
    @Email VARCHAR(100),
    @Department VARCHAR(50),
    @HireDate DATE,
    @PhoneNumber VARCHAR(15),
    @Address VARCHAR(100),
    @Salary DECIMAL(10,2),
    @Currency VARCHAR(10),
    @PaymentDate DATE,
    @PaymentMethod VARCHAR(50),
    @BankAccount VARCHAR(50)
)
AS
BEGIN
    DECLARE @EmployeeID INT;
    
    INSERT INTO Employees (FirstName, LastName, Email, Department, HireDate, PhoneNumber, Address)
    VALUES (@FirstName, @LastName, @Email, @Department, @HireDate, @PhoneNumber, @Address);
    
    SET @EmployeeID = SCOPE_IDENTITY();
    
    INSERT INTO Salaries (EmployeeID, Salary, Currency, PaymentDate, PaymentMethod, BankAccount)
    VALUES (@EmployeeID, @Salary, @Currency, @PaymentDate, @PaymentMethod, @BankAccount);
END;