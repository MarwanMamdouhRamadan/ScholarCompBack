USE [master];
GO

-- =====================================================
-- 0. DROPPING AND RECREATING THE DATABASE (FOR CLEAN SLATE)
-- This ensures a completely fresh start, resolving persistent "object already exists" errors.
-- =====================================================

PRINT 'Checking for and dropping existing database...';

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
GO

PRINT 'Creating new database [ElsewedySchoolSys]...';
CREATE DATABASE [ElsewedySchoolSys];
GO

-- Set the collation for the ElsewedySchoolSys database
-- This ensures proper handling of Arabic characters.
ALTER DATABASE [ElsewedySchoolSys] COLLATE Arabic_100_CI_AI;
GO

-- Use the target database.
USE ElsewedySchoolSys;
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
GO

-- Drop existing triggers (if any were previously created).
IF OBJECT_ID('TR_grade_updated_at', 'TR') IS NOT NULL DROP TRIGGER TR_grade_updated_at;
IF OBJECT_ID('TR_class_updated_at', 'TR') IS NOT NULL DROP TRIGGER TR_class_updated_at;
IF OBJECT_ID('TR_team_updated_at', 'TR') IS NOT NULL DROP TRIGGER TR_team_updated_at;
IF OBJECT_ID('TR_account_updated_at', 'TR') IS NOT NULL DROP TRIGGER TR_account_updated_at;
IF OBJECT_ID('TR_task_updated_at', 'TR') IS NOT NULL DROP TRIGGER TR_task_updated_at;
IF OBJECT_ID('TR_student_task_updated_at', 'TR') IS NOT NULL DROP TRIGGER TR_student_task_updated_at;
IF OBJECT_ID('TR_report_updated_at', 'TR') IS NOT NULL DROP TRIGGER TR_report_updated_at;
IF OBJECT_ID('TR_status_updated_at', 'TR') IS NOT NULL DROP TRIGGER TR_status_updated_at;
IF OBJECT_ID('TR_account_type_lookup_updated_at', 'TR') IS NOT NULL DROP TRIGGER TR_account_type_lookup_updated_at;
IF OBJECT_ID('TR_student_extension_updated_at', 'TR') IS NOT NULL DROP TRIGGER TR_student_extension_updated_at;
IF OBJECT_ID('TR_reviewer_supervisor_extension_updated_at', 'TR') IS NOT NULL DROP TRIGGER TR_reviewer_supervisor_extension_updated_at;
IF OBJECT_ID('TR_capstone_supervisor_extension_updated_at', 'TR') IS NOT NULL DROP TRIGGER TR_capstone_supervisor_extension_updated_at;
IF OBJECT_ID('TR_super_admin_extension_updated_at', 'TR') IS NOT NULL DROP TRIGGER TR_super_admin_extension_updated_at;
IF OBJECT_ID('TR_session_updated_at', 'TR') IS NOT NULL DROP TRIGGER TR_session_updated_at;
IF OBJECT_ID('TR_ticket_type_lookup_updated_at', 'TR') IS NOT NULL DROP TRIGGER TR_ticket_type_lookup_updated_at;
IF OBJECT_ID('TR_subordinate_ticket_updated_at', 'TR') IS NOT NULL DROP TRIGGER TR_subordinate_ticket_updated_at;
IF OBJECT_ID('TR_project_updated_at', 'TR') IS NOT NULL DROP TRIGGER TR_project_updated_at;
IF OBJECT_ID('TR_team_member_updated_at', 'TR') IS NOT NULL DROP TRIGGER TR_team_member_updated_at;
IF OBJECT_ID('TR_scholarship_updated_at', 'TR') IS NOT NULL DROP TRIGGER TR_scholarship_updated_at;
GO

-- Drop tables in reverse order of (conceptual) dependency to ensure smooth removal.
IF OBJECT_ID('dbo.Admission_Profile', 'U') IS NOT NULL DROP TABLE dbo.Admission_Profile;
IF OBJECT_ID('dbo.student_extension', 'U') IS NOT NULL DROP TABLE dbo.student_extension;
IF OBJECT_ID('dbo.reviewer_supervisor_extension', 'U') IS NOT NULL DROP TABLE dbo.reviewer_supervisor_extension;
IF OBJECT_ID('dbo.capstone_supervisor_extension', 'U') IS NOT NULL DROP TABLE dbo.capstone_supervisor_extension;
IF OBJECT_ID('dbo.super_admin_extension', 'U') IS NOT NULL DROP TABLE dbo.super_admin_extension;
IF OBJECT_ID('dbo.student_task', 'U') IS NOT NULL DROP TABLE dbo.student_task;
IF OBJECT_ID('dbo.report', 'U') IS NOT NULL DROP TABLE dbo.report;
IF OBJECT_ID('dbo.task', 'U') IS NOT NULL DROP TABLE dbo.task;
IF OBJECT_ID('dbo.team_member', 'U') IS NOT NULL DROP TABLE dbo.team_member;
IF OBJECT_ID('dbo.team', 'U') IS NOT NULL DROP TABLE dbo.team;
IF OBJECT_ID('dbo.project', 'U') IS NOT NULL DROP TABLE dbo.project;
IF OBJECT_ID('dbo.scholarship', 'U') IS NOT NULL DROP TABLE dbo.scholarship;
IF OBJECT_ID('dbo.account', 'U') IS NOT NULL DROP TABLE dbo.account;
IF OBJECT_ID('dbo.Account_Type', 'U') IS NOT NULL DROP TABLE dbo.Account_Type;
IF OBJECT_ID('dbo.class', 'U') IS NOT NULL DROP TABLE dbo.class;
IF OBJECT_ID('dbo.grade', 'U') IS NOT NULL DROP TABLE dbo.grade;
IF OBJECT_ID('dbo.Session', 'U') IS NOT NULL DROP TABLE dbo.Session;
IF OBJECT_ID('dbo.subordinate_ticket', 'U') IS NOT NULL DROP TABLE dbo.subordinate_ticket;
IF OBJECT_ID('dbo.Ticket_Type_Lookup', 'U') IS NOT NULL DROP TABLE dbo.Ticket_Type_Lookup;
IF OBJECT_ID('dbo.status', 'U') IS NOT NULL DROP TABLE dbo.status;
IF OBJECT_ID('dbo.email_settings', 'U') IS NOT NULL DROP TABLE dbo.email_settings;
GO

