public with sharing class CaseTriggerFutureMethods {
	

	
	//manage the parsing and linking of the manual claim created via email to case
	@Future
	public static void handleManualClaim(Set<Id> caseIds){
		rflib_Logger logger = rflib_LoggerUtil.getFactory().createLogger('CaseTriggerFutureMethods');
		CaseService caseService = new CaseService();
		List<Case> cases = new CaseSelector().getCaseByIds(caseIds);
		List<Claim> claims = new List<Claim>();
		Map<String, Claim> policyNumberToClaimNumber = new Map<String, Claim>();
		Map<String, Case> claimNumberToCase = new Map<String, Case>();
		List<InsurancePolicy> policies;
		String claimNumber;
		String policyNumber;
		Claim claim1;
		InsurancePolicy ip;
		for(Case c : cases){
			claimNumber = caseService.getClaimReference(c);
			policyNumber = caseService.getPolicyNumber2(c);

			ip = new InsurancePolicy( Instanda_Policy_Number__c = policyNumber);
			claim1 = new Claim(
				Name = claimNumber,
				Instanda_Claim_Number__c = claimNumber,
				PolicyNumber = ip
			);
			claims.add(claim1);

			policyNumberToClaimNumber.put(policyNumber, claim1);
			claimNumberToCase.put(claimNumber, c);
		}
		
		

		policies = new InsurancePolicySelector().getInsurancePolicyByPolicyNumbers(new List<String>(policyNumberToClaimNumber.keySet()));
		for(InsurancePolicy policy : policies){
			claim1 = policyNumberToClaimNumber.get(policy.Instanda_Policy_Number__c);
			claim1.AccountId = policy.NameInsuredId;
		}

		Database.upsert(claims, Claim.Instanda_Claim_Number__c, false);

		Case c;
		for(Claim claim2 : claims){
			c = claimNumberToCase.get(claim2.Instanda_Claim_Number__c);
			if(c != null){
				caseService.linkClaimToManualClaimCase(c, claim2);
			}
		}
		if(Schema.Case.SObjectType.getDescribe().isUpdateable()){
			update cases;
		}
	}

	//manage the parsing and linking of the manual claim created via email to case
    @Future
	public static void handleCorrespondences(Set<Id> caseIds){
		List<Case> newQuote = new List<Case>();
		List<Case> correspondencesCases = new List<Case>();
		for(Case c : new CaseSelector().getCaseByIds(caseIds) ){
			if(c.Subject?.contains(Constants.CORRESPONDENCE_NEWQUOTE) || c.Subject?.contains(Constants.CORRESPONDENCE_FINALIZE)){
				newQuote.add(c);
			}else{
				correspondencesCases.add(c);
			}

		}
		if(newQuote.size() > 0){
			handleNewQuote(newQuote);
		}
		if(correspondencesCases.size() > 0){
			handleCorrespondences(correspondencesCases);
		}
		

	}

	private static void handleCorrespondences(List<Case> cases){
		rflib_Logger logger = rflib_LoggerUtil.getFactory().createLogger('CaseTriggerFutureMethods');
		CaseService caseService = new CaseService();
		String policyNumber;
		Map<String, Case> policyNumbersToCase = new Map<String, Case>();
		for(Case c : cases){
			policyNumber = caseService.getPolicyNumber(c);
			if(policyNumber != null){
				policyNumbersToCase.put(policyNumber, c);
			}else{
				logger.warn('No policy number for email correspondence\n' + JSON.serializePretty(c));
			}
		}
		List<InsurancePolicy> policies = caseService.getPolicies(policyNumbersToCase.keySet());
		Case c;
		for(InsurancePolicy policy : policies){
			c = policyNumbersToCase.get(policy.Instanda_Policy_Number__c);
			if(c != null){
				caseService.linkCaseToPolicy(c, policy);
			}
		}
		if(Schema.Case.SObjectType.getDescribe().isUpdateable()){
			update cases;
		}
		
	}

	private static void handleNewQuote(List<Case> cases){
		rflib_Logger logger = rflib_LoggerUtil.getFactory().createLogger('CaseTriggerFutureMethods');
		CaseService caseService = new CaseService();
		String quoteNumber;
		Map<String, Case> quoteNumbersToCase = new Map<String, Case>();
		for(Case c : cases){
			quoteNumber = caseService.getQuoteNumber(c);
			if(quoteNumber != null){
				quoteNumbersToCase.put(quoteNumber, c);
			}else{
				logger.warn('No quote number for email correspondence\n' + JSON.serializePretty(c));
			}
		}
		List<Opportunity> opportunities = caseService.getOpportunities(quoteNumbersToCase.keySet());
		List<Lead> leads = caseService.getLeads(quoteNumbersToCase.keySet());

		handleNewQuoteOpportunity(quoteNumbersToCase, opportunities);
		handleNewQuoteLead(quoteNumbersToCase, leads);

		if(Schema.Case.SObjectType.getDescribe().isUpdateable()){
			update cases;
		}
	}

	private static void handleNewQuoteOpportunity(Map<String, Case> quoteNumbersToCase, List<Opportunity> opportunities){
		CaseService caseService = new CaseService();
		Case c;
		for(Opportunity opportunity : opportunities){
			c = quoteNumbersToCase.get(Opportunity.Quote_Number__c);
			if(c != null){
				caseService.linkCaseToAccountFromOpportunity(c, opportunity);
			}
		}
	}

	private static void handleNewQuoteLead(Map<String, Case> quoteNumbersToCase, List<Lead> leads){
		CaseService caseService = new CaseService();
		Case c;
		for(Lead lead : leads){
			c = quoteNumbersToCase.get(lead.Quote_Number__c);
			if(c != null){
				caseService.linkCaseToAccountFromLead(c, lead);
			}
		}
	}
	
}