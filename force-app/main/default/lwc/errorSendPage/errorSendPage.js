import {api, LightningElement, wire} from 'lwc';
import isEmailDeliverabilityEnabled from '@salesforce/apex/PackageUtility.isEmailDeliverabilityEnabled';
import sendEmailToDeveloper from '@salesforce/apex/PackageUtility.sendEmailToDeveloper';
import {ShowToastEvent} from "lightning/platformShowToastEvent";
import {reduceErrors} from 'c/ldsUtils';

const DEVELOPER_EMAIL = "arnasbaronas@gmail.com"
const ERROR_LOG_EMAIL_SUBJECT = "Problems occurred in OpenAI Salesforce app";
const SEND_BUTTON_STATES = {
    ready: {
        disabled: false,
        variant: "neutral",
        icon: "utility:email",
        label: "Send log to developer"
    },
    done: {
        disabled: true,
        variant: "neutral",
        icon: "utility:check",
        label: "Sent"
    }
};

export default class ErrorSendPage extends LightningElement {
    @api
    error
    @api
    request
    @wire(isEmailDeliverabilityEnabled)
    emailDeliverabilityEnabled;
    errorTime = new Date();
    sendButtonState = SEND_BUTTON_STATES.ready;
    get errorMailSubject() {
        return `${ERROR_LOG_EMAIL_SUBJECT} - ${this.errorTime}`;
    }

    get errorMailBody() {
        let body = `${ERROR_LOG_EMAIL_SUBJECT}\n\nError information:\n--- ${this.errorTime} ---\n`;
        body += `Request:\n${JSON.stringify(this.request, null, 3)}\n`;
        body += `Error:\n${JSON.stringify(this.error, null, 3)}`;
        return body;
    }

    get mailToReference() {
        return `mailto:${DEVELOPER_EMAIL}?subject=${this.errorMailSubject}&body=${this.errorMailBody}`
    }

    handleSend() {
        this.sendButtonState.disabled = true;
        sendEmailToDeveloper({
            developerEmail: DEVELOPER_EMAIL,
            subject: this.errorMailSubject,
            body: this.errorMailBody
        }).then(() => {
            this.sendButtonState = SEND_BUTTON_STATES.done;
        }).catch((error => {
            this.dispatchEvent(new ShowToastEvent({
                title: "Error",
                message: reduceErrors(error).join(', '),
                variant: "error"
            }));
        })).finally(() => {
            setTimeout(() => {
                this.sendButtonState = SEND_BUTTON_STATES.ready;
            }, 2000)
        });
    }
}