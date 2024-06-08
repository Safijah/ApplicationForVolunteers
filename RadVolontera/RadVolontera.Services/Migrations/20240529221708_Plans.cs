using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace RadVolontera.Services.Migrations
{
    /// <inheritdoc />
    public partial class Plans : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "AnnualPlanTemplate",
                columns: table => new
                {
                    Id = table.Column<long>(type: "bigint", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Year = table.Column<int>(type: "int", nullable: false),
                    CreatedById = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    CreatedAt = table.Column<DateTime>(type: "datetime2", nullable: false, defaultValueSql: "GETUTCDATE()"),
                    LastModifiedBy = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    LastModified = table.Column<DateTime>(type: "datetime2", nullable: true),
                    DeletedAt = table.Column<DateTime>(type: "datetime2", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_AnnualPlanTemplate", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "AnnualPlan",
                columns: table => new
                {
                    Id = table.Column<long>(type: "bigint", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Year = table.Column<int>(type: "int", nullable: false),
                    AnnualPlanTemplateId = table.Column<long>(type: "bigint", nullable: false),
                    CreatedById = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    CreatedAt = table.Column<DateTime>(type: "datetime2", nullable: false, defaultValueSql: "GETUTCDATE()"),
                    LastModifiedBy = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    LastModified = table.Column<DateTime>(type: "datetime2", nullable: true),
                    DeletedAt = table.Column<DateTime>(type: "datetime2", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_AnnualPlan", x => x.Id);
                    table.ForeignKey(
                        name: "FK_AnnualPlan_AnnualPlanTemplate_AnnualPlanTemplateId",
                        column: x => x.AnnualPlanTemplateId,
                        principalTable: "AnnualPlanTemplate",
                        principalColumn: "Id");
                });

            migrationBuilder.CreateTable(
                name: "MonthlyPlanTemplate",
                columns: table => new
                {
                    Id = table.Column<long>(type: "bigint", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Theme = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Month = table.Column<int>(type: "int", nullable: false),
                    AnnualPlanTemplateId = table.Column<int>(type: "int", nullable: false),
                    AnnualPlanTemplateId1 = table.Column<long>(type: "bigint", nullable: false),
                    CreatedById = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    CreatedAt = table.Column<DateTime>(type: "datetime2", nullable: false, defaultValueSql: "GETUTCDATE()"),
                    LastModifiedBy = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    LastModified = table.Column<DateTime>(type: "datetime2", nullable: true),
                    DeletedAt = table.Column<DateTime>(type: "datetime2", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_MonthlyPlanTemplate", x => x.Id);
                    table.ForeignKey(
                        name: "FK_MonthlyPlanTemplate_AnnualPlanTemplate_AnnualPlanTemplateId1",
                        column: x => x.AnnualPlanTemplateId1,
                        principalTable: "AnnualPlanTemplate",
                        principalColumn: "Id");
                });

            migrationBuilder.CreateTable(
                name: "MonthlyPlan",
                columns: table => new
                {
                    Id = table.Column<long>(type: "bigint", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Month = table.Column<int>(type: "int", nullable: false),
                    Theme1 = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Theme2 = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Goals1 = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Goals2 = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    AnualPlanId = table.Column<long>(type: "bigint", nullable: false),
                    CreatedById = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    CreatedAt = table.Column<DateTime>(type: "datetime2", nullable: false, defaultValueSql: "GETUTCDATE()"),
                    LastModifiedBy = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    LastModified = table.Column<DateTime>(type: "datetime2", nullable: true),
                    DeletedAt = table.Column<DateTime>(type: "datetime2", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_MonthlyPlan", x => x.Id);
                    table.ForeignKey(
                        name: "FK_MonthlyPlan_AnnualPlan_AnualPlanId",
                        column: x => x.AnualPlanId,
                        principalTable: "AnnualPlan",
                        principalColumn: "Id");
                });

            migrationBuilder.CreateIndex(
                name: "IX_AnnualPlan_AnnualPlanTemplateId",
                table: "AnnualPlan",
                column: "AnnualPlanTemplateId");

            migrationBuilder.CreateIndex(
                name: "IX_MonthlyPlan_AnualPlanId",
                table: "MonthlyPlan",
                column: "AnualPlanId");

            migrationBuilder.CreateIndex(
                name: "IX_MonthlyPlanTemplate_AnnualPlanTemplateId1",
                table: "MonthlyPlanTemplate",
                column: "AnnualPlanTemplateId1");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "MonthlyPlan");

            migrationBuilder.DropTable(
                name: "MonthlyPlanTemplate");

            migrationBuilder.DropTable(
                name: "AnnualPlan");

            migrationBuilder.DropTable(
                name: "AnnualPlanTemplate");
        }
    }
}
