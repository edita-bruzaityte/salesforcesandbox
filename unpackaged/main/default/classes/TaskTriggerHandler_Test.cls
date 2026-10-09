/**
 * The TaskTriggerHandler_Test to test TaskTriggerHandler.
 *
 * @author  Matteo Iacucci
 * @version 1.0
 * @since   2021-07-02
 */
@IsTest
public class TaskTriggerHandler_Test {
	@IsTest
	public static void testClaimSyncSuccess(){
		Test.setMock(HttpCalloutMock.class, new SyncQueueableMock(200));
		
		Test.startTest();
		Task task = (Task) TestDataFactory.createSimpleTask().insertObj();
		update task;
		delete task;
		Test.stopTest();
	}

	@IsTest
	public static void testTaskSyncFail(){
		Test.setMock(HttpCalloutMock.class, new SyncQueueableMock(400));
        Test.startTest();
		Task task = (Task) TestDataFactory.createSimpleTask().insertObj();
		update task;
		delete task;
		Test.stopTest();
	}
}