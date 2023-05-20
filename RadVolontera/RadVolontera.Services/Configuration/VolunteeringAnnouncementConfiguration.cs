using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using RadVolontera.Services.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RadVolontera.Services.Configuration
{
    public sealed class VolunteeringAnnouncementConfiguration : IEntityTypeConfiguration<VolunteeringAnnouncement>
    {
        public void Configure(EntityTypeBuilder<VolunteeringAnnouncement> builder)
        {
            builder.Property(u => u.Id).ValueGeneratedOnAdd();
            builder.Property(w => w.CreatedAt).HasDefaultValueSql("GETUTCDATE()");
            builder.HasOne(v => v.AnnouncementStatus).WithMany(v => v.VolunteeringAnnouncements).OnDelete(DeleteBehavior.NoAction); 
            builder.HasOne(u => u.City).WithMany(u => u.VolunteeringAnnouncements).OnDelete(DeleteBehavior.NoAction); 
            builder.HasOne(u => u.Mentor).WithMany(u => u.AnnouncementMentors).OnDelete(DeleteBehavior.NoAction);
            builder.HasQueryFilter(u => u.DeletedAt == null);
        }
    }
}
