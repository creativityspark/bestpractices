# Cloudflows

Good practices for Power Automate flows. 

# PA-001

Cloud flow names must follow the pattern:

```
[Connector prefix] - [Datastore] - [Event Name(s)] - [Action/Purpose]
```

- Connector prefix: Identifies the connector used in the trigger of the flow.
- Datastore: Identifies what data is behind the trigger. For example for Dataverse, it will be the table name. If the trigger is SharePoint, it will be the library. 
- Event Name(s): Create, Update, CreateUpdate, Delete, Assign
- Action/Purpose: Brief text describing the purpose or the action taken by the Flow.

\* If the connector does not have a data store associated, like a manual trigger this can be skipped

## Connector prefixes and Data Stores

| Prefix | Connector | Datastore
|---|---|---
| DV | Dataverse | Dataverse table or action
| SP | SharePoint | SharePoint list
| CF | Child Flow, Button trigger, Manual | 
| SC | Scheduled | Periodicity of the schedule. i.e., Daily, Weekly, Hourly
| PA | Power Apps | Power Apps Name
| OL | Outlook | 
| 

## Rationale 

1. Having naming conventions in place makes the task of choosing names easier. 
1. Including the connector prefix and the data store name at the beginning, makes it easier to identify and select the workflows in the UI. 
1. The Action/Purpose makes it very easy to see what the flow is doing.

## Examples

- DV - Contact - CreateUpdate - Send Notifications
- DV - Account - Update - Validations
- SP - Orders - Update - Move out of notice wait period
- CF - Set Reference Number
- SC - Daily - Set Status
- PA - Orders - Cancel Record