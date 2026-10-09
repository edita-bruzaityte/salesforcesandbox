/**
 * CustomerPropertySelector
 * is data access class. All SOQL to CustomerProperty DB are stored here. 
 *
 * @author  Matteo Iacucci
 * @version 1.0
 * @since   2021-04-07
*/
public with sharing class CustomerPropertySelector {
	rflib_Logger logger = rflib_LoggerUtil.getFactory().createLogger('CustomerPropertySelector');

	/**
	 * retrieve the CustomerProperty by RegistrationNumber
	 * @param registrationNumber 
	 * @return CustomerProperty
	 */
	public CustomerProperty getCustomerPropertyByRegistrationNumber(String registrationNumber) {
		CustomerProperty customerProperty = null;
		try{
			if( Schema.CustomerProperty.SObjectType.getDescribe().isAccessible() ){
				customerProperty = [SELECT Id, RegistrationNumber
						FROM CustomerProperty
						WHERE RegistrationNumber = :registrationNumber 
						LIMIT 1
					];
			}else{
				logger.error('getCustomerPropertyByRegistrationNumber(): User (userid: {0}) has no access right to CustomerProperty', new List<Object> {String.valueOf(UserInfo.getUserId())});
			}
		}catch(QueryException qe){
			logger.warn('getCustomerPropertyByRegistrationNumber() : no CustomerProperty with RegistrationNumber = ' + registrationNumber);
		}catch(Exception e){
			logger.error('getCustomerPropertyByRegistrationNumber() : Exception: ', e);
		}
		
		return customerProperty;
	}
}