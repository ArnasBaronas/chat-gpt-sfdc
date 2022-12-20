import {LightningElement} from 'lwc';
import {ShowToastEvent} from "lightning/platformShowToastEvent";
import checkConnection from "@salesforce/apex/OpenAiAuthManger.checkConnection";
/* For pre-deployment version
import grantAccess from "@salesforce/apex/PackageUtility.grantAccess"
import userId from "@salesforce/user/Id" */

const HEADERS = {
    completions: {
        title: "Completions",
        description: "Creates a completion for the provided prompt and parameters.",
        icon: "standard:prompt"
    },
    edits: {
        title: "Edits",
        description: "Given a prompt and an instruction, the model will return an edited version of the prompt.",
        icon: "custom:custom83"
    },
    images: {
        title: "Images",
        description: "Given a prompt and/or an input image, the model will generate a new image.",
        icon: "custom:custom38"
    },
    apiConfig: {
        title: "API settings",
        description: "API settings for accessing new AI models developed by OpenAI.",
        icon: "standard:apex_plugin"
    },
    botConfig: {
        title: "Bot settings",
        description: "Bot settings allow to configure requests to AI models developed by OpenAI.",
        icon: "standard:bot"
    },
};

export default class SetupPage extends LightningElement {

    /* For pre-deployment version
    grantAccessButtonDisabled = false;
    grantAccess() {
        this.disabled = true;
        grantAccess({
            userId: userId
        }).then(() => {
            this.dispatchEvent(new ShowToastEvent({
                title: "Success",
                message: "You can now upgrade the package",
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
    }*/

    selectedPage;
    completions = true;
    edits = false;
    images = false;

    apiConfig = false;

    botConfig = false;

    headerTitle;
    headerIcon;
    headerDescription;

    renderHeader = false;

    connectedCallback() {
        checkConnection()
            .then(() => {
                this.selectedPage = "completions";
            })
            .catch(error => {
                this.selectedPage = "apiConfig";
                this.dispatchEvent(new ShowToastEvent({
                    title: "API connection validation failed",
                    message: "Please enter API key and if issue persists, contact developer",
                    variant: "warning"
                }));
            })
            .finally(() => {
                this.renderHeader = true;
            });
    }

    handleSelect(event) {
        this.selectedPage = event.detail;
        this.headerTitle = HEADERS[this.selectedPage]?.title;
        this.headerIcon = HEADERS[this.selectedPage]?.icon;
        this.headerDescription = HEADERS[this.selectedPage]?.description;
        this.completions = this.selectedPage === "completions";
        this.edits = this.selectedPage === "edits";
        this.images = this.selectedPage === "images";
        this.apiConfig = this.selectedPage === "apiConfig";
        this.botConfig = this.selectedPage === "botConfig";
    }
}