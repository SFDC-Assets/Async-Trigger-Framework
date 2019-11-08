trigger AccountTrigger on Account (before insert) {
    if(Trigger.isAfter || Trigger.isDelete) {
        AccountTriggerHandler.beforeDelete(Trigger.newMap);
    }
}