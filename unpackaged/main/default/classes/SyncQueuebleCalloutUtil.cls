/**
* SyncQueuebleCalloutUtil 
* Util class to perform the callout to AWS for the sync of account, contact and case
* @author  Matteo Iacucci
* @version 1.0
* @since   2021-4-14
*/
public with sharing class SyncQueuebleCalloutUtil {
    
    public static HttpResponse postCallout(String url, String jsonBody) {
        rflib_Logger logger = rflib_LoggerUtil.getFactory().createLogger('SyncQueuebleCalloutUtil');
		try{
			// Instantiate a new http object
			Http h = new Http();
		
			// Instantiate a new HTTP request, specify the method (GET) as well as the endpoint
			HttpRequest request = new HttpRequest();
			request.setEndpoint(url);
			request.setMethod('POST');
			request.setBody( jsonBody);
		
			// Send the request, and return a response

			HttpResponse response = h.send(request);
			return response;
		}catch(Exception e){
			logger.error('postCallout() -> Exception: ' + e.getMessage(), e);
            return null;
		}
	}
}