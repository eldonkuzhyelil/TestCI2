trigger AccountAddressTrigger on Account (before insert, before update) {
//1
//23
    for(Account a : Trigger.new){
        If (a.Match_Billing_Address__c == true) {
            a.ShippingPostalCode = a.BillingPostalCode;
        }   
    }

}