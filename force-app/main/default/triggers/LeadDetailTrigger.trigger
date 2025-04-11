trigger LeadDetailTrigger on Lead_Details__c (after update) {
     List<Account> accList = new List<Account>();
    List<Contact> conList = new List<Contact>();

    for (Lead_Details__c lead : Trigger.new) {
        Lead_Details__c oldLead = Trigger.oldMap.get(lead.Id);

        if (lead.Status__c == 'Converted' && oldLead.Status__c != 'Converted') {
            Account acc = new Account(
                Name = lead.Name
            );
            accList.add(acc);
        }
    }

    if (!accList.isEmpty()) {
        insert accList;

        for (Integer i = 0; i < accList.size(); i++) {
            Contact con = new Contact(
                FirstName = accList[i].Name,
                Email = Trigger.new[i].Email__c,
                AccountId = accList[i].Id
            );
            conList.add(con);
        }

        if (!conList.isEmpty()) {
            insert conList;
        }
    }
}