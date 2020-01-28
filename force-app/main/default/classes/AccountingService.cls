public with sharing class AccountingService {

    public static void largeCalculation(Map<Id,Account> newMap) {
        // this is just meant to take a long time
        // we know it's not real
        List<String> hugeList = new List<String>();

        for(Integer i = 0; i < 1000; i++) {
            hugeList.add(String.valueOf(i));
        }

        for(Integer j = 0; j < 10000; j++) {
            JSON.serialize(hugeList);
        }
/*
        List<Account_Calculation_Result__c> acrs = new List<Account_Calculation_Result__c>();

        List<Account> accs = new List<Account>();

        for(Account acc:newMap.values()) {
            if(!acc.Calculation_Complete__c) {
                acrs.add(new Account_Calculation_Result__c(Random_Number__c = 1));
                acc.Calculation_Complete__c = true;
                accs.add(acc);
            }
        }

        if(!acrs.isEmpty()) {
            insert acrs;
        }

        if(!accs.isEmpty()) {
            update accs;
        }
*/
    }
}
