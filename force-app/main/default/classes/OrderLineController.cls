public with sharing class OrderLineController {

    @AuraEnabled(cacheable=true)
    public static List<Product_Item__c> getProductItems() {
        return [
            SELECT Id, Name, Price__c, Active__c, Stock__c
            FROM Product_Item__c
            WHERE Active__c = true AND Stock__c > 0
        ];
    }

    @AuraEnabled
    public static Boolean saveOrderLines(Id orderId, Id productId, Integer quantity) {
        try {
            System.debug('OrderId: ' + orderId);
            System.debug('ProductId: ' + productId);
            System.debug('Quantity: ' + quantity);

            if (orderId == null) {
                throw new AuraHandledException('Order Id cannot be null.');
            }
            if (productId == null) {
                throw new AuraHandledException('Product Id cannot be null.');
            }
            if (quantity == null || quantity <= 0) {
                throw new AuraHandledException('Quantity must be greater than zero.');
            }

            Product_Item__c product = [
                SELECT Id, Name, Price__c, Stock__c
                FROM Product_Item__c
                WHERE Id = :productId
                LIMIT 1
            ];

            if (product.Stock__c != null && product.Stock__c < quantity) {
                throw new AuraHandledException(
                    'Insufficient stock. Available: ' + product.Stock__c
                );
            }

            Order_Line__c line = new Order_Line__c(
                Name = product.Name + ' - Qty ' + quantity,
                Custom_Order__c = orderId,
                Product_Item__c = product.Id,
                Quantity__c = quantity,
                Line_Total__c = product.Price__c * quantity
            );
            insert line;

            

            return true;
        } catch (Exception e) {
            throw new AuraHandledException('Failed to save order line: ' + e.getMessage());
        }
    }
}