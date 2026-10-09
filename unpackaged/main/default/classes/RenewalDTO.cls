@SuppressWarnings('PMD')
public with sharing class RenewalDTO {
	public String saleStage;
	public String profileId;

	//first trigger
	public String firstname;
	public String lastname;
	public String profileFirstName;
	public String profileLastName;
	public String street1;
	public String street2;
	public String city;
	public String postCode;
	public String country;
	public DateTime dateOfBirth;
	public DateTime profileDateOfBirth;
	public String phone;
	public String profilePhone;
	public String email;
	public String profileEmail;
	public String paymentMethod;
	public Decimal paymentMethodAnnual;
	public Decimal paymentMethodMonthly;
	public String packageType;
	public Decimal coverLevel;
	public String trade;
	public String abiTradeCode;
	public String acceptableTrade;
	public Decimal occupationAdjustmentFactor;
	public String companyType;
	public String emailOptIn;
	public String termsAndConditions;
	public String quoteNumber;
	public Boolean isRenewal;
	public Boolean referral;
	public String referralReason;
	public String referralAuthorization;
	public String utmSource;
	public String utmMedium;
	public String utmCampaign;
	public String utmId;
	public String utmAgent;

	public DateTime renewalDate;
	public DateTime renewalInvitation;
	public String renewalType;
	public DateTime renewalDecline;

	//secondTrigger 
	public String company;
	public String bankruptcy;
	public String refusedInsurance;
	public String convictions;
	public String history;
	public String registrationNumber;
	public String colour;
	public String manufacturer;
	public String model;
	public Decimal year;
	public String vehicleAbiIdentifier;
	public String requiredCall;
	public String requiredCallToday;
	public String requiredCallTomorrow;
	public String requiredCallDayAfter;
	public string callBackPhone;
	//public DateTime callBackArrangement;
	public Decimal netPremium;
	public Decimal insurancePremiumTax;
	public Decimal insurancePremiumTaxPercentage;
	public Decimal premiumAmount;
	public Decimal monthlyPayments;

	//Third TRIGGER
	public DateTime effectiveDate;
	public DateTime expirationDate;
	public String instandaPolicyNumber;
	public DateTime saleDate;
	public DateTime quoteDate;
	public String autoRenewal;
	public String paperless;

}