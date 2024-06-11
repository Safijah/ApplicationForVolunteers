using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using RadVolontera.Models.Enums;
using RadVolontera.Services.Database;

namespace RadVolontera.Configuration
{
    public static class EFCoreConfiguration
    {
        public static void AddEFCoreInfrastructure(this IServiceCollection services, IConfiguration configuration)
        {
            services.AddDbContext<AppDbContext>(options =>
                options.UseSqlServer(configuration.GetConnectionString("DefaultConnection"),
                b => b.MigrationsAssembly(typeof(AppDbContext).Assembly.FullName))
            );
        }

        public static void SeedData(this IApplicationBuilder app)
        {
            using (var serviceScope = app.ApplicationServices.GetRequiredService<IServiceScopeFactory>().CreateScope())
            {
                var context = serviceScope.ServiceProvider.GetService<AppDbContext>();
                context.Database.SetCommandTimeout(TimeSpan.FromMinutes(3));
                context.Database.Migrate();

                if (!context.Cities.Any())
                {
                    SeedCitiesCategories(context);
                }

                if (!context.SchoolTypes.Any())
                {
                    SeedSchoolTypessCategories(context);
                }

                if (!context.Schools.Any())
                {
                    SeedSchools(context);
                }

                if (!context.Statuses.Any())
                {
                    SeedStatuses(context);
                }

                if (!context.CompanyCategory.Any())
                {
                    SeedCategories(context);
                }

                if (!context.Company.Any())
                {
                    SeedCompanies(context);
                }

                if (!context.Users.Any())
                {
                    SeedUsers(context, serviceScope);
                }

                if (!context.Sections.Any())
                {
                    SeedSections(context);
                }

                if (!context.Notifications.Any())
                {
                    SeedNotifications(context);
                }

                if (!context.UsefulLinks.Any())
                {
                    SeedUsefulLinks(context);
                }

                if (!context.Payments.Any())
                {
                    SeedPayments(context);
                }

                if (!context.VolunteeringAnnouncements.Any())
                {
                    SeedVolunteeringAnnouncements(context);
                }

                if (!context.CompanyEvent.Any())
                {
                    SeedEvents(context);
                }
            }
        }

        private static void SeedCitiesCategories(AppDbContext context)
        {
            var sqlCommand = @"
    SET IDENTITY_INSERT Cities ON;

    INSERT INTO Cities (Id, Name, CreatedById, CreatedAt) VALUES
    (1, 'Mostar', NULL, '2024-06-08T00:00:00.0000000'),
    (2, 'Bugojno', NULL, '2024-06-10T00:00:00.0000000'),
    (4, 'Sarajevo', NULL, '2024-06-10T00:00:00.0000000'),
    (5, 'Zenica', NULL, '2024-06-10T00:00:00.0000000'),
    (6, 'Livno', NULL, '2024-06-10T00:00:00.0000000'),
    (7, 'Donji Vakuf', NULL, '2024-06-10T00:00:00.0000000');

    SET IDENTITY_INSERT Cities OFF;";

            context.Database.ExecuteSqlRaw(sqlCommand);
        }