PRINT 'Existing objects dropped successfully (if any were present).';

-- =====================================================
-- 2. CREATE TABLES
-- All primary keys are BIGINT.
-- No 'created_at' and 'updated_at' fields.
-- No FOREIGN KEY CONSTRAINTS are used; relations are implicit via column names.
-- =====================================================

PRINT 'Creating new tables...';

-- dbo.Status: Lookup table for various statuses across the system.
CREATE TABLE dbo.Status (
    -- Primary key: Unique identifier for a status.
    id BIGINT NOT NULL IDENTITY(1,1),
    -- Name of the status (e.g., 'Active', 'Completed', 'Pending').
    status_name NVARCHAR(MAX) NOT NULL,
    -- Optional: Specifies which entity/table this status typically applies to (e.g., 'Account', 'Task').
    business_entity NVARCHAR(MAX) NULL,

    CONSTRAINT PK_Status PRIMARY KEY (id)
);
GO

-- dbo.Account_Type: Lookup table for different types of user accounts.
CREATE TABLE dbo.Account_Type (
    -- Primary key: Unique identifier for an account type.
    id BIGINT NOT NULL IDENTITY(1,1),
    -- Name of the account type (e.g., 'Admin', 'Teacher', 'Student').
    Account_type_TXT NVARCHAR(100) NOT NULL UNIQUE,
    CONSTRAINT PK_Account_Type PRIMARY KEY (id)
);
GO

-- dbo.Grade: Represents academic grades or levels in the educational system.
CREATE TABLE dbo.Grade (
    -- Primary key: Unique identifier for a grade.
    id BIGINT NOT NULL IDENTITY(1,1),
    -- Name of the grade (e.g., "Grade 10", "Senior Year").
    grade_name NVARCHAR(100) NOT NULL,
    -- Optional: Reference to a parent grade, allowing for hierarchical structures.
    parent_grade_id BIGINT NULL,
    -- Reference to the account ID of an admin who manages this grade.
    admin_account_id BIGINT NULL,
    -- Status of the grade (e.g., 'Active').
    status_id BIGINT NOT NULL DEFAULT 1,

    CONSTRAINT PK_Grade PRIMARY KEY (id)
);
GO

-- dbo.Class: Represents individual classes taught within specific grades.
CREATE TABLE dbo.Class (
    -- Primary key: Unique identifier for a class.
    id BIGINT NOT NULL IDENTITY(1,1),
    -- Name of the class (e.g., "101A", "Math Advanced").
    class_name NVARCHAR(100) NOT NULL,
    -- Reference to the grade ID this class belongs to.
    grade_id BIGINT NOT NULL,
    -- Status of the class (e.g., 'Active').
    status_id BIGINT NOT NULL DEFAULT 1,

    CONSTRAINT PK_Class PRIMARY KEY (id)
);
GO

-- dbo.Session: Represents academic sessions or periods.
CREATE TABLE dbo.Session (
    -- Primary key: Unique identifier for a session.
    id BIGINT NOT NULL IDENTITY(1,1),
    -- Session number or identifier.
    session_no INT NULL,
    -- Start Date of the session.
    from_date DATE NULL,
    -- End Date of the session.
    to_date DATE NULL,
    -- Status of the session (e.g., 'Active', 'Completed').
    status_id BIGINT NOT NULL DEFAULT 1,
	Note NVARCHAR(MAX) NULL,

    CONSTRAINT PK_Session PRIMARY KEY (id)
);
GO

-- dbo.Ticket_Type_Lookup: Lookup table for different types of tickets (e.g., Late, Absence).
CREATE TABLE dbo.Ticket_Type_Lookup (
    -- Primary key: Unique identifier for a ticket type.
    id BIGINT NOT NULL IDENTITY(1,1),
    -- Name of the ticket type (e.g., 'Late', 'Eating', 'Absence').
    ticket_type_name NVARCHAR(100) NOT NULL,
    -- Order number for sorting ticket types.
    order_no INT NULL,
    -- Business entity associated with the ticket type (e.g., 'Behaviour', 'Absence').
    business_entity NVARCHAR(90) NULL,
    -- Status of the ticket type (e.g., 'Active').
    status_id BIGINT NOT NULL DEFAULT 1,

    CONSTRAINT PK_Ticket_Type_Lookup PRIMARY KEY (id)
);
GO

-- dbo.Account: Central table for all users.
CREATE TABLE dbo.Account (
    -- Primary key: Unique identifier for an account.
    id BIGINT NOT NULL IDENTITY(1,1),
    -- User's National ID.
    national_id NVARCHAR(14) NOT NULL UNIQUE,
    -- User's password (should be hashed in application).
    password_hash NVARCHAR(MAX) NOT NULL,
    -- User's email address, must be unique.
    email NVARCHAR(255) NOT NULL UNIQUE,
    -- Reference to the account type ID from `Account_Type_Lookup`.
    account_type_id BIGINT NOT NULL,
    -- Full name of the account holder (English).
    full_name_EN NVARCHAR(MAX) NOT NULL,
	-- Full name of the account holder (Arabic).
    full_name_AR NVARCHAR(MAX) NOT NULL,
    -- Token for password reset.
    reset_token NVARCHAR(MAX) NULL,
    -- Expiry date/time for the reset token.
    reset_token_expiry DATETIME2 NULL,
    -- Flag indicating if the account is active (0=Inactive, 1=Active).
    is_active BIT NOT NULL DEFAULT 1,
    -- Status of the account (e.g., 'Active').
    status_id BIGINT NOT NULL DEFAULT 1,

    CONSTRAINT PK_Account PRIMARY KEY (id)
);
GO

