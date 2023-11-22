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

    public sealed class CompanyEventConfiguration : IEntityTypeConfiguration<CompanyEvent>
    {
        public void Configure(EntityTypeBuilder<CompanyEvent> builder)
        {
            builder.Property(u => u.Id).ValueGeneratedOnAdd();
            builder.HasQueryFilter(u => u.DeletedAt == null);
            builder.Property(w => w.CreatedAt).HasDefaultValueSql("GETUTCDATE()");
            builder.HasOne(n => n.Company).WithMany(n => n.Events).OnDelete(DeleteBehavior.NoAction);
        }
    }
}
