/**
 * @author            : edita.bruzaityte@admiralpioneer.com
 * @last modified on  : 2025-11-28
 * @last modified by  : edita.bruzaityte@admiralpioneer.com
**/

@isTest
public class PC_TestDataFactory {

    
  private SObject obj;

  public PC_TestDataFactory(SObject obj){
    this.obj = obj;
  }

  public SObject insertObj(){
    insert this.obj;
    return this.obj;
  }

  public SObject getObj(){
    return this.obj;
  }

      public static PC_TestDataFactory createAccount(String Name){
        Id AccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('General').getRecordTypeId();
            Account a = new Account(
            RecordTypeId = AccountRecordTypeId,
            Name = name
        );
     
        return new PC_TestDataFactory((SObject) a);
      }
      }