import { LightningElement, api } from 'lwc';
import ID_FIELD from '@salesforce/schema/Sub_ToDo__c.Id';
import IS_DONE_FIELD from '@salesforce/schema/Sub_ToDo__c.Is_Done__c';
import { updateRecord } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { reduceErrors } from 'c/ldsUtils';

export default class SubToDoItem extends LightningElement {
    @api subtodoid
    @api subtodoname
    @api subtodoisdone
    @api editable

    get isDone() {
        return this.subtodoisdone;
    }

    get isEditable() {
        return this.editable;
    }

    handleIsDoneChange(event) {
        const fields = {};
        fields[ID_FIELD.fieldApiName] = this.subtodoid;
        if (event.target.checked) {
            console.log('Checked');

            fields[IS_DONE_FIELD.fieldApiName] = true;
        } else {
            console.log('Unchecked');

            fields[IS_DONE_FIELD.fieldApiName] = false;
        }

        const recordInput = { fields };
        updateRecord(recordInput)
            .then(() => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'Sub-ToDo status updated',
                        variant: 'success'
                    })
                );
            })
            .catch((error) => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error updating record',
                        message: reduceErrors(error).join(', '),
                        variant: 'error'
                    })
                )
            });

    }
}