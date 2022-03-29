public with sharing class FutureSubToDoCallouts {
    @future(callout=true)
    public static void postSubToDo(List<Id> listId)
    {
        for (Id subTodoId : listId) {
            String subTodoJson = subTodoToJson(subTodoId);
            // callout post
            HttpResponse resp = SubTodoRestCallouts.postSubTodo(subTodoJson);
        }
    }
    @future(callout=true)
    public static void putSubToDo(List<Id> listId)
    {
        for (Id subTodoId : listId) {
            String subTodoJson = subTodoToJson(subTodoId);
            // callout put
            HttpResponse resp = SubTodoRestCallouts.putSubTodo(subTodoJson);
        }
    }
    @future(callout=true)
    // public static void patchSubToDo(String subTodoId)
    public static void patchSubToDo(List<Id> listId)
    {
        for (Id subTodoId : listId) {
            String subTodoJson = subTodoToJson(subTodoId);
            // callout patch
            HttpResponse resp = SubTodoRestCallouts.patchSubTodo(subTodoId, subTodoJson);
        }
    }
    @future(callout=true)
    public static void deleteSubToDo(List<Id> listId)
    {
        for (Id subTodoId : listId) {
            // callout delete
            HttpResponse resp = SubTodoRestCallouts.deleteSubTodo(subTodoId);
        }
    }
    // helper
    static String subTodoToJson(String subTodoId) {
        Sub_ToDo__c subTodo = [SELECT Id, Name, Is_Done__c, ToDo__c, ExtId__c, ToDo__r.ExtId__c  FROM Sub_ToDo__c WHERE Id = :subTodoId];
        String subTodoJson = JSON.serialize(subTodo);
        return subTodoJson;
    }
}
