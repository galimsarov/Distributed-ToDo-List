import { LightningElement, wire } from 'lwc';
import NAME_FIELD from '@salesforce/schema/ToDo__c.Name';
import STATUS_FIELD from '@salesforce/schema/ToDo__c.Status__c';
import TODO_OBJECT from '@salesforce/schema/ToDo__c';
import { createRecord } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { reduceErrors } from 'c/ldsUtils';

export default class CreateToDo extends LightningElement {
    toDoId;
    name = '';
    statusValue = 'Ready to Take';
    
    handleNameChange(event) {
        this.toDoId = undefined;
        this.name = event.target.value;
    }

    handleStatusChange(event) {
        this.toDoId = undefined;
        this.statusValue = event.target.value;
    }

    get statusOptions() {
        return [
            { label: 'Ready to Take', value: 'Ready to Take' },
            { label: 'In Progress', value: 'In Progress' },
            { label: 'Done', value: 'Done' },
        ];
    }

    createTodo() {
        const fields = {};
        fields[NAME_FIELD.fieldApiName] = this.name;
        fields[STATUS_FIELD.fieldApiName] = this.statusValue;
        const recordInput = { apiName: TODO_OBJECT.objectApiName, fields };
        createRecord(recordInput)
        .then((toDo) => {
            this.toDoId = toDo.id;
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success',
                    message: 'ToDo created',
                    variant: 'success'
                })
            );
            this.dispatchEvent(new CustomEvent('refreshtodolist'));
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