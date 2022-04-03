/**
 * REST web service with
 * @HttpGet, @HttpPost, @HttpDelete, @HttpPut, @HttpPatch
 * methods for Sub-ToDO object
 * (get, create, delete, upsert, update  record)
 */

@RestResource(urlMapping='/SubTodo/*')
global with sharing class SubTodoRestManager {

    // Inner wrapper classes used to deserialize JSON request body
    public class ReqJsonSubTodo {
        public String id;
        public String name;
        public String extid;
        public Boolean isDone;
        public String todo;
        public String todoExtId;
    }

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
        // Deserializes JSON string into wrapper Apex class.
        ReqJsonSubTodo reqJsonSubTd = (ReqJsonSubTodo) JSON.deserialize(request.requestBody.toString(), ReqJsonSubTodo.class);
        // System.debug('postSubTodo reqJsonSubTd: ' + reqJsonSubTd);
        Sub_ToDo__c targetSubToDo = RestUtility.getSubToDoById(reqJsonSubTd.Id);
        if (targetSubToDo == null) {
            // try to find parent ToDo as copy
            ToDo__c td = RestUtility.getToDoById(reqJsonSubTd.todo);
            // try to find parent ToDo as source
            if (td == null && reqJsonSubTd.todoExtId != null) {
                td = RestUtility.getToDoById(reqJsonSubTd.todoExtId);
            }
            if (td != null) {
                Sub_ToDo__c newSubTodo = new Sub_ToDo__c(Name=reqJsonSubTd.name, Is_Done__c=reqJsonSubTd.isDone, ExtId__c=reqJsonSubTd.id, ToDo__c=td.Id);
                // insert new SubToDo
                Database.SaveResult sr = Database.insert(newSubTodo, false);
                if (sr.isSuccess()) {
                    // Operation was successful, so get the ID of the record that was processed
                    System.debug('Successfully inserted subTodo. SubToDo ID: ' + sr.getId());
                }
                else {
                    // Operation failed, so get all errors
                    for(Database.Error err : sr.getErrors()) {
                        System.debug('The following error has occurred.');
                        System.debug(err.getStatusCode() + ': ' + err.getMessage());
                        System.debug('SubToDo fields that affected this error: ' + err.getFields());
                    }
                }
                response = newSubTodo.id;
            } else {
                // if parent ToDo not exists
                response = '{"message":"ToDo not exists","errorCode":"NOT_FOUND"}';
                res.statusCode = 404;
            }
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
        RestResponse res = RestContext.response;
        String response;
        // Deserializes JSON string into wrapper Apex class.
        ReqJsonSubTodo reqJsonSubTd = (ReqJsonSubTodo) JSON.deserialize(request.requestBody.toString(), ReqJsonSubTodo.class);
        // System.debug('upsertSubTodo reqJsonSubTd: ' + reqJsonSubTd);
        // try to find parent ToDo as copy
        ToDo__c td = RestUtility.getToDoById(reqJsonSubTd.todo);
        // try to find parent ToDo as source
        if (td == null && reqJsonSubTd.todoExtId != null) {
            td = RestUtility.getToDoById(reqJsonSubTd.todoExtId);
        }
        if (td != null) {
            Sub_ToDo__c newSubTodo = new Sub_ToDo__c(Name=reqJsonSubTd.name, Is_Done__c=reqJsonSubTd.isDone,  ToDo__c=td.Id);
            if (reqJsonSubTd.id != null) {
                newSubTodo.ExtId__c=reqJsonSubTd.id;
                // try to find target SubToDo as copy
                Sub_ToDo__c targetSubToDo = RestUtility.getSubToDoById(reqJsonSubTd.id);
                // try to find target ToDo as source
                if (targetSubToDo == null && reqJsonSubTd.extid != null) {
                    targetSubToDo = RestUtility.getSubToDoById(reqJsonSubTd.extid);
                }
                // System.debug('targetSubToDo: ' + targetSubToDo);
                if (targetSubToDo != null) {
                    newSubTodo.Id = targetSubToDo.Id;
                }
            }
            // upsert new SubToDo
            // System.debug('before upsert newSubTodo: ' + newSubTodo);
            try {
                upsert newSubTodo;

            } catch(DmlException e) {
                System.debug('upsert DmlException caught: ' + e.getMessage());
            }
            // System.debug('after upsert newSubTodo: ' + newSubTodo);
            response = newSubTodo.id;
        } else {
            // if parent ToDo not exists
            response = '{"message":"Parent ToDo not exists","errorCode":"NOT_FOUND"}';
            res.statusCode = 404;
        }
        return response;
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
            // Deserializes the JSON string into wrapper Apex class.
            ReqJsonSubTodo reqJsonSubTd = (ReqJsonSubTodo)JSON.deserialize(request.requestBody.toString(), ReqJsonSubTodo.class);
            // System.debug('updateSubTodoFields reqJsonSubTd: ' + reqJsonSubTd);
            // try to update field
            try {
                targetSubToDo.put('name', reqJsonSubTd.name);
                targetSubToDo.put('is_done__c', reqJsonSubTd.isDone);
                update targetSubToDo;

            } catch(DmlException e) {
                System.debug('DmlException caught: ' + e.getMessage());
            } catch(SObjectException e) {
                System.debug('SObjectException caught: ' + e.getMessage());
            }
            response = targetSubToDo.id;
        } else {
            // if SubToDo not exists
            response = '{"message":"SubToDo not exist","errorCode":"NOT_FOUND"}';
            res.statusCode = 404;
        }
        return response;
    }
}
