public class AsyncTriggerFactory {

	public class AsyncTriggerFactoryException extends Exception {}

	// THIS IS THE ENTRY POINT
	public static void initialize(Schema.SObjectType sType) {
        // create instance of trigger handler for SOBJECT
        AsyncTriggerBase handler = getHandler(sType);
        // if a trigger handler was found
        if(handler != null) { 
            // run the trigger handler
            execute(handler);
        } else {
            // if no trigger handler is found, write debug
            System.debug(
                'There is no handler for ' + 
                sType.getDescribe().getLabel() + 
                ' (' + sType.getDescribe().getName() + ')' + 
                '. If there should be, please check that your handler '+
                'follows the naming convention and that it extends AsyncTriggerBase.'
            );
        }
	}

	// execute the trigger handler
	private static void execute(AsyncTriggerBase handler) {
        // grab data and put together information on changes
        handler.triggerSetup();
        // run the trigger logic
        if(!handler.recordsMapByContext.get('CREATE').isEmpty()) {
            handler.isInsert(handler.recordsMapByContext.get('CREATE'));
        }
        if(!handler.recordsMapByContext.get('UPDATE').isEmpty()) {
            handler.isInsert(handler.recordsMapByContext.get('UPDATE'));
        }
        if(!handler.recordsMapByContext.get('DELETE').isEmpty()) {
            handler.isInsert(handler.recordsMapByContext.get('DELETE'));
        }
        if(!handler.recordsMapByContext.get('UNDELETE').isEmpty()) {
            handler.isInsert(handler.recordsMapByContext.get('UNDELETE'));
        }
	}

	private static String triggerHandlerSuffix = '_ATH';

	private static AsyncTriggerBase getHandler(Schema.SObjectType sType) {
		AsyncTriggerBase handlerClass;
		try {
			// this is where the conversion from SObject name to 
			// trigger handler class name happens
			String className = sType.getDescribe().getName();
			// call method to convert the object name to handler class name
			className = convertObjectNameToHandlerName(className);
			// create an instance of the trigger handler class
			handlerClass = (AsyncTriggerBase)Type.forName(className).newInstance(); // magic
		} catch(Exception e) {
			System.debug(e);
		}
		return handlerClass;
	}

	// receives an object name and converts it to a trigger handler class name
	public static String convertObjectNameToHandlerName(String sObjectName) {
		String className;
		try {
			System.debug('convertObjectNameToHandlerName("'+sObjectName+'")');
			// removes __c from custom objects
			className = sObjectName.removeEnd('__c');
			System.debug('"'+className+'" removed custom object suffix');
			// adds trigger handler suffix to sObject name
			className += triggerHandlerSuffix;
			System.debug('"'+className+'" added trigger handler suffix');
			// normalizes underscores (in the case of objects with a namespace)
			classname = className.replace('__','_');
			System.debug('"'+className+'" normalized underscores ');
			// the limit for a class name is 40 characters
			// if, at this point, the name is longer than 40 characters
			if(className.length() > 40) {
				// remove characters from the beginning to bring the name down to 40 characters
				className = className.subString(className.length()-40,className.length());
				System.debug('"'+className+'" class name was greater than 40 characters');
			}
			// if removing extra characters from the beginning made the class name
			// start with an underscore (underbar) remove that character
			className = className.removeStart('_');
			System.debug('"'+className+'" removed beginning underscore');
		} catch(Exception e) {
			System.debug('\nEXCEPTION WHEN TRYING TO CREATE NAME\n'+e.getMessage()+'\n'+e.getStackTraceString()+'\n');
		}
		return className;
	}

	// makes this class exceptionable
	private class TriggerException extends Exception {}
}