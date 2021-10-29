trigger AccountTrigger on Account (after insert, after update) {
    List<Id> accountsIds = new List<Id>();

    if(Trigger.isUpdate || Trigger.isInsert) {
        for(Account acc : Trigger.new){
            accountsIds.add(acc.Id);
            if(accountsIds.size() == 20){
                WeatherTrackController.createWeatherTracker(accountsIds);
                accountsIds.clear();
            }
        }
        if(accountsIds.size() != 0){
            WeatherTrackController.createWeatherTracker(accountsIds);
            accountsIds.clear();
        }
    }
}