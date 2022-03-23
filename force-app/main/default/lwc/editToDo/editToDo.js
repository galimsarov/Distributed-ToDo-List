import { LightningElement, wire } from 'lwc';
import getToDo from '@salesforce/apex/ToDoController.getToDoByName';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import TODO_OBJECT from '@salesforce/schema/ToDo__c';
import ID_FIELD from '@salesforce/schema/ToDo__c.Id';
import NAME_FIELD from '@salesforce/schema/ToDo__c.Name';
import STATUS_FIELD from '@salesforce/schema/ToDo__c.Status__c';
import RECORD_TYPE_ID_VALUE from '@salesforce/schema/ToDo__c.RecordTypeId';
import { updateRecord } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { reduceErrors } from 'c/ldsUtils';
import getSubToDos from '@salesforce/apex/SubToDoController.getAllSubToDos';

export default class EditToDo extends LightningElement {
    toDo;
    toDoId;
    name;
    statusValue = 'Ready to Take';
    selectedRecordTypeValue;
    subToDos;
    
    formVisible = false;
    recordTypeOptions = [];
    editable = true;

    findToDo() {
        getToDo({name : this.name})
        .then(result => {
            this.formVisible = true;
            this.toDo = result;
            this.toDoId = result.Id;
            getSubToDos({toDoId : this.toDoId})
            .then(result => {
                this.subToDos = result;
            })
        })
    }
    
    get statusOptions() {
        return [
            { label: 'Ready to Take', value: 'Ready to Take' },
            { label: 'In Progress', value: 'In Progress' },
            { label: 'Done', value: 'Done' },
        ];
    }

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
        
    handleNameChange(event) {
        this.name = event.target.value;
    }

    handleStatusChange(event) {
        this.statusValue = event.target.value;
    }

    handleRecordTypeChange(event) {
        this.selectedRecordTypeValue = event.detail.value;
    }

    updateTodo() {
        const fields = {};
        fields[ID_FIELD.fieldApiName] = this.toDoId;
        fields[NAME_FIELD.fieldApiName] = this.name;
        fields[STATUS_FIELD.fieldApiName] = this.statusValue;
        fields[RECORD_TYPE_ID_VALUE.fieldApiName] = this.selectedRecordTypeValue;
        const recordInput = { fields };
        updateRecord(recordInput)
            .then(() => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'ToDo updated',
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