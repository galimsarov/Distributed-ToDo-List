@IsTest
private class SubToDoTriggerTest {

    @IsTest
    private static void testSubToDoInsertTrigger() {
        // Test data setup
        Integer numOfTests = 5;
        // set mock response
        // plus one more mock response for the parent ToDO
        Integer numOfMockResp = numOfTests + 1;
        MockHttpResponse mockHttpResponse = TestDataFactory.createMockHttpResponse(numOfMockResp, '{"a007Q0000053PHIQA2"}');
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, mockHttpResponse);
        // Perform test
        Test.startTest();
        // method call to initiate trigger
        List<Id> listId = TestDataFactory.createTestSubToDos(numOfTests);
        Test.stopTest();
        // Verify
        String actualValue = SubTodoRestCallouts.testbody;
        String expectedValue = '{"a007Q0000053PHIQA2"}';
        System.assertEquals(actualValue, expectedValue);
        System.assertEquals(200, SubTodoRestCallouts.statusCode);
    }
    @IsTest
    private static void testSubToDoUpdateTrigger() {
        // Test data setup
        Integer numOfTests = 5;
        List<Id> listId = TestDataFactory.createTestSubToDos(numOfTests);
        // set mock response
        // number of mock responses must be doubled due to the insert trigger
        // plus one more mock response for the parent ToDO
        Integer numOfMockResp = numOfTests*2 + 1;
        MockHttpResponse mockHttpResponse = TestDataFactory.createMockHttpResponse(numOfMockResp, '{"a007Q0000053PHIQA2"}');
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, mockHttpResponse);
        // Perform test
        Test.startTest();
        List<Sub_ToDo__c> updateList = new List<Sub_ToDo__c>();
        for (Sub_ToDo__c subTd : [SELECT Name FROM Sub_ToDo__c
                            WHERE Id IN :listId]) {
            subTd.Name = subTd.Name + ' update';
            updateList.add(subTd);
        }
        // method call to initiate trigger
        update updateList;
        Test.stopTest();
        // Verify
        String actualValue = SubTodoRestCallouts.testbody;
        String expectedValue = '{"a007Q0000053PHIQA2"}';
        System.assertEquals(actualValue, expectedValue);
        System.assertEquals(200, SubTodoRestCallouts.statusCode);
    }
    @IsTest
    private static void testSubToDoDeleteTrigger() {
        // Test data setup
        Integer numOfTests = 5;
        List<Id> listId = TestDataFactory.createTestSubToDos(numOfTests);
        // set mock response
        // plus one more mock response for the parent ToDO
        Integer numOfMockResp = numOfTests + 1;
        MockHttpResponse mockHttpResponse = TestDataFactory.createMockHttpResponse(numOfMockResp, null);
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, mockHttpResponse);
        // Perform test
        Test.startTest();
        // method call to initiate trigger
        List<Sub_ToDo__c> deleteList = new List<Sub_ToDo__c>();
        for (Sub_ToDo__c subTd : [SELECT Id FROM Sub_ToDo__c
                                WHERE Id IN :listId]) {
            deleteList.add(subTd);
        }
        // method call to initiate trigger
        Database.DeleteResult[] resultDeleteList = Database.delete(deleteList, false);
        Test.stopTest();
        // Verify
        System.assertEquals(200, SubTodoRestCallouts.statusCode);
    }
}
