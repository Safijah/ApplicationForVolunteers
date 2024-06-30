using Microsoft.EntityFrameworkCore;

namespace RadVolonteraDodatni.Database
{
    public class AppDbContext : DbContext
    {
        public AppDbContext(DbContextOptions<AppDbContext> options) : base(options)
        {
        }
        public virtual DbSet<User> Users { get; set; }
        public virtual DbSet<Monitoring> Monitoring { get; set; }
    }
}
