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
    public sealed class MonthlyPlanTemplateConfiguration : IEntityTypeConfiguration<MonthlyPlanTemplate>
    {
        public void Configure(EntityTypeBuilder<MonthlyPlanTemplate> builder)
        {
            builder.Property(u => u.Id).ValueGeneratedOnAdd();
            builder.HasQueryFilter(u => u.DeletedAt == null);
            builder.Property(w => w.CreatedAt).HasDefaultValueSql("GETUTCDATE()");
            builder.HasOne(n => n.AnnualPlanTemplate).WithMany(n => n.MonthlyPlanTemplates).HasForeignKey(n=>n.AnnualPlanTemplateId).OnDelete(DeleteBehavior.Cascade);
        }
    }
}
