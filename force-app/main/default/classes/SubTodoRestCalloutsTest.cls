@IsTest
public with sharing class SubTodoRestCalloutsTest {
    // set fake test data
    public static String subTodoId = 'a007Q000004sBO5QAM';
    public static String subTodoJson = '{"id":"a017Q00000XlDWBQA3", "name":"TEST NAME"}';
    public static String expectedValue = '{"a007Q0000053PHIQA2"}';

    @IsTest
    static void testGetCallout() {
        // set mock response
        MockHttpResponse mockHttpResponse = new MockHttpResponse();
        HttpResponse mockRes = new HttpResponse();
        mockRes.setHeader('Content-Type', 'application/json');
        mockRes.setBody('{"attributes":{"type":"Sub_ToDo__c","url":"/services/data/v54.0/sobjects/Sub_ToDo__c/a007Q000004sBO5QAM"},"Name":"Test Sub","Is_Done__c":false,"ToDo__c":"a017Q00000ZUCABQA5","ExtId__c":"a007Q0000053zJ5QAI","Id":"a007Q000004sBO5QAM","ToDo__r":{"attributes":{"type":"ToDo__c","url":"/services/data/v54.0/sobjects/ToDo__c/a017Q00000ZUCABQA5"},"Id":"a017Q00000ZUCABQA5"}}');
        mockRes.setStatusCode(200);
        mockHttpResponse.addResponse(mockRes);
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, mockHttpResponse);
        HttpResponse response = SubTodoRestCallouts.getSubTodo(subTodoId);
        // Verify that the response received contains fake values
        String contentType = response.getHeader('Content-Type');
        System.assert(contentType == 'application/json');
        String actualValue = response.getBody();
        // System.debug(response.getBody());
        String expectedValue = '{"attributes":{"type":"Sub_ToDo__c","url":"/services/data/v54.0/sobjects/Sub_ToDo__c/a007Q000004sBO5QAM"},"Name":"Test Sub","Is_Done__c":false,"ToDo__c":"a017Q00000ZUCABQA5","ExtId__c":"a007Q0000053zJ5QAI","Id":"a007Q000004sBO5QAM","ToDo__r":{"attributes":{"type":"ToDo__c","url":"/services/data/v54.0/sobjects/ToDo__c/a017Q00000ZUCABQA5"},"Id":"a017Q00000ZUCABQA5"}}';
        System.assertEquals(expectedValue, actualValue);
        System.assertEquals(200, response.getStatusCode());
    }
    @IsTest
    static void testDeleteCallout() {
        // set mock response
        MockHttpResponse mockHttpResponse = new MockHttpResponse();
        HttpResponse mockRes = new HttpResponse();
        mockRes.setHeader('Content-Type', 'application/json');
        mockRes.setStatusCode(200);
        mockHttpResponse.addResponse(mockRes);
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, mockHttpResponse);
        HttpResponse response = SubTodoRestCallouts.deleteSubTodo(subTodoId);
        // Verify that the response received contains fake values
        System.assertEquals(200, response.getStatusCode());
    }
    @IsTest
    static void testPostCallout() {
        // set mock response
        MockHttpResponse mockHttpResponse = new MockHttpResponse();
        HttpResponse mockRes = new HttpResponse();
        mockRes.setHeader('Content-Type', 'application/json');
        mockRes.setBody('{"a007Q0000053PHIQA2"}');
        mockRes.setStatusCode(200);
        mockHttpResponse.addResponse(mockRes);
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, mockHttpResponse);
        HttpResponse response = SubTodoRestCallouts.postSubTodo(subTodoJson);
        // Verify that the response received contains fake values
        String contentType = response.getHeader('Content-Type');
        System.assert(contentType == 'application/json');
        String actualValue = response.getBody();
        System.assertEquals(expectedValue, actualValue);
        System.assertEquals(200, response.getStatusCode());
    }
    @IsTest
    static void testPutCallout() {
        // set mock response
        MockHttpResponse mockHttpResponse = new MockHttpResponse();
        HttpResponse mockRes = new HttpResponse();
        mockRes.setHeader('Content-Type', 'application/json');
        mockRes.setBody('{"a007Q0000053PHIQA2"}');
        mockRes.setStatusCode(200);
        mockHttpResponse.addResponse(mockRes);
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, mockHttpResponse);
        HttpResponse response = SubTodoRestCallouts.putSubTodo(subTodoJson);
        // Verify that the response received contains fake values
        String contentType = response.getHeader('Content-Type');
        System.assert(contentType == 'application/json');
        String actualValue = response.getBody();
        System.assertEquals(expectedValue, actualValue);
        System.assertEquals(200, response.getStatusCode());
    }
    @IsTest
    static void testPatchCallout() {
        // set mock response
        MockHttpResponse mockHttpResponse = new MockHttpResponse();
        HttpResponse mockRes = new HttpResponse();
        mockRes.setHeader('Content-Type', 'application/json');
        mockRes.setBody('{"a007Q0000053PHIQA2"}');
        mockRes.setStatusCode(200);
        mockHttpResponse.addResponse(mockRes);
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, mockHttpResponse);
        HttpResponse response = SubTodoRestCallouts.patchSubTodo(subTodoId, subTodoJson);
        // Verify that the response received contains fake values
        String contentType = response.getHeader('Content-Type');
        System.assert(contentType == 'application/json');
        String actualValue = response.getBody();
        System.assertEquals(expectedValue, actualValue);
        System.assertEquals(200, response.getStatusCode());
    }
}

