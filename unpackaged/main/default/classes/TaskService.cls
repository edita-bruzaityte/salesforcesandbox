/**
* TaskService 
*
* @author  Matteo Iacucci
* @version 1.0
* @since   2021-07-02
*/
public with sharing class TaskService {

	private rflib_Logger logger;


	public TaskService(){
		logger = rflib_LoggerUtil.getFactory().createLogger('TaskService');
	}

	//check if the creation or the edit wasn't made from the integration user and then sync the record
	public void handleSync(List<Task> tasks, String event){
		TaskSyncQueueable taskSyncQueueable = new TaskSyncQueueable(tasks, event);
		System.enqueueJob(taskSyncQueueable);
	}
	
}