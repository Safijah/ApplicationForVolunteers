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
    public class UsefulLinksConfiguration : IEntityTypeConfiguration<UsefulLinks>
    {
        public void Configure(EntityTypeBuilder<UsefulLinks> builder)
        {
            builder.Property(u => u.Id).ValueGeneratedOnAdd();
            builder.HasQueryFilter(u => u.DeletedAt == null);
            builder.Property(w => w.CreatedAt).HasDefaultValueSql("GETUTCDATE()");
            builder.HasOne(u => u.Admin).WithMany(u => u.UsefulLinks).OnDelete(DeleteBehavior.NoAction);
        }
    }
}
