using Microsoft.EntityFrameworkCore.Metadata.Builders;
using Microsoft.EntityFrameworkCore;
using RadVolontera.Services.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RadVolontera.Services.Configuration
{
    public sealed class ReportConfiguration : IEntityTypeConfiguration<Report>
    {
        public void Configure(EntityTypeBuilder<Report> builder)
        {
            builder.Property(u => u.Id).ValueGeneratedOnAdd();
            builder.Property(w => w.CreatedAt).HasDefaultValueSql("GETUTCDATE()");
            builder.HasQueryFilter(u => u.DeletedAt == null);
            builder.HasOne(r => r.Status).WithMany(r => r.Reports).OnDelete(DeleteBehavior.NoAction); 
            builder.HasMany(r=>r.PresentStudents).WithMany(r=>r.VolunteersPresent) ;
            builder.HasMany(r=>r.AbsentStudents).WithMany(r=>r.AbsentForVolunteering); 
            builder.HasOne(r=>r.VolunteeringAnnouncement).WithOne(r=>r.Report).OnDelete(DeleteBehavior.NoAction);
        }
    }
}
