using Microsoft.EntityFrameworkCore;
using ScholarShipComp.Dtos;
using ScholarShipComp.Repositories.Irepos;
using ScholarShipComp.Models;
using ScholarComp.Repositories.Irepos;
namespace ScholarShipComp.Repositories.immplemntion
{
    public class StatusRepository : IStatusRepository
    {
        private readonly ElsewedySchoolSysContext _context;

        public StatusRepository(ElsewedySchoolSysContext context)
        {
            _context = context;
        }

        public async Task<List<StatusDto>> GetAllStatusesAsync()
        {
            return await _context.Statuses
                .Select(s => new StatusDto
                {
                    Id = (int)s.Id,
                    StatusName = s.StatusName
                }).ToListAsync();
        }
    }
}
