public with sharing class LeadService {
    private rflib_Logger logger;

    public LeadService(){
        logger = rflib_LoggerUtil.getFactory().createLogger('ContactService');
    }

    public Boolean isConverted(Lead oldLead, Lead newLead ){
        return !oldLead.IsConverted && newLead.IsConverted;
    }

    public List<Case> getCases(Set<Id> ids){
        return new CaseSelector().getCasesByLeadIds(ids);
    }

    public void relateCaseToConvertedAccountAndContact(Case c, Lead l){
        c.AccountId = l?.ConvertedAccountId;
        c.ContactId = l?.ConvertedContactId;
    }
}