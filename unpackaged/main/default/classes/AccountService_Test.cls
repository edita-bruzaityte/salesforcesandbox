/**
 * The AccountService_Test to test AccountService.
 *
 * @author  Matteo Iacucci
 * @version 1.0
 * @since   2021-01-15
 */
@IsTest
public class AccountService_Test {
	public static Id employedRecordType = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Employed').getRecordTypeId();
	public static Id smallBusinessRecordType = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Small_Business').getRecordTypeId();
	public static Id soleProprietorRecordType = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Sole_Proprietor').getRecordTypeId();

	@IsTest
	public static void testTradePartnership(){
		AccountService agentService = new AccountService();
		String companyType = 'I trade as a partnership';
		Test.startTest();
		Id rt = agentService.getRecordTypeFromCompanyType(companyType);
		Test.stopTest();
		System.assertEquals(smallBusinessRecordType, rt, 'Wrong rt retrieved');
	}

	@IsTest
	public static void testTradeLimitedCompany(){
		AccountService agentService = new AccountService();
		String companyType = 'I trade as a limited company';
		Test.startTest();
		Id rt = agentService.getRecordTypeFromCompanyType(companyType);
		Test.stopTest();
		System.assertEquals(smallBusinessRecordType, rt, 'Wrong rt retrieved');
	}

	@IsTest
	public static void testSelfEmployed(){
		AccountService agentService = new AccountService();
		String companyType = 'I\'m self employed';
		Test.startTest();
		Id rt = agentService.getRecordTypeFromCompanyType(companyType);
		Test.stopTest();
		System.assertEquals(soleProprietorRecordType, rt, 'Wrong rt retrieved');
	}

	@IsTest
	public static void testEmployed(){
		AccountService agentService = new AccountService();
		String companyType = 'I\'m employed';
		Test.startTest();
		Id rt = agentService.getRecordTypeFromCompanyType(companyType);
		Test.stopTest();
		System.assertEquals(employedRecordType, rt, 'Wrong rt retrieved');
	}

}