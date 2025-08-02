using System;
using System.Collections.Generic;

namespace ScholarShipComp.Models;

public partial class Task
{
    public long Id { get; set; }

    public string TaskName { get; set; } = null!;

    public string? TaskDescription { get; set; }

    public DateTime TaskDeadline { get; set; }

    public string? GithubLink { get; set; }

    public long GradeId { get; set; }

    public long AdminAccountId { get; set; }

    public long StatusId { get; set; }

    public virtual Account AdminAccount { get; set; } = null!;

    public virtual Grade Grade { get; set; } = null!;

    public virtual Status Status { get; set; } = null!;

    public virtual ICollection<StudentTask> StudentTasks { get; set; } = new List<StudentTask>();
}
