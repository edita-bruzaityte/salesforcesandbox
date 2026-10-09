/**
 * ClaimSelector
 * is data access class. All SOQL to Claim DB are stored here. 
 *
 * @author  Matteo Iacucci
 * @version 1.0
 * @since   2021-05-19
*/

public with sharing class ClaimSelector {
	rflib_Logger logger = rflib_LoggerUtil.getFactory().createLogger('ClaimSelector');

	/**
	 * retrieve the claim by ext id InstandaClaimNumber
	 * @param claimNumber 
	 * @return Claim
	 */
	public Claim getClaimByInstandaClaimNumber(String claimNumber) {
		Claim claim = null;
		try{
			if( Schema.Claim.SObjectType.getDescribe().isAccessible() ){
				claim = [SELECT Id, CaseId, AccountId, PolicyNumberId, Instanda_Claim_Number__c
						FROM Claim
						WHERE Instanda_Claim_Number__c = :claimNumber
						LIMIT 1
					];
			}else{
				logger.error('getClaimByInstandaClaimNumber(): User (userid: {0}) has no access right to Claim', new List<Object> {String.valueOf(UserInfo.getUserId())});
			}
		}catch(QueryException qe){

			logger.warn('getClaimByInstandaClaimNumber() : no Claim with instandaClaimNumber = ' + claimNumber);
		}catch(Exception e){
			logger.error('getClaimByInstandaClaimNumber() : Exception: ', e);
		}
		
		return claim;
	}

	/**
	 * retrieve the claim by ext id InstandaClaimNumber
	 * @param claimNumber 
	 * @return Claim
	 */
	public List<Claim> getClaimByInstandaClaimNumbers(List<String> claimNumber) {
		List<Claim> claims = null;
		if( Schema.Claim.SObjectType.getDescribe().isAccessible() ){
			claims = [SELECT Id, CaseId, AccountId, PolicyNumberId, Instanda_Claim_Number__c
					FROM Claim
					WHERE Instanda_Claim_Number__c IN :claimNumber
				];
		}else{
			logger.error('getClaimByInstandaClaimNumber(): User (userid: {0}) has no access right to Claim', new List<Object> {String.valueOf(UserInfo.getUserId())});
		}
		
		return claims;
	}

}