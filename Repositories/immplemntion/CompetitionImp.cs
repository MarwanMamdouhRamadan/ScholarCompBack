
using ScholarComp.Repositories.Irepos;
using Microsoft.EntityFrameworkCore;
using System.Threading.Tasks;
using ScholarShipComp.Dtos;
using ScholarShipComp.Models;
using ScholarShipComp.Dtos;

namespace ScholarComp.Repositories
{
    public class CompetitionImp : ICompetition
    {
        private readonly ElsewedySchoolSysContext db;

        public CompetitionImp(ElsewedySchoolSysContext context)
        {
            db = context;
        }

        public async Task<IEnumerable<GetCompetitionDto>> get()
        {
            return await db.Projects.Select(x => new  GetCompetitionDto
            { 
                CompanyName = x.CompanyName,
                NameEn = x.NameEn,
            }).ToListAsync();
        }

        public async Task<CompetitionDetailsDto> GetByIdAsync(long id)
        {
            var project = await db.Projects
                     .Include(p => p.Status)
                     .Include(p => p.SupervisorAccount)
                      .FirstOrDefaultAsync(p => p.Id == id);

            if (project == null) throw new Exception("Competition not found"); ;

            string desc = project.ProjectDescription ?? "";
            string link = "";
            int idx = desc.LastIndexOf("http");
            if (idx != -1)
            {
                link = desc.Substring(idx).Trim();
                desc = desc.Substring(0, idx).Trim();
            }

            return new CompetitionDetailsDto
            {
                NameAr = project.NameAr,
                NameEn = project.NameEn,
                CompanyName = project.CompanyName,
                AdditionalInformation = project.AdditionalInformation,
                DateOfCreation = project.DateOfCreation,
                SupervisorName = project.SupervisorAccount?.FullNameEn,
                StatusName = project.Status?.StatusName,
                DescriptionWithLink = $"{desc} The link is: {link}"
            };

        }

        public async Task<CompetitionDto> AddAsync(AddCompetitionDto dto)
        {
            var status = await db.Statuses
                .FirstOrDefaultAsync(s => s.StatusName == dto.StatusName);
            if (status == null) throw new Exception("status not found");

            var project = new Project
            {
                NameAr = dto.NameAr,
                NameEn = dto.NameEn,
                CompanyName = dto.CompanyName,
                DateOfCreation = dto.DateOfCreation,
                ProjectDescription = $"{dto.Description} {dto.Link}".Trim(),
                StatusId = status.Id,
                SupervisorAccountId = dto.SupervisorAccountId
            };

            var entity = await db.Projects.AddAsync(project);
            await db.SaveChangesAsync();

            return new CompetitionDto
            {
                Id = entity.Entity.Id,
                NameAr = entity.Entity.NameAr,
                NameEn = entity.Entity.NameEn,
                StatusName = status.StatusName
            };
        }

        public async System.Threading.Tasks.Task UpdateAsync(UpdateCompetitionDto dto,long id)
        {
            var project = await db.Projects.FirstOrDefaultAsync(x => x.Id == id);
            if (project == null) throw new Exception("Competition not found");

            var status = await db.Statuses
                .FirstOrDefaultAsync(s => s.StatusName == dto.StatusName);

            if (status == null)
                throw new Exception("Status not found");

            project.NameAr = dto.NameAr;
            project.NameEn = dto.NameEn;
            project.CompanyName = dto.CompanyName;
            project.DateOfCreation = dto.DateOfCreation;
            project.ProjectDescription = $"{dto.Description} {dto.Link}".Trim();
            project.SupervisorAccountId = dto.SupervisorAccountId;
            project.StatusId = status.Id; 

            db.Projects.Update(project);
            await db.SaveChangesAsync();
            
        }

    }
}
