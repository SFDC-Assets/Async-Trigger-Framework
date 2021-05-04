public virtual class AsyncTriggerHandlerBase {

    public Map<Id,SObject> recordsMap;
    public Map<Id,Set<String>> fieldsChangedMap;
    public Map<Id,EventBus.ChangeEventHeader> changeHeaderMap;
    public Map<String,Map<Id,SObject>> recordsMapByContext;

    public virtual void isInsert(Map<Id,SObject> newMap) {
        System.debug('override isInsert in Trigger Handler for factory to call it');
    }

    public virtual void isUpdate(Map<Id,SObject> newMap) {
        System.debug('override isUpdate in Trigger Handler for factory to call it');
    }

    public virtual void isDelete(Map<Id,SObject> newMap) {
        System.debug('override isDelete in Trigger Handler for factory to call it');
    }

    public virtual void isUndelete(Map<Id,SObject> newMap) {
        System.debug('override isUndelete in Trigger Handler for factory to call it');
    }

    public void triggerSetup() {
        populateChangeHeaderMap();
        populateFieldsChanged();
        populateRecordsMap();
        populateRecordsMapByContext();
    }

    private void populateChangeHeaderMap() {
 
        changeHeaderMap = new Map<Id,EventBus.ChangeEventHeader>();
        EventBus.ChangeEventHeader changeHeader;
 
        for(SObject record:(List<SObject>)Trigger.new) {
            changeHeader = (EventBus.ChangeEventHeader)record.get('ChangeEventHeader');
            for(String recordId:changeHeader.getRecordIds()) {
                changeHeaderMap.put(recordId,changeHeader);
            }
        }
    }

    private void populateFieldsChanged() {

        fieldsChangedMap = new Map<Id,Set<String>>();
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
    }

    private void populateRecordsMap() {

        recordsMap = new Map<Id,SObject>();
        Set<String> fields = new Set<String>{
            'Id','Name','CreatedDate','LastModifiedDate',
            'CreatedById','LastModifiedById'
        };

        DescribeSObjectResult dsr = (new List<Id>(fieldsChangedMap.keySet()))[0].getSobjectType().getDescribe();
        DescribeFieldResult dfr;

        for(SObjectField sof:dsr.fields.getMap().values()) {
            dfr = sof.getDescribe();
            if(dfr.isAccessible() && dfr.isUpdateable()) {
                fields.add(dfr.getName());
            }
        }

        Set<Id> fieldsChangedIds = fieldsChangedMap.keySet();

        for(SObject sob:(List<SObject>)Database.query(
            'SELECT ' + String.join(new List<String>(fields),',') + ' FROM ' + dsr.getName() + ' WHERE ID IN:fieldsChangedIds'
        )) {
            recordsMap.put(sob.Id, sob);
        }
    }

    private void populateRecordsMapByContext() {

        recordsMapByContext = new Map<String,Map<Id,SObject>>();

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
    }
}
