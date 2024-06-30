namespace RadVolonteraDodatni.Database
{
    public class Monitoring
    {
        public long Id { get; set; }
        public string Notes { get; set; }
        public string MentorId { get; set; }
        public User Mentor { get; set; }
        public DateTime Date { get; set; }
        public string Url { get; set; }
    }
}
