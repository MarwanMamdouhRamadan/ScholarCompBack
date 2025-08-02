using Microsoft.AspNetCore.Mvc;
using ScholarShipComp.Dtos;
using ScholarComp.Repositories.Irepos;

namespace ScholarComp.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class StatusController : ControllerBase
    {
        private readonly IStatusRepository _statusRepository;

        public StatusController(IStatusRepository statusRepository)
        {
            _statusRepository = statusRepository;
        }

        [HttpGet]
        public async Task<IActionResult> GetAllStatuses()
        {
            var statuses = await _statusRepository.GetAllStatusesAsync();
            return Ok(statuses);
        }
    }


}
