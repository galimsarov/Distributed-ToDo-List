@IsTest
private class ToDoRestManagerTest {
    // set test data
    static String basePartRequestUrl = Url.getOrgDomainUrl().toExternalForm() + '/services/apexrest/Todo/';
    public static String todoJson = '{"id":"a017Q00000XlDWBQA3", "name":"TEST NAME","status":"Ready to Take","recordTypeName":"Tomorrow"}';
    @IsTest static void testGetToDoById() {
        Id recordId = createTestRecord();
        // Set up a test request
        RestRequest request = new RestRequest();
        request.requestURI = basePartRequestUrl + recordId;
        System.debug('request.requestURI: ' + request.requestURI);
        request.httpMethod = 'GET';
        RestContext.request = request;
        // Call the method to test
        ToDo__c thisTodo = ToDoRestManager.getToDoById();
        // Verify results
        System.assert(thisTodo != null);
        System.assertEquals(thisTodo.Name, 'Test record');
        System.assertEquals(thisTodo.Status__c, 'Ready to Take');
    }
    @IsTest static void testPostToDo() {
        RestRequest request = new RestRequest();
        request.requestURI = basePartRequestUrl;
        // System.debug('basePartRequestUrl: ' + basePartRequestUrl);
        request.httpMethod = 'POST';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueOf('{"name":"Test PostToDo","status":"Ready to Take","recordTypeName":"Tomorrow"}');
        RestContext.request = request;
        Id thisToDoId = ToDoRestManager.postJsonToDo();
        // Verify results
        System.assert(thisToDoId != null);
        ToDo__c thisTodo = [SELECT Id,Name,Status__c FROM ToDo__c WHERE Id=:thisToDoId];
        System.assert(thisTodo != null);
        System.assertEquals(thisTodo.Name, 'Test PostToDo');
        System.assertEquals(thisTodo.Status__c, 'Ready to Take');
    }
    @IsTest static void testDeleteToDo() {
        // to temporarily disable web service callout
        TriggerControl.isBypassToDoTrigger=true;
        Id recordId = createTestRecord();
        // Set up a test request
        RestRequest request = new RestRequest();
        request.requestURI = basePartRequestUrl + recordId;
        // System.debug('request.requestURI: ' + request.requestURI);
        request.httpMethod = 'DELETE';
        RestContext.request = request;
        // Call the method to test
        ToDoRestManager.deleteToDo();
        // Verify record is deleted
        List<ToDo__c> todoList = [SELECT Id FROM ToDo__c WHERE Id=:recordId];
        System.assert(todoList.size() == 0);
        TriggerControl.isBypassToDoTrigger=false;
    }
    @IsTest static void testUpsertToDo() {
        // to temporarily disable web service callout
        TriggerControl.isBypassToDoTrigger=true;
        RestRequest request = new RestRequest();
        request.requestURI = basePartRequestUrl;
        request.httpMethod = 'PUT';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueOf('{"name":"Test PutToDo","status":"Ready to Take","recordTypeName":"Tomorrow"}');
        RestContext.request = request;
        Id todoId = ToDoRestManager.upsertToDo();
        // Verify new record was created
        System.assert(todoId != null);
        ToDo__c td1 = [SELECT Id,Name,Status__c FROM ToDo__c WHERE Id=:todoId];
        System.assert(td1 != null);
        System.assertEquals(td1.Name, 'Test PutToDo');
        System.assertEquals(td1.Status__c, 'Ready to Take');
        // Update status of existing record to Working
        request.requestBody = Blob.valueOf('{"name":"Test PutToDo2","status":"Ready to Take","id":"' + todoId + '"}');
        RestContext.request = request;
        Id todo2Id = ToDoRestManager.upsertToDo();
        // Verify record was updated
        System.assertEquals(todoId, todo2Id);
        ToDo__c td2 = [SELECT Id,Name,Status__c FROM ToDo__c WHERE Id=:todo2Id];
        System.assert(td2 != null);
        System.assertEquals(td2.Name, 'Test PutToDo2');
        System.assertEquals(td2.Status__c, 'Ready to Take');
        TriggerControl.isBypassToDoTrigger=false;
    }
    @IsTest static void testUpdateToDoFields() {
        // to temporarily disable web service callout
        TriggerControl.isBypassToDoTrigger=true;
        Id recordId = createTestRecord();
        RestRequest request = new RestRequest();
        request.requestURI = basePartRequestUrl + recordId;
        request.httpMethod = 'PATCH';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueOf('{"name":"Test PatchToDo","status":"Done"}');
        RestContext.request = request;
        // Update status of existing record
        Id todoId = ToDoRestManager.updateToDoFields();
        // Verify record was updated
        System.assert(todoId != null);
        ToDo__c thisTodo = [SELECT Id,Name,Status__c FROM ToDo__c WHERE Id=:todoId];
        System.assert(thisTodo != null);
        System.assertEquals(thisTodo.Name, 'Test PatchToDo');
        System.assertEquals(thisTodo.Status__c, 'Done');
        TriggerControl.isBypassToDoTrigger=false;
    }
    // Helper method
    static Id createTestRecord() {
        // Create test record
        ToDo__c todoTest = new ToDo__c(
                Name='Test record',
                Status__c='Ready to Take');
        insert todoTest;
        return todoTest.Id;
    }
}
