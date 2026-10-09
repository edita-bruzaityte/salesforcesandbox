public with sharing class Constants {
	//lead and opportunity status and stage
	public static final String PARTIALQUOTE_STATUS = 'Partial Quote';
	public static final String FULLQUOTE_STATUS = 'Full Quote';
	public static final String SALECOMPLETE_STATUS = 'Sale Complete';

	//quote to buy stages
	public static final String FIRSTTRIGGER_STAGE = 'QuickQuote';
	public static final String SECONDTRIGGER_STAGE = 'Quote';
	public static final String THIRDTRIGGER_STAGE = 'SaleComplete';

	public static final String FIRSTTRIGGER_RENEWALSTAGE = 'QuickQuote';
	public static final String SECONDTRIGGER_RENEWALSTAGE = 'Quote';
	public static final String THIRDTRIGGER_RENEWALSTAGE = 'SaleComplete';


	public static final String REFERRED_STAGE = 'Referred';

	public static final String LEAD_SEMIQUALIFIED_CONVERTEDSTATUS = 'Sale Complete';

	public static final String LEAD_SEMIQUALIFIED_SOURCE = 'Instanda Self Service';
	public static final String LEAD_UNQUALIFIED_SOURCE = 'Guide Wire';

	//RequiredCall Time Slots
	public static final String REQUIREDCALL_TIMESLOTONE = '9:00 - 12:00pm';
	public static final String REQUIREDCALL_TIMEONE = '09:00:00';
	public static final String REQUIREDCALL_TIMESLOTTWO = '12:00 - 3:00pm';
	public static final String REQUIREDCALL_TIMETWO = '12:00:00';
	public static final String REQUIREDCALL_TIMESLOTTHREE = '3:00 - 6:00pm';
	public static final String REQUIREDCALL_TIMETHREE = '15:00:00';

	//Sync events
	//account
	public static final String EVENT_ACCOUNTCREATED = 'customer_account_created';
	public static final String EVENT_ACCOUNTUPDATED = 'customer_account_updated';
	public static final String EVENT_ACCOUNTDELETED = 'customer_account_deleted';
	//contact
	public static final String EVENT_CONTACTCREATED = 'customer_contact_created';
	public static final String EVENT_CONTACTUPDATED = 'customer_contact_updated';
	public static final String EVENT_CONTACTDELETED = 'customer_contact_deleted';
	//case
	public static final String EVENT_CASECREATED = 'case_created';
	public static final String EVENT_CASEUPDATED = 'case_updated';
	public static final String EVENT_CASEDELETED = 'case_deleted';
	//claim
	public static final String EVENT_CLAIMCREATED = 'sfclaim_created';
	public static final String EVENT_CLAIMUPDATED = 'sfclaim_updated';
	public static final String EVENT_CLAIMDELETED = 'sfclaim_deleted';
	//claim
	public static final String EVENT_TASKCREATED = 'task_created';
	public static final String EVENT_TASKUPDATED = 'task_updated';
	public static final String EVENT_TASKDELETED = 'task_deleted';


	public static final String INSTANDAOPPTYLEADSOURCE = 'Instanda Self Service';

	//instanda correspondence
	public static final String CORRESPONDENCE_WELCOMECASE = 'Welcome to Toolbox by Admiral';
	public static final String CORRESPONDENCE_RESETPASSWORD = 'Customer Password reset';
	public static final String CORRESPONDENCE_MISSPAYMENT = 've missed your payment';
	public static final String CORRESPONDENCE_CANCELLATION = 'Policy cancellation';
	public static final String CORRESPONDENCE_NORENEWING = 'Till we meet again';
	public static final String CORRESPONDENCE_MTAADJUSTEDPAYMENT = 'We have adjusted your payments';
	public static final String CORRESPONDENCE_MTAGOTCHANGES = 'We have got your changes';
	public static final String CORRESPONDENCE_NEWQUOTE = 'We got your new quote ready';
	public static final String CORRESPONDENCE_FINALIZE = 'Finalise your Goods and Tools cover';


}