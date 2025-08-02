using Microsoft.AspNetCore.Mvc;
using ScholarShipComp.Dtos;
using ScholarShipComp.Models;
using ScholarShipComp.Repositories.Irepos;
using static Microsoft.EntityFrameworkCore.DbLoggerCategory;

namespace ScholarShipComp.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class ScholarshipsController : ControllerBase
    {
        private readonly IScholarship _scholarship;

        public ScholarshipsController(IScholarship scholarship)
        {
            _scholarship = scholarship;
        }
        [HttpGet]
        public async Task<IActionResult> gettScholarship()
        {
            var lScholar = await _scholarship.get();
            return Ok(lScholar);
        }
        [HttpGet("{id}")]
        public async Task<IActionResult> gettScholarship(long id)
        {
            try
            {
                var scholar = await _scholarship.getDetiales(id);
                return Ok(scholar);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
            
        }
        [HttpPost]
        public async Task<IActionResult> AddScholarship(ScholarshipDto scholarship)
        {
            try
            {
                await _scholarship.add(scholarship);
                return Ok(new { message = "Scholarship created successfully" });
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }
        [HttpPut("{id}")]
        public async Task<IActionResult> UpdateScholarship([FromBody] ScholarshipDto scholarship, long id)
        {
            try
            {
                await _scholarship.update(scholarship, id);
                return Ok(new { message = "Scholarship updated successfully" });
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
            
        }

    }
}
