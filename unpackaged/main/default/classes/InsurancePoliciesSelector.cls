public with sharing class InsurancePoliciesSelector implements IInsurancePoliciesSelector{

    public Map<String,InsurancePolicy> getInsurancePolicyMapByUUID(Set<String> sourceUUIDs){

        Map<String,InsurancePolicy> mapToReturn = new Map<String,InsurancePolicy>();
        
        List<InsurancePolicy> insurancePolicies = [
            SELECT Id,SourceRecord_UUID__c	
            FROM InsurancePolicy
            WHERE SourceRecord_UUID__c
            IN :sourceUUIDs
        ];
        
        for(InsurancePolicy policy : insurancePolicies){
            mapToReturn.put(policy.SourceRecord_UUID__c, policy);
        }
        
        return mapToReturn;
        
    }

    public AggregateResult[] getInsurancePoliciesGroupedByAccountId(Set<Id> parentAccountIds){
        return [
            SELECT NameInsuredId, MAX(DurationEnd__c)
            FROM InsurancePolicy
            WHERE NameInsuredId IN :parentAccountIds
            GROUP BY NameInsuredId
        ];
    }

}