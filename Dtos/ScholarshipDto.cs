using System.ComponentModel.DataAnnotations;

namespace ScholarShipComp.Dtos
{
    public class ScholarshipDto
    {
        [Required(ErrorMessage = "ScholarshipName is required")]
        public string ScholarshipName { get; set; } = null!;
        [Required(ErrorMessage = "ScholarshipDescription is required")]
        public string ScholarshipDescription { get; set; } = null!;
        [Required(ErrorMessage = "RegestrationLink is required")]
        public string? RegestrationLink { get; set; }
        [Required(ErrorMessage = "Amount is required")]
        [Range(typeof(decimal), "0.01", "79228162514264337593543950335", ErrorMessage = "Amount must be greater than 0")]
        public decimal Amount { get; set; }
        [Required(ErrorMessage = "ProviderName is required")]
        public string ProviderName { get; set; } = null!;
        [Required(ErrorMessage = "StartDate is required")]
        public DateOnly? StartDate { get; set; }
        [Required(ErrorMessage = "EndDate is required")]
        public DateOnly? EndDate { get; set; }
        [Required(ErrorMessage = "EndDate is required")]
        public string statusName { get; set; } = null!;
    }
}
