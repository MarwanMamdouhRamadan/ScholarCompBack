﻿-- =====================================================
-- 0. DROPPING AND RECREATING THE DATABASE (FOR CLEAN SLATE)
-- This ensures a completely fresh start, resolving persistent "object already exists" errors.
-- =====================================================

PRINT 'Checking for and dropping existing database...';

-- Switch to master to ensure the target database is not in use by the current session.
USE master;
GO

IF EXISTS (SELECT name FROM sys.databases WHERE name = N'ElsewedySchoolSys')
BEGIN
    ALTER DATABASE [ElsewedySchoolSys] SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE [ElsewedySchoolSys];
    PRINT 'Existing database [ElsewedySchoolSys] dropped successfully.';
END
ELSE
BEGIN
    PRINT 'Database [ElsewedySchoolSys] does not exist, proceeding with creation.';
END
;

PRINT 'Creating new database [ElsewedySchoolSys]...';
CREATE DATABASE [ElsewedySchoolSys];
;

ALTER DATABASE [ElsewedySchoolSys] COLLATE Arabic_100_CI_AI;
;
USE [ElsewedySchoolSys]
GO

-- =====================================================
-- 1. ROBUSTLY DROP EXISTING OBJECTS (redundant after database drop, but kept for robustness if database drop is skipped)
-- This section ensures all related objects are dropped in the correct order
-- to prevent "referenced by FOREIGN KEY" and "already an object" errors.
-- =====================================================

PRINT 'Dropping existing foreign key constraints, triggers, and tables (if any residual objects exist)...';

-- **ENHANCED ROBUSTNESS**: Drop all foreign key constraints across the entire database.
DECLARE @drop_fk_sql NVARCHAR(MAX) = N'';
SELECT @drop_fk_sql += N'ALTER TABLE ' + QUOTENAME(OBJECT_SCHEMA_NAME(fk.parent_object_id)) + '.' + QUOTENAME(OBJECT_NAME(fk.parent_object_id)) +
    ' DROP CONSTRAINT ' + QUOTENAME(fk.name) + ';'
FROM sys.foreign_keys AS fk;

EXEC sp_executesql @drop_fk_sql;
;

-- Drop existing triggers (if any were previously created).
-- Triggers are not part of the current schema design, so these are commented out.

IF OBJECT_ID('tr_Grade_updated_at', 'TR') IS NOT NULL DROP TRIGGER tr_Grade_updated_at;
IF OBJECT_ID('tr_Class_updated_at', 'TR') IS NOT NULL DROP TRIGGER tr_Class_updated_at;
IF OBJECT_ID('tr_Team_updated_at', 'TR') IS NOT NULL DROP TRIGGER tr_Team_updated_at;
IF OBJECT_ID('tr_Account_updated_at', 'TR') IS NOT NULL DROP TRIGGER tr_Account_updated_at;
IF OBJECT_ID('tr_Task_updated_at', 'TR') IS NOT NULL DROP TRIGGER tr_Task_updated_at;
IF OBJECT_ID('tr_StudentTask_updated_at', 'TR') IS NOT NULL DROP TRIGGER tr_StudentTask_updated_at;
IF OBJECT_ID('tr_Report_updated_at', 'TR') IS NOT NULL DROP TRIGGER tr_Report_updated_at;
IF OBJECT_ID('tr_Status_updated_at', 'TR') IS NOT NULL DROP TRIGGER tr_Status_updated_at;
IF OBJECT_ID('tr_AccountType_updated_at', 'TR') IS NOT NULL DROP TRIGGER tr_AccountType_updated_at;
IF OBJECT_ID('tr_StudentExtension_updated_at', 'TR') IS NOT NULL DROP TRIGGER tr_StudentExtension_updated_at;
IF OBJECT_ID('tr_ReviewerSupervisorExtension_updated_at', 'TR') IS NOT NULL DROP TRIGGER tr_ReviewerSupervisorExtension_updated_at;
IF OBJECT_ID('tr_CapstoneSupervisorExtension_updated_at', 'TR') IS NOT NULL DROP TRIGGER tr_CapstoneSupervisorExtension_updated_at;
IF OBJECT_ID('tr_SuperAdminExtension_updated_at', 'TR') IS NOT NULL DROP TRIGGER tr_SuperAdminExtension_updated_at;
IF OBJECT_ID('tr_Session_updated_at', 'TR') IS NOT NULL DROP TRIGGER tr_Session_updated_at;
IF OBJECT_ID('tr_TicketType_updated_at', 'TR') IS NOT NULL DROP TRIGGER tr_TicketType_updated_at;
IF OBJECT_ID('tr_SubordinateTicket_updated_at', 'TR') IS NOT NULL DROP TRIGGER tr_SubordinateTicket_updated_at;
IF OBJECT_ID('tr_Project_updated_at', 'TR') IS NOT NULL DROP TRIGGER tr_Project_updated_at;
IF OBJECT_ID('tr_TeamMember_updated_at', 'TR') IS NOT NULL DROP TRIGGER tr_TeamMember_updated_at;
IF OBJECT_ID('tr_Scholarship_updated_at', 'TR') IS NOT NULL DROP TRIGGER tr_Scholarship_updated_at;

;

-- Drop tables in reverse order of (conceptual) dependency to ensure smooth removal.
IF OBJECT_ID('dbo.AdmissionProfile', 'U') IS NOT NULL DROP TABLE dbo.AdmissionProfile;
IF OBJECT_ID('dbo.StudentExtension', 'U') IS NOT NULL DROP TABLE dbo.StudentExtension;
IF OBJECT_ID('dbo.ReviewerSupervisorExtension', 'U') IS NOT NULL DROP TABLE dbo.ReviewerSupervisorExtension;
IF OBJECT_ID('dbo.CapstoneSupervisorExtension', 'U') IS NOT NULL DROP TABLE dbo.CapstoneSupervisorExtension;
IF OBJECT_ID('dbo.SuperAdminExtension', 'U') IS NOT NULL DROP TABLE dbo.SuperAdminExtension;
IF OBJECT_ID('dbo.StudentTask', 'U') IS NOT NULL DROP TABLE dbo.StudentTask;
IF OBJECT_ID('dbo.Report', 'U') IS NOT NULL DROP TABLE dbo.Report;
IF OBJECT_ID('dbo.Task', 'U') IS NOT NULL DROP TABLE dbo.Task;
IF OBJECT_ID('dbo.TeamMember', 'U') IS NOT NULL DROP TABLE dbo.TeamMember;
IF OBJECT_ID('dbo.Team', 'U') IS NOT NULL DROP TABLE dbo.Team;
IF OBJECT_ID('dbo.Project', 'U') IS NOT NULL DROP TABLE dbo.Project;
IF OBJECT_ID('dbo.Scholarship', 'U') IS NOT NULL DROP TABLE dbo.Scholarship;
IF OBJECT_ID('dbo.SubordinateTicket', 'U') IS NOT NULL DROP TABLE dbo.SubordinateTicket;
IF OBJECT_ID('dbo.Grade', 'U') IS NOT NULL DROP TABLE dbo.Grade;
IF OBJECT_ID('dbo.Class', 'U') IS NOT NULL DROP TABLE dbo.Class;
IF OBJECT_ID('dbo.Session', 'U') IS NOT NULL DROP TABLE dbo.Session;
IF OBJECT_ID('dbo.TicketType', 'U') IS NOT NULL DROP TABLE dbo.TicketType;
IF OBJECT_ID('dbo.Login', 'U') IS NOT NULL DROP TABLE dbo.Login; -- Drop new Login table

