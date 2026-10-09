public with sharing class QuoteToBuyHelper {

	private rflib_Logger logger;
	private QuoteToBuyService service;
	private RestRequest request;
	private RestResponse response;

	public QuoteToBuyHelper(RestRequest request, RestResponse response) {
		this.logger = rflib_LoggerUtil.getFactory().createLogger('QuoteToBuyHelper');
		this.service = new QuoteToBuyService();
		this.request = request;
		this.response = response;
	}

	public void processQuoteToBuy(){
		logger.trace('processQuoteToBuy(): request {0}, response {1}', new List<Object> { request.requestBody.toString(), response });
		
		// set default response attrbutes
		response.addHeader('Content-Type', 'application/json');

		try {
			//deserialize the body to istance of class QuoteToBuyDTO
			QuoteToBuyDTO quoteToBuyDto = (QuoteToBuyDTO) JSON.deserialize(request.requestBody.toString(), QuoteToBuyDTO.class);
			//check if the client is already a customer or a prospect in case return the contact
			Contact contact = service.isAlreadyContact(quoteToBuyDto.profileId);
			Boolean isAlreadyContact = contact != null;
			logger.debug('isAlreadyContact '+ isAlreadyContact);
			logger.debug('contact ' + contact);
			//checking the saleStage and select the right handler
			if(quoteToBuyDto.saleStage == Constants.FIRSTTRIGGER_STAGE){
				handleQuickQuoteAndQuote(quoteToBuyDto, isAlreadyContact, contact);
			}else if(quoteToBuyDto.saleStage == Constants.SECONDTRIGGER_STAGE){
				handleQuickQuoteAndQuote(quoteToBuyDto, isAlreadyContact, contact);
			}else if(quoteToBuyDto.saleStage == Constants.THIRDTRIGGER_STAGE){
				handleSaleComplete(quoteToBuyDto, isAlreadyContact, contact);
			}else if(quoteToBuyDto.saleStage == Constants.REFERRED_STAGE){
				handleQuickQuoteAndQuote(quoteToBuyDto, isAlreadyContact, contact);
			}else{
				//Wrong stage
				this.response.statusCode = 400;
				Map<String, String> responseBody = new Map<String, String>();
				responseBody.put('error', 'Sale stage not correct');
				this.response.responseBody = Blob.valueOf(JSON.serializePretty(responseBody));
				logger.warn('processQuoteToBuy() : 400 returned, Sale stage not correct: ' + quoteToBuyDto.saleStage );
			}
						
		}catch(Exception e){
			//handling of the exception
			logger.error('processQuoteToBuy() : 500 returned, Exception: ' + e.getMessage(), e);

			Map<String, String> responseBody = new Map<String, String>();
			responseBody.put('error', e.getMessage());
			this.response.statusCode = 500;
			this.response.responseBody = Blob.valueOf(JSON.serializePretty(responseBody));

		}
	}

	//handle the first and second trigger Quick Quote and quote
	private void handleQuickQuoteAndQuote(QuoteToBuyDTO quoteToBuyDto, Boolean isAlreadyContact, Contact contact){
		if(isAlreadyContact){
			//for customer
			handleQuickQuoteAndQuoteCustomer(quoteToBuyDto, contact.Id, contact.AccountId);
		}else{
			//for prospect
			handleQuickQuoteAndQuoteProspect(quoteToBuyDto);
		}
	}

	//handle the third trigger  Sale completed
	private void handleSaleComplete(QuoteToBuyDTO quoteToBuyDto, Boolean isAlreadyContact, Contact c){
		if(isAlreadyContact){
			//for customer
			handleSaleCompleteCustomer(quoteToBuyDto, c?.Id, c?.AccountId);
		}else{
			//for prospect
			handleSaleCompleteProspect(quoteToBuyDto);
		}

	}

	private void handleQuickQuoteAndQuoteProspect(QuoteToBuyDTO quoteToBuyDto){
		//set the savepoint
		System.Savepoint sp = Database.setSavePoint();
		//upsert the lead
		Lead l = service.createLead(quoteToBuyDto);
		l.OwnerId = new GroupSelector().getQueueByDeveloperName('Semi_Qualified_Leads').Id;
		//commit the upsert to the database
		Database.UpsertResult leadUpserResult = Database.upsert(l, Lead.Profile_Id__c, true);
		//check the result and create the response
		Map<String, String> responseBody = new Map<String, String>();
		if(leadUpserResult.isSuccess()){
			//set response
			this.response.statusCode = 200;
			responseBody.put('prosectId', l.Id);
			responseBody.put('profileId', l.Profile_Id__c);
		}else{
			//set response
			this.response.statusCode = 400;
			responseBody.put('error', JSON.serialize(leadUpserResult.getErrors()));
			this.logger.error('handleQuickQuoteAndQuoteProspect(). error developername: {0}', leadUpserResult.getErrors());
			Database.rollback(sp);
		}	
		//set the resposne body
		this.response.responseBody = Blob.valueOf(JSON.serializePretty(responseBody));	
	}

	private void handleSaleCompleteProspect(QuoteToBuyDTO quoteToBuyDto){
		//set the savepoint
		System.Savepoint sp = Database.setSavePoint();
		Map<String, String> responseBody = new Map<String, String>();

		try{

			Account a = service.createAccount(quoteToBuyDto, null);
			a.RecordTypeId = new AccountService().getRecordTypeFromCompanyType(quoteToBuyDto.companyType);
			//if the company is not inserted it use the last name
			if(String.isBlank(a.Name) ){
				a.Name = quoteToBuyDto.lastname;
			}
			Database.insert(a, true);

			Contact c = service.createContact(quoteToBuyDto);
			c.AccountId = a.Id;
			Database.upsert(c, Contact.Profile_Id__c, true);

			Opportunity o = service.createOpportunity(quoteToBuyDto, c.Id, a.Id);
			Database.upsert(o, Opportunity.Quote_Number__c);

			InsurancePolicy policy = service.createInsurance(quoteToBuyDto, c.Id, a.Id);
			policy.SourceOpportunityId = o.Id;
			Database.upsert(policy, InsurancePolicy.Instanda_Policy_Number__c, true);

			CustomerProperty cp = service.createCustomerProperty(quoteToBuyDto, a.Id, o.Id);
			Database.insert(cp, true);

			InsurancePolicyAsset pa = service.createPolicyAsset(policy.Id, cp.Id);
			Database.insert(pa, true);
			//convert lead
			service.converLead(quoteToBuyDto.profileId, c.Id, a.Id, o.Id);

			//set the response
			this.response.statusCode = 200;
			
			responseBody.put('costumerId', c.Id);
			responseBody.put('accountId', a.Id );
			responseBody.put('policyId', policy.Id);
			responseBody.put('quoteNumber', quoteToBuyDto.quoteNumber);
			responseBody.put('policyNumber', quoteToBuyDto.instandaPolicyNumber);
			responseBody.put('profileId', quoteToBuyDto.profileId);
			responseBody.put('customerProperty', cp.Id);
			responseBody.put('opportunity', o.Id);
			
		}catch(Exception e){
			this.logger.error('Exception handleSaleCompleteProspect()', e);
			this.response.statusCode = 400;
			responseBody.put('error', e.getMessage());
			Database.rollback(sp);
		}
		//set the resposne body
		this.response.responseBody = Blob.valueOf(JSON.serializePretty(responseBody));
		
	}

	private void handleQuickQuoteAndQuoteCustomer(QuoteToBuyDTO quoteToBuyDto, Id contactId, Id accountId){
		//set the savepoint
		System.Savepoint sp = Database.setSavePoint();
		Map<String, String> responseBody = new Map<String, String>();
		try{
			Account a = service.createAccount(quoteToBuyDto, accountId);
			Database.upsert(a, true);
			Contact c = service.createContact(quoteToBuyDto);
			Database.upsert(c, Contact.Profile_Id__c, true);
			Opportunity o = service.createOpportunity(quoteToBuyDto, contactId, accountId);
			Database.upsert(o, Opportunity.Quote_Number__c, true);
			//set response
			this.response.statusCode = 200;
			responseBody.put('costumerId', contactId);
			responseBody.put('accountId', accountId );
			responseBody.put('opportunityId', o.Id);
			responseBody.put('quoteNumber', quoteToBuyDto.quoteNumber);
			responseBody.put('profileId', quoteToBuyDto.profileId);
		}catch(Exception e){
			this.logger.error('Exception handleQuickQuoteAndQuoteCustomer()', e);
			this.response.statusCode = 400;
			responseBody.put('error', e.getMessage());
			Database.rollback(sp);
		}
		//set the resposne body
		this.response.responseBody = Blob.valueOf(JSON.serializePretty(responseBody));
		
		
	}

	private void handleSaleCompleteCustomer(QuoteToBuyDTO quoteToBuyDto, Id contactId, Id accountId){
		//set the savepoint
		System.Savepoint sp = Database.setSavePoint();
		Map<String, String> responseBody = new Map<String, String>();
		try{
			Opportunity o = service.createOpportunity(quoteToBuyDto, contactId, accountId);
			Database.upsert(o, Opportunity.Quote_Number__c);

			InsurancePolicy policy = service.createInsurance(quoteToBuyDto, contactId, accountId);
			policy.SourceOpportunityId = o.Id;
			policy.Call_Back_Arrangement__c = (o.Call_Back_Arrangement__c  != null) ? o.Call_Back_Arrangement__c : null;
			policy.Call_Back_Phone__c = (!String.isBlank(o.Call_Back_Phone__c) ) ? o.Call_Back_Phone__c : null;
			Database.upsert(policy, InsurancePolicy.Instanda_Policy_Number__c);

			CustomerProperty cp = service.createCustomerProperty(quoteToBuyDto, accountId, o.Id);
			Database.insert(cp);

			InsurancePolicyAsset pa = service.createPolicyAsset(policy.Id, cp.Id);
			Database.insert(pa);

			this.response.statusCode = 200;
			responseBody.put('costumerId', contactId);
			responseBody.put('accountId', accountId );
			responseBody.put('policyId', policy.Id);
			responseBody.put('quoteNumber', quoteToBuyDto.quoteNumber);
			responseBody.put('profileId', quoteToBuyDto.profileId);
			responseBody.put('customerProperty', cp.Id);
		}catch(Exception e){
			this.logger.error('Exception handleSaleCompleteCustomer()', e);
			this.response.statusCode = 400;
			responseBody.put('error', e.getMessage());
			Database.rollback(sp);
		}
		//set the resposne body
		this.response.responseBody = Blob.valueOf(JSON.serializePretty(responseBody));
		
	}



}