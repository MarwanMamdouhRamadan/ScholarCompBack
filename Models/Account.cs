using System;
using System.Collections.Generic;

namespace ScholarComp.Models;

public partial class Account
{
    public long Id { get; set; }

    public string NationalId { get; set; } = null!;

    public string PasswordHash { get; set; } = null!;

    public string Email { get; set; } = null!;

    public long AccountTypeId { get; set; }

    public string FullNameEn { get; set; } = null!;

    public string FullNameAr { get; set; } = null!;

    public string? ResetToken { get; set; }

    public DateTime? ResetTokenExpiry { get; set; }

    public bool IsActive { get; set; }

    public long StatusId { get; set; }

    public virtual AccountType AccountType { get; set; } = null!;

    public virtual AdmissionProfile? AdmissionProfile { get; set; }

    public virtual CapstoneSupervisorExtension? CapstoneSupervisorExtension { get; set; }

    public virtual ICollection<Grade> Grades { get; set; } = new List<Grade>();

    public virtual ICollection<Login> Logins { get; set; } = new List<Login>();

    public virtual ICollection<Project> Projects { get; set; } = new List<Project>();

    public virtual ICollection<Report> Reports { get; set; } = new List<Report>();

    public virtual ReviewerSupervisorExtension? ReviewerSupervisorExtension { get; set; }

    public virtual Status Status { get; set; } = null!;

    public virtual StudentExtension? StudentExtension { get; set; }

    public virtual ICollection<StudentTask> StudentTasks { get; set; } = new List<StudentTask>();

    public virtual ICollection<SubordinateTicket> SubordinateTicketSubordinateAccounts { get; set; } = new List<SubordinateTicket>();

    public virtual ICollection<SubordinateTicket> SubordinateTicketSupervisorAccounts { get; set; } = new List<SubordinateTicket>();

    public virtual SuperAdminExtension? SuperAdminExtension { get; set; }

    public virtual ICollection<Task> Tasks { get; set; } = new List<Task>();

    public virtual ICollection<TeamMember> TeamMembers { get; set; } = new List<TeamMember>();

    public virtual ICollection<Team> TeamSupervisorAccounts { get; set; } = new List<Team>();

    public virtual ICollection<Team> TeamTeamLeaderAccounts { get; set; } = new List<Team>();
}
