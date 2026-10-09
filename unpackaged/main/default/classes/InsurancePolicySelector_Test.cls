/**
 * The InsurancePolicySelector_Test to test InsurancePolicySelector.
 *
 * @author  Matteo Iacucci
 * @version 1.0
 * @since   2021-05-21
 */
@IsTest
public class InsurancePolicySelector_Test {
	@IsTest
	public static void testGetInsurancePolicyByPolicyNumber(){
		String policyNumber = 'policyTest1';
		Account account = (Account) TestDataFactory.createSimpleAccount('test').insertObj();
		InsurancePolicy policy = (InsurancePolicy) TestDataFactory.createInsurancePolicy(policyNumber, account.Id).insertObj();

		Test.startTest();
		InsurancePolicy retrievedPolicy  = new InsurancePolicySelector().getInsurancePolicyByPolicyNumber(policyNumber);
		Test.stopTest();
		System.assertEquals(policy.Id, retrievedPolicy.Id, 'The 2 Policies are different.');	
	}

	@IsTest
	public static void testGetInsurancePolicyByPolicyNumberNull(){
        String policyNumber = 'policyTest1';
		Test.startTest();
		InsurancePolicy retrievedPolicy  = new InsurancePolicySelector().getInsurancePolicyByPolicyNumber(policyNumber);
		Test.stopTest();
		System.assertEquals(null, retrievedPolicy, 'One policy was retrieved.');	
	}


	@IsTest
	public static void testGetInsurancePolicyByPolicyNumbers(){
		String policyNumber = 'policyTest1';
		Account account = (Account) TestDataFactory.createSimpleAccount('test').insertObj();
		InsurancePolicy policy = (InsurancePolicy) TestDataFactory.createInsurancePolicy(policyNumber, account.Id).insertObj();

		Test.startTest();
		List<InsurancePolicy> retrievedPolicies = new InsurancePolicySelector().getInsurancePolicyByPolicyNumbers(new List<String>{policyNumber});
		Test.stopTest();
		System.assertEquals(1, retrievedPolicies.size(), 'Wrong number of policies retrieved.');
		System.assertEquals(policy.Id, retrievedPolicies[0].Id, 'The 2 policies are different.');	
	}
}