public with sharing class ToDoController {
    @AuraEnabled(cacheable=true)
    public static List<ToDo__c> getAllToDos() {
        return [SELECT Id, Name, Status__c, RecordTypeId FROM ToDo__c WITH SECURITY_ENFORCED];
    }
    
    @AuraEnabled(cacheable=true)
    public static ToDo__c getToDoByName(String name) {
        List<ToDo__c> toDos = [SELECT Id, Name, Status__c, RecordTypeId FROM ToDo__c WHERE name = :name WITH SECURITY_ENFORCED];
        if (toDos.size() >= 1) {
            return toDos[0];
        } else {
            return new ToDo__c();
        }
    }
}