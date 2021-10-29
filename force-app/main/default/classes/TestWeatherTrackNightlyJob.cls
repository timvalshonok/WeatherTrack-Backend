@isTest
public class TestWeatherTrackNightlyJob {

    @isTest static void testWeatherTrackNightlyJob_positive() {
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new WeatherTrackMock());
        WeatherTrackNightlyJob nj = new WeatherTrackNightlyJob();
        Account acc = new Account(Name='Account', BillingCity='New York');
        insert acc;
        Database.executeBatch(nj);
        Test.stopTest();

        Integer actual = [SELECT COUNT() FROM Weather_Track__c WHERE Description__c = 'clear sky' AND Humidity__c = '1023'];
        System.assertEquals(1, actual, 'Should be 1 record with Description - clear sky, and Humidity - 1023');
    }

    @isTest static void testWeatherTrackNightlyJob_negative() {
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new WeatherTrackMock());
        WeatherTrackNightlyJob nj = new WeatherTrackNightlyJob();
        Account acc = new Account(Name='Account', BillingCity='New York');
        insert acc;
        Weather_Track__c wt = new Weather_Track__c(Date__c=System.today(), Account__c=acct.Id);
        insert wt;
        Database.executeBatch(nj);
        test.stopTest();

        Integer actual = [SELECT COUNT() FROM Weather_Track__c WHERE Description__c = 'clear sky' AND Humidity__c = '1023'];
        System.assertEquals(0, actual, 'There should be no records since the specified date is System.today()');
    }
}