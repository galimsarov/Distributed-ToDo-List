import { LightningElement, api } from 'lwc';

export default class ToDoItem extends LightningElement {
    @api todoname
    @api todostatus

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