﻿using System;
using System.Collections.Generic;

namespace ScholarShipComp.Models;

public partial class ReviewerSupervisorExtension
{
    public long AccountId { get; set; }

    public long? AssignedClassId { get; set; }

    public long StatusId { get; set; }

    public virtual Account Account { get; set; } = null!;

    public virtual Class? AssignedClass { get; set; }

    public virtual Status Status { get; set; } = null!;
}
