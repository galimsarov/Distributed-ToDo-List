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
        RestResponse res = RestContext.response;
        RestRequest request = RestContext.request;
        String subTodoId = request.requestURI.substring(
                request.requestURI.lastIndexOf('/')+1);
        Sub_ToDo__c result;
        if (RestUtility.existSubToDo(subTodoId)) {
            result = [SELECT Id, Name, Is_Done__c, ToDo__c, ExtId__c, Todo__r.Name, Todo__r.Status__c FROM Sub_ToDo__c WHERE ExtId__c = :subTodoId];
        } else {
            // if Sub_ToDo not exists
            res.statusCode = 404;
        }
        return result;
    }
    @HttpDelete
    global static void deleteSubTodo() {
        RestResponse res = RestContext.response;
        RestRequest request = RestContext.request;
        String subTodoId = request.requestURI.substring(
                request.requestURI.lastIndexOf('/')+1);
        if (RestUtility.existSubToDo(subTodoId)) {
            Sub_ToDo__c subTodo = [SELECT Id  FROM Sub_ToDo__c WHERE ExtId__c = :subTodoId];
            delete subTodo;
        } else {
            // if Sub_ToDo not exists
            res.statusCode = 404;
        }
    }
    @HttpPost
    global static String postSubTodo() {
        RestRequest request = RestContext.request;
        RestResponse res = RestContext.response;
        String response;
        Sub_ToDo__c reqSubTodo = (Sub_ToDo__c) JSON.deserialize(request.requestBody.toString(), Sub_ToDo__c.class);
        if(!RestUtility.existSubToDo(reqSubTodo.Id)) {
            ToDo__c td = [SELECT Id FROM ToDo__c WHERE ExtId__c = :reqSubTodo.ToDo__c];
            Sub_ToDo__c subTodo = (Sub_ToDo__c)RestUtility.copyObject(reqSubTodo);
            subTodo.ToDo__c = td.Id;
            insert subTodo;
            response = subTodo.id;
        } else {
            // if SubToDo exists
            response = '{"message":"SubToDo already exists","errorCode":"CONFLICT"}';
            res.statusCode = 409;
        }
        return response;
    }
    @HttpPut
    global static Id upsertSubTodo() {
        RestRequest request = RestContext.request;
        Sub_ToDo__c reqSubTodo = (Sub_ToDo__c) JSON.deserialize(request.requestBody.toString(), Sub_ToDo__c.class);
        ToDo__c td = [SELECT Id FROM ToDo__c WHERE ExtId__c = :reqSubTodo.ToDo__c];
        Sub_ToDo__c subTodo = (Sub_ToDo__c)RestUtility.copyObject(reqSubTodo);
        subTodo.ToDo__c = td.Id;
        if(RestUtility.existSubToDo(reqSubTodo.Id)) {
            Sub_ToDo__c targetSubTodo = [SELECT Id FROM Sub_ToDo__c WHERE ExtId__c = :reqSubTodo.Id];
            subTodo.Id = targetSubTodo.Id;
        }
        upsert subTodo;
        return subTodo.id;
    }
    @HttpPatch
    global static Id updateSubTodoFields() {
        RestResponse res = RestContext.response;
        RestRequest request = RestContext.request;
        String subTodoId = request.requestURI.substring(
            request.requestURI.lastIndexOf('/')+1);
        String response;
        if(RestUtility.existSubToDo(subTodoId)) {
            Sub_ToDo__c subTodo = [SELECT Id FROM Sub_ToDo__c WHERE ExtId__c = :subTodoId];
            // Deserialize the JSON string into name-value pairs
            Map<String, Object> params = (Map<String, Object>)JSON.deserializeUntyped(request.requestBody.toString());
            // Iterate through each parameter field and value
            for(String fieldName : params.keySet()) {
                if(fieldName == 'isDone') {
                    subTodo.put('is_done__c', params.get(fieldName));
                } else if (fieldName != 'id') {
                    // try to put
                    try {
                        subTodo.put(fieldName, params.get(fieldName));
                    } catch (SObjectException ex) {
                        System.debug('Exception subTodo.put: ' + ex);
                    }
                }
            }
            update subTodo;
            response = subTodo.id;
        } else {
            // if Sub_ToDo not exists
            response = '{"message":"SubToDo not exist","errorCode":"NOT_FOUND"}';
            res.statusCode = 404;
        }
        return response;
    }
}
