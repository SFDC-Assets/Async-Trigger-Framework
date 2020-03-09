trigger AccountChangeEventTrigger on AccountChangeEvent (after insert) {
    AsyncTriggerFactory.initialize(SObjectType.Account);
}
