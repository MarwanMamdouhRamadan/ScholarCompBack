using Microsoft.EntityFrameworkCore;
using ScholarComp.Models;
using ScholarComp.Repositories.immplemntion;
using ScholarComp.Repositories.Irepos;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.

builder.Services.AddControllers();
// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();
builder.Services.AddScoped<IScholarship, ScholarshipImp>();
builder.Services.AddDbContext<ElsewedySchoolSysContext>(x => x.UseSqlServer(builder.Configuration.GetConnectionString("connstr")));
var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseHttpsRedirection();

app.UseAuthorization();

app.MapControllers();
Console.WriteLine("CONNECTION = " + builder.Configuration.GetConnectionString("connstr"));
app.Run();
