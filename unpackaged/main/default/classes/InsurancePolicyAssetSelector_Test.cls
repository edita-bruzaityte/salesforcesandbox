/**
 * The InsurancePolicyAssetSelector_Test to test InsurancePolicyAssetSelector.
 *
 * @author  Matteo Iacucci
 * @version 1.0
 * @since   2021-05-07
 */
@IsTest
public class InsurancePolicyAssetSelector_Test {
	@IsTest
	public static void testGetActiveInsurancePolicyAssetByPolicyId(){
		String policyNumber = 'ipn-001';
		String registrationNumber = 'reg123';
		Account a = (Account) TestDataFactory.createSimpleAccount('testAccount').insertObj();
		InsurancePolicy policy = (InsurancePolicy) TestDataFactory.createInsurancePolicy(policyNumber, a.Id).insertObj();
		CustomerProperty cp = (CustomerProperty) TestDataFactory.createCustomerProperty(registrationNumber, a.Id).insertObj();
		InsurancePolicyAsset ipa = (InsurancePolicyAsset) TestDataFactory.createInsurancePolicyAsset(policy.Id, cp.Id).insertObj();
		Test.startTest();
		InsurancePolicyAsset retrievedInsurancePolicyAsset = new InsurancePolicyAssetSelector().getActiveInsurancePolicyAssetByPolicyId(policy.Id);
		Test.stopTest();
		System.assertEquals(ipa.Id, retrievedInsurancePolicyAsset.Id, 'the retrieved asset is not the one expected');	
		System.assertEquals(ipa.InsurancePolicyId, policy.Id, 'Asset related to the wrong policy');	
		System.assertEquals(ipa.CustomerPropertyId, cp.Id, 'Asset related to the wrong property');	
	}

	@IsTest
	public static void testGetActiveInsurancePolicyAssetByPolicyIdException(){
		Test.startTest();
		InsurancePolicyAsset retrievedInsurancePolicyAsset  = new InsurancePolicyAssetSelector().getActiveInsurancePolicyAssetByPolicyId('0YT3H0000004CoRWAU');
		Test.stopTest();
			
		System.assertEquals(null, retrievedInsurancePolicyAsset, 'asset retrieved');	
	}

	@IsTest
	public static void testGetActiveInsurancePolicyAssetByPolicyIdAndCustomerPropertyId(){
		String policyNumber = 'ipn-001';
		String registrationNumber = 'reg123';
		Account a = (Account) TestDataFactory.createSimpleAccount('testAccount').insertObj();
		InsurancePolicy policy = (InsurancePolicy) TestDataFactory.createInsurancePolicy(policyNumber, a.Id).insertObj();
		CustomerProperty cp = (CustomerProperty) TestDataFactory.createCustomerProperty(registrationNumber, a.Id).insertObj();
		InsurancePolicyAsset ipa = (InsurancePolicyAsset) TestDataFactory.createInsurancePolicyAsset(policy.Id, cp.Id).insertObj();
		Test.startTest();
		InsurancePolicyAsset retrievedInsurancePolicyAsset = new InsurancePolicyAssetSelector().getActiveInsurancePolicyAssetByPolicyIdAndCustomerPropertyId(policy.Id, cp.Id);
		Test.stopTest();
		System.assertEquals(ipa.Id, retrievedInsurancePolicyAsset.Id, 'the retrieved asset is not the one expected');	
		System.assertEquals(ipa.InsurancePolicyId, policy.Id, 'Asset related to the wrong policy');	
		System.assertEquals(ipa.CustomerPropertyId, cp.Id, 'Asset related to the wrong property');	
	}

	@IsTest
	public static void testGetActiveInsurancePolicyAssetByPolicyIdAndCustomerPropertyIdException(){
		Test.startTest();
		InsurancePolicyAsset retrievedInsurancePolicyAsset  = new InsurancePolicyAssetSelector().getActiveInsurancePolicyAssetByPolicyIdAndCustomerPropertyId('0YT3H0000004CoRWAU', '0b83H0000004CkEQAU');
		Test.stopTest();
			
		System.assertEquals(null, retrievedInsurancePolicyAsset, 'asset retrieved');	
	}

	@IsTest
	public static void testGetInsurancePolicyAssetByPolicyIdAndCustomerPropertyId(){
		String policyNumber = 'ipn-001';
		String registrationNumber = 'reg123';
		Account a = (Account) TestDataFactory.createSimpleAccount('testAccount').insertObj();
		InsurancePolicy policy = (InsurancePolicy) TestDataFactory.createInsurancePolicy(policyNumber, a.Id).insertObj();
		CustomerProperty cp = (CustomerProperty) TestDataFactory.createCustomerProperty(registrationNumber, a.Id).insertObj();
		InsurancePolicyAsset ipa = (InsurancePolicyAsset) TestDataFactory.createInsurancePolicyAsset(policy.Id, cp.Id).insertObj();
		Test.startTest();
		InsurancePolicyAsset retrievedInsurancePolicyAsset = new InsurancePolicyAssetSelector().getInsurancePolicyAssetByPolicyIdAndCustomerPropertyId(policy.Id, cp.Id);
		Test.stopTest();
		System.assertEquals(ipa.Id, retrievedInsurancePolicyAsset.Id, 'the retrieved asset is not the one expected');	
		System.assertEquals(ipa.InsurancePolicyId, policy.Id, 'Asset related to the wrong policy');	
		System.assertEquals(ipa.CustomerPropertyId, cp.Id, 'Asset related to the wrong property');	
	}

	@IsTest
	public static void testGetInsurancePolicyAssetByPolicyIdAndCustomerPropertyIdException(){
		Test.startTest();
		InsurancePolicyAsset retrievedInsurancePolicyAsset  = new InsurancePolicyAssetSelector().getInsurancePolicyAssetByPolicyIdAndCustomerPropertyId('0YT3H0000004CoRWAU', '0b83H0000004CkEQAU');
		Test.stopTest();
			
		System.assertEquals(null, retrievedInsurancePolicyAsset, 'asset retrieved');	
	}
}