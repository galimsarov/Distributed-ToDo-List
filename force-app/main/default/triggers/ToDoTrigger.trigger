trigger ToDoTrigger on ToDo__c (after insert, after update, before delete) {
    if (!TriggerControl.isBypassToDoTrigger) {
        // get url of trigger initiator (internal or external)
        String urlPath = System.URL.getCurrentRequestUrl().getPath().toLowerCase();
        // System.debug('Trigger urlPath: ' + urlPath);
        // only pass records to handler if trigger initiator is internal
        if(!urlPath.startsWithIgnoreCase('/services/apexrest/')) {
            if (Trigger.isInsert) {
                List<Id> listId = new List<Id>(Trigger.newMap.keySet());
                ToDoTriggerHandler.insertHandler(listId);
            }
            if (Trigger.isUpdate) {
                List<Id> listId = new List<Id>(Trigger.newMap.keySet());
                ToDoTriggerHandler.updateHandler(listId);
            }
            if (Trigger.isDelete) {
                List<ToDo__c> listTodo = new List<ToDo__c>(Trigger.oldMap.values());
                ToDoTriggerHandler.deleteHandler(listTodo);
            }
        }
    }
}