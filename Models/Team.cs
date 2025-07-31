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

    public virtual Class Class { get; set; } = null!;

    public virtual Project? Project { get; set; }

    public virtual Status Status { get; set; } = null!;

    public virtual Account? SupervisorAccount { get; set; }

    public virtual Account? TeamLeaderAccount { get; set; }

    public virtual ICollection<TeamMember> TeamMembers { get; set; } = new List<TeamMember>();
}
