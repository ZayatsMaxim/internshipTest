trigger BookTrigger on Book__c(before insert, before update) {
    // Call the helper method to set the availability based on the value of the Available__c field
    BookTriggerHelper.setAvailability(Trigger.new);
}
