using Microsoft.AspNetCore.Mvc;

namespace ScholarComp.Controllers
{
    public class CompetitionsController : Controller
    {
        public IActionResult Index()
        {
            return View();
        }
    }
}