-- Dropping the newly added tables
IF OBJECT_ID('dbo.Achievements', 'U') IS NOT NULL DROP TABLE dbo.Achievements;
IF OBJECT_ID('dbo.EmploymentRequests', 'U') IS NOT NULL DROP TABLE dbo.EmploymentRequests;

IF OBJECT_ID('dbo.Account', 'U') IS NOT NULL DROP TABLE dbo.Account; -- Drop Account before AccountType
IF OBJECT_ID('dbo.AccountType', 'U') IS NOT NULL DROP TABLE dbo.AccountType;
IF OBJECT_ID('dbo.Status', 'U') IS NOT NULL DROP TABLE dbo.Status;
IF OBJECT_ID('dbo.EmailSettings', 'U') IS NOT NULL DROP TABLE dbo.EmailSettings;
;

PRINT 'Existing objects dropped successfully (if any were present).';

-- =====================================================
-- 2. CREATE TABLES
-- All primary keys are BIGINT.
-- No 'created_at' and 'updated_at' fields.
-- Naming convention: PascalCase for tables and columns.
-- =====================================================

PRINT 'Creating new tables...';

-- dbo.Status: Lookup table for various statuses across the system.
CREATE TABLE dbo.Status (
    -- Primary key: Unique identifier for a status.
    Id BIGINT NOT NULL IDENTITY(1,1),
    -- Name of the status (e.g., 'Active', 'Completed', 'Pending').
    StatusName NVARCHAR(MAX) NOT NULL,
    -- Optional: Specifies which entity/table this status typically applies to (e.g., 'Account', 'Task').
    BusinessEntity NVARCHAR(MAX) NULL,

    CONSTRAINT PK_Status PRIMARY KEY (Id)
);
;

-- dbo.AccountType: Lookup table for different types of user accounts.
CREATE TABLE dbo.AccountType (
    -- Primary key: Unique identifier for an account type.
    Id BIGINT NOT NULL IDENTITY(1,1),
    -- Name of the account type (e.g., 'Admin', 'Teacher', 'Student').
    AccountTypeName NVARCHAR(100) NOT NULL UNIQUE,
    CONSTRAINT PK_AccountType PRIMARY KEY (Id)
);
;

-- dbo.Account: Central table for all users.
CREATE TABLE dbo.Account (
    -- Primary key: Unique identifier for an account.
    Id BIGINT NOT NULL IDENTITY(1,1),
    -- User's National ID, must be unique.
    NationalId NVARCHAR(14) NOT NULL UNIQUE,
    -- User's password hash (should be hashed in application).
    PasswordHash NVARCHAR(MAX) NOT NULL,
    -- User's email address, must be unique.
    Email NVARCHAR(100) NOT NULL UNIQUE,
    -- Reference to the account type ID from `AccountType`.
    AccountTypeId BIGINT NOT NULL,
    -- Full name of the account holder (English).
    FullNameEN NVARCHAR(MAX) NOT NULL,
    -- Full name of the account holder (Arabic).
    FullNameAR NVARCHAR(MAX) NOT NULL,
    -- Token for password reset.
    ResetToken NVARCHAR(MAX) NULL,
    -- Expiry date/time for the reset token.
    ResetTokenExpiry DATETIME2 NULL,
    -- Flag indicating if the account is active (0=Inactive, 1=Active).
    IsActive BIT NOT NULL DEFAULT 1,
    -- Status of the account (e.g., 'Active').
    StatusId BIGINT NOT NULL DEFAULT 1,

    CONSTRAINT PK_Account PRIMARY KEY (Id)
);


-- dbo.Login: Stores login credentials. This table is logically linked to the `Account` table via `AccountId` but is kept separate for security and system design.
CREATE TABLE dbo.Login (
    -- Primary key: Unique identifier for the login record.
    Id BIGINT NOT NULL IDENTITY(1,1),
    -- Foreign key: Refers to the related account in the `Account` table.
    AccountId BIGINT NOT NULL,
    -- Email associated with the login.
    Email NVARCHAR(100) NOT NULL,
    -- Hashed password for the login.
    PasswordHash NVARCHAR(MAX) NOT NULL,
    -- Status of the login record.
    StatusId BIGINT NOT NULL DEFAULT 1,

    CONSTRAINT PK_Login PRIMARY KEY (Id)
);
;

-- ================================
-- Achievements Table
-- ================================
CREATE TABLE dbo.Achievements (
    -- Primary key: Unique identifier for an achievement.
    Id BIGINT NOT NULL IDENTITY(1,1),
    -- Title of the achievement.
    Title NVARCHAR(MAX),
    -- Detailed description of the achievement.
    Description NVARCHAR(MAX) NOT NULL,
    -- URL of an image associated with the achievement.
    ImageUrl NVARCHAR(MAX) NOT NULL,


    CONSTRAINT PK_Achievements PRIMARY KEY (Id)
);
;

-- ================================
-- جدول طلبات التوظيف (EmploymentRequests)
-- ================================
CREATE TABLE dbo.EmploymentRequests (
    -- Primary key: Unique identifier for an employment request.
    Id BIGINT NOT NULL IDENTITY(1,1),
    -- Name of the company submitting the request.
    CompanyName NVARCHAR(MAX) NOT NULL,
    -- LinkedIn profile URL of the company.
    LinkedInUrl NVARCHAR(MAX) NOT NULL,
    -- Email address of the company.
    CompanyEmail NVARCHAR(MAX) NOT NULL,
    -- Phone number of the company.
    CompanyPhone NVARCHAR(MAX) NOT NULL,
    -- Physical address of the company.
    Address NVARCHAR(MAX) NOT NULL,
    -- Specialization or field of employment requested.
    Specialization NVARCHAR(MAX) NOT NULL,
    -- Amount or salary range for the employment.
    Amount NVARCHAR(MAX) NOT NULL,
    -- Name of the individual owning/submitting the request.
    OwnerName NVARCHAR(MAX) NOT NULL,
    -- Phone number of the individual owning/submitting the request.
    OwnerPhone NVARCHAR(MAX) NOT NULL,
    -- Email address of the individual owning/submitting the request.
    OwnerEmail NVARCHAR(MAX) NOT NULL,
    -- Type of employment (e.g., 'Full-time', 'Part-time', 'Internship').
    EmploymentType NVARCHAR(MAX) NOT NULL,
    -- Status of the employment request (e.g., 'Pending', 'Approved', 'Rejected').
    StatusId BIGINT NOT NULL DEFAULT 1,
    -- Date and time when the request was submitted.
    RequestDate DATETIME2 NOT NULL DEFAULT GETDATE(),

    CONSTRAINT PK_EmploymentRequests PRIMARY KEY (Id)
);
;

