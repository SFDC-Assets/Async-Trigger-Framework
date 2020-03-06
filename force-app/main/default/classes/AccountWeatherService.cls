public with sharing class AccountWeatherService {

    public static void fromTrigger_getWeather(Map<Id,SObject> accMap) {
        DebugLog.add('ENTERED AccountWeatherService.fromTrigger_getWeather');
        List<Async_Call__e> pes = new List<Async_Call__e>();
        for(Account acc:(List<Account>)accMap.values()) {
            // checks if weather is blank to avoid recursion
            if(String.isBlank(acc.Weather__c) && (String.isNotBlank(acc.BillingCity) || String.isNotBlank(acc.ShippingCity))) {
                pes.add(new Async_Call__e(
                    Record_Id__c = acc.Id,
                    City_Name__c = String.isNotBlank(acc.BillingCity) ? acc.BillingCity : acc.ShippingCity
                ));
            }
        }
        if(!pes.isEmpty()) {
            DebugLog.add(pes.size() + ' events published');
            EventBus.publish(pes);
        } else {
            DebugLog.add('no weather events to publish');
        }
        DebugLog.add('EXIT AccountWeatherService.fromTrigger_getWeather');
    }

    @future(callout=true)
    public static void async_getWeather(Map<Id,String> mapAccId_City) {

        DebugLog.add('START async_getWeather: ' + mapAccId_City.values().size() + ' records');

        List<Account> accs = new List<Account>();

        for(Id accId:mapAccId_City.keySet()) {
            WeatherResponse wr = WeatherService.getWeather(mapAccId_City.get(accId));
            if(wr != null) {
                accs.add(new Account(
                    Id = accId,
                    Weather__c = JSON.serialize(wr)
                ));
            }
        }

        if(!accs.isEmpty()) {
            update accs;
            DebugLog.add(accs.size() + ' accounts with weather data saved');
        } else {
            DebugLog.add('no accounts with weather data');
        }
        DebugLog.add('END async_getWeather');
        DebugLog.saveLog();
    }
}
