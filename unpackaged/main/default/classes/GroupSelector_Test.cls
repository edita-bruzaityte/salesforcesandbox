/**
 * The GroupSelector_Test to test GroupSelector class methods
 *
 * @author  Matteo Iacucci
 * @version 1.0
 * @since   2021-01-14
 */
@IsTest
public class GroupSelector_Test {
 
	//test method for getCustomersByPhone
	@IsTest
	public static void testGetQueueByDeveloperName(){
		String queueName = 'TESTQUEUE';
		Group g = (Group) TestDataFactory.createQueue(queueName).insertObj();

		GroupSelector groupSelector = new GroupSelector();
		Test.startTest();
		Group retrivedQueue = groupSelector.getQueueByDeveloperName(queueName);
		Test.stopTest();
		System.assertEquals(retrivedQueue.DeveloperName, queueName, 'Retrieved wrong Queue');
 
	}

	@IsTest
	public static void testGetQueueByDeveloperNameException(){
		String queueName = 'TESTQUEUE';
		Group g = (Group) TestDataFactory.createQueue(queueName).insertObj();
		Boolean except = false;
		try{
			GroupSelector groupSelector = new GroupSelector();
			Test.startTest();
			Group retrivedQueue = groupSelector.getQueueByDeveloperName(queueName+'no');
			Test.stopTest();
		}catch(Exception e){
			except = true;
		} 
		System.assert(except, 'no exception retrieved');
	}
}