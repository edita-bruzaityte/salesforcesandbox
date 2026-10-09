/**
 * LeadSelector
 * is data access class. All SOQL to Lead DB are stored here. 
 *
 * @author  Matteo Iacucci
 * @version 1.0
 * @since   2021-04-07
*/

public with sharing class LeadSelector {
	rflib_Logger logger = rflib_LoggerUtil.getFactory().createLogger('LeadSelector');

	/**
	 * retrieve the lead by ext id Profile_Id__c
	 * @param profileId 
	 * @return lead
	 */
	public Lead getLeadByProfileId(String profileId) {
		Lead lead = null;
		try{
			if( Schema.Lead.SObjectType.getDescribe().isAccessible() ){
			
				lead = [SELECT Id, Profile_Id__c
						FROM Lead
						WHERE Profile_Id__c = :profileId
						LIMIT 1
					];
			}else{
				logger.error('getLeadByInstandaEmailId(): User (userid: {0}) has no access right to Lead', new List<Object> {String.valueOf(UserInfo.getUserId())});
			}
		}catch(QueryException qe){

			logger.warn('getLeadByInstandaEmailId() : no Lead with ProfileId = ' + profileID);
		}catch(Exception e){
			logger.error('getLeadByInstandaEmailId() : Exception: ', e);
		}
		
		return lead;
	}

	/**
	 * retrieve the leads by quoteNumber
	 * @param quoteNumber 
	 * @return list lead
	 */
	public List<Lead> getLeadsByQuoteNumbers(List<String> quoteNumbers) {
		List<Lead> leads = null;
	
		if( Schema.Lead.SObjectType.getDescribe().isAccessible() ){
		
			leads = [SELECT Id, Profile_Id__c, Quote_Number__c
					FROM Lead
					WHERE Quote_Number__c IN :quoteNumbers AND IsConverted = FALSE
					
				];
		}else{
			logger.error('getLeadsByQuoteNumber(): User (userid: {0}) has no access right to Lead', new List<Object> {String.valueOf(UserInfo.getUserId())});
		}
		
		return leads;
	}
}