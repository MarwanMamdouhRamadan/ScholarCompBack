using System;
using System.Collections.Generic;

namespace ScholarShipComp.Models;

public partial class Grade
{
    public long Id { get; set; }

    public string GradeName { get; set; } = null!;

    public long? ParentGradeId { get; set; }

    public long? AdminAccountId { get; set; }

    public long StatusId { get; set; }

    public virtual Account? AdminAccount { get; set; }

    public virtual ICollection<Class> Classes { get; set; } = new List<Class>();

    public virtual Status Status { get; set; } = null!;

    public virtual ICollection<SubordinateTicket> SubordinateTickets { get; set; } = new List<SubordinateTicket>();

    public virtual ICollection<Task> Tasks { get; set; } = new List<Task>();
}
