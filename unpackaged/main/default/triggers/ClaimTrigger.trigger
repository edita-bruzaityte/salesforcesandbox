trigger ClaimTrigger on Claim (after insert , after update, before delete) {

    if(rflib_FeatureSwitch.isTurnedOn('ClaimTrigger')){
        sfpcz_TriggersController.init(ClaimTriggerHandler.class).start();
    }
}