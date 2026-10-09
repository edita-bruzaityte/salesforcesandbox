/**
 * The OpportunitySelector_Test to test OpportunitySelector.
 *
 * @author  Matteo Iacucci
 * @version 1.0
 * @since   2021-05-19
 */
@IsTest
public class OpportunitySelector_Test {
	@IsTest
	public static void testGetOpportunitiesByQuoteNumbers(){
        String quoteNumber = 'quoteN1';
		Account account = (Account) TestDataFactory.createSimpleAccount('test').insertObj();
        Contact contact = (Contact) TestDataFactory.createSimpleContact('lastName', account.Id, '141414').insertObj();
        Opportunity opportunity  = (Opportunity) TestDataFactory.createOpportunity(quoteNumber, account.Id, contact.Id).insertObj();
		Test.startTest();
		List<Opportunity> retrievedOpportunities = new OpportunitySelector().getOpportunitiesByQuoteNumbers(new Set<String>{quoteNumber});
		Test.stopTest();
		System.assertEquals(1, retrievedOpportunities.size(), 'Wrong number of opportunity retrieved.');
		System.assertEquals(opportunity.Id, retrievedOpportunities[0].Id, 'The 2 opportunity are different.');	
	}

}