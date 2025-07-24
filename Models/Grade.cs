using System;
using System.Collections.Generic;

namespace ScholarComp.Models;

public partial class Grade
{
    public long Id { get; set; }

    public string GradeName { get; set; } = null!;

    public long? ParentGradeId { get; set; }

    public long? AdminAccountId { get; set; }

    public long StatusId { get; set; }
}
