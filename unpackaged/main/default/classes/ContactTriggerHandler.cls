/**
* ContactTriggerHandler 
* Handler for the Contact trigger
*
* @author  Matteo Iacucci
* @version 1.0
* @since   2021-04-14
*/
public with sharing class ContactTriggerHandler extends sfpcz_AbstractTriggerHandler {
	ContactService contactService = new ContactService();
	rflib_Logger logger = rflib_LoggerUtil.getFactory().createLogger('ContactTriggerHandler');

	protected override void afterInsert(){
		handleSync(Constants.EVENT_CONTACTCREATED, 'SyncContactCreated', Trigger.new);
	}

	protected override void afterUpdate(){
		handleSync(Constants.EVENT_CONTACTUPDATED, 'SyncContactUpdate', Trigger.new);
	}

	protected override void beforeDelete(){
		handleSync(Constants.EVENT_CONTACTDELETED, 'SyncContactDeleted', Trigger.oldMap.values());
	}

	//method to handle the sync
	//check first if the sync feature is active
	private void handleSync(String event, String switchName, List<sObject> objs){
		//check if sync is active
		if(rflib_FeatureSwitch.isTurnedOn(switchName)){
			//handle the sycn
			contactService.handleSync((List<Contact>)objs, event);
		}
	}
}