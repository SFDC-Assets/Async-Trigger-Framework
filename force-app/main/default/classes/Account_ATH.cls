public with sharing class Account_ATH extends AsyncTriggerBase {

    public override void isInsert(Map<Id,SObject> newMap) {
        Map<Id,Account> typedMap = (Map<Id,Account>)newMap;
        AccountingService.largeCalculation(typedMap);
    }

    public override void isUpdate(Map<Id,SObject> newMap) {
        Map<Id,Account> typedMap = (Map<Id,Account>)newMap;
        AccountingService.largeCalculation(typedMap);
    }
}
