public with sharing class ToDoController {
    @AuraEnabled(cacheable=true)
    public static List<ToDo__c> getAllToDos() {
        return [SELECT Id, Name, Status__c, RecordTypeId FROM ToDo__c WITH SECURITY_ENFORCED];
    }
}
