@isTest
public class TestWeatherTrackController {

    @isTest static void testCreateWeatherTrack() {

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new WeatherTrackMock());
        Account acc = new Account(Name='Account', BillingCity='New York');
        insert acc;
        List<Id> accountsIds = new List<Id>();
        accountsIds.add(acc.Id);
        WeatherTrackController.createWeatherTracker(accountsIds);
        Test.stopTest();

        Integer actual = [SELECT COUNT() FROM Weather_Track__c WHERE Description__c = 'clear sky' AND Humidity__c = '1023'];
        System.assertEquals(1, actual, 'Should be 1 created Weather Track with Description - clear sky, and Humidity - 1023');
    }
}
