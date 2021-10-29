public inherited sharing class WeatherTrackController {

    @future(callout=true)
    public static void createWeatherTracker(List<Id> accountsIds) {
        List<Account> accountsList = [
            SELECT Id, BillingCity FROM Account WHERE Id IN :accountsIds AND BillingCity != null
        ];

        for (Account acc : accountsList){
            String apiKey = '66e898cb6656efddfccd3afa1e8e8908';
            String reqEndPoint = 'http://api.openweathermap.org/data/2.5/weather';
            reqEndPoint += '?q='+acc.BillingCity;
            reqEndPoint += '&units=metric';
            reqEndPoint += '&APPID='+apiKey;
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint(reqEndPoint);
            request.setMethod('GET'); 
            HttpResponse res = http.send(request);
            String responseBody = res.getBody();
            System.debug(responseBody);
            if(res.getStatusCode() == 200){
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
                insert tracker;
            } else {
                System.debug(res.getBody());
            }
        }
    }
}
