trigger LeadTrigger on Lead (before insert, after update) {

    if(rflib_FeatureSwitch.isTurnedOn('LeadTrigger')){
        rflib_LoggerUtil.getFactory().createLogger('LeadTrigger').debug('FeatureSwitch \'LeadTrigger\' flag is enabled');
        sfpcz_TriggersController.init(LeadTriggerHandler.class).start();
    }
}