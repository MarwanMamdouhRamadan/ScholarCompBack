using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using ScholarComp.Models;
using ScholarComp.Repositories.Irepos;

namespace ScholarComp.Controllers
{
    [ApiController]
    [Route("api/[Controller]")]
    public class ScholarshipsController : ControllerBase
    {
        private readonly IScholarship scholarShip;
        public ScholarshipsController(IScholarship admin, ElsewedySchoolSysContext db)
        {
            this.scholarShip = admin;
        }
        [HttpGet("All")]
        public async Task<IActionResult> getAll()
        {
            var lScholar = await scholarShip.GetAllScholarships();
            return Ok(lScholar);
        }




    }
}
