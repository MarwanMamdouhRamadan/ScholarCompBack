# 📘 ElsewedySchoolSys Database

This repository contains a full SQL script for creating the **ElsewedySchoolSys** database – a comprehensive school management system designed to handle accounts, classes, sessions, academic tasks, student progress, and more.  
The schema is built with **modularity**, **soft deletion**, and **multi-role support** in mind.

---

## 📌 Features

- Soft Delete via `is_deleted` and `deleted_at`
- Auditing fields: `created_at`, `updated_at`, `deleted_by`
- Role-based account structure (Students, Teachers, Admins, etc.)
- Foreign key constraints for strict relational integrity
- Dummy seed data for testing

---

## 🧱 Database Tables Overview

| Table Name        | Description |
|------------------|-------------|
| `Account`         | Main account table with shared fields across roles |
| `Login`           | Handles authentication credentials (email, password) |
| `Grade`           | Defines grade levels (e.g., Grade 10, 11, etc.) |
| `Class`           | Represents school classes, each linked to a grade |
| `Session`         | School sessions/semesters (e.g., 2024 Spring) |
| `Project`         | Capstone or team-based student projects |
| `Task`            | Tasks related to projects and phases |
| `StudentTask`     | Mapping between student and task (progress tracking) |
| `StudentPhase`    | Tracks student progress across project phases |
| `Report`          | Holds submitted reports and links to team/supervisor |

---

## 📂 Table Details

### 🔐 `Account`
Holds general info for all types of users.

| Column         | Type       | Description                           |
|----------------|------------|---------------------------------------|
| `id`           | `BIGINT`   | Primary Key                           |
| `username`     | `VARCHAR`  | Unique user handle                    |
| `full_name`    | `VARCHAR`  | Full name of the person               |
| `email`        | `VARCHAR`  | Email address                         |
| `role`         | `VARCHAR`  | `student`, `teacher`, `admin`, etc.  |
| `country_code` | `VARCHAR`  | Phone country code (e.g., +20)        |
| `status_id`    | `INT`      | User status (1 = active, 0 = inactive)|
| `created_at`   | `DATETIME` | Record creation date                  |
| `updated_at`   | `DATETIME` | Record last updated                   |
| `deleted_at`   | `DATETIME` | When deleted (soft delete)           |
| `is_deleted`   | `BIT`      | Soft delete flag (0 = active, 1 = deleted) |

---

### 🔐 `Login`
Stores authentication data.

| Column      | Type      | Description                      |
|-------------|-----------|----------------------------------|
| `id`        | `BIGINT`  | Primary Key                      |
| `account_id`| `BIGINT`  | Foreign Key → `Account(id)`      |
| `email`     | `VARCHAR` | Used for login                   |
| `password`  | `VARCHAR` | Hashed password                  |

---

### 🏫 `Grade`
Represents academic levels.

| Column      | Type      | Description          |
|-------------|-----------|----------------------|
| `id`        | `BIGINT`  | Primary Key          |
| `name`      | `VARCHAR` | Grade title (e.g. G11)|
| `status_id` | `INT`     | Soft delete/status   |
| `created_at`, etc.| ...| Same as above        |

---

### 🏫 `Class`
Defines a class inside a grade.

| Column      | Type      | Description                      |
|-------------|-----------|----------------------------------|
| `id`        | `BIGINT`  | Primary Key                      |
| `grade_id`  | `BIGINT`  | Foreign Key → `Grade(id)`        |
| `name`      | `VARCHAR` | Class name (e.g., "11A")         |

---

### 📅 `Session`
Timeframe like a semester.

| Column      | Type      | Description                  |
|-------------|-----------|------------------------------|
| `id`        | `BIGINT`  | Primary Key                  |
| `name`      | `VARCHAR` | e.g., "Spring 2025"          |
| `start_date`| `DATE`    | Start of session             |
| `end_date`  | `DATE`    | End of session               |

---

### 🚀 `Project`
Student team project (like capstone).

| Column      | Type      | Description                     |
|-------------|-----------|---------------------------------|
| `id`        | `BIGINT`  | Primary Key                     |
| `class_id`  | `BIGINT`  | FK to Class                     |
| `team_name` | `VARCHAR` | Project/Team name               |

---

### 📌 `Task`
Assigned task to teams or students.

| Column      | Type      | Description              |
|-------------|-----------|--------------------------|
| `id`        | `BIGINT`  | Primary Key              |
| `title`     | `VARCHAR` | Task title               |
| `description`| `TEXT`   | Detailed instructions    |
| `due_date`  | `DATE`    | Deadline                 |

---

### ✅ `StudentTask`
Tracks which student got which task and progress.

| Column        | Type      | Description                        |
|---------------|-----------|------------------------------------|
| `student_id`  | `BIGINT`  | FK → Account.id                    |
| `task_id`     | `BIGINT`  | FK → Task.id                       |
| `status`      | `VARCHAR` | e.g., "Not Started", "Done"        |

---

### ⏳ `StudentPhase`
Phase-level progress for each student.

| Column        | Type      | Description                  |
|---------------|-----------|------------------------------|
| `student_id`  | `BIGINT`  | FK to Account                |
| `phase_name`  | `VARCHAR` | e.g., "Research", "Coding"   |
| `progress`    | `INT`     | % completion (0–100)         |

---

### 📄 `Report`
Project progress reports.

| Column        | Type      | Description                  |
|---------------|-----------|------------------------------|
| `id`          | `BIGINT`  | PK                           |
| `team_id`     | `BIGINT`  | FK to `Project`              |
| `supervisor_id`| `BIGINT` | Reviewer                     |
| `content`     | `TEXT`    | Full report body             |

---

## 🔧 How to Use

1. Run the SQL file in **SQL Server Management Studio** or **Azure Data Studio**
2. Make sure you are using the `ElsewedySchoolSys` database context
3. Insert dummy records using the bottom section of the script
4. Query the `Account`, `Task`, or `StudentTask` tables for examples

---

## 📌 Notes

- Soft Delete is used to avoid physical deletion
- `status_id` is a flexible way to manage entity states (active/inactive/etc.)
- The system can be extended to include:
  - Teacher schedules
  - Admin dashboards
  - Automated reports

---

## 📥 Sample Dummy Queries

```sql
SELECT * FROM Account WHERE role = 'student' AND is_deleted = 0;
SELECT * FROM Task WHERE due_date > GETDATE();