-- dbo.Grade: Represents academic grades or levels in the educational system.
CREATE TABLE dbo.Grade (
    -- Primary key: Unique identifier for a grade.
    Id BIGINT NOT NULL IDENTITY(1,1),
    -- Name of the grade (e.g., "Grade 10", "Senior Year").
    GradeName NVARCHAR(100) NOT NULL,
    -- Optional: Reference to a parent grade, allowing for hierarchical structures.
    ParentGradeId BIGINT NULL,
    -- Reference to the account ID of an admin who manages this grade.
    AdminAccountId BIGINT NULL,
    -- Status of the grade (e.g., 'Active').
    StatusId BIGINT NOT NULL DEFAULT 1,

    CONSTRAINT PK_Grade PRIMARY KEY (Id)
);
;

-- dbo.Class: Represents individual classes taught within specific grades.
CREATE TABLE dbo.Class (
    -- Primary key: Unique identifier for a class.
    Id BIGINT NOT NULL IDENTITY(1,1),
    -- Name of the class (e.g., "101A", "Math Advanced").
    ClassName NVARCHAR(MAX) NOT NULL,
    -- Reference to the grade ID this class belongs to.
    GradeId BIGINT NOT NULL,
    -- Status of the class (e.g., 'Active').
    StatusId BIGINT NOT NULL DEFAULT 1,

    CONSTRAINT PK_Class PRIMARY KEY (Id)
);
;

-- dbo.Session: Represents academic sessions or periods.
CREATE TABLE dbo.Session (
    -- Primary key: Unique identifier for a session.
    Id BIGINT NOT NULL IDENTITY(1,1),
    -- Session number or identifier.
    SessionNo INT NULL,
    -- Start Date of the session.
    FromDate DATE NULL,
    -- End Date of the session.
    ToDate DATE NULL,
    -- Status of the session (e.g., 'Active', 'Completed').
    StatusId BIGINT NOT NULL DEFAULT 1,
    -- Optional notes about the session.
    Note NVARCHAR(MAX) NULL,

    CONSTRAINT PK_Session PRIMARY KEY (Id)
);
;

-- dbo.TicketType: Lookup table for different types of tickets (e.g., Late, Absence).
CREATE TABLE dbo.TicketType (
    -- Primary key: Unique identifier for a ticket type.
    Id BIGINT NOT NULL IDENTITY(1,1),
    -- Name of the ticket type (e.g., 'Late', 'Eating', 'Absence').
    TicketTypeName NVARCHAR(MAX) NOT NULL,
    -- Order number for sorting ticket types.
    OrderNo INT NULL,
    -- Business entity associated with the ticket type (e.g., 'Behaviour', 'Absence').
    BusinessEntity NVARCHAR(MAX) NULL,
    -- Status of the ticket type (e.g., 'Active').
    StatusId BIGINT NOT NULL DEFAULT 1,

    CONSTRAINT PK_TicketType PRIMARY KEY (Id)
);
;

-- dbo.EmailSettings: Stores configuration for email sending.
CREATE TABLE dbo.EmailSettings (
    -- SMTP server address.
    SmtpServer NVARCHAR(MAX) NULL,
    -- SMTP port number.
    SmtpPort INT NULL,
    -- SMTP username for authentication.
    SmtpUsername NVARCHAR(MAX) NULL,
    -- SMTP password for authentication.
    SmtpPassword NVARCHAR(MAX) NULL,
    -- Sender email address.
    SenderEmail NVARCHAR(MAX) NULL
);
;

-- dbo.Project: Represents academic projects.
CREATE TABLE dbo.Project (
    -- Primary key: Unique identifier for a project.
    Id BIGINT NOT NULL IDENTITY(1,1),
    -- Project name in Arabic.
    NameAR NVARCHAR(MAX) NULL,
    -- Project name in English.
    NameEN NVARCHAR(MAX) NOT NULL,
	-- Name of Company Name
	CompanyName NVARCHAR(MAX) NOT NULL DEFAULT 'ELSEWEDY',
	--Additional Information for project Request(first name - Last name - email - phone )
	AdditionalInformation NVARCHAR(MAX) NULL,
    -- Date of project creation. Defaults to the current date and time.
    DateOfCreation DATETIME2 NOT NULL DEFAULT GETDATE(),
    -- Detailed description of the project.
    ProjectDescription NVARCHAR(MAX) NOT NULL,
    -- Status of the project (e.g., 'Pending', 'In Progress', 'Completed').
    StatusId BIGINT NOT NULL DEFAULT 1,
    -- Foreign Key to Account Table: Supervisor account ID for this project.
    SupervisorAccountId BIGINT NOT NULL,

    CONSTRAINT PK_Project PRIMARY KEY (Id)
);
;

-- dbo.Team: Represents student teams.
CREATE TABLE dbo.Team (
    -- Primary key: Unique identifier for a team.
    Id BIGINT NOT NULL IDENTITY(1,1),
    -- Name of the team.
    TeamName NVARCHAR(MAX) NOT NULL,
    -- Reference to the account ID of the student who is the team leader.
    TeamLeaderAccountId BIGINT NULL,
    -- Reference to the class ID this team belongs to.
    ClassId BIGINT NOT NULL,
    -- Reference to the account ID of the supervisor for this team.
    SupervisorAccountId BIGINT NULL,
    -- Reference to the project ID associated with this team.
    ProjectId BIGINT NULL,
    -- Status of the team (e.g., 'Active').
    StatusId BIGINT NOT NULL DEFAULT 1,

    CONSTRAINT PK_Team PRIMARY KEY (Id)
);
;

-- dbo.TeamMember: Links individual accounts to teams.
CREATE TABLE dbo.TeamMember (
    -- Primary key: Unique identifier for this team member record.
    Id BIGINT NOT NULL IDENTITY(1,1),
    -- Reference to the team ID.
    TeamId BIGINT NOT NULL,
    -- Reference to the account ID of the team member.
    TeamMemberAccountId BIGINT NOT NULL,
    -- Description or role of the team member within the team.
    TeamMemberDescription NVARCHAR(MAX) NULL,
    -- Status of the team member record (e.g., 'Active').
    StatusId BIGINT NOT NULL DEFAULT 1,

    CONSTRAINT PK_TeamMember PRIMARY KEY (Id)
);
;

-- dbo.Scholarship: Represents scholarships offered to students.
CREATE TABLE dbo.Scholarship (
    -- Primary key: Unique identifier for a scholarship.
    Id BIGINT NOT NULL IDENTITY(1,1),
    -- Name of the scholarship.
    ScholarshipName NVARCHAR(MAX) NOT NULL,
	
    ScholarshipDescription NVARCHAR(MAX) NOT NULL,
    -- Amount
    Amount MONEY NOT NULL,
    -- Provider of the scholarship.
    ProviderName NVARCHAR(MAX) NOT NULL,
    -- Start date of the scholarship.
    StartDate DATE NULL,
    -- End date of the scholarship.
    EndDate DATE NULL,
    -- Status of the scholarship (e.g., 'Active', 'Closed').
    StatusId BIGINT NOT NULL DEFAULT 1,

    CONSTRAINT PK_Scholarship PRIMARY KEY (Id)
);
;

