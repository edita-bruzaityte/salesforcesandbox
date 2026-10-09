/**
 * InsurancePolicyAssetSelector
 * is data access class. All SOQL to InsurancePolicyAsset DB are stored here. 
 *
 * @author  Matteo Iacucci
 * @version 1.0
 * @since   2021-04-07
*/
public with sharing class InsurancePolicyAssetSelector {
	rflib_Logger logger = rflib_LoggerUtil.getFactory().createLogger('InsurancePolicyAssetSelector');

	/**
	 * retrieve the active Insurance policy by policy id (each policy can hae just one active asset)
	 * @param registrationNumber 
	 * @return InsurancePolicyAsset
	 */
	public InsurancePolicyAsset getActiveInsurancePolicyAssetByPolicyId(Id policyId) {
		InsurancePolicyAsset insurancePolicyAsset = null;
		try{
			if( Schema.InsurancePolicyAsset.SObjectType.getDescribe().isAccessible() ){
				insurancePolicyAsset = [SELECT Id, InsurancePolicyId, Is_Active__c, CustomerPropertyId
						FROM InsurancePolicyAsset
						WHERE Is_Active__c = TRUE AND InsurancePolicyId = :policyId 
						LIMIT 1
					];
			}else{
				logger.error('getActiveInsurancePolicyAssetByPolicyId(): User (userid: {0}) has no access right to CustomerProperty', new List<Object> {String.valueOf(UserInfo.getUserId())});
			}
		}catch(QueryException qe){
			logger.warn('getActiveInsurancePolicyAssetByPolicyId() : no InsurancePolicyAsset for policy id = ' + policyId);
		}catch(Exception e){
			logger.error('getActiveInsurancePolicyAssetByPolicyId() : Exception: ', e);
		}
		
		return insurancePolicyAsset;
	}

	/**
	 * retrieve the active Insurance policy by policy id and customer prop id(each policy can hae just one asset related to the same cp)
	 * @param registrationNumber 
	 * @return List<InsurancePolicyAsset>
	 */
	public InsurancePolicyAsset getInsurancePolicyAssetByPolicyIdAndCustomerPropertyId(Id policyId, Id customerPropertyId) {
		InsurancePolicyAsset insurancePolicyAsset = null;
		try{
			if( Schema.InsurancePolicyAsset.SObjectType.getDescribe().isAccessible() ){
				insurancePolicyAsset = [SELECT Id, InsurancePolicyId, Is_Active__c, CustomerPropertyId
						FROM InsurancePolicyAsset
						WHERE InsurancePolicyId = :policyId AND CustomerPropertyId = :customerPropertyId
					];
			}else{
				logger.error('getInsurancePolicyAssetByPolicyIdAndCustomerPropertyId(): User (userid: {0}) has no access right to CustomerProperty', new List<Object> {String.valueOf(UserInfo.getUserId())});
			}
		}catch(QueryException qe){
			logger.warn('getInsurancePolicyAssetByPolicyIdAndCustomerPropertyId() : no InsurancePolicyAsset for policy id = ' + policyId);
		}catch(Exception e){
			logger.error('getInsurancePolicyAssetByPolicyIdAndCustomerPropertyId() : Exception: ', e);
		}
		
		return insurancePolicyAsset;
	}

	/**
	 * retrieve the CustomerProperty by RegistrationNumber
	 * @param registrationNumber 
	 * @return CustomerProperty
	 */
	public InsurancePolicyAsset getActiveInsurancePolicyAssetByPolicyIdAndCustomerPropertyId(Id policyId, Id customerPropertyId) {
		InsurancePolicyAsset insurancePolicyAsset = null;
		try{
			if( Schema.InsurancePolicyAsset.SObjectType.getDescribe().isAccessible() ){
				insurancePolicyAsset = [SELECT Id, InsurancePolicyId, Is_Active__c, CustomerPropertyId
						FROM InsurancePolicyAsset
						WHERE Is_Active__c = true AND InsurancePolicyId = :policyId AND	
								CustomerPropertyId = :customerPropertyId
						LIMIT 1
					];
			}else{
				logger.error('getActiveInsurancePolicyAssetByPolicyId(): User (userid: {0}) has no access right to CustomerProperty', new List<Object> {String.valueOf(UserInfo.getUserId())});
			}
		}catch(QueryException qe){
			logger.warn('getActiveInsurancePolicyAssetByPolicyId() : no InsurancePolicyAsset for policy id = ' + policyId);
		}catch(Exception e){
			logger.error('getActiveInsurancePolicyAssetByPolicyId() : Exception: ', e);
		}
		
		return insurancePolicyAsset;
	}
}