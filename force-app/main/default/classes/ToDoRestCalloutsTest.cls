@IsTest
public with sharing class ToDoRestCalloutsTest {
    // set fake test data
    public static String todoId = '0017Q000006pYBRQA2';
    public static String todoJson = '{"id":"a017Q00000XlDWBQA3", "name":"TEST NAME","status":"Ready to Take","recordTypeName":"Tomorrow"}';
    public static String expectedValue = '{"a017Q00000ZA8V6QAL"}';

    @IsTest
    static void testGetCallout() {
        // set mock response
        MockHttpResponse mockHttpResponse = new MockHttpResponse();
        HttpResponse mockRes = new HttpResponse();
        mockRes.setHeader('Content-Type', 'application/json');
        mockRes.setBody('{"attributes":{"type":"ToDo__c","url":"/services/data/v54.0/sobjects/ToDo__c/a017Q00000ZSuc9QAD"},"Name":"TEST POST","Status__c":"Ready to Take","ExtId__c":"a017Q00000ZA8V1QAL","Id":"a017Q00000ZSuc9QAD"}');
        mockRes.setStatusCode(200);
        mockHttpResponse.addResponse(mockRes);
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, mockHttpResponse);
        HttpResponse response = ToDoRestCallouts.getToDo(todoId);
        // Verify that the response received contains fake values
        String contentType = response.getHeader('Content-Type');
        System.assert(contentType == 'application/json');
        String actualValue = response.getBody();
        System.debug(response.getBody());
        String expectedValue = '{"attributes":{"type":"ToDo__c","url":"/services/data/v54.0/sobjects/ToDo__c/a017Q00000ZSuc9QAD"},"Name":"TEST POST","Status__c":"Ready to Take","ExtId__c":"a017Q00000ZA8V1QAL","Id":"a017Q00000ZSuc9QAD"}';
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
        HttpResponse response = ToDoRestCallouts.deleteToDo(todoId);
        // Verify that the response received contains fake values
        System.assertEquals(200, response.getStatusCode());
    }
    @IsTest
    static void testPostCallout() {
        // set mock response
        MockHttpResponse mockHttpResponse = new MockHttpResponse();
        HttpResponse mockRes = new HttpResponse();
        mockRes.setHeader('Content-Type', 'application/json');
        mockRes.setBody('{"a017Q00000ZA8V6QAL"}');
        mockRes.setStatusCode(200);
        mockHttpResponse.addResponse(mockRes);
        // Set mock callout class
        HttpRequest req = new HttpRequest();
        Test.setMock(HttpCalloutMock.class, mockHttpResponse);
        HttpResponse response = ToDoRestCallouts.postToDo(todoJson);
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
        mockRes.setBody('{"a017Q00000ZA8V6QAL"}');
        mockRes.setStatusCode(200);
        mockHttpResponse.addResponse(mockRes);
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, mockHttpResponse);
        HttpResponse response = ToDoRestCallouts.putToDo(todoJson);
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
        mockRes.setBody('{"a017Q00000ZA8V6QAL"}');
        mockRes.setStatusCode(200);
        mockHttpResponse.addResponse(mockRes);
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, mockHttpResponse);
        HttpResponse response = ToDoRestCallouts.patchToDo(todoId, todoJson);
        // Verify that the response received contains fake values
        String contentType = response.getHeader('Content-Type');
        System.assert(contentType == 'application/json');
        String actualValue = response.getBody();
        System.assertEquals(expectedValue, actualValue);
        System.assertEquals(200, response.getStatusCode());
    }
}
