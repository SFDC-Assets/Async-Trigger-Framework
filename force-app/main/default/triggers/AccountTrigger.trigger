trigger AccountTrigger on Account (after insert, after update, before delete) {
    if(Trigger.isAfter || Trigger.isDelete) {
        AccountTriggerHandler.beforeDelete(Trigger.newMap);
    }
}