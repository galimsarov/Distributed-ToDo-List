import { LightningElement, api } from 'lwc';

export default class SubToDoItem extends LightningElement {
    @api subtodoname
    @api subtodoisdone

    get isDone() {
        return this.subtodoisdone;
    }
}