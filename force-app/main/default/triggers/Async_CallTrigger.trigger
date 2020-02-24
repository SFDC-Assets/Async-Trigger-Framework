trigger Async_CallTrigger on Async_Call__e (after insert) {

    Map<Id,String> weatherMap = new Map<Id,String>();
    Set<Id> accIds = new Set<Id>();

    for(Async_Call__e ac:Trigger.new) {
        accIds.add(ac.Record_Id__c);
    }

    Map<Id,Account> accMap = AccountTriggerHandler.getAccounts(accIds);
    for(Account acc:accMap.values()) {
        if(String.isNotBlank(acc.BillingCity) || String.isNotBlank(acc.ShippingCity)) {
            String city = String.isNotBlank(acc.BillingCity) ? acc.BillingCity : acc.ShippingCity;
            weatherMap.put(acc.Id, city);
        }
    }

    if(!accMap.isEmpty()) {
        AccountWeatherService.async_getWeather(weatherMap);
    }
}