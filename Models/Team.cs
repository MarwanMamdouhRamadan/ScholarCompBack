using System;
using System.Collections.Generic;

namespace ScholarComp.Models;

public partial class Team
{
    public long Id { get; set; }

    public string TeamName { get; set; } = null!;

    public long? TeamLeaderAccountId { get; set; }

    public long ClassId { get; set; }

    public long? SupervisorAccountId { get; set; }

    public long? ProjectId { get; set; }

    public long StatusId { get; set; }
}
