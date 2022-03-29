/**
 * REST callouts
 * for each method of Sub-Todo REST web service from API org
 *
 * @param subTodoJson: serialized object to send
 * in body of  request.
 * Example:
 * String subTodoJson = JSON.serialize([SELECT Id, Name,
 *  Is_Done__c, ToDo__c, ExtId__c, ToDo__r.ExtId__c
 * FROM Sub_ToDo__c WHERE Id ='********']);
 */

public class SubTodoRestCallouts {

    public static Http http = new Http();
    public static HttpResponse response;
    public static HttpRequest request;

    public static HttpResponse getSubTodo(String subTodoId) {
        request = new HttpRequest();
        String originId  = RestUtility.getIdByOrigin(subTodoId, 'SubToDo');
        request.setEndpoint('callout:OrgAPI/services/apexrest/SubTodo/' + originId);
        request.setMethod('GET');
        response = http.send(request);
        if(response.getStatusCode() != 200) {
            System.debug('The status code returned was not expected: ' +
                    response.getStatusCode() + ' ' + response.getStatus());
        }
        return response;
    }
    public static HttpResponse deleteSubTodo(String subTodoId) {
        request = new HttpRequest();
        request.setMethod('DELETE');
        String originId  = RestUtility.getIdByOrigin(subTodoId, 'SubToDo');
        // If callout was made after the record was deleted in the source system, the originId check will not be available
        String recordId = (originId!=null) ? originId : subTodoId;
        request.setEndpoint('callout:OrgAPI/services/apexrest/SubTodo/' + recordId);
        response = http.send(request);
        if(response.getStatusCode() != 200) {
            System.debug('The status code returned was not expected: ' +
                    response.getStatusCode() + ' ' + response.getStatus());
        }
        return response;
    }
    public static HttpResponse postSubTodo(String subTodoJson) {
        request = new HttpRequest();
        request.setMethod('POST');
        request.setEndpoint('callout:OrgAPI/services/apexrest/SubTodo/');
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        request.setBody(subTodoJson);
        response = http.send(request);
        if(response.getStatusCode() != 200) {
            System.debug('The status code returned was not expected: ' +
                    response.getStatusCode() + ' ' + response.getStatus());
        }
        return response;
    }
    public static HttpResponse putSubTodo(String subTodoJson) {
        request = new HttpRequest();
        request.setMethod('PUT');
        request.setEndpoint('callout:OrgAPI/services/apexrest/SubTodo/');
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        request.setBody(subTodoJson);
        response = http.send(request);
        if(response.getStatusCode() != 200) {
            System.debug('The status code returned was not expected: ' +
                    response.getStatusCode() + ' ' + response.getStatus());
        }
        return response;
    }
    // for Patch method examples of object serialization:
    // 1) String subTodoJson = '{"name":"1 PATCH TEST JSON","isDone":true}';
    // 2) String subTodoJson = JSON.serialize([SELECT Name, Is_Done__c, ToDo__c,
    //    ExtId__c, ToDo__r.ExtId__c FROM Sub_ToDo__c WHERE Id
    // = '************']);
    public static HttpResponse patchSubTodo(String subTodoId, String subTodoJson) {
        request = new HttpRequest();
        request.setMethod('PATCH');
        String originId  = RestUtility.getIdByOrigin(subTodoId, 'SubToDo');
        request.setEndpoint('callout:OrgAPI/services/apexrest/SubTodo/' + originId);
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        request.setBody(subTodoJson);
        response = http.send(request);
        if(response.getStatusCode() != 200) {
            System.debug('The status code returned was not expected: ' +
                    response.getStatusCode() + ' ' + response.getStatus());
        }
        return response;
    }
}
