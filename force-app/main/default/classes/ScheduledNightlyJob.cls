public class ScheduledNightlyJob implements Schedulable {
    
    public void execute(SchedulableContext ctx) {
        WeatherTrackNightlyJob c = new WeatherTrackNightlyJob();
            database.executeBatch(c);
    }
}
