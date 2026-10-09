/**
* AccountTriggerHandler 
* Handler for the Account trigger
*
* @author  Matteo Iacucci
* @version 1.0
* @since   2021-04-14
*/
public with sharing class AccountTriggerHandler extends sfpcz_AbstractTriggerHandler {
	AccountService accountService = new AccountService();
	rflib_Logger logger = rflib_LoggerUtil.getFactory().createLogger('AccountTriggerHandler');

	protected override void afterInsert(){
		handleSync(Constants.EVENT_ACCOUNTCREATED, 'SyncAccountCreated', Trigger.new);
	}

	protected override void afterUpdate(){
		handleSync(Constants.EVENT_ACCOUNTUPDATED, 'SyncAccountUpdate', Trigger.new);
	}

	protected override void beforeDelete(){
		handleSync(Constants.EVENT_ACCOUNTDELETED, 'SyncAccountDeleted', Trigger.oldMap.values());
	}

	//method to handle the sync
	//check first if the sync feature is active
	private void handleSync(String event, String switchName, List<sObject> objs){
		//check if sync is active
		if(rflib_FeatureSwitch.isTurnedOn(switchName)){
			//handle the sycn
			accountService.handleSync((List<Account>)objs, event);
		}
	}
}