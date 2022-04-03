public with sharing class ToDoTriggerHandler {
    public static void insertHandler(List<Id> listId) {
        // select only source ToDo
        Map<Id, ToDo__c> mapToDos = new Map<Id, ToDo__c>(
            [SELECT Id, ExtId__c FROM ToDo__c
            WHERE Id IN :listId
            AND ExtId__c = NULL]
            );
        List<Id> Ids = new List<Id>(mapToDos.keySet());
        // call async future method
        FutureToDoCallouts.postToDo(Ids);
    }
    public static void updateHandler(List<Id> listId) {
        // call async future method
        FutureToDoCallouts.patchToDo(listId);
    }
    public static void deleteHandler(List<ToDo__c> listTodo) {
        List<Id> listId = new List<Id>();
        // select origin Id for callout
        for (ToDo__c todo : listTodo) {
            Id originId = (todo.ExtId__c != null) ? todo.ExtId__c : todo.Id;
            listId.add(originId);
        }
        // call async future method
        FutureToDoCallouts.deleteToDo(listId);
    }
}
