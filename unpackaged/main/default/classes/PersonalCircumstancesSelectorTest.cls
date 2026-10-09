@isTest
public with sharing class PersonalCircumstancesSelectorTest {

    @TestSetup
    static void makeData(){

        PC_TestDataFactory accountWithPersonalCircumstance = PC_TestDataFactory.createAccount('Test');

        accountWithPersonalCircumstance.insertObj();

        insert new PersonalCircumstance__c(
            Account__c = accountWithPersonalCircumstance.getObj().Id,
            Details__c = 'Test Details',
            MethodOfContact__c = 'Phone',
            StartDate__c = System.today(),
            SupportCategory__c = 'Health',
            Support_Sub_Category__c = 'Addiction'
        );

    }

    @IsTest
    static void getPersonalCircumstancesByAccountIds_ShouldReturnPersonalCircumstances_WhenCalled(){

        PersonalCircumstancesSelector selector = new PersonalCircumstancesSelector();
        Account account = [SELECT Id FROM Account LIMIT 1];
        
        Test.startTest();
        List<PersonalCircumstance__c> result = selector.getPersonalCircumstancesByAccountIds(new Set<Id>{ account.Id });
        Test.stopTest();

        Assert.areEqual( 1, result.size(), 'Selector should have returned a Personal Circumstance');
        
    }

    @IsTest
    static void getRecordsForBulkDelete_ShouldReturnLapsedPersonalCircumstance_WhenPolicyEndDateIsNull(){

        PersonalCircumstancesSelector systemUnderTest = new PersonalCircumstancesSelector();
        Integer expectedResult = 1;

        Account account = [SELECT Id FROM Account LIMIT 1];

        insert new InsurancePolicy(
            Name = 'Test Policy1',
            NameInsuredId = account.Id
        );

        Test.startTest();
        List<SObject> result = systemUnderTest.getRecordsForBulkDelete();
        Test.stopTest();

        system.assertEquals(1, result.size(), 'Records to delete should have returned one record');
        
    }

    @IsTest
    static void getRecordsForBulkDelete_ShouldReturnLapsedPersonalCircumstance_WhenPolicyEndDateOverAYearOld(){

        PersonalCircumstancesSelector systemUnderTest = new PersonalCircumstancesSelector();
        Integer expectedResult = 1;

        Account account = [SELECT Id FROM Account LIMIT 1];

        insert new InsurancePolicy(
            Name = 'Test Policy1',
            NameInsuredId = account.Id,
            DurationEnd__c = System.today().addYears(-1)
        );

        Test.startTest();
        List<SObject> result = systemUnderTest.getRecordsForBulkDelete();
        Test.stopTest();

        system.assertEquals(expectedResult, result.size(), 'Records to delete should have returned one record');
        
    }

    @IsTest
    static void getRecordsForBulkDelete_ShouldNotReturnLapsedPersonalCircumstance_WhenPolicyEndDatePast(){

        PersonalCircumstancesSelector systemUnderTest = new PersonalCircumstancesSelector();
        Integer expectedResult = 0;

        Account account = [SELECT Id FROM Account LIMIT 1];

        insert new InsurancePolicy(
            Name = 'Test Policy1',
            NameInsuredId = account.Id,
            DurationEnd__c = System.today().addDays(-1)
        );

        Test.startTest();
        List<SObject> result = systemUnderTest.getRecordsForBulkDelete();
        Test.stopTest();

        system.assertEquals(expectedResult, result.size(), 'Records to delete should not have returned any records');
        
    }

    @IsTest
    static void getRecordsForBulkDelete_ShouldNotReturnLapsedPersonalCircumstance_WhenPolicyEndDateIsTodayOrInFuture(){

        PersonalCircumstancesSelector systemUnderTest = new PersonalCircumstancesSelector();
        Integer expectedResult = 0;

        Account account = [SELECT Id FROM Account LIMIT 1];

        insert new List<InsurancePolicy>{
            new InsurancePolicy(
                Name = 'Test Policy1',
                NameInsuredId = account.Id,
                DurationEnd__c = System.today()
            ), new InsurancePolicy(
                Name = 'Test Policy2',
                NameInsuredId = account.Id,
                DurationEnd__c = System.today().addDays(13)
            )
        };

        Test.startTest();
        List<SObject> result = systemUnderTest.getRecordsForBulkDelete();
        Test.stopTest();

        system.assertEquals(expectedResult, result.size(), 'Records to delete should not have returned any records');
        
    }

}