/**
* CaseService 
*
* @author  Matteo Iacucci
* @version 1.0
* @since   2021-4-14
*/
public with sharing class CaseService {
	private Id manualClaimCaseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Manual_Claim').getRecordTypeId();
	private Id instandaCorrespondenceCaseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Instanda_Correspondence').getRecordTypeId();

	private rflib_Logger logger;
	private ClaimSelector claimSelector;
	private InsurancePolicySelector policySelector;
	private LeadSelector leadSelector;
	private OpportunitySelector opportunitySelector;

	public CaseService(){
		logger = rflib_LoggerUtil.getFactory().createLogger('CaseService');
		claimSelector = new ClaimSelector();
		policySelector = new InsurancePolicySelector();
		leadSelector = new LeadSelector();
		opportunitySelector = new OpportunitySelector();
	}


	//check if the creation or the edit wasn't made from the integration user and then sync the record
	public void handleSync(List<Case> cases, String event){
		List<Case> syncCases = new List<Case>();
		for(Case c : cases){
			if(c.RecordTypeId != manualClaimCaseRecordTypeId && c.recordTypeId != instandaCorrespondenceCaseRecordTypeId){
				syncCases.add(c);
			}
		}
		if(syncCases.size() > 0){
			CaseSyncQueueable caseSyncQueueable = new CaseSyncQueueable(syncCases, event);
			System.enqueueJob(caseSyncQueueable);
		}
		
	}

	public Boolean checkCaseForMilestoneProcessResolutionTime(Case newCase, Case oldCase){
		DateTime completionDate = System.now();
		List<String> caseClosedStatuses = new List<String>{'Closed - Upheld', 'Closed - Not Upheld', 'Closed'};
		return newCase.Status != oldCase.Status && caseClosedStatuses.contains(newCase.Status) && 
					newCase.SlaStartDate <= completionDate  && newCase.SlaExitDate == null;
	}

	public Boolean checkCaseForMilestoneProcessClaimReview(Case newCase, Case oldCase){
		DateTime completionDate = System.now();
		List<String> caseClosedStatuses = new List<String>{'Send for Authorization', 'Closed - Claim Rejected', 'Closed'};
		return newCase.Status != oldCase.Status && caseClosedStatuses.contains(newCase.Status) && newCase.SlaStartDate <= completionDate  && newCase.SlaExitDate == null;
	}

	public Boolean checkCaseForMilestoneProcessPaidWithin24Hours(Case newCase, Case oldCase){
		DateTime completionDate = System.now();
		List<String> caseClosedStatuses = new List<String>{'Closed - Claim Paid', 'Closed - Claim Rejected', 'Closed'};
		return newCase.Status != oldCase.Status && caseClosedStatuses.contains(newCase.Status) && newCase.SlaStartDate <= completionDate  && newCase.SlaExitDate == null;
	}

	/**
	 * get Policy Number:
	 */
	public String getPolicyNumber(Case c){
		return c.Description.substringBetween('Policy Number: ', '\n');
	}

	/**
	 * get Policy number:
	 */
	public String getPolicyNumber2(Case c){
		return c.Description.substringBetween('Policy number: ', '\n');
	}

	public String getClaimReference(Case c){
		return c.Description.substringBetween('Claim reference: ', '\n');
	}

	public String getQuoteNumber(Case c){
		return c.Description.substringBetween('Quote Reference: ', '\n');
	}

	public List<Claim> getClaims(Set<String> claimNumbers){
		return claimSelector.getClaimByInstandaClaimNumbers(new List<String>(claimNumbers));
	}

	public List<InsurancePolicy> getPolicies(Set<String> policyNumbers){
		return policySelector.getInsurancePolicyByPolicyNumbers(new List<String>(PolicyNumbers));
	}

	public List<Opportunity> getOpportunities(Set<String> quoteNumbers){
		return opportunitySelector.getOpportunitiesByQuoteNumbers(quoteNumbers);
	}

	public List<Lead> getLeads(Set<String> quoteNumbers){
		return leadSelector.getLeadsByQuoteNumbers(new List<String>(quoteNumbers));
	}

	public void linkClaimToManualClaimCase(Case c, Claim claim){
		c.AccountId = claim?.AccountId;
		c.ParentId = claim?.CaseId;
		c.Claim__c = claim?.Id;
		if(String.isBlank(claim.PolicyNumberId)){
			c.Insurance_Policy__r = new InsurancePolicy(Instanda_Policy_Number__c = claim.PolicyNumber.Instanda_Policy_Number__c);
		}else{
			c.Insurance_Policy__c = claim.PolicyNumberId;
		}
	}
	//link the case to account and policy
	public void linkCaseToPolicy(Case c, InsurancePolicy policy){
		c.AccountId = policy?.NameInsuredId;
		c.Insurance_Policy__c = policy?.Id;
	}

	//link the case to account 
	public void linkCaseToAccountFromOpportunity(Case c, Opportunity opportunity){
		c.AccountId = opportunity?.AccountId;
		c.ContactId = opportunity?.ContactId;
	}

	//link the case to account 
	public void linkCaseToAccountFromLead(Case c, Lead lead){
		c.Lead__c = lead?.Id;
	}
}