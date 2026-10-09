/**
 * The CaseSelector_Test to test CaseSelector.
 *
 * @author  Matteo Iacucci
 * @version 1.0
 * @since   2021-05-19
 */
@IsTest
public class CaseSelector_Test {
	@IsTest
	public static void testGetCaseById(){
		Account account = (Account) TestDataFactory.createSimpleAccount('test').insertObj();
		Case c = (Case) TestDataFactory.createSimpleCase(account.Id).insertObj();

		Test.startTest();
		Case retrievedCase  = new CaseSelector().getCaseById(c.Id);
		Test.stopTest();
		System.assertEquals(c.Id, retrievedCase.Id, 'The 2 Cases are different.');	
	}

	@IsTest
	public static void testGetCaseByIdNull(){
		Test.startTest();
		Case retrievedCase  = new CaseSelector().getCaseById('5003M000003XuQXQA0');
		Test.stopTest();
		System.assertEquals(null, retrievedCase, 'One Case was retrieved.');	
	}


	@IsTest
	public static void testGetCaseByIds(){
		Account account = (Account) TestDataFactory.createSimpleAccount('test').insertObj();
		Case c = (Case) TestDataFactory.createSimpleCase(account.Id).insertObj();

		Test.startTest();
		List<Case> retrievedCases  = new CaseSelector().getCaseByIds(new List<String>{c.Id});
		Test.stopTest();
		System.assertEquals(1, retrievedCases.size(), 'Wrong number of case retrieved.');
		System.assertEquals(c.Id, retrievedCases[0].Id, 'The 2 cases are different.');	
	}

	@IsTest
	public static void testGetCasesByLeadIds(){
		Account account = (Account) TestDataFactory.createSimpleAccount('test').insertObj();
		Lead lead = (Lead) TestDataFactory.createSimpleLead('test').insertObj();
		Case c = (Case) TestDataFactory.createSimpleCase(account.Id).getObj();
		c.Lead__c = lead.Id;
		insert c;

		Test.startTest();
		List<Case> retrievedCases  = new CaseSelector().getCasesByLeadIds(new Set<Id>{c.Lead__c});
		Test.stopTest();
		System.assertEquals(1, retrievedCases.size(), 'Wrong number of case retrieved.');
		System.assertEquals(lead.Id, retrievedCases[0].Lead__c, 'The 2 cases are different.');	
	}
}