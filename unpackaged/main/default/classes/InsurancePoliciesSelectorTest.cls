@IsTest
private class InsurancePoliciesSelectorTest {

    @IsTest
    static void testGetInsurancePolicyMapByUUID() {
        // Test data
        Account acc = new Account(Name = 'Test Account');
        insert acc;

        InsurancePolicy policy = new InsurancePolicy(
            Name                = 'Test Policy',
            SourceRecord_UUID__c = 'UUID-1',
            NameInsuredId       = acc.Id,
            DurationEnd__c      = Date.today().addDays(10)
            // TODO: add any other required fields for InsurancePolicy here
        );
        insert policy;

        Test.startTest();
        InsurancePoliciesSelector selector = new InsurancePoliciesSelector();

        Set<String> uuids = new Set<String>{ 'UUID-1' };
        Map<String, InsurancePolicy> result =
            selector.getInsurancePolicyMapByUUID(uuids);
        Test.stopTest();

        System.assertEquals(1, result.size(), 'Map should contain one entry');
        System.assertEquals(
            policy.Id,
            result.get('UUID-1').Id,
            'Policy in the map should match the inserted policy'
        );
    }

    @IsTest
static void testGetInsurancePoliciesGroupedByAccountId() {
    // Create Account
    Account acc = new Account(Name = 'Grouped Account');
    insert acc;

    // Create two policies for same Account
    InsurancePolicy p1 = new InsurancePolicy(
        Name = 'Policy 1',
        SourceRecord_UUID__c = 'UUID-2',
        NameInsuredId = acc.Id,
        DurationEnd__c = Date.today()
    );
    InsurancePolicy p2 = new InsurancePolicy(
        Name = 'Policy 2',
        SourceRecord_UUID__c = 'UUID-3',
        NameInsuredId = acc.Id,
        DurationEnd__c = Date.today().addDays(5)
    );
    insert new List<InsurancePolicy>{ p1, p2 };

    Test.startTest();
    InsurancePoliciesSelector selector = new InsurancePoliciesSelector();
    AggregateResult[] results =
        selector.getInsurancePoliciesGroupedByAccountId(new Set<Id>{ acc.Id });
    Test.stopTest();

    System.assertEquals(1, results.size(), 'Should return one grouped row');

    // Get MAX(DurationEnd__c) from AggregateResult (expr0)
    Object raw = results[0].get('expr0');
    System.assertNotEquals(null, raw);

    // Convert safely
    Date maxDate;
    if (raw instanceof Datetime) {
        maxDate = ((Datetime) raw).date();
    } else if (raw instanceof Date) {
        maxDate = (Date) raw;
    } else {
        System.assert(false, 'Unexpected type returned by MAX(DurationEnd__c): ' + raw);
    }

    System.assertEquals(p2.DurationEnd__c, maxDate);
}
}