public with sharing class FutureToDoCallouts {
    @future(callout=true)
    public static void postToDo(List<Id> listId)
    {
        for (Id todoId : listId) {
            try {
                String todoJson = todoToJson(todoId);
                // callout post
                HttpResponse resp = ToDoRestCallouts.postToDo(todoJson);
            } catch(Exception e) {
                System.debug('FutureToDoCallouts.postToDo: exception caught: ' + e.getMessage());
            }
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
            // object serialization
            String todoJson = todoToJson(todoId);
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
        ToDo__c todo = [SELECT Name, Status__c, ExtId__c, RecordType.Name FROM ToDo__c WHERE Id = :todoId];
        // object serialization
        String todoJson = RestUtility.objJsonGen(todo);
        return todoJson;
    }
}
