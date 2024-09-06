# Cloudflows

Good practices for Power Automate flows. 

# PA-001

Cloud flow names must follow the pattern:

```
[Connector prefix] - [Datastore] - [Event Name(s)] - [Action/Purpose]
```

- Connector prefix: Identifies the connector in the trigger
- Datastore: Identifies what data is behind the trigger. In the case of Dataverse, it will be the table name. If the trigger is SharePoint, it will be the library. 
- Event Name(s): Create, Update, CreateUpdate, Delete, Assign *
- Action/Purpose: Brief text describing the purpose or the action taken by the Flow. 

\* Camel Casing

## Connector prefixes

|---
|Prefix|Connector|
|---
|sda



## Rationale 

- Having naming conventions in place makes the task of choosing names easier. 
- Including the table name at the beginning of the name, makes it easier to identify and select the workflows in the UI. 
- Same applies to the event. Is immediately noticeable what's the trigger of the Workflow/Action.

## Examples

- Contact - CreateUpdate - Send Notifications
- Account - Update - Validations
- Order - Update - Move out of notice wait period
- Product - Child - Set Reference Number
- CaseBPF - Update - Set Status
- CustomerRequest - Demand - Cancel Record
