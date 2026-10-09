@Istest
public class CircumstanceNotificationControllerTest {

    private static final String WITH_PERSONAL_CIRCUMSTANCE = 'TestingWithPersonalCircumstances';
    private static final String WITHOUT_PERSONAL_CIRCUMSTANCE = 'TestingWithoutPersonalCircumstances';

    @TestSetup
    static void makeData(){
        PC_TestDataFactory accountWithPersonalCircumstance = PC_TestDataFactory.createAccount(WITH_PERSONAL_CIRCUMSTANCE);
        PC_TestDataFactory accountWithOutPersonalCircumstance = PC_TestDataFactory.createAccount(WITHOUT_PERSONAL_CIRCUMSTANCE);

        insert new List<SObject>{
            (Account) accountWithPersonalCircumstance.getObj(),
            (Account) accountWithOutPersonalCircumstance.getObj()
        };

        InsurancePolicy policyWithPersonalCircumstance = createPolicy((Account) accountWithPersonalCircumstance.getObj());
        InsurancePolicy policyWithOutPersonalCircumstance = createPolicy((Account) accountWithOutPersonalCircumstance.getObj());

        insert new List<SObject>{
            createPersonalCircumstance((Account) accountWithPersonalCircumstance.getObj()),
            createOpportunity((Account) accountWithPersonalCircumstance.getObj()),
            createCase((Account) accountWithPersonalCircumstance.getObj()),
            policyWithPersonalCircumstance,
            policyWithOutPersonalCircumstance,
            createOpportunity((Account) accountWithOutPersonalCircumstance.getObj()),
            createCase((Account) accountWithOutPersonalCircumstance.getObj())
        };

        insert new List<Claim>{
            createClaim((Account) accountWithPersonalCircumstance.getObj(), policyWithPersonalCircumstance),
            createClaim((Account) accountWithOutPersonalCircumstance.getObj(), policyWithOutPersonalCircumstance)
        };
    }

    @IsTest
    static void additionalSupportNotificationHandler_ShouldDisplayNotificationAsTrue_WhenAccountHasPersonalCircumstances(){

        Account account = [SELECT Id FROM Account WHERE Name = :WITH_PERSONAL_CIRCUMSTANCE];

        Test.startTest();
        CircumstanceNotificationController.AdditionalSupportNotificationWrapper result = CircumstanceNotificationController.additionalSupportNotificationHandler(account.Id);
        Test.stopTest();

        Assert.areEqual(account.Id, result.ParentAccountId, 'Values should be the same');
        Assert.isTrue(result.DisplayNotification, 'DisplayNotification should be true');
        
    }

    @IsTest
    static void additionalSupportNotificationHandler_ShouldDisplayNotificationAsFalse_WhenAccountHasNoPersonalCircumstances(){

        Account account = [SELECT Id FROM Account WHERE Name = :WITHOUT_PERSONAL_CIRCUMSTANCE];

        Test.startTest();
        CircumstanceNotificationController.AdditionalSupportNotificationWrapper result = CircumstanceNotificationController.additionalSupportNotificationHandler(account.Id);
        Test.stopTest();

        Assert.areEqual(account.Id, result.ParentAccountId, 'Values should be the same');
        Assert.isFalse(result.DisplayNotification, 'DisplayNotification should be true');
        
    }

    @IsTest
    static void additionalSupportNotificationHandler_ShouldDisplayNotificationAsTrue_WhenParentAccountOnCaseHasPersonalCircumstances(){

        Account account = [SELECT Id FROM Account WHERE Name = :WITH_PERSONAL_CIRCUMSTANCE];
        Case cse = [SELECT Id FROM Case WHERE AccountId = :account.Id];
        
        Test.startTest();
        CircumstanceNotificationController.AdditionalSupportNotificationWrapper result = CircumstanceNotificationController.additionalSupportNotificationHandler(cse.Id);
        Test.stopTest();

        Assert.areEqual(account.Id, result.ParentAccountId, 'Values should be the same');
        Assert.isTrue(result.DisplayNotification, 'DisplayNotification should be true');
        
    }


    @IsTest
    static void additionalSupportNotificationHandler_ShouldDisplayNotificationAsFalse_WhenParentAccountOnCaseHasNoPersonalCircumstances(){

        Account account = [SELECT Id FROM Account WHERE Name = :WITHOUT_PERSONAL_CIRCUMSTANCE];
        Case cse = [SELECT Id FROM Case WHERE AccountId = :account.Id];

        Test.startTest();
        CircumstanceNotificationController.AdditionalSupportNotificationWrapper result = CircumstanceNotificationController.additionalSupportNotificationHandler(cse.Id);
        Test.stopTest();

        Assert.areEqual(account.Id, result.ParentAccountId, 'Values should be the same');
        Assert.isFalse(result.DisplayNotification, 'DisplayNotification should be true');
        
    }

    @IsTest
    static void additionalSupportNotificationHandler_ShouldDisplayNotificationAsTrue_WhenParentAccountOnOpportunityHasPersonalCircumstances(){

        Account account = [SELECT Id FROM Account WHERE Name = :WITH_PERSONAL_CIRCUMSTANCE];
        Opportunity opp = [SELECT Id FROM Opportunity WHERE AccountId = :account.Id];

        Test.startTest();
        CircumstanceNotificationController.AdditionalSupportNotificationWrapper result = CircumstanceNotificationController.additionalSupportNotificationHandler(opp.Id);
        Test.stopTest();

        Assert.areEqual(account.Id, result.ParentAccountId, 'Values should be the same');
        Assert.isTrue(result.DisplayNotification, 'DisplayNotification should be true');
        
    }


