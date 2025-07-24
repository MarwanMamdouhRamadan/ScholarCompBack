using System;
using System.Collections.Generic;

namespace ScholarComp.Models;

public partial class Class
{
    public long Id { get; set; }

    public string ClassName { get; set; } = null!;

    public long GradeId { get; set; }

    public long StatusId { get; set; }
}
