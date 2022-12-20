import {api, LightningElement} from 'lwc';

export default class SetupNavigation extends LightningElement {

    @api
    selectedItem

    handleSelect(event) {
        this.selectedItem = event.detail.name;
        this.dispatchEvent(new CustomEvent("navigate", {
            detail: this.selectedItem
        }));
    }
}