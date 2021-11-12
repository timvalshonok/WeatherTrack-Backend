@isTest
private class AccountTriggerTest {
    @isTest static void createAccountTest() {
        Account acc = new Account(Name='Test Account', BillingCity='Paris');
        
        Test.startTest();
        insert acc;
        Test.stopTest();
        
        List<Weather_Track__c> tracker = [SELECT Account__c FROM Weather_Track__c WHERE Account__c = :acc.Id LIMIT 1];
        System.assertEquals(acc.Id, tracker[0].Account__c, 'Should be create tracker with Account__c equal to acc.Id');
    }

    @isTest static void changeAccountBillingCityTest() {
        Account acc = new Account(Name='Test Account', BillingCity='Paris');
        insert acc;

        Test.startTest();
        acc.BillingCity = 'New York';
        update acc;
        Test.stopTest();

        Integer trackers = [SELECT COUNT() FROM Weather_Track__c WHERE Account__c = :acc.Id];
        System.assertEquals(2, trackers, 'Should be 2 Weather Tracks with Account__c equals to acc.Id');
    }
}
