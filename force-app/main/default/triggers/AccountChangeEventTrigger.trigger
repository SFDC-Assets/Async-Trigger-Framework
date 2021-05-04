trigger AccountChangeEventTrigger on AccountChangeEvent (after insert) {
    if(OrgSettings.demoSwitches.isAsync__c) {
        AsyncTriggerFactory.initialize(SObjectType.Account);
    }
}
