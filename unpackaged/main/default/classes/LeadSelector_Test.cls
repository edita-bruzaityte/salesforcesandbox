/**
 * The LeadSelector_Test to test LeadSelector.
 *
 * @author  Matteo Iacucci
 * @version 1.0
 * @since   2021-01-15
 */
@IsTest
public class LeadSelector_Test {
	@IsTest
	public static void testGetLeadByProfileId(){
		String name = 'testLead';
		Lead l = (Lead) TestDataFactory.createSimpleLead(name).insertObj();

		Test.startTest();
		Lead retrievedLead  = new LeadSelector().getLeadByProfileId(name + '_pid');
		Test.stopTest();
		System.assertEquals(l.Id, retrievedLead.Id, 'The 2 Lead are different.');	
	}

	@IsTest
	public static void testGetLeadByProfileIdNull(){
		String name = 'testLead';
		Lead l = (Lead) TestDataFactory.createSimpleLead(name).insertObj();

		Test.startTest();
		Lead retrievedLead  = new LeadSelector().getLeadByProfileId(name + '1@testdatafactory.com');
		Test.stopTest();
		System.assertEquals(null, retrievedLead, 'One lead was retrieved.');	
	}

	@IsTest
	public static void testGetLeadsByQuoteNumbers(){
		String name = 'testLead';
		String quoteNumber = 'test';
		Lead l = (Lead) TestDataFactory.createSimpleLead(name).getObj();
		l.Quote_Number__c = quoteNumber;
		insert l;
		Test.startTest();
		List<Lead> retrievedLeads  = new LeadSelector().getLeadsByQuoteNumbers(new List<String>{quoteNumber});
		Test.stopTest();
		System.assertEquals(1, retrievedLeads.size(), 'wrong numner of lead retrieved');
		System.assertEquals(l.Quote_Number__c, retrievedLeads[0].Quote_Number__c, 'The 2 Lead are different.');	
	}
}