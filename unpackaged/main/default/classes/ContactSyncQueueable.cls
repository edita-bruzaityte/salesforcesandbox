public with sharing class ContactSyncQueueable implements Queueable , Database.AllowsCallouts {
	//list of account to sync
	private List<Contact> contacts;
	//logger instance
	private rflib_Logger logger;
	//event (creation or edit)
	private String event;

	private ExternalIntegrationSelector extIntegartionSelector;

	//costructor
	public ContactSyncQueueable(List<Contact> contacts, String event) {
		this.logger = rflib_LoggerUtil.getFactory().createLogger('ContactSyncQueueable');
		this.extIntegartionSelector = new ExternalIntegrationSelector();
		this.contacts = contacts;
		this.event = event;
	}


	public void execute(QueueableContext context) {
		logger.debug('execute(): sync for event ' + this.event);
		//create the body
		Map<String, object> body = createBody();
		//serialize the body
		String jsonContact = JSON.serialize(body);
		//make the callout
		postCallout(jsonContact);

		
	}

	private Map<String, object> createBody(){
		Map<String, object> body = new Map<String, object>();
		//create the body as a map with the event and the record to sync
		body.put('event_name', (object) event);
		body.put('records', (object) this.contacts);
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
		List<External_Integration__mdt> configurations = extIntegartionSelector.getExternalIntegrationsByDeveloperName('ContactSync');
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