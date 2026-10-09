/**
 * RenewalService 
 *
 * @author  Matteo Iacucci
 * @version 1.0
 * @since   2021-05-04
*/
public with sharing class RenewalService {

	private Id renewalInsurancePolicyRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Renewal_Insurance_Policy').getRecordTypeId();

	private rflib_Logger logger;
	private ContactSelector contactSelector;
	private CustomerPropertySelector customerPropertySelector;
	private InsurancePolicyAssetSelector insurancePolicyAssetSelecotor;
	
	public RenewalService() {
		this.logger = rflib_LoggerUtil.getFactory().createLogger('RenewalService');
		this.contactSelector = new ContactSelector();
		this.customerPropertySelector = new CustomerPropertySelector();
		this.insurancePolicyAssetSelecotor = new InsurancePolicyAssetSelector();
	}

	public Contact getContact(String profileId){
		return contactSelector.getContactByProfileId(profileId);
	}

	public CustomerProperty getCustomerProperty(String registrationNumber){
		return customerPropertySelector.getCustomerPropertyByRegistrationNumber(registrationNumber);
	}

	public InsurancePolicyAsset getActiveInsurancePolicyAsset(Id policyId){
		return insurancePolicyAssetSelecotor.getActiveInsurancePolicyAssetByPolicyId(policyId);
	}

	public InsurancePolicyAsset getInsurancePolicyAsset(Id policyId, Id customerPropertyId){
		return insurancePolicyAssetSelecotor.getInsurancePolicyAssetByPolicyIdAndCustomerPropertyId(policyId, customerPropertyId);
	}

	public InsurancePolicyAsset getActiveInsurancePolicyAsset(Id policyId, Id customerPropertyId){
		return insurancePolicyAssetSelecotor.getActiveInsurancePolicyAssetByPolicyIdAndCustomerPropertyId(policyId, customerPropertyId);
	}

	public void handleAssetCreation(InsurancePolicy policy, CustomerProperty cp){
		//get asset related to policy and customer prop
		InsurancePolicyAsset ipa = getInsurancePolicyAsset(policy.Id, cp?.Id);
		if(ipa == null){
			//if no asset is related to policy and customer //
			//deactivate the old one and create a new one
			deactiveteOldPolicyAsset(policy.Id);
			InsurancePolicyAsset pa = createPolicyAsset(policy.Id, cp.Id);
			Database.insert(pa);
		}else if(!ipa.Is_Active__c){
			//if not active deacvitate the old and activate the current
			deactiveteOldPolicyAsset(policy.Id);
			ipa.Is_Active__c = true;
			Database.update(ipa);
		}
	}

	public void deactiveteOldPolicyAsset(Id policyId){
		InsurancePolicyAsset ipa = getActiveInsurancePolicyAsset(policyId);
		ipa.Is_Active__c = false;
		Database.update(ipa);
	}

	public void updateContact(RenewalDTO renewalDto, Contact contact){

		contact.FirstName = renewalDto.firstName;
		contact.LastName = renewalDto.lastName;
		contact.Profile_First_Name__c = renewalDto.profileFirstName;
		contact.Profile_Last_Name__c = renewalDto.profileLastName;

		contact.Street_1__c = renewalDto.street1;
		contact.Street_2__c = renewalDto.street2;
		contact.City__c = renewalDto.city;
		contact.Postcode__c = renewalDto.postCode;
		contact.Country__c = renewalDto.country;

		contact.Date_of_Birth__c = renewalDto.dateOfBirth;
		contact.Profile_Date_of_Birth__c = renewalDto.profileDateOfBirth;
		contact.Phone = renewalDto.phone;
		contact.Profile_Phone__c = renewalDto.profilePhone;
		contact.Email = renewalDto.email;
		contact.Profile_Email__c = renewalDto.profileEmail;
		contact.Trade__c = renewalDto.trade;
		contact.Email_Opt_In__c = (renewalDto.emailOptIn == 'Confirmed') ? true : false;
		contact.HasOptedOutOfEmail = (renewalDto.emailOptIn == 'Confirmed') ? false : true;
		contact.Terms_Conditions__c = (renewalDto.termsAndConditions == 'Confirmed' ) ? true : false;

		contact.Bankruptcy__c = (renewalDto.bankruptcy == 'Yes') ? true : false;
		contact.Refused_Insurance__c = (renewalDto.refusedInsurance == 'Yes') ? true : false;
		contact.Convictions__c = (renewalDto.convictions == 'Yes') ? true : false;
		contact.History__c = (renewalDto.history == 'Yes') ? true : false;
		
		contact.UTM_Source__c = renewalDto.utmSource;
		contact.UTM_Medium__c = renewalDto.utmMedium;
		contact.UTM_Campaign__c = renewalDto.utmCampaign;
		contact.UTM_Id__c = renewalDto.utmId;
		contact.UTM_Agent__c = renewalDto.utmAgent;
	}

	public Account createAccount(RenewalDTO renewalDto, Id accountId){
		Account a = new Account(
			Id = accountId,

			Street_1__c = renewalDto.street1,
			Street_2__c = renewalDto.street2,
			City__c = renewalDto.city,
			Postcode__c = renewalDto.postCode,
			Country__c = renewalDto.country,
			Company_Type__c = renewalDto.companyType
		);

		if(!String.isBlank(renewalDto.company)){
			a.Name = renewalDto.company;
		}
		return a;
		
	}


	public Opportunity createOpportunity(RenewalDTO renewalDto, Id contactId, Id accountId){
		String opptyStage = ( renewalDto.saleStage == Constants.FIRSTTRIGGER_RENEWALSTAGE) ? Constants.PARTIALQUOTE_STATUS : ( renewalDto.saleStage == Constants.SECONDTRIGGER_RENEWALSTAGE) ? Constants.FULLQUOTE_STATUS : Constants.SALECOMPLETE_STATUS ;
		String paymentMethod = (renewalDto.saleStage == Constants.FIRSTTRIGGER_RENEWALSTAGE) ? renewalDto.paymentMethod :(renewalDto.paymentMethodAnnual == 0) ? 'perMonth' :  ( (renewalDto.paymentMethodMonthly == 0) ? 'perYear' : renewalDto.paymentMethod ) ;

		Opportunity op = new Opportunity();

		op.Quote_Number__c = renewalDto.quoteNumber;
		op.RecordTypeId = renewalInsurancePolicyRecordTypeId;
		
		op.ContactId = contactId;
		op.AccountId = accountId;
		op.Name = renewalDto.quoteNumber;
		op.CloseDate = Date.today();
		
		op.Payment_Method__c = paymentMethod;
		op.Package_Type__c = renewalDto.packageType;
		op.Cover_Level__c = renewalDto.coverLevel;
		op.ABI_Trade_Code__c = renewalDto.abiTradeCode;
		op.Acceptable_Trade__c = renewalDto.acceptableTrade;
		op.Occupation_Adjustment_Factor__c = renewalDto.occupationAdjustmentFactor;
		op.Referral__c = (renewalDto.referral == null ) ? false : renewalDto.referral;
		op.Referral_Reason__c = renewalDto.referralReason;
		op.Referral_Authorization__c = renewalDto.referralAuthorization;
		op.UTM_Source__c = renewalDto.utmSource;
		op.UTM_Medium__c = renewalDto.utmMedium;
		op.UTM_Campaign__c = renewalDto.utmCampaign;
		op.UTM_Id__c = renewalDto.utmId;
		op.UTM_Agent__c = renewalDto.utmAgent;
		op.Is_Renewal__c = (renewalDto.isRenewal == null ) ? false : renewalDto.isRenewal;
		op.Renewal_Date__c = renewalDto.renewalDate?.date();
		op.Renewal_Invitation_Date__c = renewalDto.renewalInvitation?.date();	
		op.Renewal_Type__c = renewalDto.renewalType;
		op.Renewal_Decline_Date__c = renewalDto.renewalDecline?.date();
		
		op.Registration_Number__c = renewalDto.registrationNumber;
		op.Colour__c = renewalDto.colour;
		op.Manufacturer__c = renewalDto.manufacturer;
		op.Model__c = renewalDto.model;
		op.Year__c = (renewalDto.year != null) ? Integer.valueOf(renewalDto.year): null;
		op.Vehicle_ABI_Identifier__c = renewalDto.vehicleAbiIdentifier;
		
		op.Net_Premium__c = renewalDto.netPremium;
		op.Insurance_Premium_Tax__c = renewalDto.insurancePremiumTax;
		op.Insurance_Premium_Tax_Percentage__c = renewalDto.insurancePremiumTaxPercentage;
		op.Premium_Amount__c = renewalDto.premiumAmount;
		op.Monthly_Payments__c = renewalDto.monthlyPayments;

		op.Effective_Date__c = renewalDto.effectiveDate;
		op.Expiration_Date__c  = renewalDto.expirationDate;
		op.Sale_Date__c = renewalDto.saleDate;
		op.Quote_Date__c = renewalDto.quoteDate;
		op.Auto_Renewal__c = (renewalDto.autoRenewal == 'Yes' ) ? true : false;
		op.Paperless__c = (renewalDto.paperless == 'Yes' ) ? true : false;

		op.LeadSource = Constants.INSTANDAOPPTYLEADSOURCE;

		if(renewalDto.saleStage == Constants.REFERRED_STAGE){
			op.Call_Back_Arrangement__c = assignCallBackArrangement(renewalDto);
			op.Call_Back_Phone__c = renewalDto.callBackPhone;
		}else{
			op.StageName = opptyStage;
		}
		
		
		return op;
	}

	public InsurancePolicy createInsurance(RenewalDTO renewalDto, Id contactId, Id accountId){
		String paymentMethod =  (renewalDto.paymentMethodAnnual == 0) ? 'perMonth' : (renewalDto.paymentMethodMonthly == 0) ? 'perYear' : renewalDto.paymentMethod;

		InsurancePolicy ip = new InsurancePolicy();
		ip.Instanda_Policy_Number__c = renewalDto.instandaPolicyNumber;
		ip.NameInsuredId = accountId;
		ip.Name = renewalDto.instandaPolicyNumber;
		ip.PolicyName = renewalDto.instandaPolicyNumber;
		ip.Payment_Method__c = paymentMethod;

		ip.ABI_Trade_Code__c = renewalDto.abiTradeCode;
		ip.Acceptable_Trade__c = renewalDto.acceptableTrade;
		ip.Occupation_Adjustment_Factor__c = renewalDto.occupationAdjustmentFactor;
		ip.Referral__c = (renewalDto.referral == null ) ? false : renewalDto.referral;
		ip.Referral_Authorization__c = renewalDto.referralAuthorization;
		ip.Package_Type__c = renewalDto.packageType;
		ip.Cover_Level__c = renewalDto.coverLevel;
		ip.Referral_Reason__c = renewalDto.referralReason;
		ip.Payment_Method__c = paymentMethod;
		ip.Net_Premium__c = renewalDto.netPremium;
		ip.Insurance_Premium_Tax__c = renewalDto.insurancePremiumTax;
		ip.Insurance_Premium_Tax_Percentage__c = renewalDto.insurancePremiumTaxPercentage;
		ip.PremiumAmount = renewalDto.premiumAmount;
		ip.Monthly_Payments__c = renewalDto.monthlyPayments;
		ip.Quote_Number__c = renewalDto.quoteNumber;

		ip.Is_Renewal__c = (renewalDto.isRenewal == null ) ? false : renewalDto.isRenewal;
		ip.RenewalDate = renewalDto.renewalDate?.date();
		ip.Renewal_Invitation_Date__c = renewalDto.renewalInvitation?.date();	
		ip.Renewal_Type__c = renewalDto.renewalType;
		ip.Renewal_Decline_Date__c = renewalDto.renewalDecline?.date();

		ip.OriginalEffectiveDate = renewalDto.effectiveDate;
		ip.OriginalExpirationDate = renewalDto.expirationDate;
		ip.SaleDate = renewalDto.saleDate;
		ip.Quote_Date__c = renewalDto.quoteDate;
		ip.Auto_Renewal__c = (renewalDto.autoRenewal == 'Yes' ) ? true : false;
		ip.Paperless__c = (renewalDto.paperless == 'Yes' ) ? true : false;
		return ip;
	}


	public CustomerProperty createCustomerProperty(RenewalDTO renewalDto, Id accountId, Id opportunityId){
		CustomerProperty cp  = new CustomerProperty();
		cp.RegistrationNumber = renewalDto.registrationNumber;
		cp.ModelName = renewalDto.model;
		cp.Colour__c = renewalDto.colour;
		cp.Make = renewalDto.manufacturer;
		cp.MakeYear = (renewalDto.year != null) ? Integer.valueOf(renewalDto.year): null;
		cp.Vehicle_ABI_Identifier__c = renewalDto.vehicleAbiIdentifier;

		cp.PrimaryOwnerId = accountId;
		cp.Opportunity__c = opportunityId;
		return cp;
	}

	public InsurancePolicyAsset createPolicyAsset(Id policyId, Id customerPropertyId){
		return new InsurancePolicyAsset(
			InsurancePolicyId = policyId,
			CustomerPropertyId = customerPropertyId,
			Is_Active__c = true
		);
	}

	public Datetime assignCallBackArrangement(RenewalDTO renewalDto) {
		Datetime callBackArrangement = System.now().date(); 
		String dateTimeField;

		switch on renewalDto.requiredCall {
			when '1. Today' {
				dateTimeField = callBackArrangement.format('yyyy-MM-dd'); 
				dateTimeField += ' ' + getHour(renewalDto.requiredCallToday);
			} when '2. Tomorrow' {
				callBackArrangement += 1;
				dateTimeField = callBackArrangement.format('yyyy-MM-dd'); 
				dateTimeField += ' ' + getHour(renewalDto.requiredCallTomorrow);
			} when '3. Day After' {
				callBackArrangement += 2;
				dateTimeField = callBackArrangement.format('yyyy-MM-dd'); 
				dateTimeField += ' ' + getHour(renewalDto.requiredCallDayAfter);
			} when else {
				this.logger.warn('required call value not handled: ' + renewalDto.requiredCall);
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