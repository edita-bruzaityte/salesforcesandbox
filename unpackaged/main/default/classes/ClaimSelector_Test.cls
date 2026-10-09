/**
 * The ClaimSelector_Test to test ClaimSelector.
 *
 * @author  Matteo Iacucci
 * @version 1.0
 * @since   2021-05-19
 */
@IsTest
public class ClaimSelector_Test {
	@IsTest
	public static void testGetClaimByInstandaClaimNumber(){
		String claimNumber = 'claimTest';
		Account account = (Account) TestDataFactory.createSimpleAccount('test').insertObj();
		InsurancePolicy policy = (InsurancePolicy) TestDataFactory.createInsurancePolicy('test', account.Id).insertObj();
		Claim claim = (Claim) TestDataFactory.createClaim(claimNumber, policy.Id, account.Id, null).insertObj();

		Test.startTest();
		Claim retrievedClaim  = new ClaimSelector().getClaimByInstandaClaimNumber(claimNumber);
		Test.stopTest();
		System.assertEquals(claim.Id, retrievedClaim.Id, 'The 2 Claims are different.');	
	}

	@IsTest
	public static void testGetClaimByInstandaClaimNumberNull(){
		String claimNumber = 'claimTest';
		Test.startTest();
		Claim retrievedClaim  = new ClaimSelector().getClaimByInstandaClaimNumber(claimNumber);
		Test.stopTest();
		System.assertEquals(null, retrievedClaim, 'One claim was retrieved.');	
	}


	@IsTest
	public static void testGetClaimByInstandaClaimNumbers(){
		String claimNumber = 'claimTest';
		Account account = (Account) TestDataFactory.createSimpleAccount('test').insertObj();
		InsurancePolicy policy = (InsurancePolicy) TestDataFactory.createInsurancePolicy('test', account.Id).insertObj();
		Claim claim = (Claim) TestDataFactory.createClaim(claimNumber, policy.Id, account.Id, null).insertObj();

		Test.startTest();
		List<Claim> retrievedClaims  = new ClaimSelector().getClaimByInstandaClaimNumbers(new List<String>{claimNumber});
		Test.stopTest();
		System.assertEquals(1, retrievedClaims.size(), 'Wrong number of claim retrieved.');
		System.assertEquals(claim.Id, retrievedClaims[0].Id, 'The 2 Claims are different.');	
	}
}