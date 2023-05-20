using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using RadVolontera.Services.Database;

namespace RadVolontera.Services.Configuration
{
    public sealed class UserConfiguration : IEntityTypeConfiguration<User>
    {
        public void Configure(EntityTypeBuilder<User> builder)
        {
            builder.Property(u => u.Id).ValueGeneratedOnAdd();
            builder.Property(w => w.CreatedAt).HasDefaultValueSql("GETUTCDATE()");
            builder.Property(u => u.Username).IsRequired().HasMaxLength(254);
            builder.Property(u => u.Email).IsRequired().HasMaxLength(254);
            builder.Property(u => u.PasswordHash).IsRequired();
            builder.HasQueryFilter(u => u.DeletedAt == null);
        }
    }
}
