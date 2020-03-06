trigger AccountChangeEventTrigger on AccountChangeEvent (after insert) {
    DebugLog.add('ENTERED AccountChangeEventTrigger');
    // un-comment below when using AsyncTriggerFactory
    AsyncTriggerFactory.initialize(SObjectType.Account);

    // TODO: make this generic
    // Map<Id,Set<String>> fieldsChangedMap = new Map<Id,Set<String>>();

    // for(AccountChangeEvent acc: Trigger.new) {
    //     List<String> recordIds = acc.ChangeEventHeader.getRecordIds();
    //     SObject trythis = (SObject)acc;
    //     for(String recordId:recordIds) {
    //         if(fieldsChangedMap.containsKey(recordId)) {
    //             fieldsChangedMap.get(recordId).add(recordId);
    //         } else {
    //             fieldsChangedMap.put(recordId,new Set<String>{recordId});
    //         }
    //     }
    // }
    // // end generic

    // Map<Id,Account> accMap = AccountTriggerHandler.getAccounts(fieldsChangedMap.keySet());

    // AccountTriggerHandler.async_afterChange(accMap, fieldsChangedMap);
}
