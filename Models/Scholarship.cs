﻿using System;
using System.Collections.Generic;

namespace ScholarComp.Models;

public partial class Scholarship
{
    public long Id { get; set; }

    public string ScholarshipName { get; set; } = null!;

    public string ScholarshipDescription { get; set; } = null!;

    public decimal Amount { get; set; }

    public string ProviderName { get; set; } = null!;

    public DateOnly? StartDate { get; set; }

    public DateOnly? EndDate { get; set; }

    public long StatusId { get; set; }

    public virtual Status Status { get; set; } = null!;
}
