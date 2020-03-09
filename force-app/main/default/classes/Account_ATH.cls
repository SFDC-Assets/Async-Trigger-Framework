public with sharing class Account_ATH extends AsyncTriggerBase {

    public override void isInsert(Map<Id,SObject> newMap) {
        AccountingService.largeCalculation(newMap);
    }

    public override void isUpdate(Map<Id,SObject> newMap) {
        AccountingService.largeCalculation(newMap);
    }
}
