trigger SubToDoTrigger on Sub_ToDo__c (after insert, after update, after delete) {
    if (Trigger.isInsert) {
        Set<Id> listIds = Trigger.newMap.keySet();
        // System.debug('sub trigger insert listIds: ' + listIds);
        for (Id subTodoId : Trigger.newMap.keySet()) {
            // future post
            FutureSubToDoCallouts.postSubToDo(subTodoId);
        }
    }
    if (Trigger.isUpdate) {
        Set<Id> listIds = Trigger.newMap.keySet();
        // System.debug('sub trigger update listIds: ' + listIds);
        // for (Id todoId : Trigger.newMap.keySet()) {
        for(Id subTodoId : listIds) {
            // future patch
            FutureSubToDoCallouts.patchSubToDo(subTodoId);
        }
    }
    if (Trigger.isDelete) {
        Set<Id> listIds = Trigger.oldMap.keySet();
        // System.debug('sub trigger delete listIds: ' + listIds);
        for(Id subTodoId : listIds) {
            // future delete
            FutureSubToDoCallouts.deleteSubToDo(subTodoId);
        }
    }
}