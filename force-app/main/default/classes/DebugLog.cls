public with sharing class DebugLog {

    public static List<String> logRows = new List<String>();

    public static String between = '\n\n';

    public static void add(String logEntry) {
        logRows.add(logEntry);
    }

    public static String getLog() {
        return String.join(logRows, between);
    }

    public static void saveLog() {
        if(logRows != null & !logRows.isEmpty()) {
            insert new Debug_Log__c(Log__c = getLog());
        }
    }
}
