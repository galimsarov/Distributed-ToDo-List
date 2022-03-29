/**
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
        Sub_ToDo__c targetSubToDo = RestUtility.getSubToDoById(subTodoId);
        if(targetSubToDo==null) {
            //if SubToDo not exists
            res.statusCode = 404;
        }
        return targetSubToDo;
    }
    @HttpDelete
    global static void deleteSubTodo() {
        RestResponse res = RestContext.response;
        RestRequest request = RestContext.request;
        String subTodoId = request.requestURI.substring(
                request.requestURI.lastIndexOf('/')+1);
        Sub_ToDo__c targetSubToDo = RestUtility.getSubToDoById(subTodoId);
        if (targetSubToDo != null) {
            delete targetSubToDo;
        } else {
            // if SubToDo not exists
            res.statusCode = 404;
        }
    }
    @HttpPost
    global static String postSubTodo() {
        RestRequest request = RestContext.request;
        RestResponse res = RestContext.response;
        String response;
        Sub_ToDo__c reqSubTodo = (Sub_ToDo__c) JSON.deserialize(request.requestBody.toString(), Sub_ToDo__c.class);
        Sub_ToDo__c targetSubToDo = RestUtility.getSubToDoById(reqSubTodo.Id);
        if (targetSubToDo == null) {
            // try to find parent ToDo as copy
            ToDo__c td = RestUtility.getToDoById(reqSubTodo.ToDo__c);
            // try to find parent ToDo as source
            if (td == null && reqSubTodo.ToDo__r.ExtId__c != null) {
                td = RestUtility.getToDoById(reqSubTodo.ToDo__r.ExtId__c);
            }
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
        // try to find target SubToDo as copy
        Sub_ToDo__c targetSubToDo = RestUtility.getSubToDoById(reqSubTodo.Id);
        // try to find target SubToDo as source
        if (targetSubToDo == null && reqSubTodo.ExtId__c != null) {
            targetSubToDo = RestUtility.getSubToDoById(reqSubTodo.ExtId__c);
        }
        Sub_ToDo__c newSubTodo = (Sub_ToDo__c)RestUtility.copyObject(reqSubTodo);
        // try to find parent ToDo as copy
        ToDo__c td = RestUtility.getToDoById(reqSubTodo.ToDo__c);
        // try to find parent ToDo as source
        if (td == null && reqSubTodo.ToDo__r.ExtId__c != null) {
            td = RestUtility.getToDoById(reqSubTodo.ToDo__r.ExtId__c);
        }
        newSubTodo.ToDo__c = td.Id;
        if (targetSubTodo != null) {
            newSubTodo.Id = targetSubTodo.Id;
        }
        upsert newSubTodo;
        return newSubTodo.id;
    }
    @HttpPatch
    global static Id updateSubTodoFields() {
        RestResponse res = RestContext.response;
        RestRequest request = RestContext.request;
        String subTodoId = request.requestURI.substring(
            request.requestURI.lastIndexOf('/')+1);
        String response;
        Sub_ToDo__c targetSubToDo = RestUtility.getSubToDoById(subTodoId);
        if (targetSubToDo != null) {
            // list of fieldNames that can be updated
            List<String> fieldNameList = new List<String>{'is_done__c', 'name'};
            // Deserialize the JSON string into name-value pairs
            Map<String, Object> params = (Map<String, Object>)JSON.deserializeUntyped(request.requestBody.toString());
            // Iterate through each parameter field and value
            for(String fieldName : params.keySet()) {
                System.debug('fieldName: ' + fieldName);
                if(fieldName == 'isDone') {
                    targetSubToDo.put('is_done__c', params.get(fieldName));
                // put fieldName value if fieldName is in list
                } else if (fieldNameList.contains(fieldName.toLowerCase())) {
                    // try to put
                    try {
                        targetSubToDo.put(fieldName, params.get(fieldName));
                    } catch (SObjectException ex) {
                        System.debug('Exception subTodo.put: ' + ex);
                    }
                }
            }
            update targetSubToDo;
            response = targetSubToDo.id;
        } else {
            // if SubToDo not exists
            response = '{"message":"SubToDo not exist","errorCode":"NOT_FOUND"}';
            res.statusCode = 404;
        }
        return response;
    }
}
