global without sharing class ContactUtil {
  webService static Boolean AddContact(String AcName) {
    
    try {
      Account newAccount = new Account (name = AcName,
BillingCity ='TestCity',
BillingCountry ='TestCountry',
BillingStreet ='TestStreet',
BillingPostalCode ='t3stcd3'
);

insert newAccount;

Contact NewContact = new Contact (
FirstName = 'xyzFirst',
LastName = 'XyZLast',
//line changed - waveoc
AccountId = newAccount.Id,
Email = 'xyzmail@mail.com'
);

//line added - waveoc
insert newContact;

      return true;
    } catch (Exception e) {
      return false;
  }
  global without sharing class ContactUtil {
    webService static Boolean AddContact(String AcName) {
      
      try {
        Account newAccount = new Account (name = AcName,
  BillingCity ='TestCity',
  BillingCountry ='TestCountry',
  BillingStreet ='TestStreet',
  BillingPostalCode ='t3stcd3'
  );
  
  insert newAccount;
  
  Contact NewContact = new Contact (
  FirstName = 'xyzFirst',
  LastName = 'XyZLast',
  //line changed - waveoc
  AccountId = newAccount.Id,
  Email = 'xyzmail@mail.com'
  );
  
  //line added - waveoc
  insert newContact;
  
        return true;
      } catch (Exception e) {
        return false;
    }
  }
  
  }