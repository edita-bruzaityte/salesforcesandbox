trigger CaseTrigger on Case (before insert, after insert , after update, before delete, before update) {

    if(rflib_FeatureSwitch.isTurnedOn('CaseTrigger')){
        sfpcz_TriggersController.init(CaseTriggerHandler.class).start();
    }
}