﻿using System;
using System.Collections.Generic;

namespace ScholarComp.Models;

public partial class CapstoneSupervisorExtension
{
    public long AccountId { get; set; }

    public long StatusId { get; set; }

    public virtual Account Account { get; set; } = null!;

    public virtual Status Status { get; set; } = null!;
}
