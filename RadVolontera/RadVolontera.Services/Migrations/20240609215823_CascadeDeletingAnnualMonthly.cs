using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace RadVolontera.Services.Migrations
{
    /// <inheritdoc />
    public partial class CascadeDeletingAnnualMonthly : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_MonthlyPlans_AnnualPlans_AnualPlanId",
                table: "MonthlyPlans");

            migrationBuilder.AddForeignKey(
                name: "FK_MonthlyPlans_AnnualPlans_AnualPlanId",
                table: "MonthlyPlans",
                column: "AnualPlanId",
                principalTable: "AnnualPlans",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_MonthlyPlans_AnnualPlans_AnualPlanId",
                table: "MonthlyPlans");

            migrationBuilder.AddForeignKey(
                name: "FK_MonthlyPlans_AnnualPlans_AnualPlanId",
                table: "MonthlyPlans",
                column: "AnualPlanId",
                principalTable: "AnnualPlans",
                principalColumn: "Id");
        }
    }
}
