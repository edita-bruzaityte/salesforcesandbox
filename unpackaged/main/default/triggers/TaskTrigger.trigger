trigger TaskTrigger on Task (after insert , after update, before delete) {

    if(rflib_FeatureSwitch.isTurnedOn('TaskTrigger')){
        sfpcz_TriggersController.init(TaskTriggerHandler.class).start();
    }
}