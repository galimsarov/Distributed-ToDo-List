@isTest
private class CleanOldToDosTest {
    private static Integer toDosCount = 10;
    
    @testSetup
    private static void setup() {
        List<ToDo__c> toDos = new List<ToDo__c>();
        for (Integer i = 1; i <= toDosCount; i++) {
            toDos.add(new ToDo__c(Name = 'Test ' + i));
        }
        insert toDos;
    }
    
    @isTest
    private static void cleaningTest() {
        System.assertEquals(toDosCount, [SELECT Name FROM ToDo__c].size());
        Test.startTest();
        CleanOldToDos cot = new CleanOldToDos();
        Id batchId = Database.executeBatch(cot);
        Test.stopTest();
        // Данный вариант раскомментировать при проведении тестов с целью проверки исполнения CleanOldToDos.execute
        // System.assertEquals(0, [SELECT Name FROM ToDo__c].size());
        System.assertEquals(10, [SELECT Name FROM ToDo__c].size());
    }
}