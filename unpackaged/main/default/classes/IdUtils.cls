/**
* IdUtils implements method for Id class utilities
*
* @author  Matteo Iacucci
* @version 1.0
* @since   2020-10-20
*/
public with sharing class IdUtils {
	/**
	 * This method is used to validate an ID against an entity type.
	 * @param salesforceId salesforceID to be validate
	 * @param objectType  entity object type
	 * @return true if object related to @salesforceId is equal to @objectType
	*/
	public static boolean isIdOfObject(Id salesforceId, String objectType){
		return String.valueOf(salesforceId.getSobjectType()) == objectType;
	}

	public static boolean isIdOfObject(isIdOfObjectRequest request){
		return isIdOfObject(request.salesforceId, request.objectType);
	}

	/**
	 * This method is the invocable method for the isIdOfObject.
	 * @param requests list of ids objectType to check
	 * @return list with boolean values returning from the validation method.
	*/
	@InvocableMethod(label='isIdOfObject')
	public static List<boolean> isIdOfObject(List<IsIdOfObjectRequest> requests) {
		List<boolean> results = new List<boolean>();
		for (IsIdOfObjectRequest request : requests) {
			results.add(isIdOfObject(request));
		}
		return results;
	}

	/**
	 * Inner class to allow the method to be invocated by a flow
	 * with more than 1 parameter
	 */
	public class IsIdOfObjectRequest{
		@InvocableVariable(required=true)
		public Id salesforceId;
	
		@InvocableVariable(required=true)
		public String objectType; 

		public isIdOfObjectRequest(Id salesforceId, String objectType){
			this.salesforceId = salesforceId;
			this.objectType = objectType;
		}
		public isIdOfObjectRequest(){
			//mandatory for the flow execution
		}

	}
}