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
    public sealed class StatusConfiguration : IEntityTypeConfiguration<Status>
    {
        public void Configure(EntityTypeBuilder<Status> builder)
        {
            builder.Property(u => u.Id).ValueGeneratedOnAdd();
            builder.Property(w => w.CreatedAt).HasDefaultValueSql("GETUTCDATE()");
        }
    }
}
