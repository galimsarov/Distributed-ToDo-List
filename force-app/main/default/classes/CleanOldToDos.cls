public with sharing class CleanOldToDos implements Database.Batchable<ToDo__c> {
    public Iterable<ToDo__c> start(Database.BatchableContext bc) {
        return new OldToDosIterable();
    }

    public void execute(Database.BatchableContext bc, List<ToDo__c> records){
        delete records;
    }
    public void finish(Database.BatchableContext bc){
        System.debug('Deletion of old toDos completed ' + Date.today());
    }
}