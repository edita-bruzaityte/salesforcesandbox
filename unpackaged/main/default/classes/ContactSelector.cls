/**
 * ContactSelector
 * is data access class. All SOQL to Contact DB are stored here. 
 *
 * @author  Matteo Iacucci
 * @version 1.0
 * @since   2021-04-07
*/
public with sharing class ContactSelector {
	rflib_Logger logger = rflib_LoggerUtil.getFactory().createLogger('ContactSelector');

	/**
	 * retrieve the Contact by ext id Profile_Id__c
	 * @param profileId 
	 * @return contact
	 */
	public Contact getContactByProfileId(String profileId) {
		Contact contact = null;
		try{
			if( Schema.Contact.SObjectType.getDescribe().isAccessible() ){
			
				contact = [SELECT Id, Profile_Id__c, AccountId
						FROM Contact
						WHERE Profile_Id__c = :profileId 
					];
			}else{
				logger.error('getContactByInstandaEmailId(): User (userid: {0}) has no access right to Contact', new List<Object> {String.valueOf(UserInfo.getUserId())});
			}
		}catch(QueryException qe){
			logger.warn('getContactByInstandaEmailId() : no Contact with profileId = ' + profileId);
		}catch(Exception e){
			logger.error('getContactByInstandaEmailId() : Exception: ', e);
		}
		
		return contact;
	}
}