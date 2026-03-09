import { LightningElement, api, wire } from 'lwc';
import getOrderSummary from '@salesforce/apex/OrderSummaryController.getOrderSummary';

export default class OrderSummary extends LightningElement {

    @api recordId;

    total;
    finalAmount;

    @wire(getOrderSummary, { orderId: '$recordId' })
    wiredSummary({ data, error }) {

        console.log('DATA:', data);
        console.log('ERROR:', error);
        console.log('recordId:', this.recordId);

        if (data) {
            this.total = data.Total_Amount__c;
            this.finalAmount = data.Final_Amount__c;
        } 
        else if (error) {
            console.error('Error:', error);
        }
    }
}
