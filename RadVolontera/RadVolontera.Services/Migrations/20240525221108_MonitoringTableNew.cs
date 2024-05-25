using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace RadVolontera.Services.Migrations
{
    /// <inheritdoc />
    public partial class MonitoringTableNew : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_VolunteeringAnnouncements_Cities_CityId",
                table: "VolunteeringAnnouncements");

            migrationBuilder.DropForeignKey(
                name: "FK_VolunteeringAnnouncements_Statuses_AnnouncementStatusId",
                table: "VolunteeringAnnouncements");

            migrationBuilder.DropForeignKey(
                name: "FK_VolunteeringAnnouncements_Users_MentorId",
                table: "VolunteeringAnnouncements");

            migrationBuilder.AlterColumn<DateTime>(
                name: "CreatedAt",
                table: "VolunteeringAnnouncements",
                type: "datetime2",
                nullable: false,
                defaultValueSql: "GETUTCDATE()",
                oldClrType: typeof(DateTime),
                oldType: "datetime2");

            migrationBuilder.AddColumn<string>(
                name: "Reason",
                table: "Reports",
                type: "nvarchar(max)",
                nullable: true);

            migrationBuilder.CreateTable(
                name: "Monitoring",
                columns: table => new
                {
                    Id = table.Column<long>(type: "bigint", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Notes = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    MentorId = table.Column<string>(type: "nvarchar(450)", nullable: false),
                    Date = table.Column<DateTime>(type: "datetime2", nullable: false),
                    Url = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    CreatedById = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    CreatedAt = table.Column<DateTime>(type: "datetime2", nullable: false, defaultValueSql: "GETUTCDATE()"),
                    LastModifiedBy = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    LastModified = table.Column<DateTime>(type: "datetime2", nullable: true),
                    DeletedAt = table.Column<DateTime>(type: "datetime2", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Monitoring", x => x.Id);
                    table.ForeignKey(
                        name: "FK_Monitoring_Users_MentorId",
                        column: x => x.MentorId,
                        principalTable: "Users",
                        principalColumn: "Id");
                });

            migrationBuilder.CreateIndex(
                name: "IX_Monitoring_MentorId",
                table: "Monitoring",
                column: "MentorId");

            migrationBuilder.AddForeignKey(
                name: "FK_VolunteeringAnnouncements_Cities_CityId",
                table: "VolunteeringAnnouncements",
                column: "CityId",
                principalTable: "Cities",
                principalColumn: "Id");

            migrationBuilder.AddForeignKey(
                name: "FK_VolunteeringAnnouncements_Statuses_AnnouncementStatusId",
                table: "VolunteeringAnnouncements",
                column: "AnnouncementStatusId",
                principalTable: "Statuses",
                principalColumn: "Id");

            migrationBuilder.AddForeignKey(
                name: "FK_VolunteeringAnnouncements_Users_MentorId",
                table: "VolunteeringAnnouncements",
                column: "MentorId",
                principalTable: "Users",
                principalColumn: "Id");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_VolunteeringAnnouncements_Cities_CityId",
                table: "VolunteeringAnnouncements");

            migrationBuilder.DropForeignKey(
                name: "FK_VolunteeringAnnouncements_Statuses_AnnouncementStatusId",
                table: "VolunteeringAnnouncements");

            migrationBuilder.DropForeignKey(
                name: "FK_VolunteeringAnnouncements_Users_MentorId",
                table: "VolunteeringAnnouncements");

            migrationBuilder.DropTable(
                name: "Monitoring");

            migrationBuilder.DropColumn(
                name: "Reason",
                table: "Reports");

            migrationBuilder.AlterColumn<DateTime>(
                name: "CreatedAt",
                table: "VolunteeringAnnouncements",
                type: "datetime2",
                nullable: false,
                oldClrType: typeof(DateTime),
                oldType: "datetime2",
                oldDefaultValueSql: "GETUTCDATE()");

            migrationBuilder.AddForeignKey(
                name: "FK_VolunteeringAnnouncements_Cities_CityId",
                table: "VolunteeringAnnouncements",
                column: "CityId",
                principalTable: "Cities",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_VolunteeringAnnouncements_Statuses_AnnouncementStatusId",
                table: "VolunteeringAnnouncements",
                column: "AnnouncementStatusId",
                principalTable: "Statuses",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_VolunteeringAnnouncements_Users_MentorId",
                table: "VolunteeringAnnouncements",
                column: "MentorId",
                principalTable: "Users",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);
        }
    }
}
