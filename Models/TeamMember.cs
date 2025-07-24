using System;
using System.Collections.Generic;

namespace ScholarComp.Models;

public partial class TeamMember
{
    public long Id { get; set; }

    public long TeamId { get; set; }

    public long TeamMemberAccountId { get; set; }

    public string? TeamMemberDescription { get; set; }

    public long StatusId { get; set; }
}