        private static void SeedSchoolTypessCategories(AppDbContext context)
        {
            var sqlCommand = @"
    SET IDENTITY_INSERT SchoolTypes ON;

    INSERT INTO SchoolTypes (Id, Name) VALUES
    (1, 'Elementary school'),
    (2, 'High school'),
    (3, 'Faculty');

    SET IDENTITY_INSERT SchoolTypes OFF;";

            context.Database.ExecuteSqlRaw(sqlCommand);
        }
        private static void SeedSchools(AppDbContext context)
        {
            var sqlCommand = @"
    SET IDENTITY_INSERT Schools ON;

    INSERT INTO Schools (Id, Name, SchoolTypeId, CreatedById, CreatedAt) VALUES
    (1, 'Faculty of information technology', 3, NULL, '2024-06-08T00:00:00.0000000'),
    (2, 'High technical school', 2, NULL, '2024-06-10T00:00:00.0000000'),
    (6, 'Elementary school ''Hasan Kjafi Pruscak''', 1, NULL, '2024-06-10T00:00:00.0000000');

    SET IDENTITY_INSERT Schools OFF;";

            context.Database.ExecuteSqlRaw(sqlCommand);
        }
        private static void SeedStatuses(AppDbContext context)
        {
            var sqlCommand = @"
    SET IDENTITY_INSERT Statuses ON;

    INSERT INTO Statuses (Id, Name, CreatedById, CreatedAt, LastModifiedBy, LastModified) VALUES
    (1, 'On hold', NULL, '2024-06-09T00:00:00.0000000', NULL, NULL),
    (2, 'Approved', NULL, '2024-06-09T00:00:00.0000000', NULL, NULL),
    (3, 'Rejected', NULL, '2024-06-09T00:00:00.0000000', NULL, NULL);

    SET IDENTITY_INSERT Statuses OFF;";

            context.Database.ExecuteSqlRaw(sqlCommand);
        }
        private static void SeedCategories(AppDbContext context)
        {
            var sqlCommand = @"
    SET IDENTITY_INSERT CompanyCategory ON;

    INSERT INTO CompanyCategory (Id, Name) VALUES
    (1, 'IT'),
    (2, 'Business'),
    (3, 'Technology'),
    (4, 'Healthcare'),
    (5, 'Education'),
    (6, 'Healthcare');  -- Duplicate entry

    SET IDENTITY_INSERT CompanyCategory OFF;";

            context.Database.ExecuteSqlRaw(sqlCommand);
        }
        private static void SeedCompanies(AppDbContext context)
        {
            var sqlCommand = @"
    SET IDENTITY_INSERT Company ON;

    INSERT INTO Company (Id, Name, Address, PhoneNumber, Email, CityId, CompanyCategoryId, CreatedById, CreatedAt, LastModifiedBy, LastModified, DeletedAt) VALUES
    (1, 'Hastor', 'Sarajevo, bb', '123456', 'hastor@test.no', 1, 1, NULL, '2024-06-10T17:36:39.8608610', NULL, NULL, NULL),
    (2, 'Networg', 'Bugojno', '123456', 'networg@test.com', 1, 2, NULL, '2024-06-10T17:37:34.2347661', NULL, NULL, NULL),
    (3, 'Tech Innovations Inc', 'Sarajevo', '123456', 'tech@test.no', 2, 3, NULL, '2024-06-10T17:39:11.9070649', NULL, NULL, NULL),
    (4, 'HealthCare Partners', 'Bugojno', '123456', 'partners@test.com', 1, 4, NULL, '2024-06-10T17:39:50.4747456', NULL, NULL, NULL);

    SET IDENTITY_INSERT Company OFF;";

            context.Database.ExecuteSqlRaw(sqlCommand);
        }
        private static void SeedSections(AppDbContext context)
        {
            var sqlCommand = @"
    SET IDENTITY_INSERT Sections ON;

    INSERT INTO Sections (Id, Name, CreatedById, CreatedAt, LastModifiedBy, LastModified) VALUES
    (1, N'Event Reminder', NULL, CAST(N'2024-06-10T00:00:00.0000000' AS DateTime2), NULL, NULL),
    (3, N'Training Session', NULL, CAST(N'2024-06-10T00:00:00.0000000' AS DateTime2), NULL, NULL),
    (4, N'Event Details Updated', NULL, CAST(N'2024-06-10T00:00:00.0000000' AS DateTime2), NULL, NULL),
    (5, N'Upcoming Volunteer Orientation', NULL, CAST(N'2024-06-10T00:00:00.0000000' AS DateTime2), NULL, NULL),
    (6, N'Event Sign-Up Confirmation', NULL, CAST(N'2024-06-10T00:00:00.0000000' AS DateTime2), NULL, NULL);

    SET IDENTITY_INSERT Sections OFF;";

            context.Database.ExecuteSqlRaw(sqlCommand);
        }
        private static void SeedNotifications(AppDbContext context)
        {
            var sqlCommand = @"
    SET IDENTITY_INSERT Notifications ON;

    INSERT INTO Notifications (Id, Heading, Content, SectionId, AdminId, CreatedById, CreatedAt, LastModifiedBy, LastModified, DeletedAt) VALUES
    (1, N'Upcoming Volunteer Orientation', N'Join us for the volunteer orientation on Monday, June 12th at 5:00 PM. This session will cover important guidelines and provide an opportunity to meet fellow volunteers.', 5, N'499196fe-d061-4d2b-8773-718c4fe431ea', NULL, CAST(N'2024-06-10T17:21:32.6523861' AS DateTime2), NULL, NULL, NULL),
    (2, N'Event Sign-Up Confirmation', N'Thank you for signing up for the Community Clean-Up event on Saturday, June 14th. We look forward to your participation!', 6, N'499196fe-d061-4d2b-8773-718c4fe431ea', NULL, CAST(N'2024-06-10T17:22:33.9782992' AS DateTime2), NULL, NULL, NULL);

    SET IDENTITY_INSERT Notifications OFF;";

            context.Database.ExecuteSqlRaw(sqlCommand);
        }
        private static void SeedUsefulLinks(AppDbContext context)
        {
            var sqlCommand = @"
    SET IDENTITY_INSERT dbo.UsefulLinks ON;

    INSERT INTO dbo.UsefulLinks (Id, UrlLink, Name, AdminId, CreatedById, CreatedAt, LastModifiedBy, LastModified, DeletedAt) VALUES
    (1, N'https://volunteerportal.example.com', N'Volunteer Portal', N'499196fe-d061-4d2b-8773-718c4fe431ea', NULL, CAST(N'2024-06-10T17:23:22.8159966' AS DateTime2), NULL, NULL, NULL),
    (2, N'https://volunteertraining.example.com', N'Training Materials', N'499196fe-d061-4d2b-8773-718c4fe431ea', NULL, CAST(N'2024-06-10T17:23:43.5305491' AS DateTime2), NULL, NULL, NULL),
    (3, N'https://volunteerhandbook.example.com', N'Volunteer Handbook', N'499196fe-d061-4d2b-8773-718c4fe431ea', NULL, CAST(N'2024-06-10T17:24:02.3713657' AS DateTime2), NULL, NULL, NULL);

    SET IDENTITY_INSERT dbo.UsefulLinks OFF;";

            context.Database.ExecuteSqlRaw(sqlCommand);
        }
        private static void SeedUsers(AppDbContext context, IServiceScope scope)
        {
            var userManager = scope.ServiceProvider.GetService<UserManager<User>>();
            var mentor = new User
            {
                Id = "120842a7-ea9f-41ee-8739-d5858f9dfe89",
                Username = "safija_mentor@hotmail.com",
                Email = "safija_mentor@hotmail.com",
                FirstName = "Safija",
                LastName = "Mentor",
                BirthDate = DateTime.Parse("2024-06-29"),
                Gender = Gender.Female,
                PhoneNumber = "123456",
                PasswordHash = "AQAAAAEAACcQAAAAEI3BSc0gbecYS0n/u7kn4aJCrTeXPGySz/wMzHi3gdN57pibjJ3i406RXptP4H2DBA==",
                SecurityStamp = Guid.NewGuid().ToString(),
                EmailConfirmed = false,
                CreatedById = null,
                CreatedAt = DateTime.Parse("2024-06-08T20:41:17.7392956"),
                LastModifiedBy = null,
                LastModified = DateTime.Parse("2024-06-11T11:59:11.8330444"),
                DeletedAt = null,
                CityId = 1,
                MentorId = null,
                SchoolId = 1,
            };
            var result = userManager.CreateAsync(mentor).Result;
            var roleResult = userManager.AddToRoleAsync(mentor, Roles.Mentor).Result;
            var user1 = new User
            {
                Id = "070935f5-9db0-46dd-98d0-7a2830f89277",
                Username = "safija_user3@hotmail.com",
                Email = "safija_user3@hotmail.com",
                FirstName = "Safija",
                LastName = "User 3",
                BirthDate = DateTime.Parse("2024-06-11"),
                Gender = Gender.Female,
                PhoneNumber = "123456",
                PasswordHash = "AQAAAAEAACcQAAAAEI3BSc0gbecYS0n/u7kn4aJCrTeXPGySz/wMzHi3gdN57pibjJ3i406RXptP4H2DBA==",
                SecurityStamp = Guid.NewGuid().ToString(),
                EmailConfirmed = false,
                CreatedById = null,
                CreatedAt = DateTime.Parse("2024-06-11T11:34:53.2171698"),
                LastModifiedBy = null,
                LastModified = DateTime.Parse("2024-06-11T11:35:19.1284920"),
                DeletedAt = null,
                CityId = 2,
                MentorId = "120842a7-ea9f-41ee-8739-d5858f9dfe89",
                SchoolId = 6
            };
             result = userManager.CreateAsync(user1).Result;
             roleResult = userManager.AddToRoleAsync(user1, Roles.Student).Result;
            var user2 = new User
            {
                Id = "20adb6d0-e597-452d-a1ea-27ab4e013bfc",
                Username = "safija_user7@hotmail.com",
                Email = "safija_user7@hotmail.com",
                FirstName = "Safija",
                LastName = "User 7",
                BirthDate = DateTime.Parse("2024-06-11"),
                Gender = Gender.Female,
                PhoneNumber = "123456",
                PasswordHash = "AQAAAAEAACcQAAAAEI3BSc0gbecYS0n/u7kn4aJCrTeXPGySz/wMzHi3gdN57pibjJ3i406RXptP4H2DBA==",
                SecurityStamp = Guid.NewGuid().ToString(),
                EmailConfirmed = false,
                CreatedById = null,
                CreatedAt = DateTime.Parse("2024-06-11T11:37:48.0849821"),
                LastModifiedBy = null,
                LastModified = DateTime.Parse("2024-06-11T11:37:48.1218973"),
                DeletedAt = null,
                CityId = 4,
                MentorId = "120842a7-ea9f-41ee-8739-d5858f9dfe89",
                SchoolId = 6
            };
            result = userManager.CreateAsync(user2).Result;
            roleResult = userManager.AddToRoleAsync(user2, Roles.Student).Result;
            var admin = new User
            {
                Id = "499196fe-d061-4d2b-8773-718c4fe431ea",
                Username = "safija_admin@hotmail.com",
                Email = "safija_admin@hotmail.com",
                FirstName = "Safija",
                LastName = "Hubljar",
                BirthDate = DateTime.Parse("2024-06-01T12:52:21.5160000"),
                Gender = Gender.Female,
                PhoneNumber = "123456",
                PasswordHash = "AQAAAAEAACcQAAAAEI3BSc0gbecYS0n/u7kn4aJCrTeXPGySz/wMzHi3gdN57pibjJ3i406RXptP4H2DBA==",
                SecurityStamp = Guid.NewGuid().ToString(),
                EmailConfirmed = false,
                CreatedById = null,
                CreatedAt = DateTime.Parse("2024-06-01T13:03:09.9051960"),
                LastModifiedBy = null,
                LastModified = DateTime.Parse("2024-06-01T13:03:15.7230865"),
                DeletedAt = null,
                CityId = null,
                MentorId = null,
                SchoolId = null
            };
            result = userManager.CreateAsync(admin).Result;
            roleResult = userManager.AddToRoleAsync(admin, Roles.Admin).Result;
            var user = new User
            {
                Id = "657dbebe-f4e7-43c0-99a1-487798b54c48",
                Username = "safija_user1@hotmail.com",
                Email = "safija_user1@hotmail.com",
                FirstName = "Safija",
                LastName = "User 1",
                BirthDate = DateTime.Parse("2024-06-11"),
                Gender = Gender.Female,
                PhoneNumber = "123456",
                PasswordHash = "AQAAAAEAACcQAAAAEI3BSc0gbecYS0n/u7kn4aJCrTeXPGySz/wMzHi3gdN57pibjJ3i406RXptP4H2DBA==",
                SecurityStamp = Guid.NewGuid().ToString(),
                EmailConfirmed = false,
                CreatedById = null,
                CreatedAt = DateTime.Parse("2024-06-11T11:33:52.6011618"),
                LastModifiedBy = null,
                LastModified = DateTime.Parse("2024-06-11T11:33:52.8975394"),
                DeletedAt = null,
                CityId = 2,
                MentorId = "120842a7-ea9f-41ee-8739-d5858f9dfe89",
                SchoolId = 1
            };
            result = userManager.CreateAsync(user).Result;
            roleResult = userManager.AddToRoleAsync(user, Roles.Student).Result;
            var user3 = new User
            {
                Id = "890721eb-4aac-48d0-bf11-fa8ff563de99",
                Username = "safija_user2@hotmail.com",
                Email = "safija_user2@hotmail.com",
                FirstName = "Safija",
                LastName = "User 2",
                BirthDate = DateTime.Parse("2024-06-11"),
                Gender = Gender.Female,
                PhoneNumber = "123456",
                PasswordHash = "AQAAAAEAACcQAAAAEI3BSc0gbecYS0n/u7kn4aJCrTeXPGySz/wMzHi3gdN57pibjJ3i406RXptP4H2DBA==",
                SecurityStamp = Guid.NewGuid().ToString(),
                EmailConfirmed = false,
                CreatedById = null,
                CreatedAt = DateTime.Parse("2024-06-11T11:34:25.0660649"),
                LastModifiedBy = null,
                LastModified = DateTime.Parse("2024-06-11T11:34:25.0916026"),
                DeletedAt = null,
                CityId = 6,
                MentorId = "120842a7-ea9f-41ee-8739-d5858f9dfe89",
                SchoolId = 2
            };
            result = userManager.CreateAsync(user3).Result;
            roleResult = userManager.AddToRoleAsync(user3, Roles.Student).Result;
           
          var user5 = new User
            {
                Id = "e268c8d0-f039-42f3-a37b-12599f56aad1",
                Username = "safija_user5@hotmail.com",
                Email = "safija_user5@hotmail.com",
                FirstName = "Safija",
                LastName = "User 5",
                BirthDate = DateTime.Parse("2024-06-11"),
                Gender = Gender.Female,
                PhoneNumber = "123456",
                PasswordHash = "AQAAAAEAACcQAAAAEI3BSc0gbecYS0n/u7kn4aJCrTeXPGySz/wMzHi3gdN57pibjJ3i406RXptP4H2DBA==",
                SecurityStamp = Guid.NewGuid().ToString(),
                EmailConfirmed = false,
                CreatedById = null,
                CreatedAt = DateTime.Parse("2024-06-11T11:36:28.7697258"),
                LastModifiedBy = null,
                LastModified = DateTime.Parse("2024-06-11T11:36:28.7871762"),
                DeletedAt = null,
                CityId = 7,
                MentorId = "AQAAAAEAACcQAAAAEI3BSc0gbecYS0n/u7kn4aJCrTeXPGySz/wMzHi3gdN57pibjJ3i406RXptP4H2DBA==",
                SchoolId = 2
            };
            result = userManager.CreateAsync(user5).Result;
            roleResult = userManager.AddToRoleAsync(user5, Roles.Student).Result;
        }
        private static void SeedPayments(AppDbContext context)
        {
            var sqlCommand = @"
    SET IDENTITY_INSERT Payments ON;

    INSERT INTO Payments (Id, Notes, Amount, Month, Year, StudentId, CreatedById, CreatedAt, LastModifiedBy, LastModified, DeletedAt) VALUES
    (1, N'Notes 1', 100, 1, 2024, N'070935f5-9db0-46dd-98d0-7a2830f89277', NULL, CAST(N'2024-06-11T11:42:49.4776995' AS DateTime2), NULL, NULL, NULL),
    (2, N'Notes 2', 200, 2, 2024, N'20adb6d0-e597-452d-a1ea-27ab4e013bfc', NULL, CAST(N'2024-06-11T11:43:03.8203352' AS DateTime2), NULL, NULL, NULL);

    SET IDENTITY_INSERT Payments OFF;";

            context.Database.ExecuteSqlRaw(sqlCommand);
        }
        private static void SeedVolunteeringAnnouncements(AppDbContext context)
        {
            var sqlCommand = @"
    SET IDENTITY_INSERT VolunteeringAnnouncements ON;

    INSERT INTO VolunteeringAnnouncements (Id, Place, AnnouncementStatusId, CityId, MentorId, TimeFrom, TimeTo, Date, Notes, CreatedById, CreatedAt, LastModifiedBy, LastModified, DeletedAt, Reason) VALUES
    (1, N'Dom kulture', 1, 1, N'120842a7-ea9f-41ee-8739-d5858f9dfe89', N'11:00', N'16:00', CAST(N'2024-07-11T00:00:00.0000000' AS DateTime2), N'Rad sa volonterima', NULL, CAST(N'2024-06-10T23:01:23.3017403' AS DateTime2), NULL, CAST(N'2024-06-10T23:01:37.0509171' AS DateTime2), NULL, NULL),
    (2, N'Dom kulture', 2, 6, N'120842a7-ea9f-41ee-8739-d5858f9dfe89', N'09:00', N'16:00', CAST(N'2024-06-10T00:00:00.0000000' AS DateTime2), N'Rad sa volonterima', NULL, CAST(N'2024-06-10T23:02:22.0928125' AS DateTime2), NULL, CAST(N'2024-06-11T11:38:07.7320744' AS DateTime2), NULL, NULL),
    (3, N'Dom kulture', 3, 2, N'120842a7-ea9f-41ee-8739-d5858f9dfe89', N'09:00', N'18:00', CAST(N'2024-07-09T00:00:00.0000000' AS DateTime2), N'Rad sa volonterima', NULL, CAST(N'2024-06-10T23:03:04.1332353' AS DateTime2), NULL, CAST(N'2024-06-11T11:38:30.7243218' AS DateTime2), NULL, N'Please correct date');

    SET IDENTITY_INSERT VolunteeringAnnouncements OFF;";

            context.Database.ExecuteSqlRaw(sqlCommand);
        }

        private static void SeedEvents(AppDbContext context)
        {
            var sqlCommand = @"
                SET IDENTITY_INSERT CompanyEvent ON;

                INSERT INTO CompanyEvent (Id, CompanyId, EventName, EventDate, Location, Time, CreatedById, CreatedAt, LastModifiedBy, LastModified, DeletedAt)
                VALUES
                (1, 3, N'Tech Innovations Summit 2024', CAST(N'2024-11-30T00:00:00.0000000' AS DateTime2), N'San Francisco, CA', N'11:00', NULL, CAST(N'2024-06-10T17:40:34.3556190' AS DateTime2), NULL, NULL, NULL),
                (2, 4, N'FutureTech Expo', CAST(N'2024-12-20T00:00:00.0000000' AS DateTime2), N'New York, NY', N'12:00', NULL, CAST(N'2024-06-10T17:41:10.6460113' AS DateTime2), NULL, NULL, NULL);
                SET IDENTITY_INSERT VolunteeringAnnouncements OFF;";
            context.Database.ExecuteSqlRaw(sqlCommand);
        }

    }

}

