trigger AccountAddressTrigger on Account (before insert, before update) {
//1wd34adhssChange123ssssdfds
    for(Account a : Trigger.new){
        If (a.Match_Billing_Address__c == true) {
            a.ShippingPostalCode = a.BillingPostalCode;
        }   
    }

}