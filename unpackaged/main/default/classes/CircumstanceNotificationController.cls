public with sharing class CircumstanceNotificationController {

    public class AdditionalSupportNotificationWrapper{

        @AuraEnabled
        public Id ParentAccountId { get; private set;}
        @AuraEnabled
        public Boolean DisplayNotification { get; private set;}

        public AdditionalSupportNotificationWrapper(Id parentAccountId, Boolean displayNotification){
            this.ParentAccountId = parentAccountId;
            this.DisplayNotification = displayNotification;
        }
    }

    @AuraEnabled(cacheable=true)
    public static AdditionalSupportNotificationWrapper additionalSupportNotificationHandler(String recordId){

        PersonalCircumstancesSelector personalCircumstancesSelector = new PersonalCircumstancesSelector();
        String baseSoqlQuery = 'SELECT {0} FROM {1} WHERE Id = \'\'{2}\'\' LIMIT 1';

        Map<String,String> objectToParentAccountField = new Map<String,String>{
            'Account' => 'Id',
            'Case' => 'AccountId',
            'Opportunity' => 'AccountId',
            'InsurancePolicy' => 'NameInsuredId',
            'Claim' => 'AccountId',
            'Task' => 'AccountId__c',
            'VoiceCall' => 'AccountId__c'
        };

        Id objectId = Id.valueOf(recordId);
        Schema.SObjectType sobjectType = objectId.getSObjectType();
        Map<String,Schema.SObjectField> objectToParentAccountFields = sobjectType.getDescribe().fields.getMap();
        
        SObject sobjList = Database.query(String.format(baseSoqlQuery, new List<Object>{
            objectToParentAccountFields.get(objectToParentAccountField.get(sobjectType.getDescribe().getName())),
            sobjectType.getDescribe().getName(),
            recordId
        }));

        Id parentAccountId = (Id) sobjList.get(objectToParentAccountFields.get(objectToParentAccountField.get(sobjectType.getDescribe().getName())));

        List<PersonalCircumstance__c> results = personalCircumstancesSelector.getPersonalCircumstancesByAccountIds(new Set<Id>{ parentAccountId });
        Boolean displayNotification = !results.isEmpty();

        return new AdditionalSupportNotificationWrapper(parentAccountId, displayNotification);
        
    }

}