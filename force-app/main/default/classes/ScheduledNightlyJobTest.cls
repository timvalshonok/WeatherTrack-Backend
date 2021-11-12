@isTest
private class ScheduledNightlyJobTest {
    static testMethod void scheduledNightlyJobTest() {
        test.startTest();
        ScheduledNightlyJob testClass = new ScheduledNightlyJob ();   
        String cron = '0 0 23 * * ?';        
        System.schedule('Test Schedule', cron, testClass);
        test.stopTest();    
    }
}
