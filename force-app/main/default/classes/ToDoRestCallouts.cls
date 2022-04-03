/**
 * REST callouts
 * for each method of ToDo REST web service from API org
 *
 * @param todoId: Id or ExtId of ToDo record
 *
 * @param todoJson: serialized object to send
 * in body of  request.
 * Example:
 * String todoJson = JSON.serialize([SELECT Id, Name,
 *  Status__c, ExtId__c, RecordType.Name FROM ToDo__c WHERE Id ='********']);
 */

public class ToDoRestCallouts {

    public static Http http = new Http();
    public static HttpResponse response;
    public static HttpRequest request;
    // testing strings
    public static String testbody = null;
    public static String testpoint = null;
    public static Integer statusCode = 0;

    public static HttpResponse getToDo(Id todoId) {
        request = new HttpRequest();
        String originId  = RestUtility.getIdByOrigin(todoId, 'ToDo');
        request.setEndpoint('callout:OrgAPI/services/apexrest/Todo/' + originId);
        request.setMethod('GET');
        response = http.send(request);
        if(response.getStatusCode() != 200) {
            System.debug('The status code returned was not expected: ' +
                    response.getStatusCode() + ' ' + response.getStatus());
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
        System.debug('ToDoRestCallouts deleteToDo recordId: ' + recordId);
        response = http.send(request);
        if(response.getStatusCode() != 200) {
            System.debug('The status code returned was not expected: ' +
                    response.getStatusCode() + ' ' + response.getStatus());
        }
        System.debug('ToDoRestCallouts deleteToDo response.getStatusCode(): ' + response.getStatusCode());
        forUnitTest(response);
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
        forUnitTest(response);
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
        forUnitTest(response);
        return response;
    }
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
        forUnitTest(response);
        return response;
    }
    public static void forUnitTest(HttpResponse response) {
        // for future callout unit test
        if (Test.isRunningTest()) {
                testbody = (String)response.getBody();
                testpoint=(String)request.getEndpoint();
                statusCode = (Integer)response.getStatusCode();
        }
    }
}
