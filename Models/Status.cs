using System;
using System.Collections.Generic;

namespace ScholarComp.Models;

public partial class Status
{
    public long Id { get; set; }

    public string StatusName { get; set; } = null!;

    public string? BusinessEntity { get; set; }
}