-- dbo.Email_Settings: Stores configuration for email sending.
CREATE TABLE dbo.Email_Settings (
    -- SMTP server address.
    smtp_server NVARCHAR(255) NULL,
    -- SMTP port number.
    smtp_port INT NULL,
    -- SMTP username for authentication.
    smtp_username NVARCHAR(255) NULL,
    -- SMTP password for authentication.
    smtp_password NVARCHAR(255) NULL,
    -- Sender email address.
    sender_email NVARCHAR(255) NULL
);
GO

-- dbo.Team: Represents student teams.
CREATE TABLE dbo.Team (
    -- Primary key: Unique identifier for a team.
    id BIGINT NOT NULL IDENTITY(1,1),
    -- Name of the team.
    team_name NVARCHAR(100) NOT NULL,
    -- Reference to the account ID of the student who is the team leader.
    team_leader_account_id BIGINT NULL,
    -- Reference to the class ID this team belongs to.
    class_id BIGINT NOT NULL,
    -- Reference to the account ID of the supervisor for this team.
    supervisor_account_id BIGINT NULL,
    -- Reference to the project ID associated with this team.
    project_id BIGINT NULL,
    -- Status of the team (e.g., 'Active').
    status_id BIGINT NOT NULL DEFAULT 1,

    CONSTRAINT PK_Team PRIMARY KEY (id)
);
GO

-- dbo.Team_Member: Links individual accounts to teams.
CREATE TABLE dbo.Team_Member (
    -- Primary key: Unique identifier for this team member record.
    id BIGINT NOT NULL IDENTITY(1,1),
    -- Reference to the team ID.
    team_id BIGINT NOT NULL,
    -- Reference to the account ID of the team member.
    team_member_account_id BIGINT NOT NULL,
    -- Description or role of the team member within the team.
    team_member_description NVARCHAR(MAX) NULL,
    -- Status of the team member record (e.g., 'Active').
    status_id BIGINT NOT NULL DEFAULT 1,

    CONSTRAINT PK_Team_Member PRIMARY KEY (id)
);
GO

-- dbo.Project: Represents academic projects.
CREATE TABLE dbo.Project (
    -- Primary key: Unique identifier for a project.
    id BIGINT NOT NULL IDENTITY(1,1),
    -- Project name in Arabic.
    name_ar NVARCHAR(MAX) NOT NULL,
    -- Project name in English.
    name_en NVARCHAR(MAX) NOT NULL,
    -- Date of project creation.
    date_of_creation DATETIME2 NOT NULL DEFAULT GETDATE(),
    -- Detailed description of the project.
    project_description NVARCHAR(MAX) NOT NULL,
    -- Status of the project (e.g., 'Pending', 'In Progress', 'Completed').
    status_id BIGINT NOT NULL DEFAULT 1,
	--Foreign Key to account Table
	Supervisor_account_ID BIGINT NOT NULL

    CONSTRAINT PK_Project PRIMARY KEY (id)
);
GO

-- dbo.Scholarship: Represents scholarships offered to students.
CREATE TABLE dbo.Scholarship (
    -- Primary key: Unique identifier for a scholarship.
    id BIGINT NOT NULL IDENTITY(1,1),
    -- Name of the scholarship.
    scholarship_name NVARCHAR(MAX) NOT NULL,
    -- Amount of the scholarship.
    amount MONEY NOT NULL,
    -- Provider of the scholarship.
    provider_name NVARCHAR(MAX) NOT NULL,
    -- Start date of the scholarship.
    start_date DATE NULL,
    -- End date of the scholarship.
    end_date DATE NULL,
    -- Status of the scholarship (e.g., 'Active', 'Closed').
    status_id BIGINT NOT NULL DEFAULT 1,

    CONSTRAINT PK_Scholarship PRIMARY KEY (id)
);
GO

-- dbo.Task: Represents individual assignments or tasks.
CREATE TABLE dbo.Task (
    -- Primary key: Unique identifier for a task.
    id BIGINT NOT NULL IDENTITY(1,1),
    -- Name of the task.
    task_name NVARCHAR(MAX) NOT NULL,
    -- Detailed instructions or description for the task.
    task_description NVARCHAR(MAX) NULL,
    -- Deadline for the task.
    task_deadline DATETIME NOT NULL,
    -- Optional: Link to a GitHub repository related to the task.
    github_link NVARCHAR(MAX) NULL,
    -- Reference to the grade ID this task is associated with.
    grade_id BIGINT NOT NULL,
    -- Reference to the account ID of the admin who created/manages this task.
    admin_account_id BIGINT NOT NULL,
    -- Status of the task (e.g., 'Active', 'Pending').
    status_id BIGINT NOT NULL DEFAULT 1,

    CONSTRAINT PK_Task PRIMARY KEY (id)
);
GO

