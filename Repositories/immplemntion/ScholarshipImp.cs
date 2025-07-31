using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using ScholarComp.Models;
using ScholarComp.Repositories.Irepos;

namespace ScholarComp.Repositories.immplemntion
{
    public class ScholarshipImp : IScholarship
    {
        private readonly ElsewedySchoolSysContext db;
        public ScholarshipImp(ElsewedySchoolSysContext db)
        {
            this.db = db;
        }
        public async Task<IEnumerable<Scholarship>> GetAllScholarships()
        {
           return await db.Scholarships.ToListAsync();
        }
    }
}
