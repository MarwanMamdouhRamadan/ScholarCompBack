using System;
using System.Collections.Generic;
using Microsoft.EntityFrameworkCore;

namespace ScholarComp.Models;

public partial class AppDbContext : DbContext
{
    public AppDbContext()
    {
    }

    public AppDbContext(DbContextOptions<AppDbContext> options)
        : base(options)
    {
    }

    public virtual DbSet<Account> Accounts { get; set; }

    public virtual DbSet<AccountType> AccountTypes { get; set; }

    public virtual DbSet<AdmissionProfile> AdmissionProfiles { get; set; }

    public virtual DbSet<CapstoneSupervisorExtension> CapstoneSupervisorExtensions { get; set; }

    public virtual DbSet<Class> Classes { get; set; }

    public virtual DbSet<EmailSetting> EmailSettings { get; set; }

    public virtual DbSet<Grade> Grades { get; set; }

    public virtual DbSet<Project> Projects { get; set; }

    public virtual DbSet<Report> Reports { get; set; }

    public virtual DbSet<ReviewerSupervisorExtension> ReviewerSupervisorExtensions { get; set; }

    public virtual DbSet<Scholarship> Scholarships { get; set; }

    public virtual DbSet<Session> Sessions { get; set; }

    public virtual DbSet<Status> Statuses { get; set; }

    public virtual DbSet<StudentExtension> StudentExtensions { get; set; }

    public virtual DbSet<StudentTask> StudentTasks { get; set; }

    public virtual DbSet<SubordinateTicket> SubordinateTickets { get; set; }

    public virtual DbSet<SuperAdminExtension> SuperAdminExtensions { get; set; }

    public virtual DbSet<Task> Tasks { get; set; }

    public virtual DbSet<Team> Teams { get; set; }

    public virtual DbSet<TeamMember> TeamMembers { get; set; }

    public virtual DbSet<TicketTypeLookup> TicketTypeLookups { get; set; }

    protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
#warning To protect potentially sensitive information in your connection string, you should move it out of source code. You can avoid scaffolding the connection string by using the Name= syntax to read it from configuration - see https://go.microsoft.com/fwlink/?linkid=2131148. For more guidance on storing connection strings, see https://go.microsoft.com/fwlink/?LinkId=723263.
        => optionsBuilder.UseSqlServer("Server=.;Database=ElsewedySchoolSys;Trusted_Connection=True;TrustServerCertificate=True;");

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.UseCollation("Arabic_100_CI_AI");

        modelBuilder.Entity<Account>(entity =>
        {
            entity.ToTable("Account");

            entity.HasIndex(e => e.NationalId, "UQ__Account__9560E95D86D7D2F7").IsUnique();

            entity.HasIndex(e => e.Email, "UQ__Account__AB6E6164ABD47A49").IsUnique();

            entity.Property(e => e.Id).HasColumnName("id");
            entity.Property(e => e.AccountTypeId).HasColumnName("account_type_id");
            entity.Property(e => e.Email)
                .HasMaxLength(255)
                .HasColumnName("email");
            entity.Property(e => e.FullNameAr).HasColumnName("full_name_AR");
            entity.Property(e => e.FullNameEn).HasColumnName("full_name_EN");
            entity.Property(e => e.IsActive)
                .HasDefaultValue(true)
                .HasColumnName("is_active");
            entity.Property(e => e.NationalId)
                .HasMaxLength(14)
                .HasColumnName("national_id");
            entity.Property(e => e.PasswordHash).HasColumnName("password_hash");
            entity.Property(e => e.ResetToken).HasColumnName("reset_token");
            entity.Property(e => e.ResetTokenExpiry).HasColumnName("reset_token_expiry");
            entity.Property(e => e.StatusId)
                .HasDefaultValue(1L)
                .HasColumnName("status_id");
        });

        modelBuilder.Entity<AccountType>(entity =>
        {
            entity.ToTable("Account_Type");

            entity.HasIndex(e => e.AccountTypeTxt, "UQ__Account___4BA1713501FC6117").IsUnique();

            entity.Property(e => e.Id).HasColumnName("id");
            entity.Property(e => e.AccountTypeTxt)
                .HasMaxLength(100)
                .HasColumnName("Account_type_TXT");
        });

