import { LightningElement, wire } from 'lwc';
import getToDo from '@salesforce/apex/ToDoController.getToDoByName';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import TODO_OBJECT from '@salesforce/schema/ToDo__c';

export default class EditToDo extends LightningElement {
    toDo;
    toDoId;
    name;
    formVisible = false;
    statusValue = 'Ready to Take';
    selectedRecordTypeValue;
    recordTypeOptions = [];

    findToDo() {
        getToDo({name : this.name})
        .then(result => {
            this.formVisible = true;
            this.toDo = result;
            this.toDoId = result.Id 
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
}