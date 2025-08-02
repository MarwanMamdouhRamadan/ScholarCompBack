using System.Collections.Generic;
using System.Threading.Tasks;
using ScholarShipComp.Dtos;

public interface ICompetition
{
    public Task<IEnumerable<GetCompetitionDto>> get();
    public Task<CompetitionDetailsDto> GetByIdAsync(long id);
    public  Task<CompetitionDto> AddAsync(AddCompetitionDto dto);
    public Task UpdateAsync(UpdateCompetitionDto dto,long id);
}
