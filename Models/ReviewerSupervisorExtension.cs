using System;
using System.Collections.Generic;

namespace ScholarComp.Models;

public partial class ReviewerSupervisorExtension
{
    public long AccountId { get; set; }

    public long? AssignedClassId { get; set; }

    public long StatusId { get; set; }
}
