public with sharing class AccountTriggerHandler {

    public static void afterInsert(Map<Id,Account> newMap) {
        AccountingService.largeCalculation(newMap);
    }

    public static void afterUpdate(Map<Id,Account> newMap) {
        AccountingService.largeCalculation(newMap);
    }

    public static void beforeDelete(Map<Id,Account> newMap) {
        AccountingService.largeCalculation(newMap);
    }

    public static void async_afterChange(Map<Id,Account> accMap, Map<Id,Set<String>> fieldsChangedMap) {
        // AccountingService.largeCalculation(accMap);
    }
}