        modelBuilder.Entity<AdmissionProfile>(entity =>
        {
            entity.HasKey(e => e.AccountId);

            entity.ToTable("Admission_Profile");

            entity.Property(e => e.AccountId)
                .ValueGeneratedNever()
                .HasColumnName("account_id");
            entity.Property(e => e.ArabicInterviewScore).HasColumnType("decimal(5, 2)");
            entity.Property(e => e.EnglishInterviewScore).HasColumnType("decimal(5, 2)");
            entity.Property(e => e.EnglishScore).HasColumnType("decimal(5, 2)");
            entity.Property(e => e.MathInterviewScore).HasColumnType("decimal(5, 2)");
            entity.Property(e => e.MathScore).HasColumnType("decimal(5, 2)");
            entity.Property(e => e.PhoneNumber).HasMaxLength(20);
            entity.Property(e => e.SoftwareInterviewScore).HasColumnType("decimal(5, 2)");
            entity.Property(e => e.StatusId)
                .HasDefaultValue(1L)
                .HasColumnName("status_id");
            entity.Property(e => e.ThirdPrepScore).HasColumnType("decimal(5, 2)");
        });

        modelBuilder.Entity<CapstoneSupervisorExtension>(entity =>
        {
            entity.HasKey(e => e.AccountId);

            entity.ToTable("Capstone_Supervisor_Extension");

            entity.Property(e => e.AccountId)
                .ValueGeneratedNever()
                .HasColumnName("account_id");
            entity.Property(e => e.StatusId)
                .HasDefaultValue(1L)
                .HasColumnName("status_id");
        });

        modelBuilder.Entity<Class>(entity =>
        {
            entity.ToTable("Class");

            entity.Property(e => e.Id).HasColumnName("id");
            entity.Property(e => e.ClassName)
                .HasMaxLength(100)
                .HasColumnName("class_name");
            entity.Property(e => e.GradeId).HasColumnName("grade_id");
            entity.Property(e => e.StatusId)
                .HasDefaultValue(1L)
                .HasColumnName("status_id");
        });

        modelBuilder.Entity<EmailSetting>(entity =>
        {
            entity
                .HasNoKey()
                .ToTable("Email_Settings");

            entity.Property(e => e.SenderEmail)
                .HasMaxLength(255)
                .HasColumnName("sender_email");
            entity.Property(e => e.SmtpPassword)
                .HasMaxLength(255)
                .HasColumnName("smtp_password");
            entity.Property(e => e.SmtpPort).HasColumnName("smtp_port");
            entity.Property(e => e.SmtpServer)
                .HasMaxLength(255)
                .HasColumnName("smtp_server");
            entity.Property(e => e.SmtpUsername)
                .HasMaxLength(255)
                .HasColumnName("smtp_username");
        });

        modelBuilder.Entity<Grade>(entity =>
        {
            entity.ToTable("Grade");

            entity.Property(e => e.Id).HasColumnName("id");
            entity.Property(e => e.AdminAccountId).HasColumnName("admin_account_id");
            entity.Property(e => e.GradeName)
                .HasMaxLength(100)
                .HasColumnName("grade_name");
            entity.Property(e => e.ParentGradeId).HasColumnName("parent_grade_id");
            entity.Property(e => e.StatusId)
                .HasDefaultValue(1L)
                .HasColumnName("status_id");
        });

        modelBuilder.Entity<Project>(entity =>
        {
            entity.ToTable("Project");

            entity.Property(e => e.Id).HasColumnName("id");
            entity.Property(e => e.DateOfCreation)
                .HasDefaultValueSql("(getdate())")
                .HasColumnName("date_of_creation");
            entity.Property(e => e.NameAr).HasColumnName("name_ar");
            entity.Property(e => e.NameEn).HasColumnName("name_en");
            entity.Property(e => e.ProjectDescription).HasColumnName("project_description");
            entity.Property(e => e.StatusId)
                .HasDefaultValue(1L)
                .HasColumnName("status_id");
            entity.Property(e => e.SupervisorAccountId).HasColumnName("Supervisor_account_ID");
        });

