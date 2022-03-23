import { LightningElement, api, wire } from 'lwc';
import getSubToDos from '@salesforce/apex/SubToDoController.getAllSubToDos';
// importing to get the object info 
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import TODO_OBJECT from '@salesforce/schema/ToDo__c';

export default class ToDoItem extends LightningElement {
    @api todoname
    @api todostatus
    @api todoid
    @api recordtypeid
    
    subToDos;
    
    isToday = false;
    isLater = false;
    isTomorrow = false;
    editable = false;

    connectedCallback() {
        getSubToDos({toDoId : this.todoid})
        .then(result => {
            this.subToDos = result;
        })
    }

    get isInProgress() {
        return this.todostatus === 'In Progress';
    }

    get isReadyToTake () {
        return this.todostatus === 'Ready to Take';
    }

    get isDone () {
        return this.todostatus === 'Done';
    }

    // object info using wire service
    @wire(getObjectInfo, { objectApiName: TODO_OBJECT })
    toDoObjectInfo({data, error}) {
        if (data) {
            // map of record type Info
            const rtInfos = data.recordTypeInfos;
           
            // getting map values
            let rtValues = Object.values(rtInfos);
           
            for (let i = 0; i < rtValues.length; i++) {
                if (rtValues[i].name !== 'Master') {
                    if ((rtValues[i].name === 'Today') && (rtValues[i].recordTypeId === this.recordtypeid)) {
                        this.isToday = true;
                        break;
                    }
                    if ((rtValues[i].name === 'Later') && (rtValues[i].recordTypeId === this.recordtypeid)) {
                        this.isLater = true;
                        break;
                    }
                    if ((rtValues[i].name === 'Tomorrow') && (rtValues[i].recordTypeId === this.recordtypeid)) {
                        this.isTomorrow = true;
                        break;
                    }
                }
            }
        } else if (error) {
            window.console.log('Error ===> '+JSON.stringify(error));
        }
    }
}