-- dbo.Task: Represents individual assignments or tasks.
CREATE TABLE dbo.Task (
    -- Primary key: Unique identifier for a task.
    Id BIGINT NOT NULL IDENTITY(1,1),
    -- Name of the task.
    TaskName NVARCHAR(MAX) NOT NULL,
    -- Detailed instructions or description for the task.
    TaskDescription NVARCHAR(MAX) NULL,
    -- Deadline for the task.
    TaskDeadline DATETIME NOT NULL,
    -- Optional: Link to a GitHub repository related to the task.
    GithubLink NVARCHAR(MAX) NULL,
    -- Reference to the grade ID this task is associated with.
    GradeId BIGINT NOT NULL,
    -- Reference to the account ID of the admin who created/manages this task.
    AdminAccountId BIGINT NOT NULL,
    -- Status of the task (e.g., 'Active', 'Pending').
    StatusId BIGINT NOT NULL DEFAULT 1,

    CONSTRAINT PK_Task PRIMARY KEY (Id)
);
;

-- dbo.StudentTask: Links students to tasks and tracks their completion status.
CREATE TABLE dbo.StudentTask (
    -- Primary key: Unique identifier for this student-task record.
    Id BIGINT NOT NULL IDENTITY(1,1),
    -- Reference to the student's account ID.
    StudentAccountId BIGINT NOT NULL,
    -- Reference to the task ID.
    TaskId BIGINT NOT NULL,
    -- Flag indicating if the student has completed the task (0=No, 1=Yes).
    IsCompleted BIT NOT NULL DEFAULT 0,
    -- Timestamp when the task was marked as completed (nullable if not completed).
    CompletedAt DATETIME NULL,
    -- Status of the student's task (e.g., 'Pending', 'Completed').
    StatusId BIGINT NOT NULL DEFAULT 1,

    CONSTRAINT PK_StudentTask PRIMARY KEY (Id)
);
;

-- dbo.Report: Stores user-submitted reports or feedback.
CREATE TABLE dbo.Report (
    -- Primary key: Unique identifier for a report.
    Id BIGINT NOT NULL IDENTITY(1,1),
    -- Title or subject of the report.
    Title NVARCHAR(MAX) NOT NULL,
    -- Timestamp when the report was submitted. Defaults to the current date and time.
    SubmissionDate DATETIME NOT NULL DEFAULT GETDATE(),
    -- Main message or body of the report.
    ReportMessage NVARCHAR(MAX) NOT NULL,
    -- Reference to the account ID of the user who submitted the report.
    SubmitterAccountId BIGINT NOT NULL,
    -- Status of the report (e.g., 'Pending', 'Approved', 'Rejected').
    StatusId BIGINT NOT NULL DEFAULT 1,

    CONSTRAINT PK_Report PRIMARY KEY (Id)
);
;

-- dbo.SubordinateTicket: Represents tickets raised by subordinates or for specific entities.
CREATE TABLE dbo.SubordinateTicket (
    -- Primary key: Unique identifier for a subordinate ticket.
    Id BIGINT NOT NULL IDENTITY(1,1),
    -- Reference to the account ID of the supervisor.
    SupervisorAccountId BIGINT NULL,
    -- Reference to the grade ID relevant to the ticket.
    GradeId BIGINT NULL,
    -- Reference to the class ID relevant to the ticket.
    ClassId BIGINT NULL,
    -- Reference to the session ID relevant to the ticket.
    SessionId BIGINT NULL,
    -- Reference to the account ID of the subordinate (the one the ticket is about).
    SubordinateAccountId BIGINT NULL,
    -- Reference to the ticket type ID from `TicketType`.
    TicketTypeId BIGINT NULL,
    -- Status of the subordinate ticket (e.g., 'New', 'Resolved').
    StatusId BIGINT NOT NULL DEFAULT 1,

    CONSTRAINT PK_SubordinateTicket PRIMARY KEY (Id)
);
;

-- dbo.StudentExtension: Extension table for student-specific attributes.
CREATE TABLE dbo.StudentExtension (
    -- Primary key: Reference to the student's account ID from the `Account` table.
    AccountId BIGINT NOT NULL,
    -- Flag indicating if the student is a team leader (0=No, 1=Yes).
    IsLeader BIT NOT NULL DEFAULT 0,
    -- Reference to the class ID the student belongs to.
    ClassId BIGINT NULL,
    -- Status of the student extension record.
    StatusId BIGINT NOT NULL DEFAULT 1,

    CONSTRAINT PK_StudentExtension PRIMARY KEY (AccountId)
);
;

-- dbo.ReviewerSupervisorExtension: Extension table for reviewer/supervisor-specific attributes.
CREATE TABLE dbo.ReviewerSupervisorExtension (
    -- Primary key: Reference to the reviewer/supervisor's account ID.
    AccountId BIGINT NOT NULL,
    -- Optional: Reference to the class ID they are assigned to review/supervise.
    AssignedClassId BIGINT NULL,
    -- Status of the extension record.
    StatusId BIGINT NOT NULL DEFAULT 1,

    CONSTRAINT PK_ReviewerSupervisorExtension PRIMARY KEY (AccountId)
);
;

-- dbo.CapstoneSupervisorExtension: Extension table for capstone project supervisor-specific attributes.
CREATE TABLE dbo.CapstoneSupervisorExtension (
    -- Primary key: Reference to the capstone supervisor's account ID.
    AccountId BIGINT NOT NULL,
    -- Status of the extension record.
    StatusId BIGINT NOT NULL DEFAULT 1,

    CONSTRAINT PK_CapstoneSupervisorExtension PRIMARY KEY (AccountId)
);
;

-- dbo.SuperAdminExtension: Extension table for super admin-specific attributes.
CREATE TABLE dbo.SuperAdminExtension (
    -- Primary key: Reference to the super admin's account ID.
    AccountId BIGINT NOT NULL,
    -- Status of the extension record.
    StatusId BIGINT NOT NULL DEFAULT 1,

    CONSTRAINT PK_SuperAdminExtension PRIMARY KEY (AccountId)
);
;

-- dbo.AdmissionProfile: Stores admission-specific attributes for accounts.
CREATE TABLE dbo.AdmissionProfile (
    -- Primary key: Reference to the account ID from the `Account` table.
    AccountId BIGINT NOT NULL,
    -- Date of birth of the applicant/student.
    DateOfBirth DATE NULL,
    -- Location of the applicant/student.
    Location NVARCHAR(MAX) NULL,
    -- Phone number of the applicant/student.
    PhoneNumber NVARCHAR(20) NULL,
    -- Score from the software interview.
    SoftwareInterviewScore DECIMAL(5,2) NULL,
    -- Score from the math interview.
    MathInterviewScore DECIMAL(5,2) NULL,
    -- Score from the English interview.
    EnglishInterviewScore DECIMAL(5,2) NULL,
    -- Score from the Arabic interview.
    ArabicInterviewScore DECIMAL(5,2) NULL,
    -- Name of the student.
    StudentName NVARCHAR(MAX) NULL,
    -- Student's math score.
    MathScore DECIMAL(5,2) NULL,
    -- Student's English score.
    EnglishScore DECIMAL(5,2) NULL,
    -- Student's third preparatory year score.
    ThirdPrepScore DECIMAL(5,2) NULL,
    -- Flag indicating if the acceptance letter has been received (0=No, 1=Yes).
    IsAcceptanceLetterReceived BIT NOT NULL DEFAULT 0,
    -- Status of the admission profile record.
    StatusId BIGINT NOT NULL DEFAULT 1,

    CONSTRAINT PK_AdmissionProfile PRIMARY KEY (AccountId)
);
;

