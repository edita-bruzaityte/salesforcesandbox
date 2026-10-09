/**
 * The ContactSelector_Test to test ContactSelector.
 *
 * @author  Matteo Iacucci
 * @version 1.0
 * @since   2021-01-07
 */
@IsTest
public class ContactSelector_Test {
	@IsTest
	public static void testGetContactByProfileId(){
		String contactName = 'testContact';
		Account account = (Account) TestDataFactory.createSimpleAccount('testAccount').insertObj();
		Contact contact = (Contact) TestDataFactory.createSimpleContact(contactName, account.Id, '2312312').insertObj();

		Test.startTest();
		Contact retrievedContact  = new ContactSelector().getContactByProfileId(contactName + '_pid');
		Test.stopTest();
		System.assertEquals(contact.Id, retrievedContact.Id, 'The 2 Contact are different.');	
	} 

	@IsTest
	public static void testGetContactByProfileIdNull(){
		String contactName = 'testContact';
		Account account = (Account) TestDataFactory.createSimpleAccount('testAccount').insertObj();
		Contact contact = (Contact) TestDataFactory.createSimpleContact(contactName, account.Id, '2312312').insertObj();

		Test.startTest();
		Contact retrievedContact  = new ContactSelector().getContactByProfileId(contactName + '1@testdatafactory.com');
		Test.stopTest();
		System.assertEquals(null, retrievedContact, 'One Contact was retrieved.');	
	}
}