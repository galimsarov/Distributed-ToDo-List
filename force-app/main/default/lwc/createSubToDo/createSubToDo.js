import { api, LightningElement } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import NAME_FIELD from '@salesforce/schema/Sub_ToDo__c.Name';
import IS_DONE_FIELD from '@salesforce/schema/Sub_ToDo__c.Is_Done__c';
import TODO_ID_FIELD from '@salesforce/schema/Sub_ToDo__c.ToDo__c';
import SUB_TODO_OBJECT from '@salesforce/schema/Sub_ToDo__c';
import { createRecord } from 'lightning/uiRecordApi';
import { reduceErrors } from 'c/ldsUtils';

export default class CreateSubToDo extends LightningElement {
    @api todoid

    subToDoId;
    name = '';
    
    handleNameChange(event) {
        this.subToDoId = undefined;
        this.name = event.target.value;
    }

    createSubTodo() {
        if (this.name === '') {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error creating record',
                    message: 'Please, enter name for Sub-ToDo',
                    variant: 'error'
                })
            );
        } else {
            const fields = {};
            fields[NAME_FIELD.fieldApiName] = this.name;
            fields[IS_DONE_FIELD.fieldApiName] = false;
            fields[TODO_ID_FIELD.fieldApiName] = this.todoid;
            const recordInput = { apiName: SUB_TODO_OBJECT.objectApiName, fields };
            createRecord(recordInput)
            .then((subToDo) => {
                this.subToDoId = subToDo.id;
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'Sub-ToDo created',
                        variant: 'success'
                    })
                );
            })
            .catch((error) => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error creating record',
                        message: reduceErrors(error).join(', '),
                        variant: 'error'
                    })
                )
            });
        }
    }
}