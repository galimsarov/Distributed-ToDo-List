/**
 *
 * REST web service with
 * @HttpGet, @HttpPost, @HttpDelete, @HttpPut, @HttpPatch
 * methods for Sub-ToDO object
 * (get, create, delete, upsert, update  record)
 */

@RestResource(urlMapping='/SubTodo/*')
global with sharing class SubTodoRestManager {
    @HttpGet
    global static Sub_ToDo__c getSubTodoById() {
        RestRequest request = RestContext.request;
        String subTodoId = request.requestURI.substring(
                request.requestURI.lastIndexOf('/')+1);
        System.debug('getSubTodoById subTodoId: ' + subTodoId);
       	Sub_ToDo__c result =  [SELECT Id, Name, Is_Done__c, ToDo__c FROM Sub_ToDo__c WHERE Id = :subTodoId];
        System.debug('getSubTodoById result: ' + result);
        return result;
    }
    @HttpDelete
    global static void deleteSubTodo() {
        RestRequest request = RestContext.request;
        String Id = request.requestURI.substring(
                request.requestURI.lastIndexOf('/')+1);
        Sub_ToDo__c subTodo = [SELECT Id FROM Sub_ToDo__c WHERE Id = :Id];
        delete subTodo;
    }
    @HttpPost
    global static String postSubTodo(String name, Boolean isDone, String todoId) {
        System.debug('postSubTodo name: ' + name + ', isDone: ' + isDone + ', todoId: ' + todoId);
        Sub_ToDo__c subTodo = new Sub_ToDo__c(
                            Name = name,
                            Is_Done__c = isDone,
                            ToDo__c = todoId);
        insert subTodo;
        System.debug('postSubTodo subTodo: ' + subTodo);
        return subTodo.Id;
    }
    @HttpPut
    global static Id upsertSubTodo(String name, Boolean isDone, String todoId, String id) {
        System.debug('upsertSubTodo name: ' + name + ', isDone: ' + isDone + ', id: ' + id + ', todoId: ' + todoId);
        Sub_ToDo__c subTodo = new Sub_ToDo__c(
                Id=id,
                Name = name,
                Is_Done__c = isDone,
                ToDo__c = todoId
                );
        upsert subTodo;
        System.debug('upsertSubTodo subTodo: ' + subTodo);
        return subTodo.Id;
    }
    @HttpPatch
    global static Id updateSubTodoFields() {
        RestRequest request = RestContext.request;
        String subTodoId = request.requestURI.substring(
            request.requestURI.lastIndexOf('/')+1);
        System.debug('updateSubTodoFields subTodoId: ' + subTodoId);
        Sub_ToDo__c subTodo = [SELECT Id FROM Sub_ToDo__c WHERE Id = :subTodoId];
        System.debug('rest updateSubTodoFields: subTodo: ' + subTodo);
        // Deserialize the JSON string into name-value pairs
        Map<String, Object> params = (Map<String, Object>)JSON.deserializeUntyped(request.requestBody.toString());
        System.debug('rest Patch map: params: ' + params);
        for(String fieldName : params.keySet()) {
            if(fieldName == 'isDone') {
              subTodo.put('is_done__c', params.get(fieldName));
            } else if (fieldName == 'todoId') {
              subTodo.put('todo__c', params.get(fieldName));
            } else {
              subTodo.put(fieldName, params.get(fieldName));
            }
        }
        update subTodo;
        return subTodo.Id;
    }
}
