/**
 *
 * REST callouts
 * for each method of Sub-Todo REST web service from API org
 */

public class SubTodoRestCallouts {

    public static Http http = new Http();
    public static HttpResponse response;
    public static HttpRequest request;

    public static HttpResponse getSubTodo(String id) {
        request = new HttpRequest();
        request.setEndpoint('callout:OrgAPI/services/apexrest/SubTodo/' + id);
        request.setMethod('GET');
        response = http.send(request);
        System.debug('response.getBody(): ' + response.getBody());
        if(response.getStatusCode() == 200) {
            Sub_ToDo__c subTodo = (Sub_ToDo__c) JSON.deserialize(response.getBody(), Sub_ToDo__c.class);
            System.debug('subTodo: ' + subTodo);
        }
        return response;
    }
    public static HttpResponse deleteSubTodo(String id) {
        request = new HttpRequest();
        request.setMethod('DELETE');
        request.setEndpoint('callout:OrgAPI/services/apexrest/SubTodo/' + id);
        response = http.send(request);
        System.debug('response.getBody(): ' + response.getBody());
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
        System.debug('response.getBody(): ' + response.getBody());
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
        System.debug('response.getBody(): ' + response.getBody());
        if(response.getStatusCode() != 200) {
            System.debug('The status code returned was not expected: ' +
                    response.getStatusCode() + ' ' + response.getStatus());
        }
        return response;
    }
    public static HttpResponse patchSubTodo(String subTodoId, String subTodoJson) {
        request = new HttpRequest();
        request.setMethod('PATCH');
        request.setEndpoint('callout:OrgAPI/services/apexrest/SubTodo/' + subTodoId);
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        request.setBody(subTodoJson);
        response = http.send(request);
        System.debug('response.getBody(): ' + response.getBody());
        if(response.getStatusCode() != 200) {
            System.debug('The status code returned was not expected: ' +
                    response.getStatusCode() + ' ' + response.getStatus());
        }
        return response;
    }
}
