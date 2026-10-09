public class SyncQueueableMock implements HttpCalloutMock {

    private Integer statusCode;

    public SyncQueueableMock(Integer statusCode){
        this.statusCode = statusCode;
    }

    public HTTPResponse respond(HTTPRequest req) {
        HTTPResponse response = new HTTPResponse();
        response.setStatusCode(this.statusCode);
        return response; 
    }
}