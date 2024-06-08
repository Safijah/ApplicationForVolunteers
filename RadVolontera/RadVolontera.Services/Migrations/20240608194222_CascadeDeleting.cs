using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace RadVolontera.Services.Migrations
{
    /// <inheritdoc />
    public partial class CascadeDeleting : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_MonthlyPlanTemplates_AnnualPlanTemplates_AnnualPlanTemplateId1",
                table: "MonthlyPlanTemplates");

            migrationBuilder.DropIndex(
                name: "IX_MonthlyPlanTemplates_AnnualPlanTemplateId1",
                table: "MonthlyPlanTemplates");

            migrationBuilder.DropColumn(
                name: "AnnualPlanTemplateId1",
                table: "MonthlyPlanTemplates");

            migrationBuilder.AlterColumn<long>(
                name: "AnnualPlanTemplateId",
                table: "MonthlyPlanTemplates",
                type: "bigint",
                nullable: false,
                oldClrType: typeof(int),
                oldType: "int");

            migrationBuilder.CreateIndex(
                name: "IX_MonthlyPlanTemplates_AnnualPlanTemplateId",
                table: "MonthlyPlanTemplates",
                column: "AnnualPlanTemplateId");

            migrationBuilder.AddForeignKey(
                name: "FK_MonthlyPlanTemplates_AnnualPlanTemplates_AnnualPlanTemplateId",
                table: "MonthlyPlanTemplates",
                column: "AnnualPlanTemplateId",
                principalTable: "AnnualPlanTemplates",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_MonthlyPlanTemplates_AnnualPlanTemplates_AnnualPlanTemplateId",
                table: "MonthlyPlanTemplates");

            migrationBuilder.DropIndex(
                name: "IX_MonthlyPlanTemplates_AnnualPlanTemplateId",
                table: "MonthlyPlanTemplates");

            migrationBuilder.AlterColumn<int>(
                name: "AnnualPlanTemplateId",
                table: "MonthlyPlanTemplates",
                type: "int",
                nullable: false,
                oldClrType: typeof(long),
                oldType: "bigint");

            migrationBuilder.AddColumn<long>(
                name: "AnnualPlanTemplateId1",
                table: "MonthlyPlanTemplates",
                type: "bigint",
                nullable: false,
                defaultValue: 0L);

            migrationBuilder.CreateIndex(
                name: "IX_MonthlyPlanTemplates_AnnualPlanTemplateId1",
                table: "MonthlyPlanTemplates",
                column: "AnnualPlanTemplateId1");

            migrationBuilder.AddForeignKey(
                name: "FK_MonthlyPlanTemplates_AnnualPlanTemplates_AnnualPlanTemplateId1",
                table: "MonthlyPlanTemplates",
                column: "AnnualPlanTemplateId1",
                principalTable: "AnnualPlanTemplates",
                principalColumn: "Id");
        }
    }
}
