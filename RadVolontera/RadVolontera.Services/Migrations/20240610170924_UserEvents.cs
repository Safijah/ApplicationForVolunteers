using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace RadVolontera.Services.Migrations
{
    /// <inheritdoc />
    public partial class UserEvents : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "CompanyEventUser",
                columns: table => new
                {
                    CompanyEventsId = table.Column<long>(type: "bigint", nullable: false),
                    MentorsId = table.Column<string>(type: "nvarchar(450)", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_CompanyEventUser", x => new { x.CompanyEventsId, x.MentorsId });
                    table.ForeignKey(
                        name: "FK_CompanyEventUser_CompanyEvent_CompanyEventsId",
                        column: x => x.CompanyEventsId,
                        principalTable: "CompanyEvent",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_CompanyEventUser_Users_MentorsId",
                        column: x => x.MentorsId,
                        principalTable: "Users",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateIndex(
                name: "IX_CompanyEventUser_MentorsId",
                table: "CompanyEventUser",
                column: "MentorsId");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "CompanyEventUser");
        }
    }
}
