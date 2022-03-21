import { LightningElement, api} from 'lwc';
import getSubToDos from '@salesforce/apex/SubToDoController.getAllSubToDos';

export default class ToDoItem extends LightningElement {
    @api todoname
    @api todostatus
    @api todoid

    subToDos;

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
}