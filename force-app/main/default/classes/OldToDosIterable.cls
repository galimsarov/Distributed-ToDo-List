public with sharing class OldToDosIterable implements Iterable<ToDo__c> {
    public Iterator<ToDo__c> iterator() {
        ToDoIterator iterator;
        List<ToDo_Cleaning_Setting__mdt> settings = [SELECT Id, DeveloperName, Number_of_Months__c FROM ToDo_Cleaning_Setting__mdt];
        if (settings.size() > 0) {
            Date pastDate = Date.today() - ((365/12)*Integer.valueOf(settings[0].Number_of_Months__c));
            // Данный вариант раскомментировать при проведении тестов с целью проверки исполнения CleanOldToDos.execute
            // List<ToDo__c> toDos = [SELECT Name, CreatedDate FROM ToDo__c WHERE CreatedDate > :pastDate];
            List<ToDo__c> toDos = [SELECT Name, CreatedDate FROM ToDo__c WHERE CreatedDate <= :pastDate];
            iterator = new ToDoIterator(toDos);
        }
        return iterator;
    }
}