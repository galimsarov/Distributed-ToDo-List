public with sharing class FutureSubToDoCallouts {
    @future(callout=true)
    public static void postSubToDo(String subTodoId)
    {
        Sub_ToDo__c subTodo = [SELECT Id, Name, Is_Done__c, ToDo__c  FROM Sub_ToDo__c WHERE Id = :subTodoId];
        // callout post
        String subTodoJson = JSON.serialize(subTodo);
        HttpResponse resp = SubTodoRestCallouts.postSubTodo(subTodoJson);
    }
    @future(callout=true)
    public static void putSubToDo(String subTodoId)
    {
        Sub_ToDo__c subTodo = [SELECT Id, Name, Is_Done__c, ToDo__c  FROM Sub_ToDo__c WHERE Id = :subTodoId];
        // callout put
        String subTodoJson = JSON.serialize(subTodo);
        HttpResponse resp = SubTodoRestCallouts.putSubTodo(subTodoJson);
    }
    @future(callout=true)
    public static void patchSubToDo(String subTodoId)
    {
        Sub_ToDo__c subTodo = [SELECT Id, Name, Is_Done__c, ToDo__c  FROM Sub_ToDo__c WHERE Id = :subTodoId];
        // object serialization
        String subTodoJson = JSON.serialize(subTodo);
        // callout patch
        HttpResponse resp = SubTodoRestCallouts.patchSubTodo(subTodoId, subTodoJson);
    }
    @future(callout=true)
    public static void deleteSubToDo(String subTodoId)
    {
        // callout delete
        HttpResponse resp = SubTodoRestCallouts.deleteSubTodo(subTodoId);
    }
}
