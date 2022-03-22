import { LightningElement, wire } from 'lwc';
import NAME_FIELD from '@salesforce/schema/ToDo__c.Name';
import STATUS_FIELD from '@salesforce/schema/ToDo__c.Status__c';
import RECORD_TYPE_ID_FIELD from '@salesforce/schema/ToDo__c.RecordTypeId';
import TODO_OBJECT from '@salesforce/schema/ToDo__c';
import { createRecord } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { reduceErrors } from 'c/ldsUtils';
// importing to get the object info 
import { getObjectInfo } from 'lightning/uiObjectInfoApi';

export default class CreateToDo extends LightningElement {
    toDoId;
    name = '';
    statusValue = 'Ready to Take';
    selectedRecordTypeValue;
    recordTypeOptions = [];
    
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
    
    // object info using wire service
    @wire(getObjectInfo, { objectApiName: TODO_OBJECT })
    toDoObjectInfo({data, error}) {
        if (data) {
            let optionsValues = [];
            // map of record type Info
            const rtInfos = data.recordTypeInfos;
   
            // getting map values
            let rtValues = Object.values(rtInfos);
   
            for (let i = 0; i < rtValues.length; i++) {
                if (rtValues[i].name !== 'Master') {
                    optionsValues.push({
                        label: rtValues[i].name,
                        value: rtValues[i].recordTypeId
                    })
                }
            }
            
            this.recordTypeOptions = optionsValues;
        } else if (error) {
            window.console.log('Error ===> '+JSON.stringify(error));
        }
    }
    
    // Handling on change value
    handleRecordTypeChange(event) {
        this.selectedRecordTypeValue = event.detail.value;
    }

    createTodo() {
        if (this.name === '') {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error creating record',
                    message: 'Please, enter name for ToDo',
                    variant: 'error'
                })
            );
        } else {
            const fields = {};
            fields[NAME_FIELD.fieldApiName] = this.name;
            fields[STATUS_FIELD.fieldApiName] = this.statusValue;
            fields[RECORD_TYPE_ID_FIELD.fieldApiName] = this.selectedRecordTypeValue;
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
}