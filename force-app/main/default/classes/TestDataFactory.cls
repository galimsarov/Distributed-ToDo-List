@isTest
public with sharing class TestDataFactory {
    public static List<Id> createTestToDos(Integer numRec) {
        // Create test records
        List<Id> listId = new List<Id>();
        List<ToDo__c> listTodo = new List<ToDo__c>();
        for (Integer i=0;i<numRec;i++) {
            listTodo.add(
                new ToDo__c(
                Name='Test record' + i,
                Status__c='Ready to Take')
            );
        }
        insert listTodo;
        for (ToDo__c td : listTodo) {
            listId.add(td.Id);
        }
        return listId;
    }
    public static List<Id> createTestSubToDos(Integer numRec) {
        // Create test parent ToDo
        ToDo__c todoTest = new ToDo__c(
                Name='Test ToDo',
                Status__c='Ready to Take');
        insert todoTest;
        List<Id> listId = new List<Id>();
        List<Sub_ToDo__c> listSubTodo = new List<Sub_ToDo__c>();
        for (Integer i=0;i<numRec;i++) {
            listSubTodo.add(
                new Sub_ToDo__c(
                Name='Test record' + i,
                Is_Done__c=true,
                ToDo__c=todoTest.Id)
            );
        }
        insert listSubTodo;
        for (Sub_ToDo__c subTd : listSubTodo) {
            listId.add(subTd.Id);
        }
        return listId;
    }
    public static MockHttpResponse createMockHttpResponse(Integer numMock, String strBody) {
        MockHttpResponse mockHttpResponse = new MockHttpResponse();
        for (Integer i = 0; i < numMock; i++) {
            HttpResponse mockRes = new HttpResponse();
            mockRes.setHeader('Content-Type', 'application/json');
            if(strBody != null) {
                mockRes.setBody(strBody);
            }
            mockRes.setStatusCode(200);
            mockHttpResponse.addResponse(mockRes);
        }
        return mockHttpResponse;
    }
}
