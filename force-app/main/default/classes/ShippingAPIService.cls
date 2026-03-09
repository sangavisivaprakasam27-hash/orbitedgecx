public class ShippingAPIService implements Queueable, Database.AllowsCallouts {

    private Id orderId;

    public ShippingAPIService(Id ordId) {
        this.orderId = ordId;
    }

    public void execute(QueueableContext context) {

        // Correct object name here
        Order__c ord = [
            SELECT Id, Name
            FROM Order__c
            WHERE Id = :orderId
        ];

        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:ShippingApi/createShipment');
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/json');

        String body = JSON.serialize(new Map<String, String>{
            'orderId' => ord.Id,
            'orderName' => ord.Name
        });

        req.setBody(body);

        Http http = new Http();
        HttpResponse res = http.send(req);

        if(res.getStatusCode() == 200) {

            Map<String, Object> responseMap =
                (Map<String, Object>) JSON.deserializeUntyped(res.getBody());

            String trackingId = (String) responseMap.get('trackingId');

            Shipment__c shipment = new Shipment__c(
                Name = 'Shipment for ' + ord.Name,
                Custom_Order__c = ord.Id,   // this is the lookup FIELD
                Tracking_Id__c = trackingId,
                Status__c = 'Created'
            );

            insert shipment;
            System.debug('Shipment Inserted: ' + shipment.Id);

        }
    }
}
