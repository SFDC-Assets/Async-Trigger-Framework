trigger AccountTrigger on Account (after insert, after update, before delete) {
    if(Trigger.isAfter && (Trigger.isInsert || Trigger.isUpdate)) {
        AccountTriggerHandler.beforeDelete(Trigger.newMap);
    }
}