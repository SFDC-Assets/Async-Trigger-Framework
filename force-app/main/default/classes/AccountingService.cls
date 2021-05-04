public with sharing class AccountingService {

    public static void largeCalculation(Map<Id,SObject> newMap) {
        // this is just meant to take a long time
        // we know it's not real
        List<String> hugeList = new List<String>();

        for(Integer i = 0; i < 500; i++) {
            hugeList.add(String.valueOf(i));
        }

        for(Integer j = 0; j < 1000; j++) {
            JSON.serialize(hugeList);
        }

        List<Accounting_Calculation_Result__c> acrs = new List<Accounting_Calculation_Result__c>();

        List<Account> accs = new List<Account>();

        for(Account acc:(List<Account>)newMap.values()) {
            acrs.add(new Accounting_Calculation_Result__c(Account__c = acc.Id, Random_Number__c = 1));
        }

        if(!acrs.isEmpty()) {
            insert acrs;
        }
    }
}
