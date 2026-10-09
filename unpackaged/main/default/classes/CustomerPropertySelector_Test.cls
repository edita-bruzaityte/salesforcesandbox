/**
 * The CustomerPropertySelector_Test to test CustomerPropertySelector.
 *
 * @author  Matteo Iacucci
 * @version 1.0
 * @since   2021-05-07
 */
@IsTest
public class CustomerPropertySelector_Test {
	@IsTest
	public static void testGetCustomerPropertyByRegistrationNumber(){
		String registrationNumber = 'reg123';
		Account a = (Account) TestDataFactory.createSimpleAccount('testAccount').insertObj();
		CustomerProperty cp = (CustomerProperty) TestDataFactory.createCustomerProperty(registrationNumber, a.Id).insertObj();

		Test.startTest();
		CustomerProperty retrievedcp  = new CustomerPropertySelector().getCustomerPropertyByRegistrationNumber(registrationNumber);
		Test.stopTest();
		System.assertEquals(cp.Id, retrievedcp.Id, 'The 2 Customer Proprieties are different.');	
	}

	@IsTest
	public static void testGetCustomerPropertyByRegistrationNumberException(){
		Test.startTest();
		CustomerProperty retrievedcp  = new CustomerPropertySelector().getCustomerPropertyByRegistrationNumber('testExcepton');
		Test.stopTest();
			
		System.assertEquals(null, retrievedcp, 'Customer property retrieved');	
	}
}