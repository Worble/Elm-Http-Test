using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace apitester.Controllers
{
    [Route("api/[controller]")]
    public class ValuesController : Controller
    {
        MyDbContext context;

        public ValuesController(MyDbContext context)
        {
            this.context = context;
        }


        // GET api/values
        [HttpGet]
        public IEnumerable<Value> Get()
        {
            return context.Values;
        }

        // POST api/values
        [HttpPost]
        public IEnumerable<Value> Post([FromBody]Value value)
        {
            context.Values.Add(value);
            context.SaveChanges();
            return context.Values;
        }
    }

    public class Value
    {
        public int ID { get; set; }
        public string Message { get; set; }
    }

    public class MyDbContext : DbContext
    {
        public MyDbContext(DbContextOptions<MyDbContext> options) : base(options)
        {
        }

        public DbSet<Value> Values { get; set; }
    }
}
