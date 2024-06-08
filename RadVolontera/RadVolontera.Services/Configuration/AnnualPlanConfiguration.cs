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
    public sealed class AnnualPlanConfiguration : IEntityTypeConfiguration<AnnualPlan>
    {
        public void Configure(EntityTypeBuilder<AnnualPlan> builder)
        {
            builder.Property(u => u.Id).ValueGeneratedOnAdd();
            builder.HasQueryFilter(u => u.DeletedAt == null);
            builder.Property(w => w.CreatedAt).HasDefaultValueSql("GETUTCDATE()");
            builder.HasOne(n => n.AnnualPlanTemplate).WithMany(n => n.AnnualPlans).OnDelete(DeleteBehavior.NoAction);
            builder.HasOne(n => n.Mentor).WithMany(n => n.AnnualPlans).OnDelete(DeleteBehavior.NoAction);
            builder.HasOne(n => n.Status).WithMany(n => n.AnnualPlans).OnDelete(DeleteBehavior.NoAction);
        }
    }
}
