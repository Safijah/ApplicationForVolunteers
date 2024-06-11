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
    public sealed class CityConfiguration : IEntityTypeConfiguration<City>
    {
        public void Configure(EntityTypeBuilder<City> builder)
        {
            builder.Property(u => u.Id).ValueGeneratedOnAdd();
            builder.Property(w => w.CreatedAt).HasDefaultValueSql("GETUTCDATE()");
        }
    }
}
