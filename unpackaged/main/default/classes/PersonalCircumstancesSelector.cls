public with sharing class PersonalCircumstancesSelector implements IBulkDeleteFactory {

    private IInsurancePoliciesSelector policySelector;

    public PersonalCircumstancesSelector(){

    }
    
    public List<PersonalCircumstance__c> getPersonalCircumstancesByAccountIds(Set<Id> accountIds){
        return [
            SELECT Id, Name, Account__c
            FROM PersonalCircumstance__c
            WHERE Account__c IN :accountIds
        ];
    }

    public List<SObject> getRecordsForBulkDelete(){
        List<SObject> objectsForDeletion = new List<SObject>();
        Map<Id,PersonalCircumstance__c> accountIdToPersonalCircumstances = new Map<Id,PersonalCircumstance__c>();

        List<PersonalCircumstance__c> candidateRecordsForDeletion = getPersonalCircumstancesWhereEndDateIsPastOrEndDateIsNull();

        for(PersonalCircumstance__c circumstance : candidateRecordsForDeletion){
            if(circumstance.EndDate__c != null){
                objectsForDeletion.add(circumstance);
            }else{
                accountIdToPersonalCircumstances.put(circumstance.Account__c,circumstance);
            }
        }

        for(Id accountId : removeAccountIdsWhereMostRecentPolicyEndDateIsWithinAYear(accountIdToPersonalCircumstances.keySet())){
            objectsForDeletion.add(accountIdToPersonalCircumstances.get(accountId));
        }

        return objectsForDeletion;

    }

    private List<PersonalCircumstance__c> getPersonalCircumstancesWhereEndDateIsPastOrEndDateIsNull(){
        return [
            SELECT Id, Account__c, EndDate__c
            FROM PersonalCircumstance__c
            WHERE EndDate__c < TODAY
            OR EndDate__c = null
        ];
    }

    private Set<Id> removeAccountIdsWhereMostRecentPolicyEndDateIsWithinAYear(Set<Id> accountIds){

        policySelector = (InsurancePoliciesSelector) new InsurancePoliciesSelector();

        AggregateResult[] policies = policySelector.getInsurancePoliciesGroupedByAccountId(accountIds);

        for(AggregateResult result : policies){
            if((DateTime) result.get('expr0') > System.today().addYears(-1)){
                accountIds.remove((Id) result.get('NameInsuredId'));
            }
        }

        return accountIds;

    }
    
    
}