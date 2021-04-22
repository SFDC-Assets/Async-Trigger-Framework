trigger Async_CallTrigger on Async_Call__e (after insert) {
    Map<Id,String> weatherMap = new Map<Id,String>();
    Set<Id> accIds = new Set<Id>();

    for(Async_Call__e ac:Trigger.new) {
        accIds.add(ac.Record_Id__c);
    }

    Map<Id,Account> accMap = new Map<Id,Account>([
        SELECT  Id, BillingCity, ShippingCity
        FROM    Account
        WHERE   Id IN:accIds
    ]);

    for(Account acc:(List<Account>)accMap.values()) {
        if(String.isNotBlank(acc.BillingCity) || String.isNotBlank(acc.ShippingCity)) {
            String city = String.isNotBlank(acc.BillingCity) ? acc.BillingCity : acc.ShippingCity;
            weatherMap.put(acc.Id, city);
        }
    }

    if(!weatherMap.isEmpty()) {
        AccountWeatherService.async_getWeather(weatherMap);
    }
}