        modelBuilder.Entity<Report>(entity =>
        {
            entity.ToTable("Report");

            entity.Property(e => e.Id).HasColumnName("id");
            entity.Property(e => e.ReportMessage).HasColumnName("report_message");
            entity.Property(e => e.StatusId)
                .HasDefaultValue(1L)
                .HasColumnName("status_id");
            entity.Property(e => e.SubmissionDate)
                .HasDefaultValueSql("(getdate())")
                .HasColumnType("datetime")
                .HasColumnName("submission_date");
            entity.Property(e => e.SubmitterAccountId).HasColumnName("submitter_account_id");
            entity.Property(e => e.Title).HasColumnName("title");
        });

        modelBuilder.Entity<ReviewerSupervisorExtension>(entity =>
        {
            entity.HasKey(e => e.AccountId);

            entity.ToTable("Reviewer_Supervisor_Extension");

            entity.Property(e => e.AccountId)
                .ValueGeneratedNever()
                .HasColumnName("account_id");
            entity.Property(e => e.AssignedClassId).HasColumnName("assigned_class_id");
            entity.Property(e => e.StatusId)
                .HasDefaultValue(1L)
                .HasColumnName("status_id");
        });

        modelBuilder.Entity<Scholarship>(entity =>
        {
            entity.ToTable("Scholarship");

            entity.Property(e => e.Id).HasColumnName("id");
            entity.Property(e => e.Amount)
                .HasColumnType("money")
                .HasColumnName("amount");
            entity.Property(e => e.EndDate).HasColumnName("end_date");
            entity.Property(e => e.ProviderName).HasColumnName("provider_name");
            entity.Property(e => e.ScholarshipName).HasColumnName("scholarship_name");
            entity.Property(e => e.StartDate).HasColumnName("start_date");
            entity.Property(e => e.StatusId)
                .HasDefaultValue(1L)
                .HasColumnName("status_id");
        });

        modelBuilder.Entity<Session>(entity =>
        {
            entity.ToTable("Session");

            entity.Property(e => e.Id).HasColumnName("id");
            entity.Property(e => e.FromDate).HasColumnName("from_date");
            entity.Property(e => e.SessionNo).HasColumnName("session_no");
            entity.Property(e => e.StatusId)
                .HasDefaultValue(1L)
                .HasColumnName("status_id");
            entity.Property(e => e.ToDate).HasColumnName("to_date");
        });

        modelBuilder.Entity<Status>(entity =>
        {
            entity.ToTable("Status");

            entity.Property(e => e.Id).HasColumnName("id");
            entity.Property(e => e.BusinessEntity).HasColumnName("business_entity");
            entity.Property(e => e.StatusName).HasColumnName("status_name");
        });

        modelBuilder.Entity<StudentExtension>(entity =>
        {
            entity.HasKey(e => e.AccountId);

            entity.ToTable("Student_Extension");

            entity.Property(e => e.AccountId)
                .ValueGeneratedNever()
                .HasColumnName("account_id");
            entity.Property(e => e.ClassId).HasColumnName("class_id");
            entity.Property(e => e.IsLeader).HasColumnName("is_leader");
            entity.Property(e => e.StatusId)
                .HasDefaultValue(1L)
                .HasColumnName("status_id");
        });

        modelBuilder.Entity<StudentTask>(entity =>
        {
            entity.ToTable("Student_Task");

            entity.Property(e => e.Id).HasColumnName("id");
            entity.Property(e => e.CompletedAt)
                .HasColumnType("datetime")
                .HasColumnName("completed_at");
            entity.Property(e => e.IsCompleted).HasColumnName("is_completed");
            entity.Property(e => e.StatusId)
                .HasDefaultValue(1L)
                .HasColumnName("status_id");
            entity.Property(e => e.StudentAccountId).HasColumnName("student_account_id");
            entity.Property(e => e.TaskId).HasColumnName("task_id");
        });

