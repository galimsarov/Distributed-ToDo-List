@IsTest
private class FutureSubToDoCalloutsTest {

    @IsTest
    private static void testPostSubTodo() {
        //setup test data
        Integer numOfTests = 5;
        List<Id> listId = createTestSubTodos(numOfTests);
        // set mock response
        // number of mock responses must be doubled because of the additional
        // implicit call to Future Callout Post method when creating the test data
        // plus one more mock response for the parent ToDO
        MockHttpResponse mockHttpResponse = createMockHttpResponse(numOfTests*2+1, '{"a007Q0000053PHIQA2"}');
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, mockHttpResponse);
        System.debug('mockHttpResponse.getResponsesSize(): ' + mockHttpResponse.getResponsesSize());
        // Perform test
        Test.startTest();
        // call method for test
        FutureSubTodoCallouts.postSubToDo(listId);
        Test.stopTest();
        System.debug('mockHttpResponse.getResponsesSize() after test: ' + mockHttpResponse.getResponsesSize());
        // Verify
        String actualValue = SubTodoRestCallouts.testbody;
        String expectedValue = '{"a007Q0000053PHIQA2"}';
        System.assertEquals(actualValue, expectedValue);
        System.assertEquals(200, SubTodoRestCallouts.statusCode);
    }
    @IsTest
    private static void testPutSubToDo() {
        //setup test data
        Integer numOfTests = 5;
        List<Id> listId = createTestSubTodos(numOfTests);
        // set mock response
        // number of mock responses must be doubled because of the additional
        // implicit call to Future Callout Post method when creating the test data
        // plus one more mock response for the parent ToDO
        MockHttpResponse mockHttpResponse = createMockHttpResponse(numOfTests*2+1, '{"a007Q0000053PHIQA2"}');
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, mockHttpResponse);
        // Perform test
        Test.startTest();
        // call method for test
        FutureSubToDoCallouts.putSubToDo(listId);
        Test.stopTest();
        // Verify
        String actualValue = SubTodoRestCallouts.testbody;
        String expectedValue = '{"a007Q0000053PHIQA2"}';
        System.assertEquals(actualValue, expectedValue);
        System.assertEquals(200, SubTodoRestCallouts.statusCode);
    }
    @IsTest
    private static void testPatchSubTodo() {
        //setup test data
        Integer numOfTests = 5;
        List<Id> listId = createTestSubTodos(numOfTests);
        // set mock response
        // number of mock responses must be doubled because of the additional
        // implicit call to Future Callout Post method when creating the test data
        // plus one more mock response for the parent ToDO
        MockHttpResponse mockHttpResponse = createMockHttpResponse(numOfTests*2+1, '{"a007Q0000053PHIQA2"}');
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, mockHttpResponse);
        // Perform test
        Test.startTest();
        // call method for test
        FutureSubToDoCallouts.patchSubToDo(listId);
        Test.stopTest();
        // Verify
        String actualValue = SubTodoRestCallouts.testbody;
        String expectedValue = '{"a007Q0000053PHIQA2"}';
        System.assertEquals(actualValue, expectedValue);
        System.assertEquals(200, SubTodoRestCallouts.statusCode);
    }
    @IsTest
    private static void testDeleteSubTodo() {
        //setup test data
        Integer numOfTests = 5;
        List<Id> listId = createTestSubTodos(numOfTests);
        // set mock response
        // number of mock responses must be doubled because of the additional
        // implicit call to Future Callout Post method when creating the test data
        // plus one more mock response for the parent ToDO
        MockHttpResponse mockHttpResponse = createMockHttpResponse(numOfTests*2+1, null);
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, mockHttpResponse);
        // Perform test
        Test.startTest();
        // call method for test
        FutureSubToDoCallouts.deleteSubToDo(listId);
        Test.stopTest();
        // Verify
        String actualValue = SubTodoRestCallouts.testbody;
        System.assertEquals(200, SubTodoRestCallouts.statusCode);
    }
    // Helper method
    static List<Id> createTestSubTodos(Integer numSubTodos) {
        // Create test parent ToDo
        ToDo__c todoTest = new ToDo__c(
                Name='Test ToDo',
                Status__c='Ready to Take');
        insert todoTest;
        List<Id> listId = new List<Id>();
        List<Sub_ToDo__c> listSubTodo = new List<Sub_ToDo__c>();
        for (Integer i=0;i<numSubTodos;i++) {
            listSubTodo.add(
                new Sub_ToDo__c(
                Name='Test subTodo' + i,
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