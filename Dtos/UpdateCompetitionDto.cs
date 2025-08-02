namespace ScholarShipComp.Dtos
{
    public class UpdateCompetitionDto
    {
        public string NameAr { get; set; }
        public string NameEn { get; set; }
        public string CompanyName { get; set; }
        public DateTime DateOfCreation { get; set; }
        public string Description { get; set; }
        public string Link { get; set; }
        public long SupervisorAccountId { get; set; }

        public string StatusName { get; set; }  
    }

}
