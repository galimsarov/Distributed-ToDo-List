@isTest
public class MockHttpResponse implements HttpCalloutMock {
    // set list of responses
    HttpResponse[] responses = new HttpResponse[0];
    public void addResponse(HttpResponse response) {
        responses.add(response);
    }
    public Integer getResponsesSize() {
        return responses.size();
    }
    public HTTPResponse respond(HTTPRequest req) {
        System.debug('Mock responses.size() before return: ' + responses.size());
        return responses.remove(0);
    }
}