public with sharing class ToDoToQueueAssignmentDispatcherHandler {
    private static List<Group> queues = [SELECT Id, DeveloperName, Type FROM Group WHERE Type = 'Queue'];
    public static List<RecordType> recordTypes = [SELECT Id, Name FROM RecordType];
    
    public static void assignToDosToQueue(List<ToDo__c> toDos) {        
        Map<Id, Id> queuesIdsToRecordTypeIds = getQueuesIdsToRecordTypeIds();        
        for (ToDo__c toDo: toDos) {
            if (isQueueMember(toDo.OwnerId)) {
                toDo.OwnerId = queuesIdsToRecordTypeIds.get(toDo.RecordTypeId);   
            }
        }
    }
    
    private static Boolean isQueueMember(Id userId) {
        List<Id> queuesIds = new List<Id>();
        for (Group queue: queues) {
            queuesIds.add(queue.Id);
        }
        List<GroupMember> queuesMembers = [SELECT GroupId, UserOrGroupId FROM GroupMember WHERE GroupId IN :queuesIds];
        for (GroupMember member: queuesMembers) {
            if ((member.UserOrGroupId == userId) || (member.GroupId == userId)) {
                return true;
            }
        }
        return false;
    }
    
    private static Map<Id, Id> getQueuesIdsToRecordTypeIds() {
        Map<Id, Id> result = new Map<Id, Id>();
        for (RecordType recordType: recordTypes) {
            if (recordType.Name == 'Later') {
                result.put(recordType.Id, getLaterToDosQueueId());
            }
            if (recordType.Name == 'Today') {
                result.put(recordType.Id, getTodayToDosQueueId());
            }
            if (recordType.Name == 'Tomorrow') {
                result.put(recordType.Id, getTomorrowToDosQueueId());
            }
        }
        return result;
    }
    
    public static Id getLaterToDosQueueId() {
        Id result;
        for (Group queue: queues) {
            if (queue.DeveloperName == 'Later_ToDos') {
                result = queue.Id;
                break;
            }
        }
        return result;
    }
    
    public static Id getTodayToDosQueueId() {
        Id result;
        for (Group queue: queues) {
            if (queue.DeveloperName == 'Today_ToDos') {
                result = queue.Id;
                break;
            }
        }
        return result;
    }
    
    public static Id getTomorrowToDosQueueId() {
        Id result;
        for (Group queue: queues) {
            if (queue.DeveloperName == 'Tomorrow_ToDos') {
                result = queue.Id;
                break;
            }
        }
        return result;
    }
}