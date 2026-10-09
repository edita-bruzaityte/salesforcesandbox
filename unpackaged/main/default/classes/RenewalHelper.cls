public with sharing class RenewalHelper {

	private rflib_Logger logger;
	private RenewalService service;
	private RestRequest request;
	private RestResponse response;


	public RenewalHelper(RestRequest request, RestResponse response) {
		this.logger = rflib_LoggerUtil.getFactory().createLogger('RenewalHelper');
		this.service = new RenewalService();
		this.request = request;
		this.response = response;

	}

	public void processRenewal(){
		this.logger.trace('processRenewal(): request {0}, response {1}', new List<Object> { request.requestBody.toString(), response });

		response.addHeader('Content-Type', 'application/json');

		try {
			//deserialize the body to istance of class renewalDto
			RenewalDTO renewalDto = (RenewalDTO) JSON.deserialize(request.requestBody.toString(), RenewalDTO.class);

			//check if the client is already a customer or a prospect in case return the contact
			Contact contact = service.getContact(renewalDto.profileId);
			if(contact == null){
				this.response.statusCode = 400;
				Map<String, String> responseBody = new Map<String, String>();
				responseBody.put('error', 'profile di not associalted with no contact');
				this.response.responseBody = Blob.valueOf(JSON.serializePretty(responseBody));
				logger.warn('processQuoteToBuy() : 400 returned, profile di not associalted with no contact: ' + renewalDto.profileId );
				return;
			}

			logger.debug('contact ' + contact);
			//checking the saleStage and select the right handler
			if(renewalDto.saleStage == Constants.FIRSTTRIGGER_RENEWALSTAGE){
				handleRenewalQuickQuoteAndQuote(renewalDto, contact);
			}else if(renewalDto.saleStage == Constants.SECONDTRIGGER_RENEWALSTAGE){
				handleRenewalQuickQuoteAndQuote(renewalDto, contact);
			}else if(renewalDto.saleStage == Constants.THIRDTRIGGER_RENEWALSTAGE){
				handleRenewalSaleComplete(renewalDto, contact);
			}else if(renewalDto.saleStage == Constants.REFERRED_STAGE){
				handleRenewalQuickQuoteAndQuote(renewalDto, contact);
			}else{
				//Wrong stage
				this.response.statusCode = 400;
				Map<String, String> responseBody = new Map<String, String>();
				responseBody.put('error', 'Sale stage not correct');
				this.response.responseBody = Blob.valueOf(JSON.serializePretty(responseBody));
				logger.warn('processQuoteToBuy() : 400 returned, Sale stage not correct: ' + renewalDto.saleStage );
			}

		}catch(Exception e){
			//handling of the exception
			logger.error('processRenewal() : 500 returned, Exception: ' + e.getMessage(), e);

			Map<String, String> responseBody = new Map<String, String>();
			responseBody.put('error', e.getMessage());
			this.response.statusCode = 500;
			this.response.responseBody = Blob.valueOf(JSON.serializePretty(responseBody));

		}
	}

	public void handleRenewalQuickQuoteAndQuote(RenewalDTO renewalDto, Contact contact){
		//set the savepoint
		System.Savepoint sp = Database.setSavePoint();
		Map<String, String> responseBody = new Map<String, String>();
		try{
			//update the account
			Account a = service.createAccount(renewalDto, contact.AccountId);
			Database.upsert(a, true);

			//update the retrieved contact
			service.updateContact(renewalDto, contact);
			Database.upsert(contact, true);
			InsurancePolicy policy = new InsurancePolicy(
				Instanda_Policy_Number__c = renewalDto.instandaPolicyNumber
			);
			Opportunity o = service.createOpportunity(renewalDto, contact.Id, contact.AccountId);
			o.Renewals__r = policy;
			Database.upsert(o, Opportunity.Quote_Number__c, true);

			//set response
			this.response.statusCode = 200;
			responseBody.put('costumerId', contact.Id);
			responseBody.put('accountId', contact.AccountId );
			responseBody.put('opportunityId', o.Id);
			responseBody.put('quoteNumber', renewalDto.quoteNumber);
			responseBody.put('profileId', renewalDto.profileId);
		}catch(Exception e){
			this.logger.error('Exception handleQuickQuoteAndQuoteCustomer()', e);
			this.response.statusCode = 500;
			responseBody.put('error', e.getMessage());
			Database.rollback(sp);
		}
		//set the resposne body
		this.response.responseBody = Blob.valueOf(JSON.serializePretty(responseBody));
		
	}

	private void handleRenewalSaleComplete(RenewalDTO renewalDto, Contact contact){
		//set the savepoint
		System.Savepoint sp = Database.setSavePoint();
		Map<String, String> responseBody = new Map<String, String>();
		try{
			//try to retrieve the customoer property
			CustomerProperty existingCP = this.service.getCustomerProperty(renewalDto.registrationNumber);

			Opportunity o = service.createOpportunity(renewalDto, contact.Id, contact.AccountId);

			InsurancePolicy policy = service.createInsurance(renewalDto, contact.Id, contact.AccountId);
			policy.Call_Back_Arrangement__c = (o.Call_Back_Arrangement__c  != null) ? o.Call_Back_Arrangement__c : null;
			policy.Call_Back_Phone__c = (!String.isBlank(o.Call_Back_Phone__c) ) ? o.Call_Back_Phone__c : null;
			Database.upsert(policy, InsurancePolicy.Instanda_Policy_Number__c, true);

			o.Renewals__c = policy.Id;
			Database.upsert(o, Opportunity.Quote_Number__c, true);
			
			CustomerProperty cp = service.createCustomerProperty(renewalDto, contact.AccountId, o.Id);
			cp.Id = existingCP?.Id;
			Database.upsert(cp, true);

			service.handleAssetCreation(policy, existingCP);

			this.response.statusCode = 200;
			responseBody.put('costumerId', contact.Id);
			responseBody.put('accountId', contact.AccountId);
			responseBody.put('policyId', policy.Id);
			responseBody.put('quoteNumber', renewalDto.quoteNumber);
			responseBody.put('profileId', renewalDto.profileId);
			responseBody.put('customerProperty', cp.Id);
			responseBody.put('opportunityId', o.Id);
		}catch(Exception e){
			this.logger.error('Exception handleSaleCompleteCustomer()', e);
			this.response.statusCode = 500;
			responseBody.put('error', e.getMessage());
			Database.rollback(sp);
		}
		//set the resposne body
		this.response.responseBody = Blob.valueOf(JSON.serializePretty(responseBody));
		
	}

}