-- dbo.Student_Task: Links students to tasks and tracks their completion status.
CREATE TABLE dbo.Student_Task (
    -- Primary key: Unique identifier for this student-task record.
    id BIGINT NOT NULL IDENTITY(1,1),
    -- Reference to the student's account ID.
    student_account_id BIGINT NOT NULL,
    -- Reference to the task ID.
    task_id BIGINT NOT NULL,
    -- Flag indicating if the student has completed the task (0=No, 1=Yes).
    is_completed BIT NOT NULL DEFAULT 0,
    -- Timestamp when the task was marked as completed (nullable if not completed).
    completed_at DATETIME NULL,
    -- Status of the student's task (e.g., 'Pending', 'Completed').
    status_id BIGINT NOT NULL DEFAULT 1,

    CONSTRAINT PK_Student_Task PRIMARY KEY (id)
);
GO

-- dbo.Report: Stores user-submitted reports or feedback.
CREATE TABLE dbo.Report (
    -- Primary key: Unique identifier for a report.
    id BIGINT NOT NULL IDENTITY(1,1),
    -- Title or subject of the report.
    title NVARCHAR(MAX) NOT NULL,
    -- Timestamp when the report was submitted.
    submission_date DATETIME NOT NULL DEFAULT GETDATE(),
    -- Main message or body of the report.
    report_message NVARCHAR(MAX) NOT NULL,
    -- Reference to the account ID of the user who submitted the report.
    submitter_account_id BIGINT NOT NULL,
    -- Status of the report (e.g., 'Pending', 'Approved', 'Rejected').
    status_id BIGINT NOT NULL DEFAULT 1,

    CONSTRAINT PK_Report PRIMARY KEY (id)
);
GO

-- dbo.Subordinate_Ticket: Represents tickets raised by subordinates or for specific entities.
CREATE TABLE dbo.Subordinate_Ticket (
    -- Primary key: Unique identifier for a subordinate ticket.
    id BIGINT NOT NULL IDENTITY(1,1),
    -- Reference to the account ID of the supervisor.
    supervisor_account_id BIGINT NULL,
    -- Reference to the grade ID relevant to the ticket.
    grade_id BIGINT NULL,
    -- Reference to the class ID relevant to the ticket.
    class_id BIGINT NULL,
    -- Reference to the session ID relevant to the ticket.
    session_id BIGINT NULL,
    -- Reference to the account ID of the subordinate (the one the ticket is about).
    subordinate_account_id BIGINT NULL,
    -- Reference to the ticket type ID from `Ticket_Type_Lookup`.
    ticket_type_id BIGINT NULL,
    -- Status of the subordinate ticket (e.g., 'New', 'Resolved').
    status_id BIGINT NOT NULL DEFAULT 1,

    CONSTRAINT PK_Subordinate_Ticket PRIMARY KEY (id)
);
GO

-- dbo.Student_Extension: Extension table for student-specific attributes.
CREATE TABLE dbo.Student_Extension (
    -- Primary key: Reference to the student's account ID from the `Account` table.
    account_id BIGINT NOT NULL,
    -- Flag indicating if the student is a team leader (0=No, 1=Yes).
    is_leader BIT NOT NULL DEFAULT 0,
    -- Reference to the class ID the student belongs to.
    class_id BIGINT NULL,
    -- Status of the student extension record.
    status_id BIGINT NOT NULL DEFAULT 1,

    CONSTRAINT PK_Student_Extension PRIMARY KEY (account_id)
);
GO

-- dbo.Reviewer_Supervisor_Extension: Extension table for reviewer/supervisor-specific attributes.
CREATE TABLE dbo.Reviewer_Supervisor_Extension (
    -- Primary key: Reference to the reviewer/supervisor's account ID.
    account_id BIGINT NOT NULL,
    -- Optional: Reference to the class ID they are assigned to review/supervise.
    assigned_class_id BIGINT NULL,
    -- Status of the extension record.
    status_id BIGINT NOT NULL DEFAULT 1,

    CONSTRAINT PK_Reviewer_Supervisor_Extension PRIMARY KEY (account_id)
);
GO

-- dbo.Capstone_Supervisor_Extension: Extension table for capstone project supervisor-specific attributes.
CREATE TABLE dbo.Capstone_Supervisor_Extension (
    -- Primary key: Reference to the capstone supervisor's account ID.
    account_id BIGINT NOT NULL,
    -- Status of the extension record.
    status_id BIGINT NOT NULL DEFAULT 1,

    CONSTRAINT PK_Capstone_Supervisor_Extension PRIMARY KEY (account_id)
);
GO

-- dbo.Super_Admin_Extension: Extension table for super admin-specific attributes.
CREATE TABLE dbo.Super_Admin_Extension (
    -- Primary key: Reference to the super admin's account ID.
    account_id BIGINT NOT NULL,
    -- Status of the extension record.
    status_id BIGINT NOT NULL DEFAULT 1,

    CONSTRAINT PK_Super_Admin_Extension PRIMARY KEY (account_id)
);
GO

-- dbo.Admission_Profile: Stores admission-specific attributes for accounts.
CREATE TABLE dbo.Admission_Profile (
    -- Primary key: Reference to the account ID from the `Account` table.
    account_id BIGINT NOT NULL,
    -- Date of birth of the applicant/student.
    DateOfBirth DATE NULL,
    -- Location of the applicant/student.
    Location NVARCHAR(MAX) NULL,
    -- Phone number of the applicant/student.
    PhoneNumber NVARCHAR(20) NULL,
    -- Score from the software interview.
    SoftwareInterviewScore Decimal(5,2) NULL,
    -- Score from the math interview.
    MathInterviewScore Decimal(5,2) NULL,
    -- Score from the English interview.
    EnglishInterviewScore Decimal(5,2) NULL,
    -- Score from the Arabic interview.
    ArabicInterviewScore Decimal(5,2) NULL,
    -- Name of the student (redundant with Account.full_name but included as per request).
    StudentName NVARCHAR(MAX) NULL,
    -- Student's math score.
    MathScore Decimal(5,2) NULL,
    -- Student's English score.
    EnglishScore Decimal(5,2) NULL,
    -- Student's third preparatory year score.
    ThirdPrepScore Decimal(5,2) NULL,
    -- Flag indicating if the acceptance letter has been received (0=No, 1=Yes).
    IsAcceptanceLetterReceived BIT NOT NULL DEFAULT 0,
    -- Status of the admission profile record.
    status_id BIGINT NOT NULL DEFAULT 1,

    CONSTRAINT PK_Admission_Profile PRIMARY KEY (account_id)
);
GO

