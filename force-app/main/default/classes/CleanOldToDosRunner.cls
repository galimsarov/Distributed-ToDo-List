public with sharing class CleanOldToDosRunner implements Schedulable {
    public void execute(SchedulableContext ctx) {
        CleanOldToDos cot = new CleanOldToDos();
        Id batchId = Database.executeBatch(cot);
    }
}