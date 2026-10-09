public interface IInsurancePoliciesSelector {

    AggregateResult[] getInsurancePoliciesGroupedByAccountId(Set<Id> parentAccountIds);

}