PRINT 'New tables created successfully.';

-- =====================================================
-- 3. INSERT DUMMY DATA
-- Data is inserted in an order that respects conceptual dependencies.
-- IDs are auto-generated by IDENTITY.
-- =====================================================

PRINT 'Inserting dummy data...';

-- Inserting Status Data
INSERT INTO dbo.Status (status_name, business_entity) VALUES
('Active', 'General'),
('Inactive', 'General'),
('Pending', 'Task, Report, Ticket'),
('Completed', 'Task, Project'),
('Archived', 'General'),
('Approved', 'Report'),
('Rejected', 'Report'),
('New', 'Ticket'),
('Resolved', 'Ticket'),
('In Progress', 'Project, Task');

-- Inserting Account Type Data
INSERT INTO dbo.Account_Type (Account_type_TXT) VALUES
('Admin'),
('SuperAdmin'),
('Student'),
('Specialist'),
('Teacher'),
('Engineer'),
('Parent'),
('IT'),
('Reviewer'),
('CapstoneSupervisor');


-- Inserting Ticket Type Lookup Data
INSERT INTO dbo.Ticket_Type_Lookup (ticket_type_name, order_no, business_entity, status_id) VALUES
('Late', 10, 'Behaviour', 1),
('Eating', 30, 'Behaviour', 1),
('SideTalks', 20, 'Behaviour', 1),
('Absence', 10, 'Absence', 1),
('Bullying', 40, 'Behaviour', 1),
('Technical Issue', 50, 'IT', 1);

-- Declare variables to hold generated IDs for lookups and relationships
DECLARE @active_status_id BIGINT, @pending_status_id BIGINT, @completed_status_id BIGINT, @new_status_id BIGINT, @resolved_status_id BIGINT;
SELECT @active_status_id = id FROM dbo.Status WHERE status_name = 'Active';
SELECT @pending_status_id = id FROM dbo.Status WHERE status_name = 'Pending';
SELECT @completed_status_id = id FROM dbo.Status WHERE status_name = 'Completed';
SELECT @new_status_id = id FROM dbo.Status WHERE status_name = 'New';
SELECT @resolved_status_id = id FROM dbo.Status WHERE status_name = 'Resolved';

DECLARE @admin_type_id BIGINT, @super_admin_type_id BIGINT, @student_type_id BIGINT,
        @teacher_type_id BIGINT, @reviewer_type_id BIGINT, @capstone_supervisor_type_id BIGINT,
        @specialist_type_id BIGINT, @engineer_type_id BIGINT, @parent_type_id BIGINT, @it_type_id BIGINT;

SELECT @admin_type_id = id FROM dbo.Account_Type WHERE Account_type_TXT = 'Admin';
SELECT @super_admin_type_id = id FROM dbo.Account_Type WHERE Account_type_TXT = 'SuperAdmin';
SELECT @student_type_id = id FROM dbo.Account_Type WHERE Account_type_TXT = 'Student';
SELECT @specialist_type_id = id FROM dbo.Account_Type WHERE Account_type_TXT = 'Specialist';
SELECT @teacher_type_id = id FROM dbo.Account_Type WHERE Account_type_TXT = 'Teacher';
SELECT @engineer_type_id = id FROM dbo.Account_Type WHERE Account_type_TXT = 'Engineer';
SELECT @parent_type_id = id FROM dbo.Account_Type WHERE Account_type_TXT = 'Parent';
SELECT @it_type_id = id FROM dbo.Account_Type WHERE Account_type_TXT = 'IT';
SELECT @reviewer_type_id = id FROM dbo.Account_Type WHERE Account_type_TXT = 'Reviewer';
SELECT @capstone_supervisor_type_id = id FROM dbo.Account_Type WHERE Account_type_TXT = 'CapstoneSupervisor';

DECLARE @late_ticket_type_id BIGINT, @absence_ticket_type_id BIGINT, @technical_issue_ticket_type_id BIGINT;
SELECT @late_ticket_type_id = id FROM dbo.Ticket_Type_Lookup WHERE ticket_type_name = 'Late';
SELECT @absence_ticket_type_id = id FROM dbo.Ticket_Type_Lookup WHERE ticket_type_name = 'Absence';
SELECT @technical_issue_ticket_type_id = id FROM dbo.Ticket_Type_Lookup WHERE ticket_type_name = 'Technical Issue';


-- Inserting Admin Accounts
INSERT INTO dbo.Account (national_id, password_hash, email, account_type_id, full_name_EN, full_name_AR, is_active, status_id) VALUES
('12345678901234', 'hashedadminpass1', 'admin1@school.edu', @super_admin_type_id, 'Dr. Mohamed Ahmed El-Sayed', N'د. محمد أحمد السيد', 1, @active_status_id),
('12345678901235', 'hashedadminpass2', 'admin2@school.edu', @admin_type_id, 'Dr. Fatima Ali Mahmoud', N'د. فاطمة علي محمود', 1, @active_status_id);

DECLARE @admin1_id BIGINT, @admin2_id BIGINT;
SELECT @admin1_id = id FROM dbo.Account WHERE email = 'admin1@school.edu';
SELECT @admin2_id = id FROM dbo.Account WHERE email = 'admin2@school.edu';

