/**
 * InsurancePolicySelector
 * is data access class. All SOQL to InsurancePolicy DB are stored here. 
 *
 * @author  Matteo Iacucci
 * @version 1.0
 * @since   2021-05-21
*/

public with sharing class InsurancePolicySelector {
	rflib_Logger logger = rflib_LoggerUtil.getFactory().createLogger('InsurancePolicySelector');

	/**
	 * retrieve the insurance policy by ext id PolicyNumber
	 * @param policyNumber 
	 * @return InsurancePolicy
	 */
	public InsurancePolicy getInsurancePolicyByPolicyNumber(String policyNumber) {
		InsurancePolicy policy = null;
		try{
			if( Schema.InsurancePolicy.SObjectType.getDescribe().isAccessible() ){
				policy = [SELECT Id, NameInsuredId, Instanda_Policy_Number__c 
                            FROM InsurancePolicy 
                            WHERE Instanda_Policy_Number__c = :policyNumber
                            LIMIT 1
					];
			}else{
				logger.error('getInsurancePolicyByPolicyNumber(): User (userid: {0}) has no access right to policy', new List<Object> {String.valueOf(UserInfo.getUserId())});
			}
		}catch(QueryException qe){

			logger.warn('getInsurancePolicyByPolicyNumber() : no policy with PolicyNumber = ' + policyNumber);
		}catch(Exception e){
			logger.error('getInsurancePolicyByPolicyNumber() : Exception: ', e);
		}
		
		return policy;
	}

	/**
	 * retrieve the policy by ext id PolicyNumber
	 * @param policyNumbers 
	 * @return insurancePolicy
	 */
	public List<InsurancePolicy> getInsurancePolicyByPolicyNumbers(List<String> policyNumbers) {
		List<InsurancePolicy> policy = null;
		if( Schema.InsurancePolicy.SObjectType.getDescribe().isAccessible() ){
			policy = [SELECT Id, NameInsuredId, Instanda_Policy_Number__c
					FROM InsurancePolicy
					WHERE Instanda_Policy_Number__c IN :policyNumbers
				];
		}else{
			logger.error('getInsurancePolicyByPolicyNumbers(): User (userid: {0}) has no access right to InsurancePolicy', new List<Object> {String.valueOf(UserInfo.getUserId())});
		}
		
		return policy;
	}

}