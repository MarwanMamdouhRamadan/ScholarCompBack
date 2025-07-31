using System;
using System.Collections.Generic;
using Microsoft.EntityFrameworkCore;

namespace ScholarComp.Models;

public partial class ElsewedySchoolSysContext : DbContext
{
    public ElsewedySchoolSysContext()
    {
    }

    public ElsewedySchoolSysContext(DbContextOptions<ElsewedySchoolSysContext> options)
        : base(options)
    {
    }

    public virtual DbSet<Account> Accounts { get; set; }

    public virtual DbSet<AccountType> AccountTypes { get; set; }

    public virtual DbSet<Achievement> Achievements { get; set; }

    public virtual DbSet<AdmissionProfile> AdmissionProfiles { get; set; }

    public virtual DbSet<CapstoneSupervisorExtension> CapstoneSupervisorExtensions { get; set; }

    public virtual DbSet<Class> Classes { get; set; }

    public virtual DbSet<EmailSetting> EmailSettings { get; set; }

    public virtual DbSet<EmploymentRequest> EmploymentRequests { get; set; }

    public virtual DbSet<Grade> Grades { get; set; }

    public virtual DbSet<Login> Logins { get; set; }

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

    public virtual DbSet<TicketType> TicketTypes { get; set; }

    protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
#warning To protect potentially sensitive information in your connection string, you should move it out of source code. You can avoid scaffolding the connection string by using the Name= syntax to read it from configuration - see https://go.microsoft.com/fwlink/?linkid=2131148. For more guidance on storing connection strings, see https://go.microsoft.com/fwlink/?LinkId=723263.
        => optionsBuilder.UseSqlServer("Server=.;Database=ElsewedySchoolSys;Trusted_Connection=True;TrustServerCertificate=True;");

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.UseCollation("Arabic_100_CI_AI");

