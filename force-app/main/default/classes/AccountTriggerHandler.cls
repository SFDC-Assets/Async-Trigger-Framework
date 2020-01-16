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

    public static Map<Id,Account> getAccounts(Set<Id> accIds) {
        Set<String> accFields = new Set<String>{'Id','Name','CreatedDate','LastModifiedDate','CreatedById','LastModifiedById'};
        DescribeFieldResult dfr;
        for(SObjectField sof:SObjectType.Account.fields.getMap().values()) {
            dfr = sof.getDescribe();
            if(dfr.isAccessible() && (dfr.isUpdateable() || dfr.isCalculated())) {
                accFields.add(dfr.getName());
            }
        }
        Map<Id,Account> accMap = new Map<Id,Account>();
        for(Account acc:(List<Account>)Database.query('SELECT ' + String.join(new List<String>(accFields),',') + ' WHERE ID IN:accIds')) {
            accMap.put(acc.Id, acc);
        }
        return accMap;
    }
}