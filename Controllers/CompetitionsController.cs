using Microsoft.AspNetCore.Mvc;
using ScholarShipComp.Dtos;
using ScholarShipComp.Repositories.Irepos;
using ScholarShipComp.Dtos;
using System.Threading.Tasks;

namespace ScholarComp.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class CompetitionsController : ControllerBase
    {
        private readonly ICompetition _IComp;

        public CompetitionsController(ICompetition comp)
        {
            _IComp = comp;
        }
        [HttpGet]
        public async Task<IActionResult> getCompetition()
        {
            var lCompetition = await _IComp.get();
            return Ok(lCompetition);
        }
        [HttpPost]
        public async Task<IActionResult> Add([FromBody] AddCompetitionDto dto)
        {
            var result = await _IComp.AddAsync(dto);
            return Ok(new { message = "Scholarship created successfully" });
        }


        [HttpGet("details/{id}")]
        public async Task<ActionResult<CompetitionDetailsDto>> GetCompetitionDetails(long id)
        {
            var dto = await _IComp.GetByIdAsync(id);
            return Ok(dto);
        }

        [HttpPut("{id}")]
        public async Task<IActionResult> UpdateCompetition([FromBody] UpdateCompetitionDto dto, long id)
        {
            await _IComp.UpdateAsync(dto,id);
            return Ok(new { message = "Competition updated successfully" });
        }
    }
}
