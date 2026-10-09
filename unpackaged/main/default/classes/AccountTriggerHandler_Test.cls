/**
 * The AccountTriggerHandler_Test to test AccountTriggerHandler.
 *
 * @author  Matteo Iacucci
 * @version 1.0
 * @since   2021-01-18
 */
@IsTest
public class AccountTriggerHandler_Test {
	@IsTest
	public static void testAccountSyncSuccess(){
		
		Test.setMock(HttpCalloutMock.class, new SyncQueueableMock(200));
		Test.startTest();
		Account account = (Account) TestDataFactory.createSimpleAccount('testAccount').insertObj();
		Account.Name = 'TestUpdate NametName';
		update account;
        List<Entitlement> le = [SELECT id FROM Entitlement];
        delete le;
		delete account;
		Test.stopTest();
	}

	@IsTest
	public static void testAccountSyncFail(){
		
		Test.setMock(HttpCalloutMock.class, new SyncQueueableMock(400));
		Test.startTest();
		Account account = (Account) TestDataFactory.createSimpleAccount('testAccount').insertObj();
		Account.Name = 'TestUpdate NametName';
		update account;
        List<Entitlement> le = [SELECT id FROM Entitlement];
        delete le;
		delete account;
		Test.stopTest();
	} 
}