-- Inserting Super Admin Extension
INSERT INTO dbo.Super_Admin_Extension (account_id, status_id) VALUES
(@admin1_id, @active_status_id);

-- Inserting Teacher Accounts
INSERT INTO dbo.Account (national_id, password_hash, email, account_type_id, full_name_EN, full_name_AR, is_active, status_id) VALUES
('12345678901236', 'hashedteacherpass1', 'teacher1@school.edu', @teacher_type_id, 'Ms. Sara Abdelrahman', N'أ. سارة عبدالرحمن', 1, @active_status_id),
('12345678901237', 'hashedteacherpass2', 'teacher2@school.edu', @teacher_type_id, 'Mr. Ahmed Mohamed Ali', N'أ. أحمد محمد علي', 1, @active_status_id);

DECLARE @teacher1_id BIGINT, @teacher2_id BIGINT;
SELECT @teacher1_id = id FROM dbo.Account WHERE email = 'teacher1@school.edu';
SELECT @teacher2_id = id FROM dbo.Account WHERE email = 'teacher2@school.edu';

-- Inserting Reviewer/Supervisor Accounts
INSERT INTO dbo.Account (national_id, password_hash, email, account_type_id, full_name_EN, full_name_AR, is_active, status_id) VALUES
('12345678901238', 'hashedreviewerpass1', 'reviewer1@school.edu', @reviewer_type_id, 'Dr. Basma Hassan', N'د. بسمة حسن', 1, @active_status_id),
('12345678901239', 'hashedcapsup_pass1', 'capsup1@school.edu', @capstone_supervisor_type_id, 'Prof. Karim Said', N'أ.د. كريم سعيد', 1, @active_status_id);

DECLARE @reviewer1_id BIGINT, @capsup1_id BIGINT;
SELECT @reviewer1_id = id FROM dbo.Account WHERE email = 'reviewer1@school.edu';
SELECT @capsup1_id = id FROM dbo.Account WHERE email = 'capsup1@school.edu';

-- Inserting Parent Account
INSERT INTO dbo.Account (national_id, password_hash, email, account_type_id, full_name_EN, full_name_AR, is_active, status_id) VALUES
('12345678901240', 'hashedparentpass1', 'parent1@school.edu', @parent_type_id, 'Mrs. Mona Sayed', N'السيدة منى سيد', 1, @active_status_id);

DECLARE @parent1_id BIGINT;
SELECT @parent1_id = id FROM dbo.Account WHERE email = 'parent1@school.edu';

-- Inserting IT Account
INSERT INTO dbo.Account (national_id, password_hash, email, account_type_id, full_name_EN, full_name_AR, is_active, status_id) VALUES
('12345678901241', 'hasheditpass1', 'it1@school.edu', @it_type_id, 'Mr. Omar Gamal', N'أ. عمر جمال', 1, @active_status_id);

DECLARE @it1_id BIGINT;
SELECT @it1_id = id FROM dbo.Account WHERE email = 'it1@school.edu';

-- Inserting Grade Data with hierarchical structure
INSERT INTO dbo.Grade (grade_name, parent_grade_id, admin_account_id, status_id) VALUES
('Primary School', NULL, @admin1_id, @active_status_id),
('Secondary School', NULL, @admin1_id, @active_status_id);

DECLARE @primary_grade_id BIGINT, @secondary_grade_id BIGINT;
SELECT @primary_grade_id = id FROM dbo.Grade WHERE grade_name = 'Primary School';
SELECT @secondary_grade_id = id FROM dbo.Grade WHERE grade_name = 'Secondary School';

INSERT INTO dbo.Grade (grade_name, parent_grade_id, admin_account_id, status_id) VALUES
('First Secondary Grade', @secondary_grade_id, @admin1_id, @active_status_id),
('Second Secondary Grade', @secondary_grade_id, @admin2_id, @active_status_id),
('Third Secondary Grade', @secondary_grade_id, @admin1_id, @active_status_id);

DECLARE @first_secondary_grade_id BIGINT, @second_secondary_grade_id BIGINT, @third_secondary_grade_id BIGINT;
SELECT @first_secondary_grade_id = id FROM dbo.Grade WHERE grade_name = 'First Secondary Grade';
SELECT @second_secondary_grade_id = id FROM dbo.Grade WHERE grade_name = 'Second Secondary Grade';
SELECT @third_secondary_grade_id = id FROM dbo.Grade WHERE grade_name = 'Third Secondary Grade';


-- Inserting Class Data
INSERT INTO dbo.Class (class_name, grade_id, status_id) VALUES
('101A', @first_secondary_grade_id, @active_status_id),
('101B', @first_secondary_grade_id, @active_status_id),
('201A', @second_secondary_grade_id, @active_status_id),
('301A', @third_secondary_grade_id, @active_status_id);

DECLARE @class101A_id BIGINT, @class101B_id BIGINT, @class201A_id BIGINT, @class301A_id BIGINT;
SELECT @class101A_id = id FROM dbo.Class WHERE class_name = '101A';
SELECT @class101B_id = id FROM dbo.Class WHERE class_name = '101B';
SELECT @class201A_id = id FROM dbo.Class WHERE class_name = '201A';
SELECT @class301A_id = id FROM dbo.Class WHERE class_name = '301A';

-- Inserting Sessions
INSERT INTO dbo.Session (session_no, from_date, to_date, status_id, Note) VALUES
(1, '2024-09-01', '2025-01-31', @active_status_id, 'Fall Semester 2024-2025'),
(2, '2025-02-01', '2025-06-30', @active_status_id, 'Spring Semester 2025'),
(3, '2023-09-01', '2024-06-30', @completed_status_id, 'Academic Year 2023-2024');

