using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace RadVolontera.Services.Migrations
{
    /// <inheritdoc />
    public partial class PlansMentor : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_AnnualPlan_AnnualPlanTemplate_AnnualPlanTemplateId",
                table: "AnnualPlan");

            migrationBuilder.DropForeignKey(
                name: "FK_MonthlyPlan_AnnualPlan_AnualPlanId",
                table: "MonthlyPlan");

            migrationBuilder.DropForeignKey(
                name: "FK_MonthlyPlanTemplate_AnnualPlanTemplate_AnnualPlanTemplateId1",
                table: "MonthlyPlanTemplate");

            migrationBuilder.DropPrimaryKey(
                name: "PK_MonthlyPlanTemplate",
                table: "MonthlyPlanTemplate");

            migrationBuilder.DropPrimaryKey(
                name: "PK_MonthlyPlan",
                table: "MonthlyPlan");

            migrationBuilder.DropPrimaryKey(
                name: "PK_AnnualPlanTemplate",
                table: "AnnualPlanTemplate");

            migrationBuilder.DropPrimaryKey(
                name: "PK_AnnualPlan",
                table: "AnnualPlan");

            migrationBuilder.RenameTable(
                name: "MonthlyPlanTemplate",
                newName: "MonthlyPlanTemplates");

            migrationBuilder.RenameTable(
                name: "MonthlyPlan",
                newName: "MonthlyPlans");

            migrationBuilder.RenameTable(
                name: "AnnualPlanTemplate",
                newName: "AnnualPlanTemplates");

            migrationBuilder.RenameTable(
                name: "AnnualPlan",
                newName: "AnnualPlans");

            migrationBuilder.RenameIndex(
                name: "IX_MonthlyPlanTemplate_AnnualPlanTemplateId1",
                table: "MonthlyPlanTemplates",
                newName: "IX_MonthlyPlanTemplates_AnnualPlanTemplateId1");

            migrationBuilder.RenameIndex(
                name: "IX_MonthlyPlan_AnualPlanId",
                table: "MonthlyPlans",
                newName: "IX_MonthlyPlans_AnualPlanId");

            migrationBuilder.RenameIndex(
                name: "IX_AnnualPlan_AnnualPlanTemplateId",
                table: "AnnualPlans",
                newName: "IX_AnnualPlans_AnnualPlanTemplateId");

            migrationBuilder.AddColumn<string>(
                name: "MentorId",
                table: "AnnualPlans",
                type: "nvarchar(450)",
                nullable: false,
                defaultValue: "");

            migrationBuilder.AddPrimaryKey(
                name: "PK_MonthlyPlanTemplates",
                table: "MonthlyPlanTemplates",
                column: "Id");

            migrationBuilder.AddPrimaryKey(
                name: "PK_MonthlyPlans",
                table: "MonthlyPlans",
                column: "Id");

            migrationBuilder.AddPrimaryKey(
                name: "PK_AnnualPlanTemplates",
                table: "AnnualPlanTemplates",
                column: "Id");

            migrationBuilder.AddPrimaryKey(
                name: "PK_AnnualPlans",
                table: "AnnualPlans",
                column: "Id");

            migrationBuilder.CreateIndex(
                name: "IX_AnnualPlans_MentorId",
                table: "AnnualPlans",
                column: "MentorId");

            migrationBuilder.AddForeignKey(
                name: "FK_AnnualPlans_AnnualPlanTemplates_AnnualPlanTemplateId",
                table: "AnnualPlans",
                column: "AnnualPlanTemplateId",
                principalTable: "AnnualPlanTemplates",
                principalColumn: "Id");

            migrationBuilder.AddForeignKey(
                name: "FK_AnnualPlans_Users_MentorId",
                table: "AnnualPlans",
                column: "MentorId",
                principalTable: "Users",
                principalColumn: "Id");

            migrationBuilder.AddForeignKey(
                name: "FK_MonthlyPlans_AnnualPlans_AnualPlanId",
                table: "MonthlyPlans",
                column: "AnualPlanId",
                principalTable: "AnnualPlans",
                principalColumn: "Id");

            migrationBuilder.AddForeignKey(
                name: "FK_MonthlyPlanTemplates_AnnualPlanTemplates_AnnualPlanTemplateId1",
                table: "MonthlyPlanTemplates",
                column: "AnnualPlanTemplateId1",
                principalTable: "AnnualPlanTemplates",
                principalColumn: "Id");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_AnnualPlans_AnnualPlanTemplates_AnnualPlanTemplateId",
                table: "AnnualPlans");

            migrationBuilder.DropForeignKey(
                name: "FK_AnnualPlans_Users_MentorId",
                table: "AnnualPlans");

            migrationBuilder.DropForeignKey(
                name: "FK_MonthlyPlans_AnnualPlans_AnualPlanId",
                table: "MonthlyPlans");

            migrationBuilder.DropForeignKey(
                name: "FK_MonthlyPlanTemplates_AnnualPlanTemplates_AnnualPlanTemplateId1",
                table: "MonthlyPlanTemplates");

            migrationBuilder.DropPrimaryKey(
                name: "PK_MonthlyPlanTemplates",
                table: "MonthlyPlanTemplates");

            migrationBuilder.DropPrimaryKey(
                name: "PK_MonthlyPlans",
                table: "MonthlyPlans");

            migrationBuilder.DropPrimaryKey(
                name: "PK_AnnualPlanTemplates",
                table: "AnnualPlanTemplates");

            migrationBuilder.DropPrimaryKey(
                name: "PK_AnnualPlans",
                table: "AnnualPlans");

            migrationBuilder.DropIndex(
                name: "IX_AnnualPlans_MentorId",
                table: "AnnualPlans");

            migrationBuilder.DropColumn(
                name: "MentorId",
                table: "AnnualPlans");

            migrationBuilder.RenameTable(
                name: "MonthlyPlanTemplates",
                newName: "MonthlyPlanTemplate");

            migrationBuilder.RenameTable(
                name: "MonthlyPlans",
                newName: "MonthlyPlan");

            migrationBuilder.RenameTable(
                name: "AnnualPlanTemplates",
                newName: "AnnualPlanTemplate");

            migrationBuilder.RenameTable(
                name: "AnnualPlans",
                newName: "AnnualPlan");

            migrationBuilder.RenameIndex(
                name: "IX_MonthlyPlanTemplates_AnnualPlanTemplateId1",
                table: "MonthlyPlanTemplate",
                newName: "IX_MonthlyPlanTemplate_AnnualPlanTemplateId1");

            migrationBuilder.RenameIndex(
                name: "IX_MonthlyPlans_AnualPlanId",
                table: "MonthlyPlan",
                newName: "IX_MonthlyPlan_AnualPlanId");

            migrationBuilder.RenameIndex(
                name: "IX_AnnualPlans_AnnualPlanTemplateId",
                table: "AnnualPlan",
                newName: "IX_AnnualPlan_AnnualPlanTemplateId");

            migrationBuilder.AddPrimaryKey(
                name: "PK_MonthlyPlanTemplate",
                table: "MonthlyPlanTemplate",
                column: "Id");

            migrationBuilder.AddPrimaryKey(
                name: "PK_MonthlyPlan",
                table: "MonthlyPlan",
                column: "Id");

            migrationBuilder.AddPrimaryKey(
                name: "PK_AnnualPlanTemplate",
                table: "AnnualPlanTemplate",
                column: "Id");

            migrationBuilder.AddPrimaryKey(
                name: "PK_AnnualPlan",
                table: "AnnualPlan",
                column: "Id");

            migrationBuilder.AddForeignKey(
                name: "FK_AnnualPlan_AnnualPlanTemplate_AnnualPlanTemplateId",
                table: "AnnualPlan",
                column: "AnnualPlanTemplateId",
                principalTable: "AnnualPlanTemplate",
                principalColumn: "Id");

            migrationBuilder.AddForeignKey(
                name: "FK_MonthlyPlan_AnnualPlan_AnualPlanId",
                table: "MonthlyPlan",
                column: "AnualPlanId",
                principalTable: "AnnualPlan",
                principalColumn: "Id");

            migrationBuilder.AddForeignKey(
                name: "FK_MonthlyPlanTemplate_AnnualPlanTemplate_AnnualPlanTemplateId1",
                table: "MonthlyPlanTemplate",
                column: "AnnualPlanTemplateId1",
                principalTable: "AnnualPlanTemplate",
                principalColumn: "Id");
        }
    }
}
