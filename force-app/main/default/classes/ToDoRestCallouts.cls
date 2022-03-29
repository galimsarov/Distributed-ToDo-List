/**
 * REST callouts
 * for each method of ToDo REST web service from API org
 *
 * @param todoId: Id or ExtId of ToDo record
 * If the record is the original, the argument
 * for the todoId parameter is the record's Id.
 * If the record is a copy, the argument for
 * the todoId parameter will be the record's ExtId
 *
 * @param todoJson: serialized object to send
 * in body of  request.
 * Example:
 * String todoJson = JSON.serialize([SELECT Id, Name,
 *  Status__c, ExtId__c (SELECT Name, Is_Done__c, ToDo__c  FROM
 * Sub_ToDos__r) FROM ToDo__c WHERE Id ='********']);
 */

public class ToDoRestCallouts {

    public static Http http = new Http();
    public static HttpResponse response;
    public static HttpRequest request;

    public static HttpResponse getToDo(Id todoId) {
        request = new HttpRequest();
        String originId  = RestUtility.getIdByOrigin(todoId, 'ToDo');
        request.setEndpoint('callout:OrgAPI/services/apexrest/Todo/' + originId);
        request.setMethod('GET');
        response = http.send(request);
        if(response.getStatusCode() == 200) {
            ToDo__c respToDo = (ToDo__c) JSON.deserialize(response.getBody(), ToDo__c.class);
            List<Sub_ToDo__c> listSubTd = respToDo.getSObjects('Sub_ToDos__r');
            if(listSubTd.size()>0) {
                for(Sub_ToDo__c sb : listSubTd) {
                    System.debug('sb: ' + sb);
                }
            }
        }
        return response;
    }
    public static HttpResponse deleteToDo(String todoId) {
        request = new HttpRequest();
        request.setMethod('DELETE');
        String originId  = RestUtility.getIdByOrigin(todoId, 'ToDo');
        // If the callout was made after the record was deleted in the source system, the originId check will not be available
        String recordId = (originId!=null) ? originId : todoId;
        request.setEndpoint('callout:OrgAPI/services/apexrest/Todo/' + recordId);
        response = http.send(request);
        if(response.getStatusCode() != 200) {
            System.debug('The status code returned was not expected: ' +
                    response.getStatusCode() + ' ' + response.getStatus());
        }
        return response;
    }
    public static HttpResponse postToDo(String todoJson) {
        request = new HttpRequest();
        request.setMethod('POST');
        request.setEndpoint('callout:OrgAPI/services/apexrest/Todo/');
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        request.setBody(todoJson);
        response = http.send(request);
        if(response.getStatusCode() != 200) {
            System.debug('The status code returned was not expected: ' +
                    response.getStatusCode() + ' ' + response.getStatus());
        }
        return response;
    }
    public static HttpResponse putToDo(String todoJson) {
        request = new HttpRequest();
        request.setMethod('PUT');
        request.setEndpoint('callout:OrgAPI/services/apexrest/Todo/');
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        request.setBody(todoJson);
        response = http.send(request);
        if(response.getStatusCode() != 200) {
            System.debug('The status code returned was not expected: ' +
                    response.getStatusCode() + ' ' + response.getStatus());
        }
        return response;
    }
    // for Patch method examples of object serialization:
    // 1) String todoJson = '{"name":"PATCH TEST JSON","status":"Done"}';
    // 2) String todoJson = JSON.serialize([SELECT Name,  Status__c FROM ToDo__c WHERE Id
    // = '*****']);
    public static HttpResponse patchToDo(String todoId, String todoJson) {
        request = new HttpRequest();
        request.setMethod('PATCH');
        String originId  = RestUtility.getIdByOrigin(todoId, 'ToDo');
        request.setEndpoint('callout:OrgAPI/services/apexrest/Todo/' + originId);
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        request.setBody(todoJson);
        response = http.send(request);
        if(response.getStatusCode() != 200) {
            System.debug('The status code returned was not expected: ' +
                    response.getStatusCode() + ' ' + response.getStatus());
        }
        return response;
    }
}
