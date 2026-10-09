/**
 * CaseSelector
 * is data access class. All SOQL to Case DB are stored here. 
 *
 * @author  Matteo Iacucci
 * @version 1.0
 * @since   2021-05-19
*/

public with sharing class CaseSelector {
	rflib_Logger logger = rflib_LoggerUtil.getFactory().createLogger('CaseSelector');

	/**
	 * retrieve the case by id 
	 * @param claimNumber 
	 * @return case
	 */
	public Case getCaseById(Id id) {
		Case c = null;
		try{
			if( Schema.Case.SObjectType.getDescribe().isAccessible() ){
				c = [SELECT Id, Description, Subject
						FROM Case
						WHERE Id = :id
						LIMIT 1
					];
			}else{
				logger.error('getCaseById(): User (userid: {0}) has no access right to Case', new List<Object> {String.valueOf(UserInfo.getUserId())});
			}
		}catch(QueryException qe){

			logger.warn('getCaseById() : no Case with id = ' + id);
		}catch(Exception e){
			logger.error('getCaseById() : Exception: ', e);
		}
		
		return c;
	}

	/**
	 * retrieve the case by  id 
	 * @param caseIds 
	 * @return Case
	 */
	public List<Case> getCaseByIds(List<Id> caseIds) {
		List<Case> cases = null;
		if( Schema.Case.SObjectType.getDescribe().isAccessible() ){
			cases = [SELECT Id, Description, Subject
					FROM Case
					WHERE Id IN :caseIds
				];
		}else{
			logger.error('getCaseByIds(): User (userid: {0}) has no access right to Case', new List<Object> {String.valueOf(UserInfo.getUserId())});
		}
		
		return cases;
	}

	/**
	 * retrieve the case by id 
	 * @param caseIds 
	 * @return Case
	 */
	public List<Case> getCaseByIds(Set<Id> caseIds) {
		return getCaseByIds(new List<Id>(caseIds));
	}

	public List<Case> getCasesByLeadIds(Set<Id> leadIds){
		return getCasesByLeadIds(new List<Id>(leadIds));
	}

	public List<Case> getCasesByLeadIds(List<Id> leadIds){
		List<Case> cases = null;
		if( Schema.Case.SObjectType.getDescribe().isAccessible() ){
			cases = [SELECT Id, Lead__c, AccountId, ContactId 
					FROM Case 
					WHERE Lead__c IN :leadIds
				];
		}else{
			logger.error('getCasesByLeadIds(): User (userid: {0}) has no access right to Case', new List<Object> {String.valueOf(UserInfo.getUserId())});
		}
		
		return cases;
	}

}