PRINT 'New tables created successfully.';

-- =====================================================
-- 3. ADD FOREIGN KEY CONSTRAINTS
-- Added after all tables are created to ensure references exist.
-- =====================================================

PRINT 'Adding foreign key constraints...';

ALTER TABLE dbo.Account
ADD CONSTRAINT FK_Account_AccountType FOREIGN KEY (AccountTypeId) REFERENCES dbo.AccountType(Id);
;

ALTER TABLE dbo.Login
ADD CONSTRAINT FK_Login_Account FOREIGN KEY (AccountId) REFERENCES dbo.Account(Id);
;

ALTER TABLE dbo.Login
ADD CONSTRAINT FK_Login_Status FOREIGN KEY (StatusId) REFERENCES dbo.Status(Id);
;



ALTER TABLE dbo.EmploymentRequests
ADD CONSTRAINT FK_EmploymentRequests_Status FOREIGN KEY (StatusId) REFERENCES dbo.Status(Id);
;

ALTER TABLE dbo.Grade
ADD CONSTRAINT FK_Grade_AdminAccount FOREIGN KEY (AdminAccountId) REFERENCES dbo.Account(Id);
;

ALTER TABLE dbo.Grade
ADD CONSTRAINT FK_Grade_Status FOREIGN KEY (StatusId) REFERENCES dbo.Status(Id);
;

ALTER TABLE dbo.Class
ADD CONSTRAINT FK_Class_Grade FOREIGN KEY (GradeId) REFERENCES dbo.Grade(Id);
;

ALTER TABLE dbo.Class
ADD CONSTRAINT FK_Class_Status FOREIGN KEY (StatusId) REFERENCES dbo.Status(Id);
;

ALTER TABLE dbo.Session
ADD CONSTRAINT FK_Session_Status FOREIGN KEY (StatusId) REFERENCES dbo.Status(Id);
;

ALTER TABLE dbo.TicketType
ADD CONSTRAINT FK_TicketType_Status FOREIGN KEY (StatusId) REFERENCES dbo.Status(Id);
;

ALTER TABLE dbo.Account
ADD CONSTRAINT FK_Account_Status FOREIGN KEY (StatusId) REFERENCES dbo.Status(Id);
;

ALTER TABLE dbo.Project
ADD CONSTRAINT FK_Project_Status FOREIGN KEY (StatusId) REFERENCES dbo.Status(Id);
;

ALTER TABLE dbo.Project
ADD CONSTRAINT FK_Project_SupervisorAccount FOREIGN KEY (SupervisorAccountId) REFERENCES dbo.Account(Id);
;

ALTER TABLE dbo.Team
ADD CONSTRAINT FK_Team_TeamLeaderAccount FOREIGN KEY (TeamLeaderAccountId) REFERENCES dbo.Account(Id);
;

ALTER TABLE dbo.Team
ADD CONSTRAINT FK_Team_Class FOREIGN KEY (ClassId) REFERENCES dbo.Class(Id);
;

ALTER TABLE dbo.Team
ADD CONSTRAINT FK_Team_SupervisorAccount FOREIGN KEY (SupervisorAccountId) REFERENCES dbo.Account(Id);
;

ALTER TABLE dbo.Team
ADD CONSTRAINT FK_Team_Project FOREIGN KEY (ProjectId) REFERENCES dbo.Project(Id);
;

ALTER TABLE dbo.Team
ADD CONSTRAINT FK_Team_Status FOREIGN KEY (StatusId) REFERENCES dbo.Status(Id);
;

ALTER TABLE dbo.TeamMember
ADD CONSTRAINT FK_TeamMember_Team FOREIGN KEY (TeamId) REFERENCES dbo.Team(Id);
;

ALTER TABLE dbo.TeamMember
ADD CONSTRAINT FK_TeamMember_TeamMemberAccount FOREIGN KEY (TeamMemberAccountId) REFERENCES dbo.Account(Id);
;

ALTER TABLE dbo.TeamMember
ADD CONSTRAINT FK_TeamMember_Status FOREIGN KEY (StatusId) REFERENCES dbo.Status(Id);
;

ALTER TABLE dbo.Scholarship
ADD CONSTRAINT FK_Scholarship_Status FOREIGN KEY (StatusId) REFERENCES dbo.Status(Id);
;

ALTER TABLE dbo.Task
ADD CONSTRAINT FK_Task_Grade FOREIGN KEY (GradeId) REFERENCES dbo.Grade(Id);
;

ALTER TABLE dbo.Task
ADD CONSTRAINT FK_Task_AdminAccount FOREIGN KEY (AdminAccountId) REFERENCES dbo.Account(Id);
;

ALTER TABLE dbo.Task
ADD CONSTRAINT FK_Task_Status FOREIGN KEY (StatusId) REFERENCES dbo.Status(Id);
;

ALTER TABLE dbo.StudentTask
ADD CONSTRAINT FK_StudentTask_StudentAccount FOREIGN KEY (StudentAccountId) REFERENCES dbo.Account(Id);
;

ALTER TABLE dbo.StudentTask
ADD CONSTRAINT FK_StudentTask_Task FOREIGN KEY (TaskId) REFERENCES dbo.Task(Id);
;

ALTER TABLE dbo.StudentTask
ADD CONSTRAINT FK_StudentTask_Status FOREIGN KEY (StatusId) REFERENCES dbo.Status(Id);
;

ALTER TABLE dbo.Report
ADD CONSTRAINT FK_Report_SubmitterAccount FOREIGN KEY (SubmitterAccountId) REFERENCES dbo.Account(Id);
;

ALTER TABLE dbo.Report
ADD CONSTRAINT FK_Report_Status FOREIGN KEY (StatusId) REFERENCES dbo.Status(Id);
;

ALTER TABLE dbo.SubordinateTicket
ADD CONSTRAINT FK_SubordinateTicket_SupervisorAccount FOREIGN KEY (SupervisorAccountId) REFERENCES dbo.Account(Id);
;

ALTER TABLE dbo.SubordinateTicket
ADD CONSTRAINT FK_SubordinateTicket_Grade FOREIGN KEY (GradeId) REFERENCES dbo.Grade(Id);
;

ALTER TABLE dbo.SubordinateTicket
ADD CONSTRAINT FK_SubordinateTicket_Class FOREIGN KEY (ClassId) REFERENCES dbo.Class(Id);
;

ALTER TABLE dbo.SubordinateTicket
ADD CONSTRAINT FK_SubordinateTicket_Session FOREIGN KEY (SessionId) REFERENCES dbo.Session(Id);
;

ALTER TABLE dbo.SubordinateTicket
ADD CONSTRAINT FK_SubordinateTicket_SubordinateAccount FOREIGN KEY (SubordinateAccountId) REFERENCES dbo.Account(Id);
;

ALTER TABLE dbo.SubordinateTicket
ADD CONSTRAINT FK_SubordinateTicket_TicketType FOREIGN KEY (TicketTypeId) REFERENCES dbo.TicketType(Id);
;

