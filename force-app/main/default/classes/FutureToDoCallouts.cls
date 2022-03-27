public with sharing class FutureToDoCallouts {
    @future(callout=true)
    public static void postToDo(String todoId)
    {
        ToDo__c todo = [SELECT Name, Status__c, (SELECT Name, Is_Done__c, ToDo__c  FROM Sub_ToDos__r) FROM ToDo__c WHERE Id = :todoId];
        // callout post
        String todoJson = JSON.serialize(todo);
        HttpResponse resp = ToDoRestCallouts.postToDo(todoJson);
    }
    @future(callout=true)
    public static void putToDo(String todoId)
    {
        ToDo__c todo = [SELECT Name, Status__c, (SELECT Name, Is_Done__c, ToDo__c  FROM Sub_ToDos__r) FROM ToDo__c WHERE Id = :todoId];
        // callout put
        String todoJson = JSON.serialize(todo);
        HttpResponse resp = ToDoRestCallouts.putToDo(todoJson);
    }
    @future(callout=true)
    public static void patchToDo(String todoId)
    {
        ToDo__c todo = [SELECT Name, Status__c FROM ToDo__c WHERE Id = :todoId];
        // object serialization
        String todoJson = JSON.serialize(todo);
        // callout patch
        HttpResponse resp = ToDoRestCallouts.patchToDo(todoId, todoJson);
    }
    @future(callout=true)
    public static void deleteToDo(String todoId)
    {
        // callout delete
        HttpResponse resp = ToDoRestCallouts.deleteToDo(todoId);
    }
}
