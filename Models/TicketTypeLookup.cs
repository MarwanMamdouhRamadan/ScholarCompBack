using System;
using System.Collections.Generic;

namespace ScholarComp.Models;

public partial class TicketTypeLookup
{
    public long Id { get; set; }

    public string TicketTypeName { get; set; } = null!;

    public int? OrderNo { get; set; }

    public string? BusinessEntity { get; set; }

    public long StatusId { get; set; }
}
