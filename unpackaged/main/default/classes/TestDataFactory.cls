/**
* TestDataFactory is used to create data in our unit tests.
*
* @author  Matteo Iacucci
* @version 1.0
* @since   2021-04-07
*/
@IsTest
public class TestDataFactory {

	private SObject obj;

	public TestDataFactory(SObject obj){
		this.obj = obj;
	}

	public SObject insertObj(){
		insert this.obj;
		return this.obj;
	}

	public SObject getObj(){
		return this.obj;
	}

	public static TestDataFactory createSimpleLead(String lastName){
		Lead l = new Lead(
			Status = 'New',
			LastName = lastName,
			email = lastName + '@testdatafactory.com',
			Profile_Id__c = lastName + '_pid',
			Company = lastName + 'company'
		);

		return new TestDataFactory((SObject) l);
	}
	
	
	public static TestDataFactory createSimpleLeadWithSource(String lastName, String source){
		Lead l = new Lead(
			Status = 'New',
			LastName = lastName,
			email = lastName + '@testdatafactory.com',
			Profile_Id__c = lastName + '_pid',
			LeadSource = source,
			Company = 'TestCompany'
		);

		return new TestDataFactory((SObject) l);
	} 
	
	public static TestDataFactory createSimpleAccount(String accountName){
		Account a = new Account(
			Name = accountName,
			BillingCity = 'Praha',
			BillingCountry = 'CZ',
			BillingStreet = 'Havlickova',
			BillingPostalCode = '11000'
		);

		return new TestDataFactory((SObject) a);
	}

	public static TestDataFactory createSimpleContact(String lastName, Id accountId, String phoneNumber){
		Contact c = new Contact(
			LastName = lastName,
			AccountId = accountId,
			Email = lastName + '@testdatafactory.com',
			Profile_Id__c = lastName + '_pid',
			Phone = phoneNumber
		);

		return new TestDataFactory((SObject) c);
	}

	public static TestDataFactory createSimpleCase(Id accountId){
		Case c = new Case(
			AccountId = accountId,
			Subject = 'test',
			Origin = 'Email'

		);
		
		return new TestDataFactory((SObject) c);
	}

	public static TestDataFactory createSimpleCaseWithRecordType(Id accountId, Id recordTypeId){
		Case c = new Case(
			AccountId = accountId,
			Subject = 'test',
			Origin = 'Email',
			RecordTypeId = recordTypeId

		);
		
		return new TestDataFactory((SObject) c);
	}

	public static TestDataFactory createSimpleCaseWithRecordTypeAndStatus(Id accountId, Id recordTypeId, String status){
		Case c = new Case(
			AccountId = accountId,
			Subject = 'test',
			Origin = 'Email',
			RecordTypeId = recordTypeId,
			Status = status

		);
		
		return new TestDataFactory((SObject) c);
	}

	public static TestDataFactory createQueue(String queueName){
		Group g = new Group(
			Name = queueName,
			DeveloperName = queueName,
			Type='Queue');
		return new TestDataFactory((SObject) g);
	}

	public static TestDataFactory createInsurancePolicy(String policyNumber, Id accountId){
		InsurancePolicy policy = new InsurancePolicy(
			Instanda_Policy_Number__c = policyNumber,
			NameInsuredId = accountId,
			Name = policyNumber,
			PolicyName = policyNumber
		);
		return new TestDataFactory((SObject) policy);
	}

	public static TestDataFactory createCustomerProperty(String registrationNumber, Id accountId){
		CustomerProperty cp  = new CustomerProperty(
			RegistrationNumber = registrationNumber,
			ModelName = 'test',
			Colour__c = 'testColour',
			Make = 'make',
			MakeYear = 2021,
			Vehicle_ABI_Identifier__c = 'abi' + registrationNumber,
			PrimaryOwnerId = accountId
		);
		return new TestDataFactory((SObject) cp);
	}

	public static TestDataFactory createInsurancePolicyAsset(Id policyId, Id customerPropertyId){
		InsurancePolicyAsset ipa = new InsurancePolicyAsset(
			InsurancePolicyId = policyId,
			CustomerPropertyId = customerPropertyId,
			Is_Active__c = true
		);
		return new TestDataFactory((SObject) ipa);
	}

	public static TestDataFactory createClaim(String claimNumber, Id policyId, Id AccountId, Id caseId){
		Claim claim = new Claim(
			Name = claimNumber,
			Instanda_Claim_Number__c = claimNumber,
			AccountId = accountId,
			CaseId = caseId,
			PolicyNumberId = policyId
		);
		return new TestDataFactory((SObject) claim);
	}

	public static TestDataFactory createOpportunity(String quoteNumber, Id accountId, Id contactId ){
		Opportunity oppty = new Opportunity(
			ContactId = contactId,
			AccountId = accountId,
			Name = quoteNumber,
			CloseDate = Date.today(),
			Quote_Number__c = quoteNumber,
			StageName = Constants.PARTIALQUOTE_STATUS
		);
		return new TestDataFactory((SObject) oppty);
	}

	public static TestDataFactory createSimpleTask(){
		Task task = new Task(
			Priority = 'Normal',
			Status = 'Open'
		);
		return new TestDataFactory((SObject) task);
	}
	
}