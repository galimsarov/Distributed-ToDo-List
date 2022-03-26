trigger ToDoToQueueAssignmentDispatcher on ToDo__c (before insert, before update) {
    if (Trigger.isInsert) {
        ToDoToQueueAssignmentDispatcherHandler.assignToDosToQueue(Trigger.new);
    }
    if (Trigger.isUpdate) {
        List<ToDo__c> toDos = new List<ToDo__c>();
        for (Id toDoId: Trigger.newMap.keySet()) {
            if (Trigger.oldMap.get(toDoId).RecordTypeId != Trigger.newMap.get(toDoId).RecordTypeId) {
                toDos.add(Trigger.newMap.get(toDoId));
            }
        }
        ToDoToQueueAssignmentDispatcherHandler.assignToDosToQueue(toDos);
    }
}