        modelBuilder.Entity<Account>(entity =>
        {
            entity.ToTable("Account");

            entity.HasIndex(e => e.Email, "UQ__Account__A9D105349AB0C27F").IsUnique();

            entity.HasIndex(e => e.NationalId, "UQ__Account__E9AA32FA1F7A353B").IsUnique();

            entity.Property(e => e.Email).HasMaxLength(100);
            entity.Property(e => e.FullNameAr).HasColumnName("FullNameAR");
            entity.Property(e => e.FullNameEn).HasColumnName("FullNameEN");
            entity.Property(e => e.IsActive).HasDefaultValue(true);
            entity.Property(e => e.NationalId).HasMaxLength(14);
            entity.Property(e => e.StatusId).HasDefaultValue(1L);

            entity.HasOne(d => d.AccountType).WithMany(p => p.Accounts)
                .HasForeignKey(d => d.AccountTypeId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Account_AccountType");

            entity.HasOne(d => d.Status).WithMany(p => p.Accounts)
                .HasForeignKey(d => d.StatusId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Account_Status");
        });

        modelBuilder.Entity<AccountType>(entity =>
        {
            entity.ToTable("AccountType");

            entity.HasIndex(e => e.AccountTypeName, "UQ__AccountT__602E1DF2FEFA5749").IsUnique();

            entity.Property(e => e.AccountTypeName).HasMaxLength(100);
        });

        modelBuilder.Entity<AdmissionProfile>(entity =>
        {
            entity.HasKey(e => e.AccountId);

            entity.ToTable("AdmissionProfile");

            entity.Property(e => e.AccountId).ValueGeneratedNever();
            entity.Property(e => e.ArabicInterviewScore).HasColumnType("decimal(5, 2)");
            entity.Property(e => e.EnglishInterviewScore).HasColumnType("decimal(5, 2)");
            entity.Property(e => e.EnglishScore).HasColumnType("decimal(5, 2)");
            entity.Property(e => e.MathInterviewScore).HasColumnType("decimal(5, 2)");
            entity.Property(e => e.MathScore).HasColumnType("decimal(5, 2)");
            entity.Property(e => e.PhoneNumber).HasMaxLength(20);
            entity.Property(e => e.SoftwareInterviewScore).HasColumnType("decimal(5, 2)");
            entity.Property(e => e.StatusId).HasDefaultValue(1L);
            entity.Property(e => e.ThirdPrepScore).HasColumnType("decimal(5, 2)");

            entity.HasOne(d => d.Account).WithOne(p => p.AdmissionProfile)
                .HasForeignKey<AdmissionProfile>(d => d.AccountId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_AdmissionProfile_Account");

            entity.HasOne(d => d.Status).WithMany(p => p.AdmissionProfiles)
                .HasForeignKey(d => d.StatusId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_AdmissionProfile_Status");
        });

        modelBuilder.Entity<CapstoneSupervisorExtension>(entity =>
        {
            entity.HasKey(e => e.AccountId);

            entity.ToTable("CapstoneSupervisorExtension");

            entity.Property(e => e.AccountId).ValueGeneratedNever();
            entity.Property(e => e.StatusId).HasDefaultValue(1L);

            entity.HasOne(d => d.Account).WithOne(p => p.CapstoneSupervisorExtension)
                .HasForeignKey<CapstoneSupervisorExtension>(d => d.AccountId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_CapstoneSupervisorExtension_Account");

            entity.HasOne(d => d.Status).WithMany(p => p.CapstoneSupervisorExtensions)
                .HasForeignKey(d => d.StatusId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_CapstoneSupervisorExtension_Status");
        });

        modelBuilder.Entity<Class>(entity =>
        {
            entity.ToTable("Class");

            entity.Property(e => e.StatusId).HasDefaultValue(1L);

            entity.HasOne(d => d.Grade).WithMany(p => p.Classes)
                .HasForeignKey(d => d.GradeId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Class_Grade");

            entity.HasOne(d => d.Status).WithMany(p => p.Classes)
                .HasForeignKey(d => d.StatusId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Class_Status");
        });

        modelBuilder.Entity<EmailSetting>(entity =>
        {
            entity.HasNoKey();
        });

        modelBuilder.Entity<EmploymentRequest>(entity =>
        {
            entity.Property(e => e.RequestDate).HasDefaultValueSql("(getdate())");
            entity.Property(e => e.StatusId).HasDefaultValue(1L);

            entity.HasOne(d => d.Status).WithMany(p => p.EmploymentRequests)
                .HasForeignKey(d => d.StatusId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_EmploymentRequests_Status");
        });

        modelBuilder.Entity<Grade>(entity =>
        {
            entity.ToTable("Grade");

            entity.Property(e => e.GradeName).HasMaxLength(100);
            entity.Property(e => e.StatusId).HasDefaultValue(1L);

            entity.HasOne(d => d.AdminAccount).WithMany(p => p.Grades)
                .HasForeignKey(d => d.AdminAccountId)
                .HasConstraintName("FK_Grade_AdminAccount");

            entity.HasOne(d => d.Status).WithMany(p => p.Grades)
                .HasForeignKey(d => d.StatusId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Grade_Status");
        });

        modelBuilder.Entity<Login>(entity =>
        {
            entity.ToTable("Login");

            entity.Property(e => e.Email).HasMaxLength(100);
            entity.Property(e => e.StatusId).HasDefaultValue(1L);

            entity.HasOne(d => d.Account).WithMany(p => p.Logins)
                .HasForeignKey(d => d.AccountId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Login_Account");

            entity.HasOne(d => d.Status).WithMany(p => p.Logins)
                .HasForeignKey(d => d.StatusId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Login_Status");
        });

        modelBuilder.Entity<Project>(entity =>
        {
            entity.ToTable("Project");

            entity.Property(e => e.CompanyName).HasDefaultValue("ELSEWEDY");
            entity.Property(e => e.DateOfCreation).HasDefaultValueSql("(getdate())");
            entity.Property(e => e.NameAr).HasColumnName("NameAR");
            entity.Property(e => e.NameEn).HasColumnName("NameEN");
            entity.Property(e => e.StatusId).HasDefaultValue(1L);

            entity.HasOne(d => d.Status).WithMany(p => p.Projects)
                .HasForeignKey(d => d.StatusId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Project_Status");

            entity.HasOne(d => d.SupervisorAccount).WithMany(p => p.Projects)
                .HasForeignKey(d => d.SupervisorAccountId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Project_SupervisorAccount");
        });

        modelBuilder.Entity<Report>(entity =>
        {
            entity.ToTable("Report");

            entity.Property(e => e.StatusId).HasDefaultValue(1L);
            entity.Property(e => e.SubmissionDate)
                .HasDefaultValueSql("(getdate())")
                .HasColumnType("datetime");

            entity.HasOne(d => d.Status).WithMany(p => p.Reports)
                .HasForeignKey(d => d.StatusId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Report_Status");

            entity.HasOne(d => d.SubmitterAccount).WithMany(p => p.Reports)
                .HasForeignKey(d => d.SubmitterAccountId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Report_SubmitterAccount");
        });

        modelBuilder.Entity<ReviewerSupervisorExtension>(entity =>
        {
            entity.HasKey(e => e.AccountId);

            entity.ToTable("ReviewerSupervisorExtension");

            entity.Property(e => e.AccountId).ValueGeneratedNever();
            entity.Property(e => e.StatusId).HasDefaultValue(1L);

            entity.HasOne(d => d.Account).WithOne(p => p.ReviewerSupervisorExtension)
                .HasForeignKey<ReviewerSupervisorExtension>(d => d.AccountId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_ReviewerSupervisorExtension_Account");

            entity.HasOne(d => d.AssignedClass).WithMany(p => p.ReviewerSupervisorExtensions)
                .HasForeignKey(d => d.AssignedClassId)
                .HasConstraintName("FK_ReviewerSupervisorExtension_Class");

            entity.HasOne(d => d.Status).WithMany(p => p.ReviewerSupervisorExtensions)
                .HasForeignKey(d => d.StatusId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_ReviewerSupervisorExtension_Status");
        });

        modelBuilder.Entity<Scholarship>(entity =>
        {
            entity.ToTable("Scholarship");

            entity.Property(e => e.Amount).HasColumnType("money");
            entity.Property(e => e.StatusId).HasDefaultValue(1L);

            entity.HasOne(d => d.Status).WithMany(p => p.Scholarships)
                .HasForeignKey(d => d.StatusId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Scholarship_Status");
        });

        modelBuilder.Entity<Session>(entity =>
        {
            entity.ToTable("Session");

            entity.Property(e => e.StatusId).HasDefaultValue(1L);

            entity.HasOne(d => d.Status).WithMany(p => p.Sessions)
                .HasForeignKey(d => d.StatusId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Session_Status");
        });

        modelBuilder.Entity<Status>(entity =>
        {
            entity.ToTable("Status");
        });

        modelBuilder.Entity<StudentExtension>(entity =>
        {
            entity.HasKey(e => e.AccountId);

            entity.ToTable("StudentExtension");

            entity.Property(e => e.AccountId).ValueGeneratedNever();
            entity.Property(e => e.StatusId).HasDefaultValue(1L);

            entity.HasOne(d => d.Account).WithOne(p => p.StudentExtension)
                .HasForeignKey<StudentExtension>(d => d.AccountId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_StudentExtension_Account");

            entity.HasOne(d => d.Class).WithMany(p => p.StudentExtensions)
                .HasForeignKey(d => d.ClassId)
                .HasConstraintName("FK_StudentExtension_Class");

            entity.HasOne(d => d.Status).WithMany(p => p.StudentExtensions)
                .HasForeignKey(d => d.StatusId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_StudentExtension_Status");
        });

        modelBuilder.Entity<StudentTask>(entity =>
        {
            entity.ToTable("StudentTask");

            entity.Property(e => e.CompletedAt).HasColumnType("datetime");
            entity.Property(e => e.StatusId).HasDefaultValue(1L);

            entity.HasOne(d => d.Status).WithMany(p => p.StudentTasks)
                .HasForeignKey(d => d.StatusId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_StudentTask_Status");

            entity.HasOne(d => d.StudentAccount).WithMany(p => p.StudentTasks)
                .HasForeignKey(d => d.StudentAccountId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_StudentTask_StudentAccount");

            entity.HasOne(d => d.Task).WithMany(p => p.StudentTasks)
                .HasForeignKey(d => d.TaskId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_StudentTask_Task");
        });

        modelBuilder.Entity<SubordinateTicket>(entity =>
        {
            entity.ToTable("SubordinateTicket");

            entity.Property(e => e.StatusId).HasDefaultValue(1L);

            entity.HasOne(d => d.Class).WithMany(p => p.SubordinateTickets)
                .HasForeignKey(d => d.ClassId)
                .HasConstraintName("FK_SubordinateTicket_Class");

            entity.HasOne(d => d.Grade).WithMany(p => p.SubordinateTickets)
                .HasForeignKey(d => d.GradeId)
                .HasConstraintName("FK_SubordinateTicket_Grade");

            entity.HasOne(d => d.Session).WithMany(p => p.SubordinateTickets)
                .HasForeignKey(d => d.SessionId)
                .HasConstraintName("FK_SubordinateTicket_Session");

            entity.HasOne(d => d.Status).WithMany(p => p.SubordinateTickets)
                .HasForeignKey(d => d.StatusId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_SubordinateTicket_Status");

            entity.HasOne(d => d.SubordinateAccount).WithMany(p => p.SubordinateTicketSubordinateAccounts)
                .HasForeignKey(d => d.SubordinateAccountId)
                .HasConstraintName("FK_SubordinateTicket_SubordinateAccount");

            entity.HasOne(d => d.SupervisorAccount).WithMany(p => p.SubordinateTicketSupervisorAccounts)
                .HasForeignKey(d => d.SupervisorAccountId)
                .HasConstraintName("FK_SubordinateTicket_SupervisorAccount");

            entity.HasOne(d => d.TicketType).WithMany(p => p.SubordinateTickets)
                .HasForeignKey(d => d.TicketTypeId)
                .HasConstraintName("FK_SubordinateTicket_TicketType");
        });

        modelBuilder.Entity<SuperAdminExtension>(entity =>
        {
            entity.HasKey(e => e.AccountId);

            entity.ToTable("SuperAdminExtension");

            entity.Property(e => e.AccountId).ValueGeneratedNever();
            entity.Property(e => e.StatusId).HasDefaultValue(1L);

            entity.HasOne(d => d.Account).WithOne(p => p.SuperAdminExtension)
                .HasForeignKey<SuperAdminExtension>(d => d.AccountId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_SuperAdminExtension_Account");

            entity.HasOne(d => d.Status).WithMany(p => p.SuperAdminExtensions)
                .HasForeignKey(d => d.StatusId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_SuperAdminExtension_Status");
        });

        modelBuilder.Entity<Task>(entity =>
        {
            entity.ToTable("Task");

            entity.Property(e => e.StatusId).HasDefaultValue(1L);
            entity.Property(e => e.TaskDeadline).HasColumnType("datetime");

            entity.HasOne(d => d.AdminAccount).WithMany(p => p.Tasks)
                .HasForeignKey(d => d.AdminAccountId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Task_AdminAccount");

            entity.HasOne(d => d.Grade).WithMany(p => p.Tasks)
                .HasForeignKey(d => d.GradeId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Task_Grade");

            entity.HasOne(d => d.Status).WithMany(p => p.Tasks)
                .HasForeignKey(d => d.StatusId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Task_Status");
        });

        modelBuilder.Entity<Team>(entity =>
        {
            entity.ToTable("Team");

            entity.Property(e => e.StatusId).HasDefaultValue(1L);

            entity.HasOne(d => d.Class).WithMany(p => p.Teams)
                .HasForeignKey(d => d.ClassId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Team_Class");

            entity.HasOne(d => d.Project).WithMany(p => p.Teams)
                .HasForeignKey(d => d.ProjectId)
                .HasConstraintName("FK_Team_Project");

            entity.HasOne(d => d.Status).WithMany(p => p.Teams)
                .HasForeignKey(d => d.StatusId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Team_Status");

            entity.HasOne(d => d.SupervisorAccount).WithMany(p => p.TeamSupervisorAccounts)
                .HasForeignKey(d => d.SupervisorAccountId)
                .HasConstraintName("FK_Team_SupervisorAccount");

            entity.HasOne(d => d.TeamLeaderAccount).WithMany(p => p.TeamTeamLeaderAccounts)
                .HasForeignKey(d => d.TeamLeaderAccountId)
                .HasConstraintName("FK_Team_TeamLeaderAccount");
        });

        modelBuilder.Entity<TeamMember>(entity =>
        {
            entity.ToTable("TeamMember");

            entity.Property(e => e.StatusId).HasDefaultValue(1L);

            entity.HasOne(d => d.Status).WithMany(p => p.TeamMembers)
                .HasForeignKey(d => d.StatusId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_TeamMember_Status");

            entity.HasOne(d => d.Team).WithMany(p => p.TeamMembers)
                .HasForeignKey(d => d.TeamId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_TeamMember_Team");

            entity.HasOne(d => d.TeamMemberAccount).WithMany(p => p.TeamMembers)
                .HasForeignKey(d => d.TeamMemberAccountId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_TeamMember_TeamMemberAccount");
        });

        modelBuilder.Entity<TicketType>(entity =>
        {
            entity.ToTable("TicketType");

            entity.Property(e => e.StatusId).HasDefaultValue(1L);

            entity.HasOne(d => d.Status).WithMany(p => p.TicketTypes)
                .HasForeignKey(d => d.StatusId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_TicketType_Status");
        });

        OnModelCreatingPartial(modelBuilder);
    }

    partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
}
