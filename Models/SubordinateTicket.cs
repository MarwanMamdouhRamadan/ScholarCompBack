﻿using System;
using System.Collections.Generic;

namespace ScholarComp.Models;

public partial class SubordinateTicket
{
    public long Id { get; set; }

    public long? SupervisorAccountId { get; set; }

    public long? GradeId { get; set; }

    public long? ClassId { get; set; }

    public long? SessionId { get; set; }

    public long? SubordinateAccountId { get; set; }

    public long? TicketTypeId { get; set; }

    public long StatusId { get; set; }
}
