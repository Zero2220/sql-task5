CREATE Database db


Use db


CREATE TABLE Groups (
    GroupID INT PRIMARY KEY IDENTITY,
    Name VARCHAR(50),
    IsDeleted BIT DEFAULT 0 
)

CREATE TABLE Students (
    StudentID INT PRIMARY KEY IDENTITY,
    Name VARCHAR(50),
    GroupID INT FOREIGN KEY REFERENCES Groups(GroupID)
)


CREATE TABLE DeletedStudents (
    StudentID INT IDENTITY ,
    Name VARCHAR(50),
    GroupID INT
)

CREATE TRIGGER trg_DeleteStudent
ON Students
AFTER DELETE
AS
BEGIN
    INSERT INTO DeletedStudents (StudentID, Name, GroupID)
    SELECT deleted.StudentID, deleted.Name, deleted.GroupID
    FROM deleted;
END;

CREATE TRIGGER trg_DeleteGroup
ON Groups
INSTEAD OF DELETE
AS
BEGIN
    UPDATE Groups
    SET IsDeleted = 1 
    FROM deleted
    WHERE Groups.GroupID = deleted.GroupID;
END;
