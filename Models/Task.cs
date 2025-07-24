using System;
using System.Collections.Generic;

namespace ScholarComp.Models;

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
}
