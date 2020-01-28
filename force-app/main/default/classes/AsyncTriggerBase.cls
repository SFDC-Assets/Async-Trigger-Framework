public virtual class AsyncTriggerBase {

    public Map<Id,SObject> recordsMap;
    public Map<Id,Set<String>> fieldsChanged;
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
        changeHeaderMap = AsyncTriggerService.getChangeEventHeaders();
        fieldsChanged = AsyncTriggerService.getFieldsChanged();
        recordsMap = AsyncTriggerService.getRecordsMap(fieldsChanged.keySet());
        recordsMapByContext = AsyncTriggerService.getRecordsMapByContext(recordsMap, changeHeaderMap);
    }
}
