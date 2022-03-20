public with sharing class SubToDoController {
    @AuraEnabled(cacheable=true)
    public static List<Sub_ToDo__c> getAllSubToDos(Id toDoId) {
        return [SELECT Name, ToDo__c, Is_Done__c FROM Sub_ToDo__c WHERE ToDo__c = :toDoId WITH SECURITY_ENFORCED];
    }
}