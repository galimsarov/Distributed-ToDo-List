trigger ToDoTrigger on ToDo__c (after insert, after update, before delete) {
    if (Trigger.isInsert) {
        List<Id> listId = new List<Id>(Trigger.newMap.keySet());
        ToDoTriggerHandler.insertHandler(listId);
    }
    if (Trigger.isUpdate) {
        // get url of trigger initiator (internal or external)
        String urlPath = System.URL.getCurrentRequestUrl().getPath().toLowerCase();
        // only pass records to handler if trigger initiator is internal
        if(!urlPath.startsWithIgnoreCase('/services/apexrest/')) {
            List<Id> listId = new List<Id>(Trigger.newMap.keySet());
            ToDoTriggerHandler.updateHandler(listId);
        }
    }
    if (Trigger.isDelete) {
        // get url of trigger initiator (internal or external)
        String urlPath = System.URL.getCurrentRequestUrl().getPath().toLowerCase();
        // only pass records to handler if trigger initiator is internal
        if(!urlPath.startsWithIgnoreCase('/services/apexrest/')) {
            List<ToDo__c> listTodo = new List<ToDo__c>(Trigger.oldMap.values());
            ToDoTriggerHandler.deleteHandler(listTodo);
        }
    }
}