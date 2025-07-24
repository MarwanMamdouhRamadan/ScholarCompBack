using Microsoft.AspNetCore.Mvc;

namespace ScholarComp.Controllers
{
    public class ScholarshipsController : Controller
    {
        public IActionResult Index()
        {
            return View();
        }
    }
}
