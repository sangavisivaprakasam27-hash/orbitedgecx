public class OrderTriggerHandler {

    public static void handleAfterUpdate(
        List<Order__c> newList,
        Map<Id, Order__c> oldMap
    ) {

        for (Order__c ord : newList) {

            Order__c oldOrd = oldMap.get(ord.Id);
           System.debug('--- TRIGGER EXECUTING ---');
System.debug('NEW STATUS: ' + ord.Status__c);
System.debug('OLD STATUS: ' + oldOrd.Status__c);
System.debug('User: ' + UserInfo.getUserName());
    
            if (ord.Status__c == 'Confirmed' &&
                oldOrd.Status__c != 'Confirmed') {
                    System.debug('🔥 Condition matched - Creating Shipment');

                System.enqueueJob(new ShippingAPIService(ord.Id));
            }
        }
    }
}
