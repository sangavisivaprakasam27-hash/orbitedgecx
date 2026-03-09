import { LightningElement, api, wire, track } from 'lwc';
import getProductItems from '@salesforce/apex/OrderLineController.getProductItems';
import saveOrderLines from '@salesforce/apex/OrderLineController.saveOrderLines';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class OrderLineManager extends LightningElement {
    @api recordId;   // ✅ use recordId, not orderId
    @track productOptions = [];
    selectedProductId;
    quantity = 1;

    @wire(getProductItems)
    wiredProducts({ data, error }) {
        if (data) {
          this.productOptions = data.map(p => ({
    label: `${p.Name} - ${new Intl.NumberFormat('en-US', {
        style: 'currency',
        currency: 'USD'
    }).format(p.Price__c)}`,
    value: p.Id
}));
;
        } else if (error) {
            console.error(error);
        }
    }

    handleProductChange(event) {
        this.selectedProductId = event.detail.value;
    }

    handleQuantityChange(event) {
        this.quantity = event.target.value;
    }

    handleAddLine() {
        saveOrderLines({
            orderId: this.recordId,   // ✅ pass recordId here
            productId: this.selectedProductId,
            quantity: this.quantity
        })
            .then(() => {
                this.dispatchEvent(new ShowToastEvent({
                    title: 'Success',
                    message: 'Order line added successfully',
                    variant: 'success'
                }));
                this.dispatchEvent(new CustomEvent('lineadded'));
            })
            .catch(error => {
                this.dispatchEvent(new ShowToastEvent({
                    title: 'Error',
                    message: error.body ? error.body.message : JSON.stringify(error),
                    variant: 'error'
                }));
            });
    }
}