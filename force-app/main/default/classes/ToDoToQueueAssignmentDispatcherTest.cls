@isTest
private class ToDoToQueueAssignmentDispatcherTest {
    private static String toDoName = 'Test';
    private static String tomorrowRecordTypeName = 'Tomorrow';
    private static Id laterToDosQueueId = ToDoToQueueAssignmentDispatcherHandler.getLaterToDosQueueId();
    private static Id tomorrowToDosQueueId = ToDoToQueueAssignmentDispatcherHandler.getTomorrowToDosQueueId();
    private static List<RecordType> recordTypes = ToDoToQueueAssignmentDispatcherHandler.recordTypes;

    @isTest
    private static void testAssignmentForCreatingToDos() {
        ToDo__c newToDo = new ToDo__c(Name = toDoName);    
        Test.startTest();
        insert newToDo;
        Test.stopTest();
        List<ToDo__c> toDos = [SELECT Name, OwnerId, RecordTypeId FROM ToDo__c WHERE Name = :toDoName];
        if (toDos.size() > 0) {
            System.assertEquals(laterToDosQueueId, toDos[0].OwnerId);
        }
    }
    
    @isTest
    private static void testAssignmentForUpdatingToDos() {
        ToDo__c newToDo = new ToDo__c(Name = toDoName);        
        insert newToDo;        
        newToDo.RecordTypeId = getTomorrowRecordTypeId();
        Test.startTest();
        update newToDo;
        Test.stopTest();        
        List<ToDo__c> toDos = [SELECT Name, OwnerId, RecordTypeId FROM ToDo__c WHERE Name = :toDoName];
        if (toDos.size() > 0) {
            System.assertEquals(tomorrowToDosQueueId, toDos[0].OwnerId);
        }
    }
    
    private static Id getTomorrowRecordTypeId() {
        for (RecordType recordType: recordTypes) {
            if (recordType.Name == tomorrowRecordTypeName) {
                return recordType.Id;
            }
        }
        return null;
    }
}