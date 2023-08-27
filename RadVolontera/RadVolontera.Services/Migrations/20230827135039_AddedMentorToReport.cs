using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace RadVolontera.Services.Migrations
{
    /// <inheritdoc />
    public partial class AddedMentorToReport : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<string>(
                name: "MentorId",
                table: "Reports",
                type: "nvarchar(450)",
                nullable: false,
                defaultValue: "");

            migrationBuilder.CreateIndex(
                name: "IX_Reports_MentorId",
                table: "Reports",
                column: "MentorId");

            migrationBuilder.AddForeignKey(
                name: "FK_Reports_Users_MentorId",
                table: "Reports",
                column: "MentorId",
                principalTable: "Users",
                principalColumn: "Id");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Reports_Users_MentorId",
                table: "Reports");

            migrationBuilder.DropIndex(
                name: "IX_Reports_MentorId",
                table: "Reports");

            migrationBuilder.DropColumn(
                name: "MentorId",
                table: "Reports");
        }
    }
}