    @IsTest
    static void additionalSupportNotificationHandler_ShouldDisplayNotificationAsFalse_WhenParentAccountOnOpportunityHasNoPersonalCircumstances(){

        Account account = [SELECT Id FROM Account WHERE Name = :WITHOUT_PERSONAL_CIRCUMSTANCE];
        Opportunity opp = [SELECT Id FROM Opportunity WHERE AccountId = :account.Id];

        Test.startTest();
        CircumstanceNotificationController.AdditionalSupportNotificationWrapper result = CircumstanceNotificationController.additionalSupportNotificationHandler(account.Id);
        Test.stopTest();

        Assert.areEqual(account.Id, result.ParentAccountId, 'Values should be the same');
        Assert.isFalse(result.DisplayNotification, 'DisplayNotification should be true');
        
    }

    @IsTest
    static void additionalSupportNotificationHandler_ShouldDisplayNotificationAsTrue_WhenParentAccountOnPolicyHasPersonalCircumstances(){

        Account account = [SELECT Id FROM Account WHERE Name = :WITH_PERSONAL_CIRCUMSTANCE];
        InsurancePolicy policy = [SELECT Id FROM InsurancePolicy WHERE NameInsuredId = :account.Id];

        Test.startTest();
        CircumstanceNotificationController.AdditionalSupportNotificationWrapper result = CircumstanceNotificationController.additionalSupportNotificationHandler(policy.Id);
        Test.stopTest();

        Assert.areEqual(account.Id, result.ParentAccountId, 'Values should be the same');
        Assert.isTrue(result.DisplayNotification, 'DisplayNotification should be true');
        
    }

    @IsTest
    static void additionalSupportNotificationHandler_ShouldDisplayNotificationAsFalse_WhenParentAccountOnPolicyHasNoPersonalCircumstances(){

        Account account = [SELECT Id FROM Account WHERE Name = :WITHOUT_PERSONAL_CIRCUMSTANCE];
        InsurancePolicy policy = [SELECT Id FROM InsurancePolicy WHERE NameInsuredId = :account.Id];

        Test.startTest();
        CircumstanceNotificationController.AdditionalSupportNotificationWrapper result = CircumstanceNotificationController.additionalSupportNotificationHandler(policy.Id);
        Test.stopTest();

        Assert.areEqual(account.Id, result.ParentAccountId, 'Values should be the same');
        Assert.isFalse(result.DisplayNotification, 'DisplayNotification should be true');
        
    }

    @IsTest
    static void additionalSupportNotificationHandler_ShouldDisplayNotificationAsTrue_WhenParentAccountOnClaimHasPersonalCircumstances(){

        Account account = [SELECT Id FROM Account WHERE Name = :WITH_PERSONAL_CIRCUMSTANCE];
        Claim claim = [SELECT Id FROM Claim WHERE AccountId = :account.Id];

        Test.startTest();
        CircumstanceNotificationController.AdditionalSupportNotificationWrapper result = CircumstanceNotificationController.additionalSupportNotificationHandler(claim.Id);
        Test.stopTest();

        Assert.areEqual(account.Id, result.ParentAccountId, 'Values should be the same');
        Assert.isTrue(result.DisplayNotification, 'DisplayNotification should be true');
        
    }

    @IsTest
    static void additionalSupportNotificationHandler_ShouldDisplayNotificationAsFalse_WhenParentAccountOnClaimHasNoPersonalCircumstances(){

        Account account = [SELECT Id FROM Account WHERE Name = :WITHOUT_PERSONAL_CIRCUMSTANCE];
        Claim claim = [SELECT Id FROM Claim WHERE AccountId = :account.Id];

        Test.startTest();
        CircumstanceNotificationController.AdditionalSupportNotificationWrapper result = CircumstanceNotificationController.additionalSupportNotificationHandler(claim.Id);
        Test.stopTest();

        Assert.areEqual(account.Id, result.ParentAccountId, 'Values should be the same');
        Assert.isFalse(result.DisplayNotification, 'DisplayNotification should be true');
        
    }

    private static PersonalCircumstance__c createPersonalCircumstance(Account parentAccount){
        return new PersonalCircumstance__c(
            Account__c = parentAccount.Id,
            Details__c = 'Test Details',
            MethodOfContact__c = 'Phone',
            StartDate__c = System.today(),
            SupportCategory__c = 'Health',
            Support_Sub_Category__c = 'Addiction'
        );
    }

    private static Opportunity createOpportunity(Account parentAccount){
        return new Opportunity(
            AccountId = parentAccount.Id,
            Name = 'Test Opportunity',
            CloseDate = System.today(),
            StageName = 'Full Quote'
        );
    }

    private static Case createCase(Account parentAccount){
        return new Case(
            AccountId = parentAccount.Id,
            Status = 'New',
            Origin = 'Email',
            Priority = 'Low'
        );
    }

    private static InsurancePolicy createPolicy(Account parentAccount){
        return new InsurancePolicy(
            Name = 'Test Policy',
            NameInsuredId = parentAccount.Id
        );
    }

    public static Claim createClaim(Account parentAccount, InsurancePolicy policy){
        return new Claim(
            Name = 'Test Claim',
            AccountId = parentAccount.Id,
            PolicyNumberId = policy.Id
        );
    }

}