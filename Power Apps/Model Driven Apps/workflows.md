# Workflows

Good practices for Model Driven Apps Workflows and Actions. 

# 001

Workflows and Actions names must follow the pattern:

```
 [Table Schema Name] - [Event(s)] - [Action/Purpose]
```
Event Names: Create, Update, CreateUpdate, Delete, Assign, Child, Demand

## Reasoning 

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
