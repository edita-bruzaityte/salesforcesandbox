/**
* GroupSelector is data access class. All SOQL to Group DB are stored here.
*
* @author  Matteo Iacucci
* @version 1.0
* @since   2021-04-20
*/
public with sharing class GroupSelector {
    rflib_Logger logger = rflib_LoggerUtil.getFactory().createLogger('GroupSelector');

    public Group getQueueByDeveloperName(String developerName){
        Group q = null;
        try{
            if( Group.SObjectType.getDescribe().isAccessible() ){
					q = [SELECT Id, DeveloperName, Name, Type 
							FROM Group 
							WHERE Type = 'Queue' AND DeveloperName = :developerName];
            }
        }catch(Exception e){
            logger.error('getQueueByDeveloperName(). exception. developername: {0}', new List<Object> {developerName}, e);
            throw e;
        }
        return q;
	}
}