public with sharing class AccountTriggerHandler {

    public static void afterInsert(Map<Id,Account> newMap) {
        AccountWeatherService.fromTrigger_getWeather(newMap);
        if(!OrgSettings.demoSwitches.isAsync__c) {
            AccountingService.largeCalculation(newMap);
        }
    }

    public static void afterUpdate(Map<Id,Account> newMap) {
        AccountWeatherService.fromTrigger_getWeather(newMap);
        if(!OrgSettings.demoSwitches.isAsync__c) {
            AccountingService.largeCalculation(newMap);
        }
    }

    public static void async_afterChange(Map<Id,Account> accMap, Map<Id,Set<String>> fieldsChangedMap) {
        AccountingService.largeCalculation(accMap);
    }
}