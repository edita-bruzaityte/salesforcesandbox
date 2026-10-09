trigger AccountTrigger on Account (after insert , after update, before delete) {

    if(rflib_FeatureSwitch.isTurnedOn('AccountTrigger')){
        sfpcz_TriggersController.init(AccountTriggerHandler.class).start();
    }
}