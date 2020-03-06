trigger AccountTrigger on Account (after insert, after update) {
    if(Trigger.isAfter) {
        if(Trigger.isInsert) {
            DebugLog.add('ENTERED AccountTrigger.isInsert');
            AccountTriggerHandler.afterInsert(Trigger.newMap);
            DebugLog.add('EXIT AccountTrigger.isInsert');
        }
        if(Trigger.isUpdate) {
            DebugLog.add('ENTERED AccountTrigger.isUpdate');
            AccountTriggerHandler.afterUpdate(Trigger.newMap);
            DebugLog.add('EXIT AccountTrigger.isUpdate');
        }
        DebugLog.saveLog();
    }
}