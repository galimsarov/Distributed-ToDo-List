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
        String todoId = request.requestURI.substring(
                request.requestURI.lastIndexOf('/')+1);
        ToDo__c result = [SELECT Id, Name,
                            Status__c, OwnerId,          (SELECT Id, Name, Is_Done__c, ToDo__c FROM Sub_ToDos__r)
                            FROM ToDo__c
                            WHERE Id = :todoId];
        return result;
    }
    @HttpDelete
    global static void deleteToDo() {
        RestRequest request = RestContext.request;
        String todoId = request.requestURI.substring(
                request.requestURI.lastIndexOf('/')+1);
        ToDo__c thisToDo = [SELECT Id FROM ToDo__c WHERE Id = :todoId];
        delete thisToDo;
    }
    @HttpPost
    global static String postToDo(String name, String status) {
        ToDo__c td = new ToDo__c();
        td.Name = name;
        td.Status__c = status;
        insert td;
        return td.Id;
    }
    @HttpPut
    global static Id upsertToDo(String name, String status, String id) {
        ToDo__c thisToDo = new ToDo__c(
                Id=id,
                Name=name,
                Status__c=status
                );
        upsert thisToDo;
        return thisToDo.Id;
    }
    @HttpPatch
    global static Id updateToDoFields() {
        RestRequest request = RestContext.request;
        String todoId = request.requestURI.substring(
                request.requestURI.lastIndexOf('/')+1);
        ToDo__c thisToDo = [SELECT Id FROM ToDo__c WHERE Id = :todoId];
        System.debug('rest Patch: thisToDo: ' + thisToDo);
        // Deserialize the JSON string into name-value pairs
        Map<String, Object> params = (Map<String, Object>)JSON.deserializeUntyped(request.requestBody.toString());
        System.debug('rest Patch: params: ' + params);
        // Iterate through each parameter field and value
        for(String fieldName : params.keySet()) {
            if(fieldName == 'status') {
                thisToDo.put('status__c', params.get(fieldName));
            } else {
                thisToDo.put(fieldName, params.get(fieldName));
            }
        }
        update thisToDo;
        return thisToDo.Id;
    }
}
