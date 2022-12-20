/**
 * Created by T1950 on 2022-12-17.
 */

import {LightningElement} from 'lwc';
import getCompletionResponse from '@salesforce/apex/OpenAiConnector.getCompletionResponse';

export default class CompletionsPage extends LightningElement {

    isProcessing = false;
    isProcessed = false;
    get isError() {
        return this.error !== undefined
    }
    error;
    request;
    newQuestion;
    lastQuestion;

    updateQuestion(event) {
        this.newQuestion = event.detail.value;
    }
    answer;
    get sendButtonDisabled() {
        return this.isProcessing;
    }
    handleEnter(event) {
        if(event.keyCode === 13){
            this.handleSend();
        }
    }
    handleSend() {
        this.isProcessed = false;
        this.isProcessing = true;
        this.error = undefined;

        getCompletionResponse({ question : this.newQuestion})
            .then(results => {
                this.answer = results;
                this.lastQuestion = this.newQuestion;
                this.newQuestion = undefined;
                this.isProcessed = true;
            })
            .catch(error => {
                this.request = {
                    question: this.newQuestion,
                    method: "completions"
                };
                this.error = error;
                this.isProcessed = false;
            })
            .finally(() => {
                this.isProcessing = false;
            });
    }

}