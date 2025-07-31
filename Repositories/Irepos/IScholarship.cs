using ScholarComp.Models;
namespace ScholarComp.Repositories.Irepos
{
    public interface IScholarship
    {
        public Task<IEnumerable<Scholarship>>GetAllScholarships();

    }
}
