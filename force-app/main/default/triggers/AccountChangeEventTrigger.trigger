trigger AccountChangeEventTrigger on AccountChangeEvent (after insert) {

    DescribeFieldResult dfr;

    Set<String> accFields = new Set<String>{'Id','Name','CreatedDate','LastModifiedDate','CreatedById','LastModifiedById'};
    for(SObjectField sof:SObjectType.Account.fields.getMap().values()) {
        dfr = sof.getDescribe();
        if(dfr.isAccessible() && (dfr.isUpdateable() || dfr.isCalculated())) {
            accFields.add(dfr.getName());
        }
    }

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

    Map<Id,Account> accMap = new Map<Id,Account>();
    for(Account acc:(List<Account>)Database.query('SELECT ' + String.join(new List<String>(accFields),',') + ' WHERE ID IN:fieldsChangedMap.set()')) {
        accMap.put(acc.Id, acc);
    }
    
    AccountTriggerHandler.async_afterChange(accMap, fieldsChangedMap);

}