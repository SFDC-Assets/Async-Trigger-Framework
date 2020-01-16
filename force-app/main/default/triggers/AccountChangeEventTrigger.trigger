trigger AccountChangeEventTrigger on AccountChangeEvent (after insert) {

    Map<Id,Set<String>> fieldsChangedMap = new Map<Id,Set<String>>();

    for(AccountChangeEvent acc: Trigger.new) {
        List<String> recordIds = acc.ChangeEventHeader.getRecordIds();
        for(String recordId:recordIds) {
            if(fieldsChangedMap.containsKey(recordId)) {
                fieldsChangedMap.get(recordId).add(recordId);
            } else {
                fieldsChangedMap.put(recordId,new Set<String>{recordId});
            }
        }
    }

    Map<Id,Account> accMap = AccountTriggerHandler.getAccounts(fieldsChangedMap.keySet());

    AccountTriggerHandler.async_afterChange(accMap, fieldsChangedMap);

}