@isTest
private with sharing class ToDoFromEmailCreatorTest {
    private static String correctName = 'Make a test class';
    private static String readyStatus = 'Ready to Take';
    private static String inProgressStatus = 'In Progress';
    private static String doneStatus = 'Done';
    private static String todayCategory = 'Today';
    private static String tomorrowCategory = 'Tomorrow';
    private static String wrongCategory = 'Never';
    private static String laterCategory = 'Later';
    private static String correctSeparator = '\n';
    private static String wrongSeparator = '.';  
    
    @isTest
    private static void createToDosCorrectTest() {
        String readyDescription = correctName + correctSeparator + readyStatus + correctSeparator + todayCategory;
        String inProgressDescription = correctName + correctSeparator + inProgressStatus + correctSeparator + todayCategory;
        String doneDescription = correctName + correctSeparator + doneStatus + correctSeparator + todayCategory;
        String tomorrowDescription = correctName + correctSeparator + doneStatus + correctSeparator + tomorrowCategory;
        String laterDescription = correctName + correctSeparator + doneStatus + correctSeparator + laterCategory;
        String wrongToLaterDescription = correctName + correctSeparator + doneStatus + correctSeparator + wrongCategory;
        List<String> descriptions = new List<String>();
        descriptions.add(readyDescription);
        descriptions.add(inProgressDescription);
        descriptions.add(doneDescription);
        descriptions.add(tomorrowDescription);
        descriptions.add(laterDescription);
        descriptions.add(wrongToLaterDescription);
        ToDoFromEmailCreator.createToDos(descriptions);
        List<ToDo__c> toDos = [SELECT Name FROM ToDo__c WHERE Name = :correctName];
        Test.startTest();
        System.assertEquals(6, toDos.size());
        Test.stopTest();
    }
    
    @isTest
    private static void createToDosWithWrongSeparatorTest() {
        String description = correctName + wrongSeparator + readyStatus + wrongSeparator + todayCategory;
        List<String> descriptions = new List<String>();
        descriptions.add(description);
        ToDoFromEmailCreator.createToDos(descriptions);
        List<ToDo__c> toDos = [SELECT Name FROM ToDo__c WHERE Name = :correctName];
        Test.startTest();
        System.assertEquals(0, toDos.size());
        Test.stopTest();
    }
    
    @isTest
    private static void createToDosWitDoubleSeparatorTest() {
        String description = correctName + correctSeparator + correctSeparator + readyStatus + correctSeparator + correctSeparator + todayCategory;
        List<String> descriptions = new List<String>();
        descriptions.add(description);
        ToDoFromEmailCreator.createToDos(descriptions);
        List<ToDo__c> toDos = [SELECT Name FROM ToDo__c WHERE Name = :correctName];
        Test.startTest();
        System.assertEquals(0, toDos.size());
        Test.stopTest();
    }   
}