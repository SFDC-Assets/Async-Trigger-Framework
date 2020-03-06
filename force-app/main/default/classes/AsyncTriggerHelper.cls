public with sharing class AsyncTriggerHelper {

    public static Map<Id,SObject> getRecordsMap(Set<Id> recordIds) {

        Map<Id,SObject> recordMap = new Map<Id,SObject>();
        Set<String> fields = new Set<String>{
            'Id','Name','CreatedDate','LastModifiedDate',
            'CreatedById','LastModifiedById'
        };

        DescribeSObjectResult dsr = (new List<Id>(recordIds))[0].getSobjectType().getDescribe();
        DescribeFieldResult dfr;

        for(SObjectField sof:dsr.fields.getMap().values()) {
            dfr = sof.getDescribe();
            if(dfr.isAccessible() && dfr.isUpdateable()) {
                fields.add(dfr.getName());
            }
        }

        try {
            for(SObject sob:(List<SObject>)Database.query(
                'SELECT ' + String.join(new List<String>(fields),',') + ' FROM ' + dsr.getName() + ' WHERE ID IN:recordIds'
            )) {
                recordMap.put(sob.Id, sob);
            }
            DebugLog.add('Number of ' +  dsr.getLabelPlural() + ' queried: ' + recordMap.values().size());
            DebugLog.add(JSON.serialize(recordMap));
        } catch (Exception e) {
            DebugLog.add(
                'ERROR: AsyncTriggerHelper.getRecordsMap' 
                + '\n' + e.getMessage()
                + '\n' + e.getStackTraceString()
            );
        }
        return recordMap;
    }

    public static Map<String,Map<Id,SObject>> getRecordsMapByContext(
        Map<Id,SObject> recordsMap, 
        Map<Id,EventBus.ChangeEventHeader> changeHeaderMap
    ) {
        Map<String,Map<Id,SObject>> recordsMapByContext = new Map<String,Map<Id,SObject>>();
        // does not cover 'GAP_OVERFLOW'
        // very large changes to a database will throw overflow events. They will basically say
        // that a large number of changes have happened to a table and you should resync the tables.
        for(String eventContext:new List<String>{'CREATE','UPDATE','DELETE','UNDELETE'}) {
            recordsMapByContext.put(eventContext, new Map<Id,SObject>());
        }

        // In this paradigm, GAP and non-GAP events are handled the same way.
        // GAP events are where a change is made at a system level (i.e. picklist value replace)
        for(EventBus.ChangeEventHeader ceh:changeHeaderMap.values()) {
            for(Id recordId:ceh.recordIds) {
                recordsMapByContext.get(ceh.changeType.replace('GAP_','')).put(recordId, recordsMap.get(recordId));
            }
        }

        return recordsMapByContext;
    }

    public static Map<Id,EventBus.ChangeEventHeader> getChangeEventHeaders() {
 
        Map<Id,EventBus.ChangeEventHeader> cehMap = new Map<Id,EventBus.ChangeEventHeader>();
        EventBus.ChangeEventHeader ceh;
 
        for(SObject record:(List<SObject>)Trigger.new) {
            ceh = (EventBus.ChangeEventHeader)record.get('ChangeEventHeader');
            for(String recordId:ceh.getRecordIds()) {
                cehMap.put(recordId,ceh);
            }
        }

        return cehMap;
    }

    public static Map<Id,Set<String>> getFieldsChanged() {

        Map<Id,Set<String>> fieldsChangedMap = new Map<Id,Set<String>>();
        EventBus.ChangeEventHeader ceh;

        for(SObject record:(List<SObject>)Trigger.new) {
            ceh = (EventBus.ChangeEventHeader)record.get('ChangeEventHeader');
            List<String> recordIds = ceh.getRecordIds();
            for(String recordId:recordIds) {
                if(fieldsChangedMap.containsKey(recordId)) {
                    fieldsChangedMap.get(recordId).addAll(ceh.changedFields);
                } else {
                    fieldsChangedMap.put(recordId,new Set<String>(ceh.changedFields));
                }
            }
        }

        return fieldsChangedMap;
    }
}
