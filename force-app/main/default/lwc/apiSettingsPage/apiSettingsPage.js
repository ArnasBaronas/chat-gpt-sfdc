import {LightningElement} from 'lwc';
import updateApiKey from '@salesforce/apex/OpenAiAuthManger.updateApiKey';
import {ShowToastEvent} from "lightning/platformShowToastEvent";
import {reduceErrors} from 'c/ldsUtils';
import grantAccess from "@salesforce/apex/PackageUtility.grantAccess"
import userId from "@salesforce/user/Id"

const UPDATE_BUTTON_STATES = {
    ready: {
        disabled: false,
        variant: "brand",
        icon: "utility:key",
        label: "Update Key"
    },
    done: {
        disabled: true,
        variant: "neutral",
        icon: "utility:check",
        label: "Updated"
    }
};

export default class ApiSettingsPage extends LightningElement {

    updateButtonState = UPDATE_BUTTON_STATES.ready;
    newKey;
    grantAccessButtonDisabled = false;
    grantAccess() {
        this.grantAccessButtonDisabled = true;
        grantAccess({
            userId : userId
        }).then(() => {
            this.dispatchEvent(new ShowToastEvent({
                title: "Success",
                variant: "success"
            }));
        })
            .catch(error => {
                this.dispatchEvent(new ShowToastEvent({
                    title: "Error",
                    message: "An unknown error has occurred",
                    variant: "error"
                }));
            })
            .finally(() => {
                this.grantAccessButtonDisabled = false;
            })
    }

    updateKey(event) {
        this.newKey = event.detail.value;
    }

    handleUpdate() {
        this.updateButtonState.disabled = true;
        updateApiKey({apiKey: this.newKey})
            .then(() => {
                this.updateButtonState = UPDATE_BUTTON_STATES.done;
                this.newKey = undefined;
                this.dispatchEvent(new ShowToastEvent({
                    title: "Success",
                    message: "API key was successfully updated",
                    variant: "success"
                }));
            })
            .catch(error => {
                this.dispatchEvent(new ShowToastEvent({
                    title: "Error",
                    message: reduceErrors(error).join(', '),
                    variant: "error"
                }));
            })
            .finally(() => {
                    setTimeout(() => {
                        this.updateButtonState = UPDATE_BUTTON_STATES.ready;
                    }, 2000)
                }
            )
    }
}