ALTER TABLE dbo.SubordinateTicket
ADD CONSTRAINT FK_SubordinateTicket_Status FOREIGN KEY (StatusId) REFERENCES dbo.Status(Id);
;

ALTER TABLE dbo.StudentExtension
ADD CONSTRAINT FK_StudentExtension_Account FOREIGN KEY (AccountId) REFERENCES dbo.Account(Id);
;

ALTER TABLE dbo.StudentExtension
ADD CONSTRAINT FK_StudentExtension_Class FOREIGN KEY (ClassId) REFERENCES dbo.Class(Id);
;

ALTER TABLE dbo.StudentExtension
ADD CONSTRAINT FK_StudentExtension_Status FOREIGN KEY (StatusId) REFERENCES dbo.Status(Id);
;

ALTER TABLE dbo.ReviewerSupervisorExtension
ADD CONSTRAINT FK_ReviewerSupervisorExtension_Account FOREIGN KEY (AccountId) REFERENCES dbo.Account(Id);
;

ALTER TABLE dbo.ReviewerSupervisorExtension
ADD CONSTRAINT FK_ReviewerSupervisorExtension_Class FOREIGN KEY (AssignedClassId) REFERENCES dbo.Class(Id);
;

ALTER TABLE dbo.ReviewerSupervisorExtension
ADD CONSTRAINT FK_ReviewerSupervisorExtension_Status FOREIGN KEY (StatusId) REFERENCES dbo.Status(Id);
;

ALTER TABLE dbo.CapstoneSupervisorExtension
ADD CONSTRAINT FK_CapstoneSupervisorExtension_Account FOREIGN KEY (AccountId) REFERENCES dbo.Account(Id);
;

ALTER TABLE dbo.CapstoneSupervisorExtension
ADD CONSTRAINT FK_CapstoneSupervisorExtension_Status FOREIGN KEY (StatusId) REFERENCES dbo.Status(Id);
;

ALTER TABLE dbo.SuperAdminExtension
ADD CONSTRAINT FK_SuperAdminExtension_Account FOREIGN KEY (AccountId) REFERENCES dbo.Account(Id);
;

ALTER TABLE dbo.SuperAdminExtension
ADD CONSTRAINT FK_SuperAdminExtension_Status FOREIGN KEY (StatusId) REFERENCES dbo.Status(Id);
;

ALTER TABLE dbo.AdmissionProfile
ADD CONSTRAINT FK_AdmissionProfile_Account FOREIGN KEY (AccountId) REFERENCES dbo.Account(Id);
;

ALTER TABLE dbo.AdmissionProfile
ADD CONSTRAINT FK_AdmissionProfile_Status FOREIGN KEY (StatusId) REFERENCES dbo.Status(Id);
;

PRINT 'Foreign key constraints added successfully.';

-- =====================================================
-- 4. INSERT DUMMY DATA
-- Data is inserted in an order that respects conceptual dependencies.
-- IDs are auto-generated by IDENTITY.
-- =====================================================

PRINT 'Inserting dummy data...';

-- Inserting Status Data
INSERT INTO dbo.Status (StatusName, BusinessEntity) VALUES
('Active', 'General'),
('Inactive', 'General'),
('Pending', 'Task, Report, Ticket'),
('Completed', 'Task, Project'),
('Archived', 'General'),
('Approved', 'Report'),
('Rejected', 'Report'),
('New', 'Ticket'),
('Resolved', 'Ticket'),
('In Progress', 'Project, Task'),
('Communication Success' , 'EmploymentRequest'),
('Awaiting Response' , 'EmploymentRequest');

-- Inserting AccountType Data
INSERT INTO dbo.AccountType (AccountTypeName) VALUES
('Admin'),
('SuperAdmin'),
('Student'),
('Specialist'),
('Teacher'),
('Engineer'),
('Parent'),
('IT'),
('Reviewer'),
('CapstoneSupervisor'),
('ReceptionAdmin');

-- Inserting TicketType Data
INSERT INTO dbo.TicketType (TicketTypeName, OrderNo, BusinessEntity, StatusId) VALUES
('Late', 10, 'Behaviour', 1),
('Eating', 30, 'Behaviour', 1),
('SideTalks', 20, 'Behaviour', 1),
('Absence', 10, 'Absence', 1),
('Bullying', 40, 'Behaviour', 1),
('Technical Issue', 50, 'IT', 1);

-- Declare variables to hold generated IDs for lookups and relationships
DECLARE @activeStatusId BIGINT, @pendingStatusId BIGINT, @completedStatusId BIGINT, @newStatusId BIGINT, @resolvedStatusId BIGINT, @approvedStatusId BIGINT;
SELECT @activeStatusId = Id FROM dbo.Status WHERE StatusName = 'Active';
SELECT @pendingStatusId = Id FROM dbo.Status WHERE StatusName = 'Pending';
SELECT @completedStatusId = Id FROM dbo.Status WHERE StatusName = 'Completed';
SELECT @newStatusId = Id FROM dbo.Status WHERE StatusName = 'New';
SELECT @resolvedStatusId = Id FROM dbo.Status WHERE StatusName = 'Resolved';
SELECT @approvedStatusId = Id FROM dbo.Status WHERE StatusName = 'Approved';


DECLARE @adminTypeId BIGINT, @superAdminTypeId BIGINT, @studentTypeId BIGINT,
        @teacherTypeId BIGINT, @reviewerTypeId BIGINT, @capstoneSupervisorTypeId BIGINT,
        @specialistTypeId BIGINT, @engineerTypeId BIGINT, @parentTypeId BIGINT, @itTypeId BIGINT, @receptionAdminTypeId BIGINT;

SELECT @adminTypeId = Id FROM dbo.AccountType WHERE AccountTypeName = 'Admin';
SELECT @superAdminTypeId = Id FROM dbo.AccountType WHERE AccountTypeName = 'SuperAdmin';
SELECT @studentTypeId = Id FROM dbo.AccountType WHERE AccountTypeName = 'Student';
SELECT @specialistTypeId = Id FROM dbo.AccountType WHERE AccountTypeName = 'Specialist';
SELECT @teacherTypeId = Id FROM dbo.AccountType WHERE AccountTypeName = 'Teacher';
SELECT @engineerTypeId = Id FROM dbo.AccountType WHERE AccountTypeName = 'Engineer';
SELECT @parentTypeId = Id FROM dbo.AccountType WHERE AccountTypeName = 'Parent';
SELECT @itTypeId = Id FROM dbo.AccountType WHERE AccountTypeName = 'IT';
SELECT @reviewerTypeId = Id FROM dbo.AccountType WHERE AccountTypeName = 'Reviewer';
SELECT @capstoneSupervisorTypeId = Id FROM dbo.AccountType WHERE AccountTypeName = 'CapstoneSupervisor';
SELECT @receptionAdminTypeId = Id FROM dbo.AccountType WHERE AccountTypeName = 'ReceptionAdmin';


DECLARE @lateTicketTypeId BIGINT, @absenceTicketTypeId BIGINT, @technicalIssueTicketTypeId BIGINT;
SELECT @lateTicketTypeId = Id FROM dbo.TicketType WHERE TicketTypeName = 'Late';
SELECT @absenceTicketTypeId = Id FROM dbo.TicketType WHERE TicketTypeName = 'Absence';
SELECT @technicalIssueTicketTypeId = Id FROM dbo.TicketType WHERE TicketTypeName = 'Technical Issue';


