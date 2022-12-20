import {LightningElement} from 'lwc';
import getEditResponse from '@salesforce/apex/OpenAiConnector.getEditResponse';

export default class EditsPage extends LightningElement {

    isProcessing = false;
    isProcessed = false;
    get isError() {
        return this.error !== undefined
    }
    error;
    request;
    newPrompt;
    lastPrompt;
    updatePrompt(event) {
        this.newPrompt = event.detail.value;
    }
    newInstructions;
    lastInstructions;
    updateInstructions(event) {
        this.newInstructions = event.detail.value;
    }
    result;
    get sendButtonDisabled() {
        return this.isProcessing;
    }
    handleSend() {
        this.isProcessed = false;
        this.isProcessing = true;
        this.error = undefined;

        getEditResponse({
            instructions: this.newInstructions,
            prompt: this.newPrompt
        })
            .then(results => {
                this.result = results;
                this.lastPrompt = this.newPrompt;
                this.newPrompt = undefined;
                this.lastInstructions = this.newInstructions;
                this.newInstructions = undefined;
                this.isProcessed = true;
            })
            .catch(error => {
                this.request = {
                    prompt: this.newPrompt,
                    instructions: this.newInstructions,
                    method: "edits"
                };
                this.error = error;
                this.isProcessed = false;
            }).finally(() => {
            this.isProcessing = false;
        });
    }
}