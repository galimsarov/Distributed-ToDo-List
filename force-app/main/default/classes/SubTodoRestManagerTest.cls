@IsTest
private class SubTodoRestManagerTest {
    // set test data
    static String basePartRequestUrl = Url.getOrgDomainUrl().toExternalForm() + '/services/apexrest/SubTodo/';
    // public static String todoJson = '{"id":"a017Q00000XlDWBQA3", "name":"TEST NAME","isDone":true}';
    @IsTest static void testGetSubTodoById() {
        Id recordId = createTestRecord();
        // Set up a test request
        RestRequest request = new RestRequest();
        request.requestURI = basePartRequestUrl + recordId;
        // System.debug('request.requestURI: ' + request.requestURI);
        request.httpMethod = 'GET';
        RestContext.request = request;
        // Call the method to test
        Sub_ToDo__c subTodo = SubTodoRestManager.getSubTodoById();
        // Verify results
        System.assert(subTodo != null);
        System.assertEquals(subTodo.Name, 'Test record');
        System.assertEquals(subTodo.Is_Done__c, true);
    }
    @IsTest static void testDeleteSubTodo() {
        TriggerControl.isBypassSubToDoTrigger=true;
        Id recordId = createTestRecord();
        // Set up a test request
        RestRequest request = new RestRequest();
        request.requestURI = basePartRequestUrl + recordId;
        request.httpMethod = 'DELETE';
        RestContext.request = request;
        // Call the method to test
        SubTodoRestManager.deleteSubTodo();
        // Verify record is deleted
        List<Sub_ToDo__c> subTodoList = [SELECT Id FROM Sub_ToDo__c WHERE Id=:recordId];
        System.assert(subTodoList.size() == 0);
        TriggerControl.isBypassSubToDoTrigger=false;
    }
    @IsTest static void testPostSubTodo() {
        TriggerControl.isBypassSubToDoTrigger=true;
        // set up parent ToDo
        ToDo__c todo = new ToDo__c(Name='Test record');
        insert todo;
        // Set up a test request
        RestRequest request = new RestRequest();
        request.requestURI = basePartRequestUrl;
        // System.debug('basePartRequestUrl: ' + basePartRequestUrl);
        request.httpMethod = 'POST';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueOf('{"name":"Test PostSubTodo","isDone":true,"todo":"' + todo.Id + '"}');
        // System.debug('testPostSubTodo request.requestBody.toString(): ' + request.requestBody.toString());
        RestContext.request = request;
        Id subTodoId = SubTodoRestManager.postSubTodo();
        // Verify results
        System.assert(subTodoId != null);
        Sub_ToDo__c subTodo = [SELECT Id,Name,Is_Done__c FROM Sub_ToDo__c WHERE Id=:subTodoId];
        System.assert(subTodo != null);
        System.assertEquals(subTodo.Name, 'Test PostSubTodo');
        System.assertEquals(subTodo.Is_Done__c, true);
        TriggerControl.isBypassSubToDoTrigger=false;
    }
    @IsTest static void testUpsertSubTodo() {
        TriggerControl.isBypassSubToDoTrigger=true;
        // set up parent ToDo
        ToDo__c todo = new ToDo__c(Name='Test ToDo');
        insert todo;
        // Set up a test request
        RestRequest request = new RestRequest();
        request.requestURI = basePartRequestUrl;
        request.httpMethod = 'PUT';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueOf('{"name":"Test PutSubTodo","isDone":true,"todo":"' + todo.Id + '"}');
        // System.debug('testUpsertSubTodo request.requestBody.toString(): ' + request.requestBody.toString());
        RestContext.request = request;
        Id subTodoId = SubTodoRestManager.upsertSubTodo();
        // Verify new record was created
        System.assert(subTodoId != null);
        Sub_ToDo__c subTd1 = [SELECT Id,Name,Is_Done__c FROM Sub_ToDo__c WHERE Id=:subTodoId];
        System.assert(subTd1 != null);
        System.assertEquals(subTd1.Name, 'Test PutSubTodo');
        System.assertEquals(subTd1.Is_Done__c, true);
        // Update status of existing record to Working
        request.requestBody = Blob.valueOf('{"name":"Test PutSubTodo2","isDone":true,"id":"' + subTodoId + '"}');
        RestContext.request = request;
        Id subTodo2Id = SubTodoRestManager.upsertSubTodo();
        // Verify record was updated
        System.assertEquals(subTodoId, subTodo2Id);
        Sub_ToDo__c subTd2 = [SELECT Id,Name,Is_Done__c FROM Sub_ToDo__c WHERE Id=:subTodo2Id];
        System.assert(subTd2 != null);
        System.assertEquals(subTd2.Name, 'Test PutSubTodo2');
        System.assertEquals(subTd2.Is_Done__c, true);
        TriggerControl.isBypassSubToDoTrigger=false;
    }
    @IsTest static void testUpdateSubTodoFields() {
        TriggerControl.isBypassSubToDoTrigger=true;
        Id recordId = createTestRecord();
        RestRequest request = new RestRequest();
        request.requestURI = basePartRequestUrl + recordId;
        request.httpMethod = 'PATCH';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueOf('{"name":"Test PatchSubTodo","isDone":false}');
        // System.debug('testUpdateSubTodoFields request.requestBody.toString(): ' + request.requestBody.toString());
        RestContext.request = request;
        // Update status of existing record
        Id subTodoId = SubTodoRestManager.updateSubTodoFields();
        // Verify record was updated
        System.assert(subTodoId != null);
        Sub_ToDo__c subTodo = [SELECT Id,Name,Is_Done__c FROM Sub_ToDo__c WHERE Id=:subTodoId];
        System.assert(subTodo != null);
        System.assertEquals(subTodo.Name, 'Test PatchSubTodo');
        System.assertEquals(subTodo.Is_Done__c, false);
        TriggerControl.isBypassSubToDoTrigger=false;
    }
    // Helper method
    static Id createTestRecord() {
        // Create test parent ToDo
        ToDo__c todoTest = new ToDo__c(
                Name='Test ToDo',
                Status__c='Ready to Take');
        insert todoTest;
        // Create test record SubToDo
        Sub_ToDo__c subTodoTest = new Sub_ToDo__c(
                Name='Test record',
                Is_Done__c=true,
                ToDo__c=todoTest.Id);
        insert subTodoTest;
        return subTodoTest.Id;
    }
}

