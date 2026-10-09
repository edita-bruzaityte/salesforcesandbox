/**
* TaskTriggerHandler 
* Handler for the Task trigger
*
* @author  Matteo Iacucci
* @version 1.0
* @since   2021-07-02
*/
public with sharing class TaskTriggerHandler extends sfpcz_AbstractTriggerHandler {
	TaskService taskService = new TaskService();
	rflib_Logger logger = rflib_LoggerUtil.getFactory().createLogger('TaskTriggerHandler');

	protected override void afterInsert(){
		handleSync(Constants.EVENT_TASKCREATED, 'SyncTaskCreated', Trigger.new);
	}

	protected override void afterUpdate(){
		handleSync(Constants.EVENT_TASKUPDATED, 'SyncTaskUpdate', Trigger.new);
	}

	protected override void beforeDelete(){
		handleSync(Constants.EVENT_TASKDELETED, 'SyncTaskDeleted', Trigger.oldMap.values());
	}

	//method to handle the sync
	//check first if the sync feature is active
	private void handleSync(String event, String switchName, List<sObject> objs){
		//check if sync is active
		if(rflib_FeatureSwitch.isTurnedOn(switchName)){
			//handle the sycn
			taskService.handleSync((List<Task>)objs, event);
		}
	}
}