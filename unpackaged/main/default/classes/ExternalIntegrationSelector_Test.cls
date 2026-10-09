/**
 * The ExternalIntegrationSelector_Test to test ExternalIntegrationSelector class methods
 *
 * @author  Matteo Iacucci
 * @version 1.0
 * @since   2021-01-14
 */
@IsTest
public class ExternalIntegrationSelector_Test {
 
	//test method for getCustomersByPhone
	@IsTest
	public static void testGetAllExternalIntegrations(){
		ExternalIntegrationSelector extIntSelector = new ExternalIntegrationSelector();
        extIntSelector.getAllExternalIntegrations();
        extIntSelector.getExternalIntegrationsByDeveloperName('test');

	}
}