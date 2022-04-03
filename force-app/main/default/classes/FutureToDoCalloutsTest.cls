@IsTest
private class FutureToDoCalloutsTest {

    @IsTest
    private static void testPostToDo() {
        //setup test data
        Integer numOfTests = 5;
        List<Id> listId = createTestToDos(numOfTests);
        // set mock response
        // number of mock responses must be doubled because of the additional
        // implicit call to Future Callout Post method when creating the test data
        MockHttpResponse mockHttpResponse = createMockHttpResponse(numOfTests*2, '{"a017Q00000ZA8V6QAL"}');
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, mockHttpResponse);
        // Perform test
        Test.startTest();
        // call method for test
        FutureToDoCallouts.postToDo(listId);
        Test.stopTest();
        // Verify
        String actualValue = ToDoRestCallouts.testbody;
        String expectedValue = '{"a017Q00000ZA8V6QAL"}';
        System.assertEquals(actualValue, expectedValue);
        System.assertEquals(200, ToDoRestCallouts.statusCode);
    }
    @IsTest
    private static void testPutToDo() {
        //setup test data
        Integer numOfTests = 5;
        List<Id> listId = createTestToDos(numOfTests);
        // set mock response
        // number of mock responses must be doubled because of the additional
        // implicit call to Future Callout Post method when creating the test data
        MockHttpResponse mockHttpResponse = createMockHttpResponse(numOfTests*2, '{"a017Q00000ZA8V6QAL"}');
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, mockHttpResponse);
        // Perform test
        Test.startTest();
        // call method for test
        FutureToDoCallouts.putToDo(listId);
        Test.stopTest();
        // Verify
        String actualValue = ToDoRestCallouts.testbody;
        String expectedValue = '{"a017Q00000ZA8V6QAL"}';
        System.assertEquals(actualValue, expectedValue);
        System.assertEquals(200, ToDoRestCallouts.statusCode);
    }
    @IsTest
    private static void testPatchToDo() {
        //setup test data
        Integer numOfTests = 5;
        List<Id> listId = createTestToDos(numOfTests);
        // set mock response
        // number of mock responses must be doubled because of the additional
        // implicit call to Future Callout Post method when creating the test data
        MockHttpResponse mockHttpResponse = createMockHttpResponse(numOfTests*2, '{"a017Q00000ZA8V6QAL"}');
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, mockHttpResponse);
        // Perform test
        Test.startTest();
        // call method for test
        FutureToDoCallouts.patchToDo(listId);
        Test.stopTest();
        // Verify
        String actualValue = ToDoRestCallouts.testbody;
        String expectedValue = '{"a017Q00000ZA8V6QAL"}';
        System.assertEquals(actualValue, expectedValue);
        System.assertEquals(200, ToDoRestCallouts.statusCode);
    }
    @IsTest
    private static void testDeleteToDo() {
        //setup test data
        Integer numOfTests = 5;
        List<Id> listId = createTestToDos(numOfTests);
        // set mock response
        // number of mock responses must be doubled because of the additional
        // implicit call to Future Callout Post method when creating the test data
        MockHttpResponse mockHttpResponse = createMockHttpResponse(numOfTests*2, null);
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, mockHttpResponse);
        // Perform test
        Test.startTest();
        // call method for test
        FutureToDoCallouts.deleteToDo(listId);
        Test.stopTest();
        // Verify
        String actualValue = ToDoRestCallouts.testbody;
        System.assertEquals(200, ToDoRestCallouts.statusCode);
    }
    // Helper method
    static List<Id> createTestToDos(Integer numTodos) {
        // Create test records
        List<Id> listId = new List<Id>();
        List<ToDo__c> listTodo = new List<ToDo__c>();
        for (Integer i=0;i<numTodos;i++) {
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