/**
 *
 * REST callouts
 * for each method of ToDo REST web service from API org
 */

public class ToDoRestCallouts {

    public static Http http = new Http();
    public static HttpResponse response;
    public static HttpRequest request;

    public static HttpResponse getToDo(Id todoId) {
        request = new HttpRequest();
        request.setEndpoint('callout:OrgAPI/services/apexrest/Todo/' + todoId);
        request.setMethod('GET');
        response = http.send(request);
        System.debug('response.getBody(): ' + response.getBody());
        if(response.getStatusCode() == 200) {
            ToDo__c respToDo = (ToDo__c) JSON.deserialize(response.getBody(), ToDo__c.class);
            System.debug('respToDo: ' + respToDo);
            List<Sub_ToDo__c> listSubTd = respToDo.getSObjects('Sub_ToDos__r');
            if(listSubTd != null) {
                System.debug('listSubTd: ' + listSubTd);
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
        request.setEndpoint('callout:OrgAPI/services/apexrest/Todo/' + todoId);
        response = http.send(request);
        System.debug('response.getBody(): ' + response.getBody());
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
        System.debug('response.getBody(): ' + response.getBody());
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
        System.debug('response.getBody(): ' + response.getBody());
        if(response.getStatusCode() != 200) {
            System.debug('The status code returned was not expected: ' +
                    response.getStatusCode() + ' ' + response.getStatus());
        }
        return response;
    }
    public static HttpResponse patchToDo(String todoId, String todoJson) {
        request = new HttpRequest();
        request.setMethod('PATCH');
        request.setEndpoint('callout:OrgAPI/services/apexrest/Todo/' + todoId);
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        request.setBody(todoJson);
        response = http.send(request);
        System.debug('response.getBody(): ' + response.getBody());
        if(response.getStatusCode() != 200) {
            System.debug('The status code returned was not expected: ' +
                    response.getStatusCode() + ' ' + response.getStatus());
        }
        return response;
    }
}
