﻿using System;
using System.Collections.Generic;

namespace ScholarComp.Models;

public partial class StudentExtension
{
    public long AccountId { get; set; }

    public bool IsLeader { get; set; }

    public long? ClassId { get; set; }

    public long StatusId { get; set; }

    public virtual Account Account { get; set; } = null!;

    public virtual Class? Class { get; set; }

    public virtual Status Status { get; set; } = null!;
}
