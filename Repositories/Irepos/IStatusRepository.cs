using ScholarShipComp.Dtos;

namespace ScholarComp.Repositories.Irepos
{
    public interface IStatusRepository
    {
        Task<List<StatusDto>> GetAllStatusesAsync();
    }
}

