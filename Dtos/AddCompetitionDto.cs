using System.ComponentModel.DataAnnotations;
using ScholarShipComp.Dtos;
namespace ScholarShipComp.Dtos
{
    public class AddCompetitionDto
    {
        [Required(ErrorMessage = "NameEn is required")]
        public string NameEn { get; set; } = null!;

        [Required(ErrorMessage = "NameAr is required")]
        public string NameAr { get; set; } = null!;

        [Required(ErrorMessage = "CompanyName is required")]
        public string CompanyName { get; set; } = null!;

        [Required(ErrorMessage = "Description is required")]
        public string Description { get; set; } = null!;

        [Required(ErrorMessage = "Link is required")]
        public string Link { get; set; } = null!;
        [Required(ErrorMessage = "DateOfCreation is required")]
        public DateTime DateOfCreation { get; set; }

        [Required(ErrorMessage = "SupervisorAccountId is required")]
        public int SupervisorAccountId { get; set; }

        [Required(ErrorMessage = "StatusName is required")]
        public string StatusName { get; set; } = null!;
        
    }

}