-- Inserting Admin Accounts
INSERT INTO dbo.Account (NationalId, PasswordHash, Email, AccountTypeId, FullNameEN, FullNameAR, IsActive, StatusId) VALUES
('12345678901234', 'hashedadminpass1', 'admin1@school.edu', @superAdminTypeId, 'Dr. Mohamed Ahmed El-Sayed', N'د. محمد أحمد السيد', 1, @activeStatusId),
('12345678901235', 'hashedadminpass2', 'admin2@school.edu', @adminTypeId, 'Eng. Sara Ali', N'مهندسة سارة علي', 1, @activeStatusId),
('12345678901236', 'hashedteacherpass1', 'teacher1@school.edu', @teacherTypeId, 'Ms. Mona Hassan', N'أ. منى حسن', 1, @activeStatusId),
('12345678901237', 'hashedstudentpass1', 'student1@school.edu', @studentTypeId, 'Ahmed Emad', N'أحمد عماد', 1, @activeStatusId),
('12345678901238', 'hashedstudentpass2', 'student2@school.edu', @studentTypeId, 'Fatma Khalid', N'فاطمة خالد', 1, @activeStatusId);

-- Inserting Login Data (for the accounts above)
INSERT INTO dbo.Login (AccountId, Email, PasswordHash, StatusId) VALUES
((SELECT Id FROM dbo.Account WHERE Email = 'admin1@school.edu'), 'admin1@school.edu', 'hashedadminpass1', @activeStatusId),
((SELECT Id FROM dbo.Account WHERE Email = 'admin2@school.edu'), 'admin2@school.edu', 'hashedadminpass2', @activeStatusId),
((SELECT Id FROM dbo.Account WHERE Email = 'teacher1@school.edu'), 'teacher1@school.edu', 'hashedteacherpass1', @activeStatusId),
((SELECT Id FROM dbo.Account WHERE Email = 'student1@school.edu'), 'student1@school.edu', 'hashedstudentpass1', @activeStatusId),
((SELECT Id FROM dbo.Account WHERE Email = 'student2@school.edu'), 'student2@school.edu', 'hashedstudentpass2', @activeStatusId);

-- Inserting Achievements Data
INSERT INTO dbo.Achievements (Title, Description, ImageUrl) VALUES
('Top Student Award 2024', 'Awarded to the student with the highest academic performance in the year 2024.', 'https://example.com/images/award1.png'),
('Robotics Competition Winner', 'Won first place in the National Robotics Competition with an innovative design.', 'https://example.com/images/robotics_win.png'),
('Community Service Excellence', 'Recognized for outstanding contributions to community service projects, volunteering over 100 hours.', 'https://example.com/images/community_award.png');

-- Inserting EmploymentRequests Data
INSERT INTO dbo.EmploymentRequests (CompanyName, LinkedInUrl, CompanyEmail, CompanyPhone, Address, Specialization, Amount, OwnerName, OwnerPhone, OwnerEmail, EmploymentType, StatusId, RequestDate) VALUES
('Tech Solutions Inc.', 'https://linkedin.com/company/techsolutions', 'hr@techsolutions.com', '01012345678', '123 Tech Park, Cairo', 'Software Development', 'Negotiable', 'Omar Badr', '01123456789', 'omar.badr@techsolutions.com', 'Full-time', @pendingStatusId, '2025-07-20 10:00:00'),
('Innovate Marketing Agency', 'https://linkedin.com/company/innovatemarketing', 'careers@innovate.com', '01223456789', '456 Creative St, Giza', 'Digital Marketing', '5000-7000 EGP', 'Leila Mansour', '01554321098', 'leila.m@innovate.com', 'Internship', @approvedStatusId, '2025-07-15 14:30:00'),
('Engineering Futures Ltd.', 'https://linkedin.com/company/engineeringfutures', 'info@engfutures.net', '01009876543', '789 Industrial Zone, October', 'Electrical Engineering', '8000-10000 EGP', 'Khaled Fawzy', '01112233445', 'khaled.f@engfutures.net', 'Full-time', @pendingStatusId, '2025-07-22 09:15:00');


-- Inserting Grade Data
INSERT INTO dbo.Grade (GradeName, ParentGradeId, AdminAccountId, StatusId) VALUES
('Grade 10', NULL, (SELECT Id FROM dbo.Account WHERE Email = 'admin1@school.edu'), @activeStatusId),
('Grade 11', NULL, (SELECT Id FROM dbo.Account WHERE Email = 'admin1@school.edu'), @activeStatusId),
('Grade 12', NULL, (SELECT Id FROM dbo.Account WHERE Email = 'admin1@school.edu'), @activeStatusId);

-- Inserting Class Data
DECLARE @grade10Id BIGINT, @grade11Id BIGINT, @grade12Id BIGINT;
SELECT @grade10Id = Id FROM dbo.Grade WHERE GradeName = 'Grade 10';
SELECT @grade11Id = Id FROM dbo.Grade WHERE GradeName = 'Grade 11';
SELECT @grade12Id = Id FROM dbo.Grade WHERE GradeName = 'Grade 12';

INSERT INTO dbo.Class (ClassName, GradeId, StatusId) VALUES
('10A', @grade10Id, @activeStatusId),
('10B', @grade10Id, @activeStatusId),
('11A', @grade11Id, @activeStatusId),
('12C', @grade12Id, @activeStatusId);

-- Inserting Session Data
INSERT INTO dbo.Session (SessionNo, FromDate, ToDate, StatusId, Note) VALUES
(1, '2024-09-01', '2025-01-31', @activeStatusId, 'Fall Semester 2024-2025'),
(2, '2025-02-01', '2025-06-30', @activeStatusId, 'Spring Semester 2025');

-- Inserting Project Data
DECLARE @supervisorAccountId BIGINT;
SELECT @supervisorAccountId = Id FROM dbo.Account WHERE Email = 'admin1@school.edu'; -- Assuming admin1 is a supervisor

INSERT INTO dbo.Project (NameAR, NameEN, CompanyName, ProjectDescription, SupervisorAccountId, StatusId) VALUES
(N'مشروع تتبع الطلاب', 'Student Tracking System', 'ELSEWEDY', 'Developing a web-based system to track student attendance and performance.', @supervisorAccountId, @pendingStatusId),
(N'تطبيق إدارة المكتبة', 'Library Management App', 'ELSEWEDY', 'Mobile application for managing library books and loans.', @supervisorAccountId, @completedStatusId),
(N'تحليل بيانات الطاقة', 'Energy Data Analysis Tool', 'ELSEWEDY', 'A tool to analyze energy consumption data for optimization.', @supervisorAccountId, @activeStatusId);

-- Inserting Team Data
DECLARE @class10AId BIGINT;
SELECT @class10AId = Id FROM dbo.Class WHERE ClassName = '10A';

INSERT INTO dbo.Team (TeamName, ClassId, StatusId) VALUES
('Innovators', @class10AId, @activeStatusId),
('Dream Builders', @class10AId, @activeStatusId);

