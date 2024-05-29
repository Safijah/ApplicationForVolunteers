using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace RadVolontera.Services.Migrations
{
    /// <inheritdoc />
    public partial class AnnoucementReason : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<string>(
                name: "Reason",
                table: "VolunteeringAnnouncements",
                type: "nvarchar(max)",
                nullable: true);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "Reason",
                table: "VolunteeringAnnouncements");
        }
    }
}
