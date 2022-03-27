trigger ToDoTrigger on ToDo__c (after insert, after update, after delete) {
    if (Trigger.isInsert) {
        Set<Id> listIds = Trigger.newMap.keySet();
        // System.debug('trigger insert listIds: ' + listIds);
        for (Id todoId : Trigger.newMap.keySet()) {
            // future post
            FutureToDoCallouts.postToDo(todoId);
        }
    }
    if (Trigger.isUpdate) {
        Set<Id> listIds = Trigger.newMap.keySet();
        // System.debug('trigger update listIds: ' + listIds);
        // for (Id todoId : Trigger.newMap.keySet()) {
        for(Id todoId : listIds) {
            // future patch
            FutureToDoCallouts.patchToDo(todoId);
        }
    }
    if (Trigger.isDelete) {
        Set<Id> listIds = Trigger.oldMap.keySet();
        // System.debug('trigger delete listIds: ' + listIds);
        for(Id todoId : listIds) {
            // future delete
            FutureToDoCallouts.deleteToDo(todoId);
        }
    }
}