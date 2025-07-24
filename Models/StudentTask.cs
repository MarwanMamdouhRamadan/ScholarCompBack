using System;
using System.Collections.Generic;

namespace ScholarComp.Models;

public partial class StudentTask
{
    public long Id { get; set; }

    public long StudentAccountId { get; set; }

    public long TaskId { get; set; }

    public bool IsCompleted { get; set; }

    public DateTime? CompletedAt { get; set; }

    public long StatusId { get; set; }
}
