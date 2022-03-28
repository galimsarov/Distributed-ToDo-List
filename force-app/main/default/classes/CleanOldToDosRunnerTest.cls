@isTest
public class CleanOldToDosRunnerTest {
    private static Integer toDosCount = 10;
    private static String CRON_EXP = '0 0 0 1 4 ? 2022';
    
    @isTest
    private static void runCleaningTest() {
        Test.startTest();
        String jobId = System.schedule('ScheduledApexTest', CRON_EXP, new CleanOldToDosRunner());
        Test.stopTest();
        System.debug(jobId);
    }
}