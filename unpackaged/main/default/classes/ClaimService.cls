/**
* ClaimService 
*
* @author  Matteo Iacucci
* @version 1.0
* @since   2021-06-24
*/
public with sharing class ClaimService {

	private rflib_Logger logger;


	public ClaimService(){
		logger = rflib_LoggerUtil.getFactory().createLogger('ClaimService');
	}

	//check if the creation or the edit wasn't made from the integration user and then sync the record
	public void handleSync(List<Claim> claims, String event){
		ClaimSyncQueueable claimSyncQueueable = new ClaimSyncQueueable(claims, event);
		System.enqueueJob(claimSyncQueueable);
	}
	
}