public with sharing class AccountingService {
    public static void largeCalculation(Map<Id,Account> newMap) {
        // this is just meant to take a long time
        // we know it's not real
        List<String> hugeList = new List<String>();

        for(Integer i = 0; i < 10000; i++) {
            hugeList.add(String.valueOf(i));
        }

        for(Integer j = 0; j < 10000; j++) {
            JSON.serialize(hugeList);
        }
    }
}
