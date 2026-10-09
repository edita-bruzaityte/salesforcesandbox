trigger InsurancePolicyTrigger on InsurancePolicy (after update) {

    InsurancePolicyTriggerHandler handle = new InsurancePolicyTriggerHandler(Trigger.new, Trigger.old);
    
    switch on Trigger.operationType{
        when AFTER_UPDATE {
            handle.afterUpdate();
        }
    }
    
    System.debug('LIMITS rows' + System.Limits.getDmlRows());
    System.debug('LIMITS queries' + System.Limits.getQueries());
    System.debug('LIMITS sosl queries' + System.Limits.getSoslQueries());
}