using Microsoft.EntityFrameworkCore;
using ScholarShipComp.Dtos;
using ScholarShipComp.Models;
using ScholarShipComp.Repositories.Irepos;

namespace ScholarShipComp.Repositories.immplemntion
{
    public class ScholarshipImp:IScholarship
    {
        private readonly ElsewedySchoolSysContext db;


        public ScholarshipImp(ElsewedySchoolSysContext db)
        {
            this.db = db;

        }
        public async Task<Scholarship> getDetiales(long id)
        {
            var scholarShip = await db.Scholarships.FirstOrDefaultAsync(x => x.Id == id);
            if (scholarShip == null)
                throw new Exception("Scholarship not found");
            return scholarShip;
        }
        public async System.Threading.Tasks.Task add(ScholarshipDto scholarship)
        {
            var stat = await db.Statuses.FirstOrDefaultAsync(x => x.StatusName == scholarship.statusName);
            if (stat == null) throw new Exception("status not found");
            var scholar = new Scholarship()
            {
                ScholarshipName = scholarship.ScholarshipName,
                ScholarshipDescription = scholarship.ScholarshipDescription,
                StartDate = scholarship.StartDate,
                EndDate = scholarship.EndDate,
                Amount = scholarship.Amount,
                RegestrationLink = scholarship.RegestrationLink,
                StatusId = stat.Id,
                ProviderName = scholarship.ProviderName,
            };
            await db.Scholarships.AddAsync(scholar);
            await db.SaveChangesAsync();
        }

        public async System.Threading.Tasks.Task update(ScholarshipDto scholarship,long id)
        {
            var stat = await db.Statuses.FirstOrDefaultAsync(x => x.StatusName == scholarship.statusName);
            if (stat == null) throw new Exception("status not found");
            var scholar = await db.Scholarships.FirstOrDefaultAsync(x => x.Id == id);
            if (scholar == null) throw new Exception("Scholarship not found");
            scholar.ScholarshipName = scholarship.ScholarshipName;
            scholar.ScholarshipDescription = scholarship.ScholarshipDescription;
            scholar.StartDate = scholarship.StartDate;
            scholar.EndDate = scholarship.EndDate;
            scholar.Amount = scholarship.Amount;
            scholar.RegestrationLink = scholarship.RegestrationLink;
            scholar.StatusId = stat.Id;
            scholar.ProviderName = scholarship.ProviderName;
            
            db.Update(scholar);
            await db.SaveChangesAsync();
        }

        public async Task<IEnumerable<GetScholarshipDto>> get()
        {
            return await db.Scholarships.Select(x => new GetScholarshipDto
            {
                ScholarShipName = x.ScholarshipName,
                ProviderName = x.ProviderName,
            }).ToListAsync();
        }
    }
}
