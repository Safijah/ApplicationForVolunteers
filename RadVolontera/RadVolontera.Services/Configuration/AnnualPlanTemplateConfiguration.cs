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
    public sealed class AnnualPlanTemplateConfiguration : IEntityTypeConfiguration<AnnualPlanTemplate>
    {
        public void Configure(EntityTypeBuilder<AnnualPlanTemplate> builder)
        {
            builder.Property(u => u.Id).ValueGeneratedOnAdd();
            builder.HasQueryFilter(u => u.DeletedAt == null);
            builder.Property(w => w.CreatedAt).HasDefaultValueSql("GETUTCDATE()");
        }
    }
}
