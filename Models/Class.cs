﻿using System;
using System.Collections.Generic;

namespace ScholarComp.Models;

public partial class Class
{
    public long Id { get; set; }

    public string ClassName { get; set; } = null!;

    public long GradeId { get; set; }

    public long StatusId { get; set; }

    public virtual Grade Grade { get; set; } = null!;

    public virtual ICollection<ReviewerSupervisorExtension> ReviewerSupervisorExtensions { get; set; } = new List<ReviewerSupervisorExtension>();

    public virtual Status Status { get; set; } = null!;

    public virtual ICollection<StudentExtension> StudentExtensions { get; set; } = new List<StudentExtension>();

    public virtual ICollection<SubordinateTicket> SubordinateTickets { get; set; } = new List<SubordinateTicket>();

    public virtual ICollection<Team> Teams { get; set; } = new List<Team>();
}
