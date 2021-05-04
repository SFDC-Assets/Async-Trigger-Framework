public with sharing class AccountTriggerHandler {

    public static void afterInsert(Map<Id,Account> newMap) {
        // for callout example
        AccountWeatherService.fromTrigger_getWeather(newMap);

        // toggle switch to run "large calculation" asynchronously (CDC)
        if(!OrgSettings.demoSwitches.isAsync__c) {
            AccountingService.largeCalculation(newMap);
        }
    }
/*
    public static void afterUpdate(Map<Id,Account> newMap) {
        // example for callout
        AccountWeatherService.fromTrigger_getWeather(newMap);

        // toggle switch to run "large calculation" asynchronously (CDC)
        if(!OrgSettings.demoSwitches.isAsync__c) {
            AccountingService.largeCalculation(newMap);
        }
    }
*/
}