/**
 * ExternalIntegrationSelector
 * is data access class. All SOQL to External_Integration__mdt DB are stored here. 
 *
 * @author  Matteo Iacucci
 * @version 1.0
 * @since   2020-11-03
*/

public with sharing class ExternalIntegrationSelector {
	rflib_Logger logger = rflib_LoggerUtil.getFactory().createLogger('ExternalIntegrationSelector');

	/**
	 * retrieve all the External_Integration__mdt metadata
	 * @return list of External_Integration__mdt
	 */
	public List<External_Integration__mdt> getAllExternalIntegrations() {
		if(Test.isRunningTest()){
			return createTestExternalIntegrationAll();
		}else{
			List<External_Integration__mdt> extIntegrations = [
				SELECT DeveloperName, Base_Url__c, Path__c, API_Key__c
				FROM External_Integration__mdt
			];
			return extIntegrations;
		}
		
	}

	/**
	 * retrieve the UCS_Integration_Configuration metadata by dev name
	 * @param name name of the configuration
	 * @return list of UCS_Integration_Configuration_mdt
	 */
	public List<External_Integration__mdt> getExternalIntegrationsByDeveloperName(String developerName){
		if(Test.isRunningTest()){
			return createTestExternalIntegration();
		}else{
			List<External_Integration__mdt> extIntegrations = [
				SELECT DeveloperName, Base_Url__c, Path__c, API_Key__c
				FROM External_Integration__mdt
				WHERE DeveloperName = :developerName];
			return extIntegrations;
		}
		
	}

	private List<External_Integration__mdt> createTestExternalIntegration(){
		External_Integration__mdt extIntegration = new External_Integration__mdt(
			DeveloperName = 'TEST',
			Base_Url__c = 'https://test.integration.com',
			Path__c = '/testsync',
			API_Key__c = '1231313131'
		);
		return new List<External_Integration__mdt>{extIntegration};
	}

	private List<External_Integration__mdt> createTestExternalIntegrationAll(){
		External_Integration__mdt extIntegration = new External_Integration__mdt(
			DeveloperName = 'TEST',
			Base_Url__c = 'https://test.integration.com',
			Path__c = '/testsync',
			API_Key__c = '1231313131'
		);
		return new List<External_Integration__mdt>{extIntegration};
	}

}