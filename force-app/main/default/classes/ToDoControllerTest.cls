@isTest
private class ToDoControllerTest {
    private static Integer listSize = 10;
    
    @testSetup
    private static void setup() {
        List<ToDo__c> toDos = new List<ToDo__c>();
        for(Integer i = 1; i <= listSize; i++) {
            toDos.add(new ToDo__c(Name = 'ToDo ' + i));
        }
        insert toDos;
    }
    
    @isTest
    private static void getAllToDosTest() {
        List<ToDo__c> toDos = ToDoController.getAllToDos();
        System.assertEquals(listSize, toDos.size());
    }
}