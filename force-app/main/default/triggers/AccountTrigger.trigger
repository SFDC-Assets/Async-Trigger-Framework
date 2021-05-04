trigger AccountTrigger on Account (after insert, after update) {
    if(Trigger.isAfter) {
        if(Trigger.isInsert) {
            AccountTriggerHandler.afterInsert(Trigger.newMap);
        }
        // if(Trigger.isUpdate) {
        //     AccountTriggerHandler.afterUpdate(Trigger.newMap);
        // }
    }
}