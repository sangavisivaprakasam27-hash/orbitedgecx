public with sharing class OrderController {

    @AuraEnabled
    public static Id createCustomOrder(Id opportunityId) {

        // 🔹 Get Opportunity Name
        Opportunity opp = [
            SELECT Id, Name
            FROM Opportunity
            WHERE Id = :opportunityId
            LIMIT 1
        ];

        // 🔹 Create Order with Opportunity Name included
        Order__c o = new Order__c(
            Opportunity__c = opportunityId,
            Status__c = 'Draft',
            Name = 'Order - ' + opp.Name + ' - ' + DateTime.now().format()
        );

        insert o;
        return o.Id;
    }
}
