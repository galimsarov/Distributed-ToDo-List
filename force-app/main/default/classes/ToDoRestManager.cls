/**
 *
 * REST web service with
 * @HttpGet, @HttpPost, @HttpDelete, @HttpPut, @HttpPatch
 * methods for ToDO object
 * (get, create, delete, upsert, update  record)
 */

@RestResource(UrlMapping='/Todo/*')
global with sharing class ToDoRestManager {
    // Inner wrapper classes used to deserialize JSON request body
    public class ReqJsonTodo {
        public String id;
        public String name;
        public String extid;
        public String status;
        public String recordTypeName;
    }

    @HttpGet
    global static ToDo__c getToDoById() {
        RestRequest request = RestContext.request;
        RestResponse res = RestContext.response;
        String todoId = request.requestURI.substring(
                request.requestURI.lastIndexOf('/')+1);
        ToDo__c targetToDo = RestUtility.getToDoById(todoId);
        System.debug('targetToDo: ' + targetToDo);
        if(targetToDo==null) {
            //if ToDo not exists
            res.statusCode = 404;
        }
        return targetToDo;
    }
    @HttpDelete
    global static void deleteToDo() {
        RestRequest request = RestContext.request;
        RestResponse res = RestContext.response;
        String todoId = request.requestURI.substring(
                request.requestURI.lastIndexOf('/')+1);
        ToDo__c targetToDo = RestUtility.getToDoById(todoId);
        if (targetToDo != null) {
                delete targetToDo;
        } else {
            // if ToDo not exists
            res.statusCode = 404;
        }
    }
    @HttpPost
    global static String postJsonToDo() {
        RestRequest request = RestContext.request;
        RestResponse res = RestContext.response;
        String response;
        // Deserializes the JSON string into wrapper Apex class.
        ReqJsonTodo reqJsonTodo = (ReqJsonTodo)JSON.deserialize(request.requestBody.toString(), ReqJsonTodo.class);
        ToDo__c targetToDo = RestUtility.getToDoById(reqJsonTodo.id);
        // System.debug('targetToDo: ' + targetToDo);
        if (targetToDo == null) {
            ToDo__c newTodo = new ToDo__c(Name=reqJsonTodo.name, Status__c=reqJsonTodo.status, ExtId__c=reqJsonTodo.id);
            newTodo.recordTypeId=RestUtility.getRecordTypeId(reqJsonTodo.recordTypeName);
            // insert new ToDo
            insert newTodo;
            response = newTodo.id;
        } else {
            response = '{"message":"ToDo already exists","errorCode":"CONFLICT"}';
            res.statusCode = 409;
        }
        return response;
    }
    @HttpPut
    global static String upsertToDo() {
        RestRequest request = RestContext.request;
        ToDo__c reqToDo = (ToDo__c) JSON.deserialize(request.requestBody.toString(), ToDo__c.class);
        // try to find target ToDo as copy
        ToDo__c targetToDo = RestUtility.getToDoById(reqToDo.Id);
        // try to find target ToDo as source
        if (targetToDo == null && reqToDo.ExtId__c != null) {
            targetToDo = RestUtility.getToDoById(reqToDo.ExtId__c);
        }
        // System.debug('targetToDo: ' + targetToDo);
        ToDo__c newTodo = (ToDo__c)RestUtility.copyObject(reqToDo);
        if (targetToDo != null) {
            newTodo.Id = targetTodo.Id;
        }
        upsert newTodo;
        return newTodo.id;
    }
    @HttpPatch
    global static String updateToDoFields() {
        RestResponse res = RestContext.response;
        RestRequest request = RestContext.request;
        String todoId = request.requestURI.substring(
                request.requestURI.lastIndexOf('/')+1);
        String response;
        ToDo__c targetToDo = RestUtility.getToDoById(todoId);
        if (targetToDo != null) {
            // Deserializes the JSON string into wrapper Apex class.
            ReqJsonTodo reqJsonTodo = (ReqJsonTodo)JSON.deserialize(request.requestBody.toString(), ReqJsonTodo.class);
            // try to update field
            try {
                targetToDo.put('name', reqJsonTodo.name);
                targetToDo.put('status__c', reqJsonTodo.status);
                targetToDo.recordTypeId=RestUtility.getRecordTypeId(reqJsonTodo.recordTypeName);
                System.debug('updateToDoFields targetToDo: ' + targetToDo);
                update targetToDo;
            } catch(DmlException e) {
                System.debug('DmlException caught: ' + e.getMessage());
            } catch(SObjectException e) {
                System.debug('SObjectException caught: ' + e.getMessage());
            }
            response = targetToDo.id;
        } else {
            // if ToDo not exists
            response = '{"message":"ToDo not exists","errorCode":"NOT_FOUND"}';
            res.statusCode = 404;
        }
        return response;
    }
}
