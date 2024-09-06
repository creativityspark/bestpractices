# Workflows

Good practices for Dataverse Classic Workflows and Actions. 

# WF-001

Workflows and Actions names must follow the pattern:

```
 [Table Schema Name] - [Event Name(s)] - [Action/Purpose]
```

- Table Schema Name: The name of the main table triggering this Workflow or Action. * 
- Event Name(s): Create, Update, CreateUpdate, Delete, Assign, Child, Demand. *
- Action/Purpose: Brief text describing the purpose or the action taken by the Workflow or Action. 

\* Camel Casing

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
