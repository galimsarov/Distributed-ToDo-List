import { LightningElement, wire} from 'lwc';
import getToDoList from '@salesforce/apex/ToDoController.getAllToDos';
import { refreshApex } from '@salesforce/apex';

export default class ToDoList extends LightningElement {
    toDos;
    error;

    /** Wired Apex result so it can be refreshed programmatically */
    wiredToDosResult;

    @wire(getToDoList)
    wiredToDos(result) {
        this.wiredToDosResult = result;
        if (result.data) {
            this.toDos = result.data;
            this.error = undefined;
        } else if (result.error) {
            this.error = result.error;
            this.toDos = undefined;
        }
    }

    handleRefreshToDoList() {
        refreshApex(this.wiredToDosResult);
    }

    handleUpdateToDoList() {
        window.location.reload();
    }
}