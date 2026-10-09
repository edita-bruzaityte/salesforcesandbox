/**
* IdUtils_Test test class for IdUtils Class.
*
* @author  Matteo Iacucci
* @version 1.0
* @since   2020-10-20
*/
@IsTest
public class IdUtils_Test {
    // test method
    @isTest
    public static void testIsIdOfObject() {
        Account a = (Account) TestDataFactory.createSimpleAccount('test').insertObj();
        Case c = (Case) TestDataFactory.createSimpleCase(a.Id).insertObj();

        Test.startTest();
        System.assertEquals(true, IdUtils.isIdOfObject(a.Id, 'Account'), 'Id is reffering to a different ojbectType');
        System.assertEquals(false, IdUtils.isIdOfObject(a.Id, 'Case'), 'Id is reffering to the same ojbectType');
        System.assertEquals(true, IdUtils.isIdOfObject(c.Id, 'Case'), 'Id is reffering to a different ojbectType');

        //just for test coverage
        IdUtils.IsIdOfObjectRequest notUsedIioor = new IdUtils.IsIdOfObjectRequest();

        IdUtils.IsIdOfObjectRequest iioor = new IdUtils.IsIdOfObjectRequest(a.Id, 'Account');
        List<IdUtils.IsIdOfObjectRequest> l = new List<IdUtils.IsIdOfObjectRequest>();
        l.add(iioor);
        List<boolean> results = IdUtils.isIdOfObject(l);
        for(boolean b : results){
            System.assertEquals(true, b, 'Id is reffering to a different ojbectType');
        }
        Test.stopTest(); 
    }
}