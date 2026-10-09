/**
* AccountService 
*
* @author  Matteo Iacucci
* @version 1.0
* @since   2021-4-14
*/
public with sharing class AccountService {

	private rflib_Logger logger;

	Id employedRecordType = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Employed').getRecordTypeId();
	Id smallBusinessRecordType = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Small_Business').getRecordTypeId();
	Id soleProprietorRecordType = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Sole_Proprietor').getRecordTypeId();


	public AccountService(){
		logger = rflib_LoggerUtil.getFactory().createLogger('AccountService');
	}

	//check if the creation or the edit wasn't made from the integration user and then sync the record
	public void handleSync(List<Account> accounts, String event){
		AccountSyncQueueable accountSyncQueueable = new AccountSyncQueueable(accounts, event);
		System.enqueueJob(accountSyncQueueable);
	}

	public Id getRecordTypeFromCompanyType(String companyType){
		switch on companyType {
			when 'I trade as a partnership'  {
				return smallBusinessRecordType;
			}when 'I trade as a limited company' {
				return smallBusinessRecordType;
			}when 'I\'m employed' {
				return employedRecordType;
			}when 'I\'m self employed' {
				return soleProprietorRecordType;
			}when else {
				return smallBusinessRecordType;
			}
		}
	}
	
}