DECLARE @session1_id BIGINT, @session2_id BIGINT, @session3_id BIGINT;
SELECT @session1_id = id FROM dbo.Session WHERE session_no = 1 AND YEAR(from_date) = 2024;
SELECT @session2_id = id FROM dbo.Session WHERE session_no = 2 AND YEAR(from_date) = 2025;
SELECT @session3_id = id FROM dbo.Session WHERE session_no = 3 AND YEAR(from_date) = 2023;


-- Inserting Project Data
INSERT INTO dbo.Project (name_ar, name_en, date_of_creation, project_description, status_id, Supervisor_account_ID) VALUES
(N'مشروع الطاقة الشمسية', 'Solar Energy Project', GETDATE(), 'A project focusing on renewable solar energy solutions for schools.', @active_status_id, @capsup1_id),
(N'تطبيق إدارة الطلاب', 'Student Management Application', GETDATE(), 'Develop a mobile application for student attendance and grade tracking.', @active_status_id, @capsup1_id),
(N'نظام الري الذكي', 'Smart Irrigation System', GETDATE(), 'An IoT-based system to optimize water usage for school gardens.', @pending_status_id, @reviewer1_id);

DECLARE @project1_id BIGINT, @project2_id BIGINT, @project3_id BIGINT;
SELECT @project1_id = id FROM dbo.Project WHERE name_en = 'Solar Energy Project';
SELECT @project2_id = id FROM dbo.Project WHERE name_en = 'Student Management Application';
SELECT @project3_id = id FROM dbo.Project WHERE name_en = 'Smart Irrigation System';

-- Inserting Team Data
INSERT INTO dbo.Team (team_name, team_leader_account_id, class_id, supervisor_account_id, project_id, status_id) VALUES
('Innovators', NULL, @class101A_id, @capsup1_id, @project1_id, @active_status_id),
('Problem Solvers', NULL, @class101A_id, @capsup1_id, @project2_id, @active_status_id),
('Dream Team', NULL, @class201A_id, @reviewer1_id, @project3_id, @active_status_id);

DECLARE @team1_id BIGINT, @team2_id BIGINT, @team3_id BIGINT;
SELECT @team1_id = id FROM dbo.Team WHERE team_name = 'Innovators';
SELECT @team2_id = id FROM dbo.Team WHERE team_name = 'Problem Solvers';
SELECT @team3_id = id FROM dbo.Team WHERE team_name = 'Dream Team';

-- Inserting Student Accounts
INSERT INTO dbo.Account (national_id, password_hash, email, account_type_id, full_name_EN, full_name_AR, is_active, status_id) VALUES
('12345678901242', 'hashedstudentpass1', 'omar.ahmed@student.edu', @student_type_id, 'Omar Ahmed Mohamed', N'عمر أحمد محمد', 1, @active_status_id),
('12345678901243', 'hashedstudentpass2', 'layla.ali@student.edu', @student_type_id, 'Layla Ali Hassan', N'ليلى علي حسن', 1, @active_status_id),
('12345678901244', 'hashedstudentpass3', 'mohamed.hassan@student.edu', @student_type_id, 'Mohamed Hassan Abdullah', N'محمد حسن عبدالله', 1, @active_status_id),
('12345678901245', 'hashedstudentpass4', 'fatima.omar@student.edu', @student_type_id, 'Fatima Omar Said', N'فاطمة عمر سعيد', 1, @active_status_id);

DECLARE @student1_id BIGINT, @student2_id BIGINT, @student3_id BIGINT, @student4_id BIGINT;
SELECT @student1_id = id FROM dbo.Account WHERE email = 'omar.ahmed@student.edu';
SELECT @student2_id = id FROM dbo.Account WHERE email = 'layla.ali@student.edu';
SELECT @student3_id = id FROM dbo.Account WHERE email = 'mohamed.hassan@student.edu';
SELECT @student4_id = id FROM dbo.Account WHERE email = 'fatima.omar@student.edu';

-- Inserting Student Extension Data
INSERT INTO dbo.Student_Extension (account_id, is_leader, class_id, status_id) VALUES
(@student1_id, 1, @class101A_id, @active_status_id),
(@student2_id, 0, @class101A_id, @active_status_id),
(@student3_id, 1, @class101A_id, @active_status_id),
(@student4_id, 0, @class201A_id, @active_status_id);

-- Update team leaders after Student_Extension is populated
UPDATE dbo.Team SET team_leader_account_id = @student1_id WHERE id = @team1_id;
UPDATE dbo.Team SET team_leader_account_id = @student3_id WHERE id = @team2_id;

-- Inserting Team Member Data
INSERT INTO dbo.Team_Member (team_id, team_member_account_id, team_member_description, status_id) VALUES
(@team1_id, @student1_id, 'Leader', @active_status_id),
(@team1_id, @student2_id, 'Developer', @active_status_id),
(@team2_id, @student3_id, 'Leader', @active_status_id);

-- Inserting Reviewer/Supervisor Extension
INSERT INTO dbo.Reviewer_Supervisor_Extension (account_id, assigned_class_id, status_id) VALUES
(@reviewer1_id, @class101A_id, @active_status_id);

-- Inserting Capstone Supervisor Extension
INSERT INTO dbo.Capstone_Supervisor_Extension (account_id, status_id) VALUES
(@capsup1_id, @active_status_id);


-- Inserting Task Data (now linked to grade and admin)
INSERT INTO dbo.Task (task_name, task_description, task_deadline, github_link, grade_id, admin_account_id, status_id) VALUES
('Math Assignment 1', 'Solve problems from Chapter 3.', '2024-07-25 23:59:59', NULL, @first_secondary_grade_id, @admin1_id, @active_status_id),
('Science Project Proposal', 'Submit a proposal for your science fair project.', '2024-08-10 17:00:00', 'https://github.com/school/science-project-templates', @first_secondary_grade_id, @admin1_id, @active_status_id),
('History Research Paper', 'Write a research paper on Ancient Egypt.', '2024-09-01 23:59:59', NULL, @second_secondary_grade_id, @admin2_id, @active_status_id),
('Capstone Project - Phase 1', 'Define project scope and initial requirements.', '2024-09-15 23:59:59', NULL, @third_secondary_grade_id, @admin1_id, @active_status_id);

