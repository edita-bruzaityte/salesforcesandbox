trigger ContactTrigger on Contact (after insert , after update, before delete) {

    if(rflib_FeatureSwitch.isTurnedOn('ContactTrigger')){
        sfpcz_TriggersController.init(ContactTriggerHandler.class).start();
    }
}