trigger SubToDoTrigger on Sub_ToDo__c (after insert, after update, after delete) {
    if (Trigger.isInsert) {
        List<Id> listId = new List<Id>(Trigger.newMap.keySet());
        SubToDoTriggerHandler.insertHandler(listId);
    }
    if (Trigger.isUpdate) {
        // get url of trigger initiator (internal or external)
        String urlPath = System.URL.getCurrentRequestUrl().getPath().toLowerCase();
        // only pass records to handler if trigger initiator is internal
        if(!urlPath.startsWithIgnoreCase('/services/apexrest/')) {
            List<Id> listId = new List<Id>(Trigger.newMap.keySet());
            SubToDoTriggerHandler.updateHandler(listId);
        }
    }
    if (Trigger.isDelete) {
        // get url of trigger initiator (internal or external)
        String urlPath = System.URL.getCurrentRequestUrl().getPath().toLowerCase();
        // only pass records to handler if trigger initiator is internal
        if(!urlPath.startsWithIgnoreCase('/services/apexrest/')) {
            List<Sub_ToDo__c> listSubTodo = new List<Sub_ToDo__c>(Trigger.oldMap.values());
            SubToDoTriggerHandler.deleteHandler(listSubTodo);
        }
    }
}