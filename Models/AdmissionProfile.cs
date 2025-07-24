using System;
using System.Collections.Generic;

namespace ScholarComp.Models;

public partial class AdmissionProfile
{
    public long AccountId { get; set; }

    public DateOnly? DateOfBirth { get; set; }

    public string? Location { get; set; }

    public string? PhoneNumber { get; set; }

    public decimal? SoftwareInterviewScore { get; set; }

    public decimal? MathInterviewScore { get; set; }

    public decimal? EnglishInterviewScore { get; set; }

    public decimal? ArabicInterviewScore { get; set; }

    public string? StudentName { get; set; }

    public decimal? MathScore { get; set; }

    public decimal? EnglishScore { get; set; }

    public decimal? ThirdPrepScore { get; set; }

    public bool IsAcceptanceLetterReceived { get; set; }

    public long StatusId { get; set; }
}
