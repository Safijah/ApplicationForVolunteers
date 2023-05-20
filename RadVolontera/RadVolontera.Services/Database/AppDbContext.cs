using Microsoft.EntityFrameworkCore;
using RadVolontera.Services.Configuration;
using RadVolontera.Services.Interfaces;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RadVolontera.Services.Database
{
    public class AppDbContext : DbContext
    {
        public virtual DbSet<User> Users { get; set; }
        public virtual DbSet<Role> Roles { get; set; }
        public AppDbContext(DbContextOptions<AppDbContext> options) : base(options)
        {

        }

        protected override void OnModelCreating(ModelBuilder builder)
        {
            base.OnModelCreating(builder);
            builder.ApplyConfiguration(new RolesConfiguration());
            builder.ApplyConfiguration(new UserConfiguration());
        }

        public override async Task<int> SaveChangesAsync(CancellationToken cancellationToken = default)
        {
            ChangeTracker.DetectChanges();

            OnBeforeSaving();

            return await base.SaveChangesAsync(cancellationToken);
        }

        public override int SaveChanges()
        {
            ChangeTracker.DetectChanges();

            OnBeforeSaving();

            return base.SaveChanges();
        }

        private void OnBeforeSaving()
        {
            var updatedEntries = ChangeTracker
                .Entries()
                .Where(x => x.State != EntityState.Unchanged && x.State != EntityState.Detached && x.State != EntityState.Added);

            foreach (var entry in updatedEntries)
            {
                if (entry.State == EntityState.Deleted)
                {
                    if (entry.Entity is ISoftDelete deleteDate)
                    {
                        deleteDate.DeletedAt = DateTime.UtcNow;
                        entry.State = EntityState.Modified;
                    }
                }
                else
                {
                    if (entry.Entity is ITrackTimes updatedDate)
                    {
                        updatedDate.LastModified = DateTime.UtcNow;
                        entry.State = EntityState.Modified;
                    }
                }
            }

            var addedEntries = ChangeTracker
                .Entries()
                .Where(x => x.State == EntityState.Added);

            foreach (var entry in addedEntries)
            {
                if (entry.Entity is ITrackCreationTime creationTime)
                {
                    creationTime.CreatedAt = DateTime.UtcNow;
                }
            }
        }
    }
}
