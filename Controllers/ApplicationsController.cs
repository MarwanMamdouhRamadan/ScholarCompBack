using Microsoft.AspNetCore.Mvc;

namespace ScholarComp.Controllers
{
    public class ApplicationsController : Controller
    {
        public IActionResult Index()
        {
            return View();
        }
    }
}
