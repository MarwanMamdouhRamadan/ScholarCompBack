using ScholarShipComp.Dtos;
using ScholarShipComp.Models;

namespace ScholarShipComp.Repositories.Irepos
{
    public interface IScholarship
    {
        public Task<IEnumerable<GetScholarshipDto>> get();
        public Task<Scholarship> getDetiales(long id);
        public  System.Threading.Tasks.Task add(ScholarshipDto scholarship);
        public System.Threading.Tasks.Task update(ScholarshipDto scholarship,long id);

    }
}
