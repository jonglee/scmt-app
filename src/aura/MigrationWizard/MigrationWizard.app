<!--
  ~ Copyright (c) 2017, Salesforce.com, Inc.
  ~ All rights reserved.
  ~ Licensed under the BSD 3-Clause license.
  ~ For full license text, see LICENSE.txt file in the repo root or https://opensource.org/licenses/BSD-3-Clause
  -->

<aura:application description="MigrationWizard" extends="force:slds" controller="MigrationWizardController">
    <aura:attribute name="privateChecks" type="List" access="private" />
    <aura:attribute name="privateToastMessage" type="String" access="private" />

    <aura:attribute name="privateAuditEnabled" type="Boolean" access="private" />
    <aura:attribute name="privateUserEmail" type="String" access="private" />
    <aura:attribute name="privateSessionId" type="String" access="private" />
    <aura:attribute name="privateApiUrl" type="String" access="private" />
    <aura:attribute name="privateServerUrl" type="String" access="private" />
    <aura:attribute name="privateDeskEndpoint" type="String" access="private" />
    <aura:attribute name="privateDeskConsumerKey" type="String" access="private" />
    <aura:attribute name="privateDeskConsumerSecret" type="String" access="private" />
    <aura:attribute name="privateDeskToken" type="String" access="private" />
    <aura:attribute name="privateDeskTokenSecret" type="String" access="private" />

    <aura:attribute name="privateGroups" type="Object[]" access="private" />
    <aura:attribute name="privateUsers" type="Object[]" access="private" />
    <aura:attribute name="privateCustomFields" type="Object[]" access="private" />

    <aura:attribute name="privateObjects" type="Object[]" access="private" />
    <aura:attribute name="privateProfiles" type="Profile[]" access="private" />
    <aura:attribute name="privateRecordTypes" type="RecordType[]" access="private" />

    <aura:attribute name="privateUserProfile" type="String" access="private" />
    <aura:attribute name="privateUserTimestamp" type="Boolean" access="private" />

    <aura:attribute name="privateAccountDataSet" type="String" access="private" />
    <aura:attribute name="privateAccountStartDate" type="Date" access="private" />
    <aura:attribute name="privateAccountStartId" type="Integer" access="private" />
    <aura:attribute name="privateAccountRecordType" type="String" access="private" />

    <aura:attribute name="privateContactDataSet" type="String" access="private" />
    <aura:attribute name="privateContactStartDate" type="Date" access="private" />
    <aura:attribute name="privateContactStartId" type="Integer" access="private" />
    <aura:attribute name="privateContactRecordType" type="String" access="private" />

    <aura:attribute name="privateCaseDataSet" type="String" access="private" />
    <aura:attribute name="privateCaseStartDate" type="Date" access="private" />
    <aura:attribute name="privateCaseStartId" type="Integer" access="private" />
    <aura:attribute name="privateCaseRecordType" type="String" access="private" />

    <aura:attribute name="privateNoteDataSet" type="String" access="private" />
    <aura:attribute name="privateNoteStartId" type="Integer" access="private" />

    <aura:attribute name="privateInteractionDataSet" type="String" access="private" />
    <aura:attribute name="privateInteractionStartId" type="Integer" access="private" />

    <aura:handler name="init" action="{!c.init}" value="{!this}" />

    <aura:method name="processMetadata" action="{!c.processMetadata}" description="Sets the data from the server.">
        <aura:attribute name="data" type="Object" />
    </aura:method>
    <aura:method name="reloadObjects" action="{!c.reloadObjects}" description="Reloads the migration objects in the background." />
    <aura:method name="alert" action="{!c.showAlert}" description="Shows an error toast on the page.">
        <aura:attribute name="message" type="String" />
    </aura:method>
    <aura:method name="loading" action="{!c.toggleLoading}" description="Toggles the loading mask.">
        <aura:attribute name="background" type="Boolean" />
    </aura:method>

    <aura:dependency resource="markup://ui:message" type="COMPONENT" />

    <ltng:require scripts="{!$Resource.MigrationWizard + '/js/jquery.min.js'}" afterScriptsLoaded="{!c.jsLoaded}" />

    <c:wizard label="Desk.com to Service Cloud Migration" aura:id="migrationwizard">
        <c:wizardStep label="Welcome and Pre-Flight Check">
            <div class="slds-text-longform">
                <h1 class="slds-text-heading--large">Welcome to the Desk.com Migration Wizard!</h1>
                <p>The Desk.com to Service Cloud Migration provides a seamless migration path from Desk.com to Service Cloud. The app makes it easy to move foundational Desk.com data and metadata into Service Cloud, so that you can focus on improving your customer’s support experience! The wizard will take you through the migration process, step by step and will provide you access to additional support information and resources.</p>
                <h2 class="slds-text-heading--medium">Pre-Flight Check</h2>
                <p>Before we get into the nitty gritty, the Pre-Flight Check ensures that you are prepared for the migration.</p>
                <p>You now have an opportunity to re-imagine your processes. Think about how your company interacts with the data through your processes, and move only the data set that provides value. We also recommend that you review your Desk.com data and metadata beforehand, to ensure that you limit any incorrect, incomplete, improperly formatted, duplicated or outdated information.</p>
                <h2 class="slds-text-heading--medium">License Permissions and Feature Enablement</h2>
            </div>

            <div class="slds-is-relative">
                <ul class="slds-m-bottom--small">
                    <aura:iteration items="{!v.privateChecks}" var="item">
                        <li>
                            <aura:if isTrue="{!item.variant == 'success'}">
                                <lightning:icon class="slds-p-right--x-small slds-icon-text-success" variant="bare" iconName="utility:success" size="x-small" alternativeText="success icon" /> {!item.label}
                                <aura:set attribute="else">
                                    <lightning:icon class="slds-p-right--x-small" variant="{!item.variant}" iconName="{!'utility:' + item.variant}" size="x-small" alternativeText="{!item.variant + ' icon'}" /> {!item.label}
                                </aura:set>
                            </aura:if>
                        </li>
                    </aura:iteration>
                </ul>
            </div>

            <div class="slds-text-longform">
                <h2 class="slds-text-heading--medium">What happens if you don't have the above enabled?</h2>
                <p>If your user record does not have the above permissions, the migration process will be limited to objects that you have access to - but will not be prevented. For example, if you do not have 'Knowledge' enabled, articles and topics will not be included in the migration. A list of all the data and metadata moved will be available for review within the associated data migration record.</p>
            </div>
        </c:wizardStep>

        <c:wizardStep label="Connect to Desk.com" onnext="{!c.handleConnect}" onactive="{!c.handleBlur}">
            <h1 class="slds-text-heading--large">Connect to Desk.com</h1>
            <p>Great! Now that you're fully prepped, let's connect to your Desk.com Environment. In order to provide authenticated access to Desk.com, please input your Desk.com Authentication Tokens below. You can find instructions for generating tokens in the <i>Authentication Tokens</i> section of the <a href="">Embedding the Mobile SDK</a> article or <i>Figure 5: Desk.com Settings screen</i> section of the <a href="">Hipmob - Desk.com Integration</a> article.</p>
            <div class="slds-form--horizontal slds-p-vertical--medium">
                <lightning:input aura:id="auth" type="url" label="Desk.com Endpoint" name="endpoint" value="{!v.privateDeskEndpoint}" placeholder="https://example.desk.com" required="true" onchange="{!c.handleBlur}" />
                <lightning:input aura:id="auth" label="OAuth Consumer Key" name="consumer_key" value="{!v.privateDeskConsumerKey}" required="true" pattern="^[a-zA-Z0-9]*$" onchange="{!c.handleBlur}" />
                <lightning:input aura:id="auth" label="OAuth Consumer Secret" name="consumer_secret" value="{!v.privateDeskConsumerSecret}" required="true" pattern="^[a-zA-Z0-9]*$" onchange="{!c.handleBlur}" />
                <lightning:input aura:id="auth" label="OAuth Access Token" name="token" value="{!v.privateDeskToken}" required="true" pattern="^[a-zA-Z0-9]*$" onchange="{!c.handleBlur}" />
                <lightning:input aura:id="auth" label="OAuth Access Token Secret" name="token_secret" value="{!v.privateDeskTokenSecret}" required="true" pattern="^[a-zA-Z0-9]*$" onchange="{!c.handleBlur}" onblur="{!c.handleBlur}" />
            </div>
        </c:wizardStep>

        <c:wizardStep label="Metadata Overview" onnext="{!c.handleMetadata}" onactive="{!c.fetchMetadata}">
            <div class="slds-text-longform">
                <h1 class="slds-text-heading--large">Review your Metadata</h1>
            </div>
            <lightning:tabset variant="scoped">
                <lightning:tab label="Queues">
                    <table class="slds-table slds-table--bordered slds-table--cell-buffer">
                        <thead>
                            <tr class="slds-text-title--caps">
                                <th scope="col">
                                    <div class="slds-truncate" title="Desk.com Group">Desk.com Group</div>
                                </th>
                                <th scope="col">
                                    <div class="slds-truncate" title="Salesforce Queue">Salesforce Queue</div>
                                </th>
                            </tr>
                        </thead>
                        <tbody>
                            <aura:iteration items="{!v.privateGroups}" var="item">
                                <tr>
                                    <td data-label="Desk.com Group">
                                        <div class="slds-truncate" title="{!item.name}">{!item.name}</div>
                                    </td>
                                    <td data-label="Salesforce Queue">
                                        <aura:if isTrue="{!item.salesforce}">
                                            <c:lookup iconName="standard:groups" value="{!item.salesforce}" isRemovable="false" />
                                            <aura:set attribute="else">
                                                <c:lookup >
                                                    <aura:set attribute="noValueBody">
                                                        <lightning:icon iconName="utility:add" class="slds-pill__icon_container" />
                                                        <span class="slds-pill__label" title="New Group">New Group</span>
                                                        <span class="slds-pill__remove"></span>
                                                    </aura:set>
                                                </c:lookup>
                                            </aura:set>
                                        </aura:if>
                                    </td>
                                </tr>
                            </aura:iteration>
                        </tbody>
                    </table>
                </lightning:tab>
                <!--
                    FIXME: We currently can't migrate users during metadata migration because the metadata enpdoint
                    needs to be revised for this.
                -->
                <!--<lightning:tab label="Users">-->
                    <!--<table class="slds-table slds-table&#45;&#45;bordered slds-table&#45;&#45;cell-buffer">-->
                        <!--<thead>-->
                        <!--<tr class="slds-text-title&#45;&#45;caps">-->
                            <!--<th scope="col">-->
                                <!--<div class="slds-truncate" title="Desk.com User">Desk.com User</div>-->
                            <!--</th>-->
                            <!--<th scope="col">-->
                                <!--<div class="slds-truncate" title="Salesforce User">Salesforce User</div>-->
                            <!--</th>-->
                        <!--</tr>-->
                        <!--</thead>-->
                        <!--<tbody>-->
                        <!--<aura:iteration items="{!v.privateUsers}" var="item">-->
                            <!--<tr>-->
                                <!--<td data-label="Desk.com User">-->
                                    <!--<div class="slds-truncate" title="{!item.name}">{!item.name}</div>-->
                                <!--</td>-->
                                <!--<td data-label="Salesforce User">-->
                                    <!--<aura:if isTrue="{!item.salesforce}">-->
                                        <!--<c:lookup iconName="standard:user" value="{!item.salesforce}" isRemovable="false" />-->
                                        <!--<aura:set attribute="else">-->
                                            <!--<c:lookup>-->
                                                <!--<aura:set attribute="noValueBody">-->
                                                    <!--<lightning:icon iconName="utility:add" class="slds-pill__icon_container" />-->
                                                    <!--<span class="slds-pill__label" title="New User">New User</span>-->
                                                    <!--<span class="slds-pill__remove"></span>-->
                                                <!--</aura:set>-->
                                            <!--</c:lookup>-->
                                        <!--</aura:set>-->
                                    <!--</aura:if>-->
                                <!--</td>-->
                            <!--</tr>-->
                        <!--</aura:iteration>-->
                        <!--</tbody>-->
                    <!--</table>-->
                <!--</lightning:tab>-->
                <lightning:tab label="Account">
                    <table class="slds-table slds-table--bordered slds-table--cell-buffer">
                        <thead>
                        <tr class="slds-text-title--caps">
                            <th scope="col">
                                <div class="slds-truncate" title="Desk.com Company">Desk.com Company</div>
                            </th>
                            <th scope="col">
                                <div class="slds-truncate" title="Salesforce Account">Salesforce Account</div>
                            </th>
                        </tr>
                        </thead>
                        <tbody>
                        <aura:iteration items="{!v.privateCustomFields}" var="item">
                            <aura:if isTrue="{!item.type == 'company'}">
                                <tr>
                                    <td data-label="Desk.com Company">
                                        <div class="slds-truncate" title="{!item.name}">{!item.label}</div>
                                    </td>
                                    <td data-label="Salesforce Account">
                                        <aura:if isTrue="{!item.salesforce}">
                                            <c:lookup iconName="standard:custom" value="{!item.salesforce}" labelVar="label" isRemovable="false" />
                                            <aura:set attribute="else">
                                                <c:lookup >
                                                    <aura:set attribute="noValueBody">
                                                        <lightning:icon iconName="utility:add" class="slds-pill__icon_container" />
                                                        <span class="slds-pill__label" title="New Field">New Field</span>
                                                        <span class="slds-pill__remove"></span>
                                                    </aura:set>
                                                </c:lookup>
                                            </aura:set>
                                        </aura:if>
                                    </td>
                                </tr>
                            </aura:if>
                        </aura:iteration>
                        </tbody>
                    </table>
                </lightning:tab>
                <lightning:tab label="Contact">
                    <table class="slds-table slds-table--bordered slds-table--cell-buffer">
                        <thead>
                        <tr class="slds-text-title--caps">
                            <th scope="col">
                                <div class="slds-truncate" title="Desk.com Customer">Desk.com Customer</div>
                            </th>
                            <th scope="col">
                                <div class="slds-truncate" title="Salesforce Contact">Salesforce Contact</div>
                            </th>
                        </tr>
                        </thead>
                        <tbody>
                        <aura:iteration items="{!v.privateCustomFields}" var="item">
                            <aura:if isTrue="{!item.type == 'customer'}">
                                <tr>
                                    <td data-label="Desk.com Customer">
                                        <div class="slds-truncate" title="{!item.name}">{!item.label}</div>
                                    </td>
                                    <td data-label="Salesforce Contact">
                                        <aura:if isTrue="{!item.salesforce}">
                                            <c:lookup iconName="standard:custom" value="{!item.salesforce}" labelVar="label" isRemovable="false" />
                                            <aura:set attribute="else">
                                                <c:lookup >
                                                    <aura:set attribute="noValueBody">
                                                        <lightning:icon iconName="utility:add" class="slds-pill__icon_container" />
                                                        <span class="slds-pill__label" title="New Field">New Field</span>
                                                        <span class="slds-pill__remove"></span>
                                                    </aura:set>
                                                </c:lookup>
                                            </aura:set>
                                        </aura:if>
                                    </td>
                                </tr>
                            </aura:if>
                        </aura:iteration>
                        </tbody>
                    </table>
                </lightning:tab>
                <lightning:tab label="Case">
                    <table class="slds-table slds-table--bordered slds-table--cell-buffer">
                        <thead>
                        <tr class="slds-text-title--caps">
                            <th scope="col">
                                <div class="slds-truncate" title="Desk.com Case">Desk.com Case</div>
                            </th>
                            <th scope="col">
                                <div class="slds-truncate" title="Salesforce Case">Salesforce Case</div>
                            </th>
                        </tr>
                        </thead>
                        <tbody>
                        <aura:iteration items="{!v.privateCustomFields}" var="item">
                            <aura:if isTrue="{!item.type == 'ticket'}">
                                <tr>
                                    <td data-label="Desk.com Case">
                                        <div class="slds-truncate" title="{!item.name}">{!item.label}</div>
                                    </td>
                                    <td data-label="Salesforce Case">
                                        <aura:if isTrue="{!item.salesforce}">
                                            <c:lookup iconName="standard:custom" value="{!item.salesforce}" labelVar="label" isRemovable="false" />
                                            <aura:set attribute="else">
                                                <c:lookup >
                                                    <aura:set attribute="noValueBody">
                                                        <lightning:icon iconName="utility:add" class="slds-pill__icon_container" />
                                                        <span class="slds-pill__label" title="New Field">New Field</span>
                                                        <span class="slds-pill__remove"></span>
                                                    </aura:set>
                                                </c:lookup>
                                            </aura:set>
                                        </aura:if>
                                    </td>
                                </tr>
                            </aura:if>
                        </aura:iteration>
                        </tbody>
                    </table>
                </lightning:tab>
            </lightning:tabset>
        </c:wizardStep>

        <c:wizardStep label="Review Desk.com Data Set" onactive="{!c.fetchObjects}">
            <div class="slds-grid slds-wrap slds-grid--pull-padded">
                <div class="slds-p-horizontal--small slds-size--1-of-1 slds-medium-size--4-of-6 slds-large-size--9-of-12 slds-order--1 slds-medium-order--2 slds-large-order--2">
                    <aura:iteration items="{!v.privateObjects}" var="item">
                        <div class="{!'slds-text-longform ' + (item.isActive ? 'slds-show' : 'slds-hide')}">
                            <h1 class="slds-text-heading--large slds-border--bottom">{!item.label}</h1>
                            <form class="slds-form--stacked slds-m-bottom--large">
                                <aura:renderIf isTrue="{!item.name == 'User'}">
                                    <lightning:select name="userProfile" label="Profile" value="{!v.privateUserProfile}" required="true">
                                        <option value="">-- Please Select --</option>
                                        <aura:iteration items="{!v.privateProfiles}" var="item">
                                            <option value="{!item.Id}">{!item.Name}</option>
                                        </aura:iteration>
                                    </lightning:select>


                                    <div class="slds-form-element">
                                        <label class="slds-form-element__legend slds-form-element__label">User Settings</label>
                                        <div class="slds-form-element__control">
                                            <lightning:input aura:id="user" type="checkbox" label="Append Timestamp to Username and Email" name="userTimestamp" checked="{!v.privateUserTimestamp}" />
                                        </div>
                                    </div>
                                </aura:renderIf>

                                <aura:renderIf isTrue="{!item.name == 'Group Member'}">
                                </aura:renderIf>

                                <aura:renderIf isTrue="{!item.name == 'Account'}">
                                    <lightning:select name="accountDataSet" label="Data Set" value="{!v.privateAccountDataSet}" required="true">
                                        <option value="">-- Please Select --</option>
                                        <option value="0">Migrate All Data</option>
                                        <option value="1">Migrate Data Range</option>
                                    </lightning:select>

                                    <aura:renderIf isTrue="{!v.privateAccountDataSet == '1'}">
                                        <fieldset class="slds-form-element">
                                            <legend class="slds-form-element__legend slds-form-element__label">Data Set Selection</legend>
                                            <div class="slds-form--inline">
                                                <lightning:input type="date" name="accountStartDate" label="Start Date" value="{!v.privateAccountStartDate}" disabled="{!v.privateAccountStartId}" />
                                                <lightning:input type="number" name="accountStartId" label="Start Id" value="{!v.privateAccountStartId}" disabled="{!v.privateAccountStartDate}" />
                                            </div>
                                        </fieldset>
                                    </aura:renderIf>

                                    <lightning:select name="accountRecordTypeId" label="Record Type" value="{!v.privateAccountRecordType}">
                                        <option value="">-- Please Select --</option>
                                        <aura:iteration items="{!v.privateRecordTypes}" var="item">
                                            <aura:if isTrue="{!item.SobjectType == 'Account'}">
                                                <option value="{!item.Id}">{!item.Name}</option>
                                            </aura:if>
                                        </aura:iteration>
                                    </lightning:select>
                                </aura:renderIf>

                                <aura:renderIf isTrue="{!item.name == 'Contact'}">
                                    <lightning:select name="contactDataSet" label="Data Set" value="{!v.privateContactDataSet}" required="true">
                                        <option value="">-- Please Select --</option>
                                        <option value="0">Migrate All Data</option>
                                        <option value="1">Migrate Data Range</option>
                                    </lightning:select>

                                    <aura:renderIf isTrue="{!v.privateContactDataSet == '1'}">
                                        <fieldset class="slds-form-element">
                                            <legend class="slds-form-element__legend slds-form-element__label">Data Set Selection</legend>
                                            <div class="slds-form--inline">
                                                <lightning:input type="date" name="accountStartDate" label="Start Date" value="{!v.privateContactStartDate}" disabled="{!v.privateContactStartId}" />
                                                <lightning:input type="number" name="accountStartId" label="Start Id" value="{!v.privateContactStartId}" disabled="{!v.privateContactStartDate}" />
                                            </div>
                                        </fieldset>
                                    </aura:renderIf>

                                    <lightning:select name="contactRecordTypeId" label="Record Type" value="{!v.privateContactRecordType}">
                                        <option value="">-- Please Select --</option>
                                        <aura:iteration items="{!v.privateRecordTypes}" var="item">
                                            <aura:if isTrue="{!item.SobjectType == 'Contact'}">
                                                <option value="{!item.Id}">{!item.Name}</option>
                                            </aura:if>
                                        </aura:iteration>
                                    </lightning:select>
                                </aura:renderIf>

                                <aura:renderIf isTrue="{!item.name == 'Case'}">
                                    <lightning:select name="caseDataSet" label="Data Set" value="{!v.privateCaseDataSet}" required="true">
                                        <option value="">-- Please Select --</option>
                                        <option value="0">Migrate All Data</option>
                                        <option value="1">Migrate Data Range</option>
                                    </lightning:select>

                                    <aura:renderIf isTrue="{!v.privateCaseDataSet == '1'}">
                                        <fieldset class="slds-form-element">
                                            <legend class="slds-form-element__legend slds-form-element__label">Data Set Selection</legend>
                                            <div class="slds-form--inline">
                                                <lightning:input type="date" name="caseStartDate" label="Start Date" value="{!v.privateCaseStartDate}" disabled="{!v.privateCaseStartId}" />
                                                <lightning:input type="number" name="caseStartId" label="Start Id" value="{!v.privateCaseStartId}" disabled="{!v.privateCaseStartDate}" />
                                            </div>
                                        </fieldset>
                                    </aura:renderIf>

                                    <lightning:select name="caseRecordTypeId" label="Record Type" value="{!v.privateCaseRecordType}">
                                        <option value="">-- Please Select --</option>
                                        <aura:iteration items="{!v.privateRecordTypes}" var="item">
                                            <aura:if isTrue="{!item.SobjectType == 'Case'}">
                                                <option value="{!item.Id}">{!item.Name}</option>
                                            </aura:if>
                                        </aura:iteration>
                                    </lightning:select>
                                </aura:renderIf>

                                <aura:renderIf isTrue="{!item.name == 'Note'}">
                                    <lightning:select name="noteDataSet" label="Data Set" value="{!v.privateNoteDataSet}" required="true">
                                        <option value="">-- Please Select --</option>
                                        <option value="0">Migrate All Data</option>
                                        <option value="1">Migrate Data Range</option>
                                    </lightning:select>

                                    <aura:renderIf isTrue="{!v.privateNoteDataSet == '1'}">
                                        <fieldset class="slds-form-element">
                                            <legend class="slds-form-element__legend slds-form-element__label">Data Set Selection</legend>
                                            <div class="slds-form--inline">
                                                <lightning:input type="number" name="noteStartPage" label="Start Page" value="{!v.privateNoteStartId}" />
                                            </div>
                                        </fieldset>
                                    </aura:renderIf>
                                </aura:renderIf>

                                <aura:renderIf isTrue="{!item.name == 'Interaction'}">
                                    <lightning:select name="interactionDataSet" label="Data Set" value="{!v.privateInteractionDataSet}" required="true">
                                        <option value="">-- Please Select --</option>
                                        <option value="0">Migrate All Data</option>
                                        <option value="1">Migrate Data Range</option>
                                    </lightning:select>

                                    <aura:renderIf isTrue="{!v.privateInteractionDataSet == '1'}">
                                        <fieldset class="slds-form-element">
                                            <legend class="slds-form-element__legend slds-form-element__label">Data Set Selection</legend>
                                            <div class="slds-form--inline">
                                                <lightning:input type="number" name="interactionStartPage" label="Start Id" value="{!v.privateInteractionStartId}" />
                                            </div>
                                        </fieldset>
                                    </aura:renderIf>
                                </aura:renderIf>

                                <aura:renderIf isTrue="{!item.name == 'Attachment'}">
                                </aura:renderIf>

                                <aura:renderIf isTrue="{!item.name == 'Article'}">
                                </aura:renderIf>

                                <div class="slds-form-element slds-clearfix">
                                    <lightning:button aura:id="startMigration" label="Start Migration" variant="brand" class="slds-float--right" onclick="{!c.createMigration}" />
                                </div>
                            </form>

                            <aura:renderIf isTrue="{!item.migrations.length > 0}">
                                <h2 class="slds-text-heading--medium slds-border--bottom">Migration Records</h2>
                                <!--Name, StartDate__c, Status__c, RecordsTotal__c, RecordsFailed__c, Object__c-->
                                <table class="slds-table slds-table--bordered slds-table--cell-buffer">
                                    <thead>
                                    <tr class="slds-text-title--caps">
                                        <th scope="col">
                                            <div class="slds-truncate" title="Name">Name</div>
                                        </th>
                                        <th scope="col">
                                            <div class="slds-truncate" title="Start Date">Start Date</div>
                                        </th>
                                        <th scope="col">
                                            <div class="slds-truncate" title="Status">Status</div>
                                        </th>
                                        <th scope="col">
                                            <div class="slds-truncate" title="Records Total">Records Total</div>
                                        </th>
                                        <th scope="col">
                                            <div class="slds-truncate" title="Records Failed">Records Failed</div>
                                        </th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <aura:iteration items="{!item.migrations}" var="i">
                                        <tr>
                                            <td data-label="Name">
                                                <div class="slds-truncate" title="{!i.Id}">{!i.Name}</div>
                                            </td>
                                            <td data-label="Start Date">
                                                <div class="slds-truncate"><lightning:formattedDateTime value="{!i.StartDate__c}" year="numeric" month="numeric" day="numeric"  hour="2-digit" minute="2-digit" timeZoneName="short" /></div>
                                            </td>
                                            <td data-label="Status">
                                                <div class="slds-truncate">{!i.Status__c}</div>
                                            </td>
                                            <td data-label="Records Total">
                                                <div class="slds-truncate">{!i.RecordsTotal__c}</div>
                                            </td>
                                            <td data-label="Records Failed">
                                                <div class="slds-truncate">{!i.RecordsFailed__c}</div>
                                            </td>
                                        </tr>
                                    </aura:iteration>
                                    </tbody>
                                </table>
                            </aura:renderIf>
                        </div>
                    </aura:iteration>
                </div>
                <div style="background-color:#FAFAFB;" class="slds-p-horizontal--small slds-p-bottom--small slds-size--1-of-1 slds-medium-size--2-of-6 slds-large-size--3-of-12 slds-order--2 slds-medium-order--1 slds-large-order--1">
                    <div class="slds-grid slds-grid--vertical slds-navigation-list--vertical slds-navigation-list--vertical-inverse">
                        <h2 class="slds-text-title--caps slds-p-around--medium">Migration Objects</h2>
                        <ul>
                            <aura:iteration items="{!v.privateObjects}" var="item">
                                <li class="{!item.isActive ? 'slds-is-active' : ''}">
                                    <a href="javascript:void(0);" data-name="{!item.name}" onclick="{!c.changeObject}" class="slds-navigation-list--vertical__action slds-text-link--reset slds-clearfix" aria-describedby="migration-object">
                                        {!item.label}
                                    </a>
                                </li>
                            </aura:iteration>
                        </ul>
                    </div>
                </div>
            </div>
        </c:wizardStep>
    </c:wizard>

    <div class="slds-notify_container slds-hide" aura:id="toast">
        <div class="slds-notify slds-notify--toast slds-theme--error" role="alert">
            <span class="slds-assistive-text">Error</span>
            <lightning:buttonIcon onclick="{!c.toggleToast}" alternativeText="Close" iconName="utility:close" variant="bare-inverse" class="slds-notify__close" size="large" />
            <div class="slds-notify__content slds-grid">
                <lightning:icon class="slds-m-right--small slds-col slds-no-flex" size="small" iconName="utility:warning" />
                <div class="slds-col slds-align-middle">
                    <h2 class="slds-text-heading--small">{!v.privateToastMessage}</h2>
                </div>
            </div>
        </div>
    </div>
    <div class="background-spinner slds-hide" aura:id="background-loading">
        <div class="slds-spinner slds-spinner--brand slds-spinner--small" role="status" data-aura-rendered-by="316:0">
            <span class="slds-assistive-text" data-aura-rendered-by="318:0">Background Loading</span>
            <div class="slds-spinner__dot-a" data-aura-rendered-by="320:0"></div>
            <div class="slds-spinner__dot-b" data-aura-rendered-by="321:0"></div>
        </div>
    </div>
    <lightning:spinner aura:id="loading" class="slds-hide" alternativeText="Loading" variant="brand" size="large" />
</aura:application>