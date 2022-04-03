@IsTest
private class ToDoTriggerTest {

    @IsTest
    private static void testToDoInsertTrigger() {
        // Test data setup
        Integer numOfTests = 5;
        // set mock response
        MockHttpResponse mockHttpResponse = createMockHttpResponse(numOfTests, '{"a017Q00000ZA8V6QAL"}');
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, mockHttpResponse);
        // Perform test
        Test.startTest();
        // method call to initiate trigger
        List<Id> listId = TestDataFactory.createTestToDos(numOfTests);
        Test.stopTest();
        // Verify
        String actualValue = ToDoRestCallouts.testbody;
        String expectedValue = '{"a017Q00000ZA8V6QAL"}';
        System.assertEquals(actualValue, expectedValue);
        System.assertEquals(200, ToDoRestCallouts.statusCode);
    }
    @IsTest
    private static void testToDoUpdateTrigger() {
        // Test data setup
        Integer numOfTests = 5;
        List<Id> listId = TestDataFactory.createTestToDos(numOfTests);
        // set mock response
        // number of mock responses must be doubled due to the insert trigger
        MockHttpResponse mockHttpResponse = createMockHttpResponse(numOfTests*2, '{"a017Q00000ZA8V6QAL"}');
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, mockHttpResponse);
        // Perform test
        Test.startTest();
        List<ToDo__c> updateList = new List<ToDo__c>();
        for (ToDo__c td : [SELECT Name FROM ToDo__c
                            WHERE Id IN :listId]) {
            td.Name = td.Name + ' update';
            updateList.add(td);
        }
        // method call to initiate trigger
        update updateList;
        Test.stopTest();
        // Verify
        String actualValue = ToDoRestCallouts.testbody;
        String expectedValue = '{"a017Q00000ZA8V6QAL"}';
        System.assertEquals(actualValue, expectedValue);
        System.assertEquals(200, ToDoRestCallouts.statusCode);
    }
    @IsTest
    private static void testToDoDeleteTrigger() {
        // Test data setup
        Integer numOfTests = 5;
        List<Id> listId = TestDataFactory.createTestToDos(numOfTests);
        // set mock response
        MockHttpResponse mockHttpResponse = createMockHttpResponse(numOfTests, null);
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, mockHttpResponse);
        // Perform test
        Test.startTest();
        // method call to initiate trigger
        List<ToDo__c> deleteList = new List<ToDo__c>();
        for (ToDo__c td : [SELECT Name FROM ToDo__c
                            WHERE Id IN :listId]) {
            deleteList.add(td);
        }
        System.debug('testToDoDeleteTrigger deleteList: ' + deleteList);
        // method call to initiate trigger
        Database.DeleteResult[] resultDeleteList = Database.delete(deleteList, false);
        Test.stopTest();
        // Verify
        String actualValue = ToDoRestCallouts.testbody;
        System.assertEquals(200, ToDoRestCallouts.statusCode);
    }
    // Helper method
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