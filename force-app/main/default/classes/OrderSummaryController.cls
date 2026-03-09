public with sharing class OrderSummaryController {

    @AuraEnabled(cacheable=true)
    public static Order__c getOrderSummary(Id orderId) {

        return [
            SELECT Total_Amount__c,
                   Final_Amount__c
            FROM Order__c
            WHERE Id = :orderId
            LIMIT 1
        ];
    }
}