DECLARE @task1_id BIGINT, @task2_id BIGINT, @task3_id BIGINT, @task4_id BIGINT;
SELECT @task1_id = id FROM dbo.Task WHERE task_name = 'Math Assignment 1';
SELECT @task2_id = id FROM dbo.Task WHERE task_name = 'Science Project Proposal';
SELECT @task3_id = id FROM dbo.Task WHERE task_name = 'History Research Paper';
SELECT @task4_id = id FROM dbo.Task WHERE task_name = 'Capstone Project - Phase 1';


-- Inserting Student Task Data
INSERT INTO dbo.Student_Task (student_account_id, task_id, is_completed, completed_at, status_id) VALUES
(@student1_id, @task1_id, 1, GETDATE(), @completed_status_id),
(@student1_id, @task2_id, 0, NULL, @pending_status_id),
(@student2_id, @task1_id, 0, NULL, @pending_status_id),
(@student3_id, @task3_id, 1, GETDATE(), @completed_status_id),
(@student4_id, @task4_id, 0, NULL, @pending_status_id);


-- Inserting Report Data
INSERT INTO dbo.Report (title, submission_date, report_message, submitter_account_id, status_id) VALUES
('Bug Report - Login Page', GETDATE(), 'The login page redirects to a blank screen after successful login.', @student1_id, @pending_status_id),
('Feature Request - Grade Calculator', GETDATE(), 'Requesting a built-in grade calculator for students to track their progress.', @student2_id, @pending_status_id),
('Complaint - Course Material', GETDATE(), 'Some course materials are outdated and contain broken links.', @teacher1_id, @pending_status_id);

-- Inserting Subordinate Ticket Data
INSERT INTO dbo.Subordinate_Ticket (supervisor_account_id, grade_id, class_id, session_id, subordinate_account_id, ticket_type_id, status_id) VALUES
(@teacher1_id, @first_secondary_grade_id, @class101A_id, @session1_id, @student1_id, @late_ticket_type_id, @new_status_id),
(@teacher2_id, @first_secondary_grade_id, @class101B_id, @session1_id, @student2_id, @absence_ticket_type_id, @new_status_id),
(@it1_id, NULL, NULL, NULL, @teacher1_id, @technical_issue_ticket_type_id, @resolved_status_id);

-- Inserting Scholarship Data
INSERT INTO dbo.Scholarship (scholarship_name, amount, provider_name, start_date, end_date, status_id) VALUES
('Academic Excellence Scholarship', 5000.00, 'Elsewedy Foundation', '2024-09-01', '2025-08-31', @active_status_id),
('Innovation Grant', 2500.00, 'Tech Solutions Inc.', '2025-01-01', '2025-12-31', @active_status_id);

-- Inserting Email Settings Data (dummy values)
INSERT INTO dbo.Email_Settings (smtp_server, smtp_port, smtp_username, smtp_password, sender_email) VALUES
('smtp.schoolmail.com', 587, 'noreply@school.edu', 'YourSecureEmailPass', 'noreply@school.edu');

-- Inserting Dummy Data for Admission_Profile
INSERT INTO dbo.Admission_Profile (
    account_id, DateOfBirth, Location, PhoneNumber,
    SoftwareInterviewScore, MathInterviewScore, EnglishInterviewScore, ArabicInterviewScore,
    StudentName, MathScore, EnglishScore, ThirdPrepScore, IsAcceptanceLetterReceived, status_id
) VALUES
(
    @student1_id, '2008-05-15', 'Cairo, Egypt', '01012345678',
    85.50, 92.00, 88.75, 90.00,
    'Omar Ahmed Mohamed', 90.50, 87.00, 93.25, 1, @active_status_id
),
(
    @student2_id, '2009-01-20', 'Giza, Egypt', '01198765432',
    78.00, 85.50, 82.00, 88.50,
    'Layla Ali Hassan', 80.00, 85.00, 89.00, 0, @active_status_id
);


PRINT 'Dummy data insertion complete.';
GO

-- =====================================================
-- SQL Server Data Retrieval Queries
-- These queries retrieve all data from each table for verification.
-- =====================================================

PRINT 'Retrieving data from all tables...';

SELECT * FROM dbo.Status;
SELECT * FROM dbo.Account_Type; -- Corrected from Account_Type_Lookup
SELECT * FROM dbo.Ticket_Type_Lookup;
SELECT * FROM dbo.Grade;
SELECT * FROM dbo.Class;
SELECT * FROM dbo.Session;
SELECT * FROM dbo.Account;
SELECT * FROM dbo.Email_Settings;
SELECT * FROM dbo.Project;
SELECT * FROM dbo.Team;
SELECT * FROM dbo.Team_Member;
SELECT * FROM dbo.Scholarship;
SELECT * FROM dbo.Task;
SELECT * FROM dbo.Student_Task;
SELECT * FROM dbo.Report;
SELECT * FROM dbo.Subordinate_Ticket;
SELECT * FROM dbo.Student_Extension;
SELECT * FROM dbo.Reviewer_Supervisor_Extension;
SELECT * FROM dbo.Capstone_Supervisor_Extension;
SELECT * FROM dbo.Super_Admin_Extension;
SELECT * FROM dbo.Admission_Profile;

PRINT 'All data retrieval queries executed.';
GO