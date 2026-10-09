/**
 * The ContactTriggerHandler_Test to test contactTriggerHandler.
 *
 * @author  Matteo Iacucci
 * @version 1.0
 * @since   2021-01-18
 */
@IsTest
public class ContactTriggerHandler_Test {
	@IsTest
	public static void testContactSyncSuccess(){
		String contactName = 'testContact';
		Account account = (Account) TestDataFactory.createSimpleAccount('testAccount').insertObj();
		Test.setMock(HttpCalloutMock.class, new SyncQueueableMock(200));
		Test.startTest();
		Contact contact = (Contact) TestDataFactory.createSimpleContact(contactName, account.Id, '2312312').insertObj();
		contact.FirstName = 'UpdateFirstName';
		update contact;
		delete contact;
		Test.stopTest();
	}

	@IsTest
	public static void testContactSyncFail(){
		String contactName = 'testContact';
		Account account = (Account) TestDataFactory.createSimpleAccount('testAccount').insertObj();
		Test.setMock(HttpCalloutMock.class, new SyncQueueableMock(400));
		Test.startTest();
		Contact contact = (Contact) TestDataFactory.createSimpleContact(contactName, account.Id, '2312312').insertObj();
		contact.FirstName = 'UpdateFirstName';
		update contact;
		delete contact;
		Test.stopTest(); 
	}
}