        modelBuilder.Entity<SubordinateTicket>(entity =>
        {
            entity.ToTable("Subordinate_Ticket");

            entity.Property(e => e.Id).HasColumnName("id");
            entity.Property(e => e.ClassId).HasColumnName("class_id");
            entity.Property(e => e.GradeId).HasColumnName("grade_id");
            entity.Property(e => e.SessionId).HasColumnName("session_id");
            entity.Property(e => e.StatusId)
                .HasDefaultValue(1L)
                .HasColumnName("status_id");
            entity.Property(e => e.SubordinateAccountId).HasColumnName("subordinate_account_id");
            entity.Property(e => e.SupervisorAccountId).HasColumnName("supervisor_account_id");
            entity.Property(e => e.TicketTypeId).HasColumnName("ticket_type_id");
        });

        modelBuilder.Entity<SuperAdminExtension>(entity =>
        {
            entity.HasKey(e => e.AccountId);

            entity.ToTable("Super_Admin_Extension");

            entity.Property(e => e.AccountId)
                .ValueGeneratedNever()
                .HasColumnName("account_id");
            entity.Property(e => e.StatusId)
                .HasDefaultValue(1L)
                .HasColumnName("status_id");
        });

        modelBuilder.Entity<Task>(entity =>
        {
            entity.ToTable("Task");

            entity.Property(e => e.Id).HasColumnName("id");
            entity.Property(e => e.AdminAccountId).HasColumnName("admin_account_id");
            entity.Property(e => e.GithubLink).HasColumnName("github_link");
            entity.Property(e => e.GradeId).HasColumnName("grade_id");
            entity.Property(e => e.StatusId)
                .HasDefaultValue(1L)
                .HasColumnName("status_id");
            entity.Property(e => e.TaskDeadline)
                .HasColumnType("datetime")
                .HasColumnName("task_deadline");
            entity.Property(e => e.TaskDescription).HasColumnName("task_description");
            entity.Property(e => e.TaskName).HasColumnName("task_name");
        });

        modelBuilder.Entity<Team>(entity =>
        {
            entity.ToTable("Team");

            entity.Property(e => e.Id).HasColumnName("id");
            entity.Property(e => e.ClassId).HasColumnName("class_id");
            entity.Property(e => e.ProjectId).HasColumnName("project_id");
            entity.Property(e => e.StatusId)
                .HasDefaultValue(1L)
                .HasColumnName("status_id");
            entity.Property(e => e.SupervisorAccountId).HasColumnName("supervisor_account_id");
            entity.Property(e => e.TeamLeaderAccountId).HasColumnName("team_leader_account_id");
            entity.Property(e => e.TeamName)
                .HasMaxLength(100)
                .HasColumnName("team_name");
        });

        modelBuilder.Entity<TeamMember>(entity =>
        {
            entity.ToTable("Team_Member");

            entity.Property(e => e.Id).HasColumnName("id");
            entity.Property(e => e.StatusId)
                .HasDefaultValue(1L)
                .HasColumnName("status_id");
            entity.Property(e => e.TeamId).HasColumnName("team_id");
            entity.Property(e => e.TeamMemberAccountId).HasColumnName("team_member_account_id");
            entity.Property(e => e.TeamMemberDescription).HasColumnName("team_member_description");
        });

        modelBuilder.Entity<TicketTypeLookup>(entity =>
        {
            entity.ToTable("Ticket_Type_Lookup");

            entity.Property(e => e.Id).HasColumnName("id");
            entity.Property(e => e.BusinessEntity)
                .HasMaxLength(90)
                .HasColumnName("business_entity");
            entity.Property(e => e.OrderNo).HasColumnName("order_no");
            entity.Property(e => e.StatusId)
                .HasDefaultValue(1L)
                .HasColumnName("status_id");
            entity.Property(e => e.TicketTypeName)
                .HasMaxLength(100)
                .HasColumnName("ticket_type_name");
        });

        OnModelCreatingPartial(modelBuilder);
    }

    partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
}
