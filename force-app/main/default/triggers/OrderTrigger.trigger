trigger OrderTrigger on Order__c (after update) {
    OrderTriggerHandler.handleAfterUpdate(Trigger.new, Trigger.oldMap);
}
    