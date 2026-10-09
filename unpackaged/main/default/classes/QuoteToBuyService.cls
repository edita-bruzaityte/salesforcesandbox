/**
 * QuoteToBuyService 
 *
 * @author  Matteo Iacucci
 * @version 1.0
 * @since   2021-04-07
*/
public with sharing class QuoteToBuyService {
	
	private Id newInsurancePolicyOpportunityRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('New_Insurance_Policy').getRecordTypeId();

	private rflib_Logger logger;

	private LeadSelector leadSelector;
	private ContactSelector contactSelector;
	
	public QuoteToBuyService() {
		this.logger = rflib_LoggerUtil.getFactory().createLogger('QuoteToBuyService');
		this.leadSelector = new LeadSelector();
		this.contactSelector = new ContactSelector();
	}

	public Contact isAlreadyContact(String profileId){
		return contactSelector.getContactByProfileId(profileId);
		
	}

	public boolean converLead(String profileId, Id contactId, Id accountId, Id opportunityId){
		Lead l = LeadSelector.getLeadByProfileId(profileId);
		l.OwnerId = UserInfo.getUserId();
		Database.upsert(l, Lead.Profile_Id__c);
		Database.LeadConvert lc = new Database.LeadConvert();
		lc.setLeadId(l.Id);
		lc.setContactId(contactId);
		lc.setAccountId(accountId);
		lc.setOpportunityId(opportunityId);
		lc.setDoNotCreateOpportunity(false);
		lc.setConvertedStatus(Constants.LEAD_SEMIQUALIFIED_CONVERTEDSTATUS);

		Database.LeadConvertResult lcr = Database.convertLead(lc);
		if(lcr.isSuccess()){
			
			return true;
			
		}else{
			logger.error('error during the convertion of the lead: ' + JSON.serializePretty(lcr.getErrors()));
			return false;
		}
	}


	//QUOTE DTO Salesofrce obj MAPPING
	public Lead createLead(QuoteToBuyDTO quoteToBuyDto){
		String paymentMethod = (quoteToBuyDto.saleStage == Constants.FIRSTTRIGGER_STAGE) ? quoteToBuyDto.paymentMethod : (quoteToBuyDto.paymentMethodAnnual == 0) ? 'perMonth' :  ( (quoteToBuyDto.paymentMethodMonthly == 0) ? 'perYear' : quoteToBuyDto.paymentMethod ) ;
		
		Lead l = new Lead(
			Profile_Id__c = quoteToBuyDto.profileId,
			
			LeadSource = Constants.LEAD_SEMIQUALIFIED_SOURCE,

			//first trigger
			Firstname = quoteToBuyDto.firstName,
			Lastname = quoteToBuyDto.lastName,
			Profile_First_Name__c = quoteToBuyDto.profileFirstName,
			Profile_Last_Name__c = quoteToBuyDto.profileLastName,
			Street_1__c = quoteToBuyDto.street1,
			Street_2__c = quoteToBuyDto.street2,
			City__c = quoteToBuyDto.city,
			PostCode__c = quoteToBuyDto.postCode,
			Country__c = quoteToBuyDto.country,
			Date_of_Birth__c = quoteToBuyDto.dateOfBirth,
			Profile_Date_of_Birth__c = quoteToBuyDto.profileDateOfBirth,
			Phone = quoteToBuyDto.phone,
			Profile_Phone__c = quoteToBuyDto.profilePhone,
			Email = quoteToBuyDto.email,
			Profile_Email__c = quoteToBuyDto.profileEmail,
			Payment_Method__c = paymentMethod,
			Package_Type__c = quoteToBuyDto.packageType,
			Cover_Level__c = quoteToBuyDto.coverLevel,
			Trade__c = quoteToBuyDto.trade,
			ABI_Trade_Code__c = quoteToBuyDto.abiTradeCode,
			Acceptable_Trade__c = quoteToBuyDto.acceptableTrade,
			Occupation_Adjustment_Factor__c = quoteToBuyDto.occupationAdjustmentFactor,
			Company_Type__c = quoteToBuyDto.companyType,
			Email_Opt_In__c = (quoteToBuyDto.emailOptIn == 'Confirmed' ) ? true : false,
			HasOptedOutOfEmail = (quoteToBuyDto.emailOptIn == 'Confirmed' ) ? false : true,
			Terms_Conditions__c = (quoteToBuyDto.termsAndConditions == 'Confirmed' ) ? true : false,
			Quote_Number__c = quoteToBuyDto.quoteNumber,
			Referral__c = (quoteToBuyDto.referral == null ) ? false : quoteToBuyDto.referral,
			Referral_Reason__c = quoteToBuyDto.referralReason,
			Referral_Authorization__c = quoteToBuyDto.referralAuthorization,
			UTM_Source__c = quoteToBuyDto.utmSource,
			UTM_Medium__c = quoteToBuyDto.utmMedium,
			UTM_Campaign__c = quoteToBuyDto.utmCampaign,
			UTM_Id__c = quoteToBuyDto.utmId,
			UTM_Agent__c = quoteToBuyDto.utmAgent,

			//second trigger
			Bankruptcy__c = (quoteToBuyDto.bankruptcy == 'Yes') ? true : false,
			Refused_Insurance__c = (quoteToBuyDto.refusedInsurance == 'Yes') ? true : false,
			Convictions__c = (quoteToBuyDto.convictions == 'Yes') ? true : false,
			History__c = (quoteToBuyDto.history == 'Yes') ? true : false,
			Registration_Number__c = quoteToBuyDto.registrationNumber,
			Colour__c = quoteToBuyDto.colour,
			Manufacturer__c = quoteToBuyDto.manufacturer,
			Model__c = quoteToBuyDto.model,
			//Year__c = (quoteToBuyDto.year != null) ? Integer.valueOf(quoteToBuyDto.year): null,
			Vehicle_ABI_Identifier__c = quoteToBuyDto.vehicleAbiIdentifier,
			Net_Premium__c = quoteToBuyDto.netPremium,
			Insurance_Premium_Tax__c = quoteToBuyDto.insurancePremiumTax,
			Insurance_Premium_Tax_Percentage__c = quoteToBuyDto.insurancePremiumTaxPercentage,
			Premium_Amount__c = quoteToBuyDto.premiumAmount,
			Monthly_Payments__c = quoteToBuyDto.monthlyPayments
	
		);
		if(!String.isBlank(quoteToBuyDto.company)){
			l.Company = quoteToBuyDto.company;
		}
		if(quoteToBuyDto.saleStage == Constants.REFERRED_STAGE){
			l.Call_Back_Arrangement__c = assignCallBackArrangement(quoteToBuyDto);
			l.Call_Back_Phone__c = quoteToBuyDto.callBackPhone;
		}else{
			String leadStatus = ( quoteToBuyDto.saleStage == Constants.FIRSTTRIGGER_STAGE) ? Constants.PARTIALQUOTE_STATUS : ( quoteToBuyDto.saleStage == Constants.SECONDTRIGGER_STAGE) ? Constants.FULLQUOTE_STATUS : Constants.SALECOMPLETE_STATUS ;
			l.Status = leadStatus;
		}

		return l;
	}

	public Contact createContact(QuoteToBuyDTO quoteToBuyDto){
		return new Contact(
			Profile_Id__c = quoteToBuyDto.profileId,

			FirstName = quoteToBuyDto.firstName,
			LastName = quoteToBuyDto.lastName,
			Profile_First_Name__c = quoteToBuyDto.profileFirstName,
			Profile_Last_Name__c = quoteToBuyDto.profileLastName,
			Street_1__c = quoteToBuyDto.street1,
			Street_2__c = quoteToBuyDto.street2,
			City__c = quoteToBuyDto.city,
			Postcode__c = quoteToBuyDto.postCode,
			Country__c = quoteToBuyDto.country,
			Date_of_Birth__c = quoteToBuyDto.dateOfBirth,
			Profile_Date_of_Birth__c = quoteToBuyDto.profileDateOfBirth,
			Phone = quoteToBuyDto.phone,
			Profile_Phone__c = quoteToBuyDto.profilePhone,
			Email = quoteToBuyDto.email,
			Profile_Email__c = quoteToBuyDto.profileEmail,
			Trade__c = quoteToBuyDto.trade,
			Email_Opt_In__c = (quoteToBuyDto.emailOptIn == 'Confirmed') ? true : false,
			HasOptedOutOfEmail = (quoteToBuyDto.emailOptIn == 'Confirmed') ? false : true,
			Terms_Conditions__c = (quoteToBuyDto.termsAndConditions == 'Confirmed' ) ? true : false,
			Bankruptcy__c = (quoteToBuyDto.bankruptcy == 'Yes') ? true : false,
			Refused_Insurance__c = (quoteToBuyDto.refusedInsurance == 'Yes') ? true : false,
			Convictions__c = (quoteToBuyDto.convictions == 'Yes') ? true : false,
			History__c = (quoteToBuyDto.history == 'Yes') ? true : false,
			UTM_Source__c = quoteToBuyDto.utmSource,
			UTM_Medium__c = quoteToBuyDto.utmMedium,
			UTM_Campaign__c = quoteToBuyDto.utmCampaign,
			UTM_Id__c = quoteToBuyDto.utmId,
			UTM_Agent__c = quoteToBuyDto.utmAgent
		);
	}

	public Account createAccount(QuoteToBuyDTO quoteToBuyDto, Id accountId){
		Account a = new Account(
			Id = accountId,

			Street_1__c = quoteToBuyDto.street1,
			Street_2__c = quoteToBuyDto.street2,
			City__c = quoteToBuyDto.city,
			Postcode__c = quoteToBuyDto.postCode,
			Country__c = quoteToBuyDto.country,
			Company_Type__c = quoteToBuyDto.companyType
			
		);
		if(!String.isBlank(quoteToBuyDto.company)){
			a.Name = quoteToBuyDto.company;
		}
		return a;
		
	}

	public Opportunity createOpportunity(QuoteToBuyDTO quoteToBuyDto, Id contactId, Id accountId){
		String opptyStage = ( quoteToBuyDto.saleStage == Constants.FIRSTTRIGGER_STAGE) ? Constants.PARTIALQUOTE_STATUS : ( quoteToBuyDto.saleStage == Constants.SECONDTRIGGER_STAGE) ? Constants.FULLQUOTE_STATUS : Constants.SALECOMPLETE_STATUS ;
		String paymentMethod = (quoteToBuyDto.saleStage == Constants.FIRSTTRIGGER_STAGE) ? quoteToBuyDto.paymentMethod :(quoteToBuyDto.paymentMethodAnnual == 0) ? 'perMonth' :  ( (quoteToBuyDto.paymentMethodMonthly == 0) ? 'perYear' : quoteToBuyDto.paymentMethod ) ;

		Opportunity op = new Opportunity();
		op.RecordTypeId = newInsurancePolicyOpportunityRecordTypeId;
		op.ContactId = contactId;
		op.AccountId = accountId;
		op.Name = quoteToBuyDto.quoteNumber;
		op.CloseDate = Date.today();
		
		op.Payment_Method__c = paymentMethod;
		op.Package_Type__c = quoteToBuyDto.packageType;
		op.Cover_Level__c = quoteToBuyDto.coverLevel;
		op.ABI_Trade_Code__c = quoteToBuyDto.abiTradeCode;
		op.Acceptable_Trade__c = quoteToBuyDto.acceptableTrade;
		op.Occupation_Adjustment_Factor__c = quoteToBuyDto.occupationAdjustmentFactor;
		op.Quote_Number__c = quoteToBuyDto.quoteNumber;
		op.Referral__c = (quoteToBuyDto.referral == null ) ? false : quoteToBuyDto.referral;
		op.Is_Renewal__c = (quoteToBuyDto.isRenewal == null ) ? false : quoteToBuyDto.isRenewal;
		op.Referral_Reason__c = quoteToBuyDto.referralReason;
		op.Referral_Authorization__c = quoteToBuyDto.referralAuthorization;
		op.UTM_Source__c = quoteToBuyDto.utmSource;
		op.UTM_Medium__c = quoteToBuyDto.utmMedium;
		op.UTM_Campaign__c = quoteToBuyDto.utmCampaign;
		op.UTM_Id__c = quoteToBuyDto.utmId;
		op.UTM_Agent__c = quoteToBuyDto.utmAgent;
		op.Registration_Number__c = quoteToBuyDto.registrationNumber;
		op.Colour__c = quoteToBuyDto.colour;
		op.Manufacturer__c = quoteToBuyDto.manufacturer;
		op.Model__c = quoteToBuyDto.model;
		op.Year__c = (quoteToBuyDto.year != null) ? Integer.valueOf(quoteToBuyDto.year): null;
		op.Vehicle_ABI_Identifier__c = quoteToBuyDto.vehicleAbiIdentifier;
		
		op.Net_Premium__c = quoteToBuyDto.netPremium;
		op.Insurance_Premium_Tax__c = quoteToBuyDto.insurancePremiumTax;
		op.Insurance_Premium_Tax_Percentage__c = quoteToBuyDto.insurancePremiumTaxPercentage;
		op.Premium_Amount__c = quoteToBuyDto.premiumAmount;
		op.Monthly_Payments__c = quoteToBuyDto.monthlyPayments;

		op.Effective_Date__c = quoteToBuyDto.originalEffectiveDate;
		op.Expiration_Date__c  = quoteToBuyDto.originalExpirationDate;
		op.Sale_Date__c = quoteToBuyDto.saleDate;
		op.Quote_Date__c = quoteToBuyDto.quoteDate;
		op.Auto_Renewal__c = (quoteToBuyDto.autoRenewal == 'Yes' ) ? true : false;
		op.Paperless__c = (quoteToBuyDto.paperless == 'Yes' ) ? true : false;

		op.LeadSource = Constants.INSTANDAOPPTYLEADSOURCE;
	

		if(quoteToBuyDto.saleStage == Constants.REFERRED_STAGE){
			op.Call_Back_Arrangement__c = assignCallBackArrangement(quoteToBuyDto);
			op.Call_Back_Phone__c = quoteToBuyDto.callBackPhone;
		}else{
			op.StageName = opptyStage;
		}
		
		return op;
	}

	public InsurancePolicy createInsurance(QuoteToBuyDTO quoteToBuyDto, Id contactId, Id accountId){
		String paymentMethod =  (quoteToBuyDto.paymentMethodAnnual == 0) ? 'perMonth' : (quoteToBuyDto.paymentMethodMonthly == 0) ? 'perYear' : quoteToBuyDto.paymentMethod;

		InsurancePolicy ip = new InsurancePolicy();
		ip.NameInsuredId = accountId;
		ip.Name = quoteToBuyDto.instandaPolicyNumber;
		ip.PolicyName = quoteToBuyDto.instandaPolicyNumber;
		ip.Payment_Method__c = paymentMethod;
		ip.Package_Type__c = quoteToBuyDto.packageType;
		ip.Cover_Level__c = quoteToBuyDto.coverLevel;
		ip.ABI_Trade_Code__c = quoteToBuyDto.abiTradeCode;
		ip.Acceptable_Trade__c = quoteToBuyDto.acceptableTrade;
		ip.Occupation_Adjustment_Factor__c = quoteToBuyDto.occupationAdjustmentFactor;
		ip.Quote_Number__c = quoteToBuyDto.quoteNumber;
		ip.Referral__c = (quoteToBuyDto.referral == null ) ? false : quoteToBuyDto.referral;
		ip.Referral_Reason__c = quoteToBuyDto.referralReason;
		ip.Referral_Authorization__c = quoteToBuyDto.referralAuthorization;
		ip.Call_Back_Arrangement__c = assignCallBackArrangement(quoteToBuyDto) ;
		ip.Call_Back_Phone__c = quoteToBuyDto.callBackPhone;
		ip.Net_Premium__c = quoteToBuyDto.netPremium;
		ip.Insurance_Premium_Tax__c = quoteToBuyDto.insurancePremiumTax;
		ip.Insurance_Premium_Tax_Percentage__c = quoteToBuyDto.insurancePremiumTaxPercentage;
		ip.PremiumAmount = quoteToBuyDto.premiumAmount;
		ip.Monthly_Payments__c = quoteToBuyDto.monthlyPayments;
		ip.OriginalEffectiveDate = quoteToBuyDto.originalEffectiveDate;
		ip.OriginalExpirationDate = quoteToBuyDto.originalExpirationDate;
		ip.Instanda_Policy_Number__c = quoteToBuyDto.instandaPolicyNumber;
		ip.SaleDate = quoteToBuyDto.saleDate;
		ip.Quote_Date__c = quoteToBuyDto.quoteDate;
		ip.Auto_Renewal__c = (quoteToBuyDto.autoRenewal == 'Yes' ) ? true : false;
		ip.Paperless__c = (quoteToBuyDto.paperless == 'Yes' ) ? true : false;
		return ip;
	}


	public CustomerProperty createCustomerProperty(QuoteToBuyDTO quoteToBuyDto, Id accountId, Id opportunityId){
		CustomerProperty cp  = new CustomerProperty();
		cp.RegistrationNumber = quoteToBuyDto.registrationNumber;
		cp.ModelName = quoteToBuyDto.model;
		cp.Colour__c = quoteToBuyDto.colour;
		cp.Make = quoteToBuyDto.manufacturer;
		cp.MakeYear = (quoteToBuyDto.year != null) ? Integer.valueOf(quoteToBuyDto.year): null;
		cp.Vehicle_ABI_Identifier__c = quoteToBuyDto.vehicleAbiIdentifier;
		cp.PrimaryOwnerId = accountId;
		cp.Opportunity__c = opportunityId;
		return cp;
	}

	public InsurancePolicyAsset createPolicyAsset(Id policyId, Id customerPorpertyId){
		return new InsurancePolicyAsset(
			InsurancePolicyId = policyId,
			CustomerPropertyId = customerPorpertyId,
			Is_Active__c = true
		);
	}

	public Datetime assignCallBackArrangement(QuoteToBuyDTO quoteToBuyDto) {
		Datetime callBackArrangement = System.now().date(); 
		String dateTimeField;

		switch on quoteToBuyDto.requiredCall {
			when '1. Today' {
				dateTimeField = callBackArrangement.format('yyyy-MM-dd'); 
				dateTimeField += ' ' + getHour(quoteToBuyDto.requiredCallToday);
			} when '2. Tomorrow' {
				callBackArrangement += 1;
				dateTimeField = callBackArrangement.format('yyyy-MM-dd'); 
				dateTimeField += ' ' + getHour(quoteToBuyDto.requiredCallTomorrow);
			} when '3. Day After' {
				callBackArrangement += 2;
				dateTimeField = callBackArrangement.format('yyyy-MM-dd'); 
				dateTimeField += ' ' + getHour(quoteToBuyDto.requiredCallDayAfter);
			} when else {
				this.logger.warn('required call value not handled: ' + quoteToBuyDto.requiredCall);
				return null;
			}
		}

		return Datetime.valueOf(dateTimeField);

	}

	private String getHour(String requiredCallTime){
		if(requiredCallTime == Constants.REQUIREDCALL_TIMESLOTONE){
			return Constants.REQUIREDCALL_TIMEONE;
		}else if(requiredCallTime == Constants.REQUIREDCALL_TIMESLOTTWO){
			return Constants.REQUIREDCALL_TIMETWO;
		}else if(requiredCallTime == Constants.REQUIREDCALL_TIMESLOTTHREE){
			return Constants.REQUIREDCALL_TIMETHREE;
		}
		this.logger.warn('required call TIME SLOT value not handled: ' + requiredCallTime);
		return '12:00:00';
	}
	
}