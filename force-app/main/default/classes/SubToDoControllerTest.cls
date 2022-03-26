@isTest
private with sharing class SubToDoControllerTest {
    private static Integer listSize = 10;
    private static String toDoName = 'ToDo';
    
    @testSetup
    private static void setup() {
        ToDo__c toDo = new ToDo__c(Name = toDoName);
        insert toDo;
        List<Sub_ToDo__c> subToDos = new List<Sub_ToDo__c>();
        for(Integer i = 1; i <= listSize; i++) {
            subToDos.add(new Sub_ToDo__c(Name = 'Sub-ToDo ' + i, ToDo__c = toDo.Id));
        }
        insert subToDos;
    }
    
    @isTest
    private static void getAllSubToDosTest() {
        ToDo__c toDo = [SELECT Id, Name FROM ToDo__c WHERE Name = :toDoName];
        List<Sub_ToDo__c> subToDos = SubToDoController.getAllSubToDos(toDo.Id);
        Test.startTest();
        System.assertEquals(listSize, subToDos.size());
        Test.stopTest();
    }

}