using AutoMapper;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;
using Microsoft.ML;
using Microsoft.ML.Data;
using Microsoft.ML.Trainers;
using RadVolontera.Models.Filters;
using RadVolontera.Services.Database;
using RadVolontera.Services.Interfaces;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RadVolontera.Services.Services
{
    public class RecommenderService : IRecommenderService
    {
        protected AppDbContext _context;
        protected IMapper _mapper { get; set; }

        public RecommenderService(AppDbContext context, IMapper mapper)
        {
            _context = context;
            _mapper = mapper;
        }

        static MLContext mlContext = null;
        static object isLocked = new object();
        static ITransformer model = null;

        public List<UserEventEntry> GetUserEventData(string mentorId)
        {
            var data = new List<UserEventEntry>();

            var userEvents = _context.CompanyEvent
                .Include(u => u.Mentors)
                .Where(u => u.Mentors.Any(c => c.Id == mentorId)).ToList();

            foreach (var ue in userEvents)
            {
                data.Add(new UserEventEntry()
                {
                    CoEventID = (uint)ue.Id,
                    EventID = (uint)ue.Id,
                    Label = 1
                });
            }

            return data;
        }

        public List<RadVolontera.Models.CompanyEvent.CompanyEvent> TrainRecommendationModel(string mentorId, long eventId)
        {
            lock (isLocked)
            {
                if (mlContext == null)
                {
                    mlContext = new MLContext();
                    var data = GetUserEventData(mentorId);

                    var trainData = mlContext.Data.LoadFromEnumerable(data);

                    var options = new MatrixFactorizationTrainer.Options
                    {
                        MatrixColumnIndexColumnName = nameof(UserEventEntry.EventID),
                        MatrixRowIndexColumnName = nameof(UserEventEntry.CoEventID),
                        LabelColumnName = "Label",
                        LossFunction = MatrixFactorizationTrainer.LossFunctionType.SquareLossOneClass,
                        Alpha = 0.01f,
                        Lambda = 0.025f,
                        NumberOfIterations = 100,
                        C = 0.00001f
                    };

                    var estimator = mlContext.Recommendation().Trainers.MatrixFactorization(options);

                    model = estimator.Fit(trainData);

                    return this.RecommendEvents(mentorId, eventId);
                }

            }
            return _mapper.Map<List<RadVolontera.Models.CompanyEvent.CompanyEvent>>(new List<RadVolontera.Models.CompanyEvent.CompanyEvent>());
        }

        public List<RadVolontera.Models.CompanyEvent.CompanyEvent> RecommendEvents(string userId, long eventId)
        {
            var events = _context.CompanyEvent.Where(e => e.Id != eventId).ToList();
            var predictionResults = new List<Tuple<CompanyEvent, float>>();

            var registeredEvents = _context.Users
                .Include(c=>c.CompanyEvents)
                .Where(eu => eu.Id == userId)
                .Select(eu => eu.CompanyEvents)
                .SelectMany(e=>e.Select(e=>e.Id))
                .ToList();

            foreach (var e in events)
            {
                if (!registeredEvents.Contains(e.Id)) // Exclude events the user is already registered for
                {
                    var predictionEngine = mlContext.Model.CreatePredictionEngine<UserEventEntry, EventPrediction>(model);
                    var prediction = predictionEngine.Predict(new UserEventEntry
                    {
                        CoEventID = (uint)e.Id,
                        EventID = (uint)eventId
                    });

                    predictionResults.Add(new Tuple<CompanyEvent, float>(e, prediction.Score));
                }
            }

            var recommendedEvents = predictionResults
                .OrderByDescending(x => x.Item2)
                .Take(2)
                .Select(x => x.Item1)
                .ToList();

            return _mapper.Map<List<RadVolontera.Models.CompanyEvent.CompanyEvent>>(recommendedEvents);
        }

        public class EventPrediction
        {
            public float Score { get; set; }
        }
    }

    public class UserEventEntry
    {
        [KeyType(count: 10)]
        public uint EventID { get; set; }

        [KeyType(count: 10)]
        public uint CoEventID { get; set; }

        public float Label { get; set; }  // This can be 1 if the user attended the event, otherwise 0
    }
}
