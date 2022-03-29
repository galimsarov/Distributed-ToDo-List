public with sharing class FutureToDoCallouts {
    @future(callout=true)
    public static void postToDo(List<Id> listId)
    {
        for (Id todoId : listId) {
            String todoJson = todoToJson(todoId);
            // callout post
            HttpResponse resp = ToDoRestCallouts.postToDo(todoJson);
        }
    }
    @future(callout=true)
    public static void putToDo(List<Id> listId)
    {
        for (Id todoId : listId) {
            String todoJson = todoToJson(todoId);
            // callout put
            HttpResponse resp = ToDoRestCallouts.putToDo(todoJson);
        }
    }
    @future(callout=true)
    public static void patchToDo(List<Id> listId)
    {
        for (Id todoId : listId) {
            ToDo__c todo = [SELECT Name, Status__c FROM ToDo__c WHERE Id = :todoId];
            // object serialization
            String todoJson = JSON.serialize(todo);
            // callout patch
            HttpResponse resp = ToDoRestCallouts.patchToDo(todoId, todoJson);
        }
    }
    @future(callout=true)
    public static void deleteToDo(List<Id> listId)
    {
        for (Id todoId : listId) {
            // callout delete
            HttpResponse resp = ToDoRestCallouts.deleteToDo(todoId);
        }
    }
    // helper
    static String todoToJson(String todoId) {
        ToDo__c todo = [SELECT Name, Status__c, ExtId__c, (SELECT Name, Is_Done__c, ToDo__c, ExtId__c  FROM Sub_ToDos__r) FROM ToDo__c WHERE Id = :todoId];
        String todoJson = JSON.serialize(todo);
        return todoJson;
    }
}
