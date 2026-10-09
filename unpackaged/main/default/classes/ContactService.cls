/**
* ContactService 
*
* @author  Matteo Iacucci
* @version 1.0
* @since   2021-4-14
*/
public with sharing class ContactService {

    private rflib_Logger logger;

    public ContactService(){
        logger = rflib_LoggerUtil.getFactory().createLogger('ContactService');
    }

	//check if the creation or the edit wasn't made from the integration user and then sync the record
	public void handleSync(List<Contact> contacts, String event){
		ContactSyncQueueable contactSyncQueueable = new ContactSyncQueueable(contacts, event);
		System.enqueueJob(contactSyncQueueable);
	}
    
}