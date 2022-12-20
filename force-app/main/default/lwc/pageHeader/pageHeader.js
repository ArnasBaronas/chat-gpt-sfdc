/**
 * Created by T1950 on 2022-12-18.
 */

import {api, LightningElement} from 'lwc';

export default class PageHeader extends LightningElement {

    @api
    title;
    @api
    icon;

    @api
    description;
}