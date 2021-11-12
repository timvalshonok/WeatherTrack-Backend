public class WeatherTrackNightlyJob implements Database.Batchable<sObject>, Database.AllowsCallouts, Database.Stateful {
    
    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(
            'SELECT Id, BillingCity FROM Account WHERE BillingCity != null'
        );
    }

    public void execute(Database.BatchableContext bc, List<Account> accs) {
        List<Id> accsIds = new List<Id>();

        for(Account acc : accs) {
            List<Weather_Track__c> trackers = [
                SELECT Id, Account__c, Date__c
                FROM Weather_Track__c
                WHERE Account__c = :acc.Id
            ];
            if(trackers.size() == 0) {
                accsIds.add(acc.Id);
            }
            if((trackers.size() != 0) && trackers[0].Date__c == System.today()) {
                continue;
            }
            else {
                accsIds.add(acc.Id);
            }
        }
        if(accsIds.size() != 0) {
            List<Account> accountsList = [
            SELECT Id, BillingCity FROM Account WHERE Id IN :accsIds AND BillingCity != null
            ];
            List<Weather_Track__c> weatherTrackers = new List<Weather_Track__c>();

            for (Account acc : accountsList) {
                String apiKey = '66e898cb6656efddfccd3afa1e8e8908';
                String reqEndPoint = 'http://api.openweathermap.org/data/2.5/weather';
                reqEndPoint += '?q='+acc.BillingCity;
                reqEndPoint += '&units=metric';
                reqEndPoint += '&APPID='+apiKey;

                Http http = new Http();
                HttpRequest request = new HttpRequest();
                request.setEndpoint(reqEndPoint);
                request.setMethod('GET'); 
                request.setTimeout(5000);
                try {
                    HttpResponse res = http.send(request);
                    String responseBody = res.getBody();
                    if(res.getStatusCode() == 200) {
                        Map<String,Object> responseMap = (Map<String,object>)JSON.deserializeUntyped(responseBody);
                        Map<String,Object> mainMap = (Map<String,Object>)responseMap.get('main');
                        Integer temp = Integer.valueOf(mainMap.get('temp'));
                        String pressure = String.valueOf(mainMap.get('pressure'));
                        Integer humidity = Integer.valueOf(mainMap.get('humidity'));
                        List<Object> weatherList = (List<Object>)responseMap.get('weather');
                        Map<String,Object> weatherInfo = (Map<String,Object>)weatherList[0];
                        String description = String.valueOf(weatherInfo.get('description'));    
                        
                        Weather_Track__c tracker = new Weather_Track__c(
                            Temp_C__c = temp,
                            Pressure__c = pressure,
                            Humidity__c = humidity,
                            Description__c = description,
                            Account__c = acc.Id,
                            Date__c = Date.today()
                        );
                        weatherTrackers.add(tracker);
                    }
                } catch(DmlException e) {
                    System.debug(e.getMessage());
                }
            }
            insert weatherTrackers;
        }
    }
    
    public void finish(Database.BatchableContext bc) {
        System.debug('weather trackers updated');
    }
}
