@isTest
private class ToDoControllerTest {
    private static Integer listSize = 10;
    private static String toDoCorrectName = 'ToDo 1';
    private static String toDoWrongName = 'Unknown ToDo';
    
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
    
    @isTest
    private static void getToDoByNameTestWithCorrectResult() {
        ToDo__c toDo = ToDoController.getToDoByName(toDoCorrectName);
        System.assertEquals(toDoCorrectName, toDo.Name);
    }
    
    @isTest
    private static void getToDoByNameTestWithEmptyResult() {
        ToDo__c toDo = ToDoController.getToDoByName(toDoWrongName);
        System.assertEquals(null, toDo.Name);
    }
}