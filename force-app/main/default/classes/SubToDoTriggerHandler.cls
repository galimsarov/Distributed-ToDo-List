public with sharing class SubToDoTriggerHandler {
    public static void insertHandler(List<Id> listId) {
        // select only source SubToDo
        Map<Id, Sub_ToDo__c> mapSubTodos = new Map<Id, Sub_ToDo__c>(
            [SELECT Id, ExtId__c FROM Sub_ToDo__c
            WHERE Id IN :listId
            AND ExtId__c = NULL]
            );
        List<Id> Ids = new List<Id>(mapSubTodos.keySet());
        // call async future method
        FutureSubToDoCallouts.postSubToDo(Ids);
    }
    public static void updateHandler(List<Id> listId) {
        // call async future method
        FutureSubToDoCallouts.patchSubToDo(listId);
    }
    public static void deleteHandler(List<Sub_ToDo__c> listSubTodo) {
        List<Id> listId = new List<Id>();
        // select origin Id for callout
        for (Sub_ToDo__c subTodo : listSubTodo) {
            Id originId = (subTodo.ExtId__c != null) ? subTodo.ExtId__c : subTodo.Id;
            listId.add(originId);
        }
        // call async future method
        FutureSubToDoCallouts.deleteSubToDo(listId);
    }
}
