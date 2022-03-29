/**
 *
 * REST web service with
 * @HttpGet, @HttpPost, @HttpDelete, @HttpPut, @HttpPatch
 * methods for ToDO object
 * (get, create, delete, upsert, update  record)
 */

@RestResource(UrlMapping='/Todo/*')
global with sharing class ToDoRestManager {

    @HttpGet
    global static ToDo__c getToDoById() {
        RestRequest request = RestContext.request;
        RestResponse res = RestContext.response;
        String todoId = request.requestURI.substring(
                request.requestURI.lastIndexOf('/')+1);
        ToDo__c targetToDo = RestUtility.getToDoById(todoId);
        System.debug('targetToDo: ' + targetToDo);
        // if (RestUtility.existsCopyToDo(todoId)) {
        // if (result) {
        //     // result = [SELECT Id, Name,
        //     //                 Status__c, OwnerId, ExtId__c,     (SELECT Id, Name, Is_Done__c, ToDo__c FROM Sub_ToDos__r)
        //     //                 FROM ToDo__c
        //     //                 WHERE ExtId__c = :todoId];
        //     return
        // } else {
        //     //if ToDo not exists
        //     res.statusCode = 404;
        // }
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
        System.debug('targetToDo: ' + targetToDo);
        // if (RestUtility.existsCopyToDo(todoId)) {
        if (targetToDo != null) {
                // ToDo__c thisToDo = [SELECT Id FROM ToDo__c WHERE ExtId__c = :todoId];
                // delete thisToDo;
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
        ToDo__c reqToDo = (ToDo__c) JSON.deserialize(request.requestBody.toString(), ToDo__c.class);
        ToDo__c targetToDo = RestUtility.getToDoById(reqToDo.Id);
        System.debug('targetToDo: ' + targetToDo);
        // if (!RestUtility.existsCopyToDo(reqToDo.Id)) {
        if (targetToDo == null) {
            ToDo__c td = (ToDo__c)RestUtility.copyObject(reqToDo);
            insert td;
            List<Sub_ToDo__c> listSubTd = reqToDo.getSObjects('Sub_ToDos__r');
            if(listSubTd != null) {
                List<Sub_ToDo__c> newSubTodoList = new List<Sub_ToDo__c>();
                for(Sub_ToDo__c sb : listSubTd) {
                    Sub_ToDo__c subTodo = (Sub_ToDo__c)RestUtility.copyObject(sb);
                    subTodo.ToDo__c = td.Id;
                    newSubTodoList.add(subTodo);
                }
                insert newSubTodoList;
            }
            response = td.id;
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
        System.debug('targetToDo: ' + targetToDo);
        ToDo__c newTodo = (ToDo__c)RestUtility.copyObject(reqToDo);
        // if (RestUtility.existsCopyToDo(reqToDo.Id)) {
        if (targetToDo != null) {
            // ToDo__c targetTodo = [SELECT Id FROM ToDo__c WHERE ExtId__c = :reqToDo.Id];
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
            // Deserialize the JSON string into name-value pairs
            Map<String, Object> params = (Map<String, Object>)JSON.deserializeUntyped(request.requestBody.toString());
            // list of fieldNames that can be updated
            List<String> fieldNameList = new List<String>{'status__c', 'name', 'recordTypeid', 'recordType.Name'};
            // Iterate through each parameter field and value
            for(String fieldName : params.keySet()) {
                if(fieldName == 'status') {
                    targetToDo.put('status__c', params.get(fieldName));
                // put fieldName value if fieldName is in list
                } else if (fieldNameList.contains(fieldName.toLowerCase())) {
                    // try to update field
                    try {
                        targetToDo.put(fieldName, params.get(fieldName));
                    } catch (SObjectException ex) {
                        System.debug('Exception subTodo.put: ' + ex);
                    }
                }
            }
            update targetToDo;
            response = targetToDo.id;
        } else {
            // if ToDo not exists
            response = '{"message":"ToDo not exists","errorCode":"NOT_FOUND"}';
            res.statusCode = 404;
        }
        return response;
    }
}
