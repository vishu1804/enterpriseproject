trigger CreateAccountFromContact on Contact (before insert) {
    //Collect list of contacts being inserted without an account
    List<Contact> needAccounts = new List<Contact>();
    for (Contact c : trigger.new) {
        if (String.isBlank(c.accountid)) {
            needAccounts.add(c);
        }
    }
    
    if (needAccounts.size() > 0) {
        List<Account> newAccounts = new List<Account>();
        Map<String,Contact> contactsByNameKeys = new Map<String,Contact>();
        //Create account for each contact
        for (Contact c : needAccounts) {
            String accountName = c.firstname + ' ' + c.lastname;
            contactsByNameKeys.put(accountName,c);
            Account a = new Account(name=accountName);
            newAccounts.add(a);
        }
        insert newAccounts;
        
        //Collect a new list of deal__c objects for new accounts
        //List<Deal__c> newRecsForAccounts = new List<Deal__c>();
        for (Account a : newAccounts) {
            //Put account ids on contacts
            if (contactsByNameKeys.containsKey(a.Name)) {
                contactsByNameKeys.get(a.Name).accountId = a.Id;
            }
            //Deal__c newRec = new Deal__c(name=a.Name, accountId=a.Id);
        }
        
        //insert newRecsForAccounts;
        
    }
    

}