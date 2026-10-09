public with sharing class ClaimSyncQueueable implements Queueable , Database.AllowsCallouts {
	//list of claim to sync
	private List<Claim> claims;
	//logger instance
	private rflib_Logger logger;
	//event (creation or edit)
	private String event;

	private ExternalIntegrationSelector extIntegartionSelector;

	//costructor
	public ClaimSyncQueueable(List<Claim> claims, String event) {
		this.logger = rflib_LoggerUtil.getFactory().createLogger('ClaimSyncQueueable');
		this.extIntegartionSelector = new ExternalIntegrationSelector();
		this.claims = claims;
		this.event = event;
	}


	public void execute(QueueableContext context) {
		logger.debug('execute(): sync for event ' + this.event);
		//create the body
		Map<String, object> body = createBody();
		//serialize the body
		String jsonClaims = JSON.serialize(body);
		//make the callout
		postCallout(jsonClaims);

		
	}

	private Map<String, object> createBody(){
		Map<String, object> body = new Map<String, object>();
		//create the body as a map with the event and the record to sync
		body.put('event_name', (object) event);
		body.put('records', (object) this.claims);
		return body;
	}

	//perform the sync and log the result
	private void postCallout(String jsonBody) {
		String url = createUrl();
		if(url != null){
			HttpResponse response = SyncQueuebleCalloutUtil.postCallout( url, jsonBody);
			if(response?.getStatusCode() != 200){
				logger.error('postCallout() -> Event: ' + this.event + ',returned status code: ' + response?.getStatusCode() + ', body: ' + response?.getBody());
			}else{
				logger.debug('postCallout() -> Event: ' + this.event + ',returned status code: ' + response?.getStatusCode() + ', body: ' + response?.getBody());
			}
		}
	}

	private String createUrl(){
		List<External_Integration__mdt> configurations = extIntegartionSelector.getExternalIntegrationsByDeveloperName('ClaimSync');
		if(configurations == null || configurations.size() == 0){
			logger.error('No configuration for external Integration found');
			return null;
		}else{
			External_Integration__mdt conf = configurations.get(0);
			String url = conf.Base_Url__c + conf.Path__c + '?apikey=' + conf.API_Key__c;
			logger.debug('generated URL ' + url);
			return url;
		}
	}
}