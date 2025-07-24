using System;
using System.Collections.Generic;

namespace ScholarComp.Models;

public partial class Report
{
    public long Id { get; set; }

    public string Title { get; set; } = null!;

    public DateTime SubmissionDate { get; set; }

    public string ReportMessage { get; set; } = null!;

    public long SubmitterAccountId { get; set; }

    public long StatusId { get; set; }
}
