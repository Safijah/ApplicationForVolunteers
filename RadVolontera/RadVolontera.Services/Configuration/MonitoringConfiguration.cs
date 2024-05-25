using Microsoft.EntityFrameworkCore.Metadata.Builders;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using RadVolontera.Services.Database;

namespace RadVolontera.Services.Configuration
{ 
    public sealed class MonitoringConfiguration : IEntityTypeConfiguration<Monitoring>
    {
        public void Configure(EntityTypeBuilder<Monitoring> builder)
        {
            builder.Property(u => u.Id).ValueGeneratedOnAdd();
            builder.Property(w => w.CreatedAt).HasDefaultValueSql("GETUTCDATE()");
            builder.HasQueryFilter(u => u.DeletedAt == null);
            builder.HasOne(r => r.Mentor).WithMany(r => r.Monitorings).OnDelete(DeleteBehavior.NoAction);
        }
    }
}
