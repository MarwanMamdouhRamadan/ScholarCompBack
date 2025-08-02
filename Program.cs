using Microsoft.EntityFrameworkCore;
using ScholarComp.Repositories;
using ScholarComp.Repositories.Irepos;
using ScholarShipComp.Models;
using ScholarShipComp.Repositories.immplemntion;
using ScholarShipComp.Repositories.Irepos;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.

builder.Services.AddControllers();
// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();
builder.Services.AddScoped<IScholarship, ScholarshipImp>();
builder.Services.AddScoped<ICompetition,CompetitionImp>();
builder.Services.AddScoped<IStatusRepository,StatusRepository>();
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

app.Run();
