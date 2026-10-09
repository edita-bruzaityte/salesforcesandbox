/**
 * OpportunitySelector
 * is data access class. All SOQL to Opportunity DB are stored here. 
 *
 * @author  Matteo Iacucci
 * @version 1.0
 * @since   2021-05-19
*/

public with sharing class OpportunitySelector {
	rflib_Logger logger = rflib_LoggerUtil.getFactory().createLogger('OpportunitySelector');



	/**
	 * retrieve the Opportunities by quote numner
	 * @param quoteNumners 
	 * @return list opportunity
	 */
	public List<Opportunity> getOpportunitiesByQuoteNumbers(List<String> quoteNumbers) {
		List<Opportunity> opportunities = null;
		if( Schema.Opportunity.SObjectType.getDescribe().isAccessible() ){
			opportunities = [SELECT Id, AccountId, ContactId, Quote_Number__c
				FROM Opportunity
				WHERE Quote_Number__c IN :quoteNumbers];
		}else{
			logger.error('getOpportunitiesByQuoteNumbers(): User (userid: {0}) has no access right to Opportunity', new List<Object> {String.valueOf(UserInfo.getUserId())});
		}
		
		return opportunities;
	}

    public List<Opportunity> getOpportunitiesByQuoteNumbers(Set<String> quoteNumbers){
        return getOpportunitiesByQuoteNumbers(new List<String>(quoteNumbers));
    }

}