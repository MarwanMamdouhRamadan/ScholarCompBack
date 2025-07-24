using System;
using System.Collections.Generic;

namespace ScholarComp.Models;

public partial class Project
{
    public long Id { get; set; }

    public string NameAr { get; set; } = null!;

    public string NameEn { get; set; } = null!;

    public DateTime DateOfCreation { get; set; }

    public string ProjectDescription { get; set; } = null!;

    public long StatusId { get; set; }

    public long SupervisorAccountId { get; set; }
}