-- Inserting TeamMember Data (Linking students to teams)
DECLARE @teamInnovatorsId BIGINT, @teamDreamBuildersId BIGINT;
DECLARE @student1AccountId BIGINT, @student2AccountId BIGINT;
SELECT @teamInnovatorsId = Id FROM dbo.Team WHERE TeamName = 'Innovators';
SELECT @teamDreamBuildersId = Id FROM dbo.Team WHERE TeamName = 'Dream Builders';
SELECT @student1AccountId = Id FROM dbo.Account WHERE Email = 'student1@school.edu';
SELECT @student2AccountId = Id FROM dbo.Account WHERE Email = 'student2@school.edu';

INSERT INTO dbo.TeamMember (TeamId, TeamMemberAccountId, TeamMemberDescription, StatusId) VALUES
(@teamInnovatorsId, @student1AccountId, 'Team Leader', @activeStatusId),
(@teamDreamBuildersId, @student2AccountId, 'Developer', @activeStatusId);

-- Inserting Scholarship Data
INSERT INTO dbo.Scholarship (ScholarshipName, Amount, ProviderName, StartDate, EndDate, StatusId) VALUES
('Academic Excellence Grant', 5000.00, 'Elsewedy Foundation', '2024-09-01', '2025-08-31', @activeStatusId),
('Innovation Fund Scholarship', 3000.00, 'Tech Leaders Corp.', '2024-10-01', '2025-09-30', @activeStatusId);

-- Inserting Task Data
DECLARE @grade10TaskId BIGINT, @admin1AccountId BIGINT;
SELECT @grade10TaskId = Id FROM dbo.Grade WHERE GradeName = 'Grade 10';
SELECT @admin1AccountId = Id FROM dbo.Account WHERE Email = 'admin1@school.edu';

INSERT INTO dbo.Task (TaskName, TaskDescription, TaskDeadline, GithubLink, GradeId, AdminAccountId, StatusId) VALUES
('Database Design Project', 'Design and implement a relational database for a small business.', '2025-08-15 23:59:59', 'https://github.com/school/db-project', @grade10TaskId, @admin1AccountId, @activeStatusId),
('Web Development Assignment', 'Create a responsive landing page using HTML, CSS, and JavaScript.', '2025-09-01 23:59:59', NULL, @grade10TaskId, @admin1AccountId, @activeStatusId);

-- Inserting StudentTask Data
DECLARE @dbProjectTaskId BIGINT, @webDevTaskId BIGINT;
SELECT @dbProjectTaskId = Id FROM dbo.Task WHERE TaskName = 'Database Design Project';
SELECT @webDevTaskId = Id FROM dbo.Task WHERE TaskName = 'Web Development Assignment';

INSERT INTO dbo.StudentTask (StudentAccountId, TaskId, IsCompleted, CompletedAt, StatusId) VALUES
(@student1AccountId, @dbProjectTaskId, 1, '2025-08-10 14:00:00', @completedStatusId),
(@student2AccountId, @dbProjectTaskId, 0, NULL, @pendingStatusId),
(@student1AccountId, @webDevTaskId, 0, NULL, @pendingStatusId);

-- Inserting Report Data
INSERT INTO dbo.Report (Title, ReportMessage, SubmitterAccountId, StatusId) VALUES
('Bug Report: Login Issue', 'Users are unable to log in intermittently.', (SELECT Id FROM dbo.Account WHERE Email = 'student1@school.edu'), @newStatusId),
('Feature Request: Dark Mode', 'Requesting a dark mode option for the student portal.', (SELECT Id FROM dbo.Account WHERE Email = 'teacher1@school.edu'), @pendingStatusId);

-- Inserting SubordinateTicket Data
INSERT INTO dbo.SubordinateTicket (SupervisorAccountId, GradeId, ClassId, SessionId, SubordinateAccountId, TicketTypeId, StatusId) VALUES
((SELECT Id FROM dbo.Account WHERE Email = 'admin1@school.edu'), @grade10Id, @class10AId, (SELECT Id FROM dbo.Session WHERE SessionNo = 1), @student2AccountId, @lateTicketTypeId, @newStatusId),
((SELECT Id FROM dbo.Account WHERE Email = 'admin1@school.edu'), @grade10Id, @class10AId, (SELECT Id FROM dbo.Session WHERE SessionNo = 1), @student1AccountId, @absenceTicketTypeId, @resolvedStatusId);

-- Inserting Extension Data
INSERT INTO dbo.StudentExtension (AccountId, IsLeader, ClassId, StatusId) VALUES
(@student1AccountId, 1, @class10AId, @activeStatusId),
(@student2AccountId, 0, @class10AId, @activeStatusId);

INSERT INTO dbo.ReviewerSupervisorExtension (AccountId, AssignedClassId, StatusId) VALUES
((SELECT Id FROM dbo.Account WHERE Email = 'teacher1@school.edu'), @class10AId, @activeStatusId);

INSERT INTO dbo.CapstoneSupervisorExtension (AccountId, StatusId) VALUES
((SELECT Id FROM dbo.Account WHERE Email = 'admin2@school.edu'), @activeStatusId);

INSERT INTO dbo.SuperAdminExtension (AccountId, StatusId) VALUES
((SELECT Id FROM dbo.Account WHERE Email = 'admin1@school.edu'), @activeStatusId);

-- Inserting AdmissionProfile Data
INSERT INTO dbo.AdmissionProfile (AccountId, DateOfBirth, Location, PhoneNumber, SoftwareInterviewScore, MathInterviewScore, EnglishInterviewScore, ArabicInterviewScore, StudentName, MathScore, EnglishScore, ThirdPrepScore, IsAcceptanceLetterReceived, StatusId) VALUES
(@student1AccountId, '2008-05-15', 'Giza, Egypt', '01001234567', 85.50, 92.00, 88.75, 95.00, N'أحمد عماد', 90.00, 85.00, 92.50, 1, @activeStatusId),
(@student2AccountId, '2009-01-20', 'Cairo, Egypt', '01123456789', 78.00, 85.50, 80.00, 88.00, N'فاطمة خالد', 80.00, 75.00, 88.00, 0, @activeStatusId);

PRINT 'Dummy data inserted successfully.';

SELECT * FROM dbo.Status;
SELECT * FROM dbo.AccountType; -- Corrected from Account_Type_Lookup
SELECT * FROM dbo.TicketType;
SELECT * FROM dbo.Grade;
SELECT * FROM dbo.Class;
SELECT * FROM dbo.Session;
SELECT * FROM dbo.Account;
SELECT * FROM dbo.EmailSettings;
SELECT * FROM dbo.Project;
SELECT * FROM dbo.Team;
SELECT * FROM dbo.TeamMember;
SELECT * FROM dbo.Scholarship;
SELECT * FROM dbo.Task;
SELECT * FROM dbo.StudentTask;
SELECT * FROM dbo.Report;
SELECT * FROM dbo.SubordinateTicket;
SELECT * FROM dbo.StudentExtension;
SELECT * FROM dbo.ReviewerSupervisorExtension;
SELECT * FROM dbo.CapstoneSupervisorExtension;
SELECT * FROM dbo.SuperAdminExtension;
SELECT * FROM dbo.AdmissionProfile;
SELECT * FROM dbo.EmploymentRequests;
SELECT * FROM dbo.Achievements;
PRINT 'All data retrieval queries executed.';
