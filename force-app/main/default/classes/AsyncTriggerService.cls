public with sharing class AsyncTriggerService {

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

        for(SObject sob:(List<SObject>)Database.query(
            'SELECT ' + String.join(new List<String>(fields),',') + ' WHERE ID IN:recordIds'
        )) {
            recordMap.put(sob.Id, sob);
        }

        return recordMap;
    }

    public static Map<String,Map<Id,SObject>> getRecordsMapByContext(
        Map<Id,SObject> recordsMap, 
        Map<Id,EventBus.ChangeEventHeader> changeHeaderMap
    ) {
        Map<String,Map<Id,SObject>> recordsMapByContext = new Map<String,Map<Id,SObject>>();
        // does not cover 'GAP_CREATE','GAP_UPDATE','GAP_DELETE','GAP_UNDELETE','GAP_OVERFLOW'
        for(String eventContext:new List<String>{'CREATE','UPDATE','DELETE','UNDELETE'}) {
            recordsMapByContext.put(eventContext, new Map<Id,SObject>());
        }
        for(EventBus.ChangeEventHeader ceh:changeHeaderMap.values()) {
            for(Id recordId:ceh.recordIds) {
                recordsMapByContext.get(ceh.changeType).put(recordId, recordsMap.get(recordId));
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
