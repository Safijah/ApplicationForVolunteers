using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace RadVolontera.Services.Migrations
{
    /// <inheritdoc />
    public partial class StatusTable : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Reports_Status_StatusId",
                table: "Reports");

            migrationBuilder.DropForeignKey(
                name: "FK_VolunteeringAnnouncements_Status_AnnouncementStatusId",
                table: "VolunteeringAnnouncements");

            migrationBuilder.DropPrimaryKey(
                name: "PK_Status",
                table: "Status");

            migrationBuilder.RenameTable(
                name: "Status",
                newName: "Statuses");

            migrationBuilder.AddPrimaryKey(
                name: "PK_Statuses",
                table: "Statuses",
                column: "Id");

            migrationBuilder.AddForeignKey(
                name: "FK_Reports_Statuses_StatusId",
                table: "Reports",
                column: "StatusId",
                principalTable: "Statuses",
                principalColumn: "Id");

            migrationBuilder.AddForeignKey(
                name: "FK_VolunteeringAnnouncements_Statuses_AnnouncementStatusId",
                table: "VolunteeringAnnouncements",
                column: "AnnouncementStatusId",
                principalTable: "Statuses",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Reports_Statuses_StatusId",
                table: "Reports");

            migrationBuilder.DropForeignKey(
                name: "FK_VolunteeringAnnouncements_Statuses_AnnouncementStatusId",
                table: "VolunteeringAnnouncements");

            migrationBuilder.DropPrimaryKey(
                name: "PK_Statuses",
                table: "Statuses");

            migrationBuilder.RenameTable(
                name: "Statuses",
                newName: "Status");

            migrationBuilder.AddPrimaryKey(
                name: "PK_Status",
                table: "Status",
                column: "Id");

            migrationBuilder.AddForeignKey(
                name: "FK_Reports_Status_StatusId",
                table: "Reports",
                column: "StatusId",
                principalTable: "Status",
                principalColumn: "Id");

            migrationBuilder.AddForeignKey(
                name: "FK_VolunteeringAnnouncements_Status_AnnouncementStatusId",
                table: "VolunteeringAnnouncements",
                column: "AnnouncementStatusId",
                principalTable: "Status",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);
        }
    }
}
