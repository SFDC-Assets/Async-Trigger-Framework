public with sharing class Account_ATH extends AsyncTriggerBase {

    public override void isInsert(Map<Id,SObject> newMap) {
        DebugLog.add('START Account_ATH.isInsert');
        try{
            AccountingService.largeCalculation(newMap);
        } catch (Exception e) {
            DebugLog.add(
                'ERROR Account_ATH.isInsert: ' 
                + '\n' + e.getMessage()
                + '\n' + e.getStackTraceString()
            );
        }
        DebugLog.add('END Account_ATH.isInsert');
    }

    public override void isUpdate(Map<Id,SObject> newMap) {
        DebugLog.add('START Account_ATH.isUpdate');
        try {
            AccountingService.largeCalculation(newMap);
        } catch (Exception e) {
            DebugLog.add(
                'ERROR Account_ATH.isInsert: ' 
                + '\n' + e.getMessage()
                + '\n' + e.getStackTraceString()
            );
        }
        DebugLog.add('END Account_ATH.isUpdate');
    }
}
