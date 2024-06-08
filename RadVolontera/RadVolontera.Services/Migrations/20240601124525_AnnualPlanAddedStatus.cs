using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace RadVolontera.Services.Migrations
{
    /// <inheritdoc />
    public partial class AnnualPlanAddedStatus : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<long>(
                name: "StatusId",
                table: "AnnualPlans",
                type: "bigint",
                nullable: false,
                defaultValue: 0L);

            migrationBuilder.CreateIndex(
                name: "IX_AnnualPlans_StatusId",
                table: "AnnualPlans",
                column: "StatusId");

            migrationBuilder.AddForeignKey(
                name: "FK_AnnualPlans_Statuses_StatusId",
                table: "AnnualPlans",
                column: "StatusId",
                principalTable: "Statuses",
                principalColumn: "Id");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_AnnualPlans_Statuses_StatusId",
                table: "AnnualPlans");

            migrationBuilder.DropIndex(
                name: "IX_AnnualPlans_StatusId",
                table: "AnnualPlans");

            migrationBuilder.DropColumn(
                name: "StatusId",
                table: "AnnualPlans");
        }
    }
}
