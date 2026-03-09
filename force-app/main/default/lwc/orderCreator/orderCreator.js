import { LightningElement, api } from 'lwc';
import createOrder from '@salesforce/apex/OrderController.createCustomOrder';
import { NavigationMixin } from 'lightning/navigation';

export default class OrderCreator extends NavigationMixin(LightningElement) {

    @api recordId; // Opportunity Id

    handleCreate() {
        createOrder({ opportunityId: this.recordId })
        .then(orderId => {
                this[NavigationMixin.Navigate]({
                    type: 'standard__recordPage',
                    attributes: {
                        recordId: orderId,
                        objectApiName: 'Order__c',
                        actionName: 'view'
                    }
                });
            })
            .catch(error => {
                console.error(error);
            });
    }
}
