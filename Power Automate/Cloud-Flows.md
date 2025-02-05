# Cloudflows

Good practices for Power Automate flows. 

# PA-001

Cloud flow names must follow the pattern:

```
[Connector prefix] - [Data Store] - [Event Nam Code(s)] - [Action/Purpose]
```

- Connector prefix: Identifies the connector used in the trigger of the flow.
- Datastore: Identifies what data is behind the trigger. For example for Dataverse, it will be the table name. If the trigger is SharePoint, it will be the library. 
- Event Name Code(s): Action that triggered the flow, like record creation or update.
- Action/Purpose: Brief text describing the purpose or the action taken by the Flow.

\* If the connector does not have a data store associated, like a manual trigger this can be skipped

## Trigger prefixes and Data Stores

| Prefix | Connector                           | Datastore                                                |
| ------ | ----------------------------------- | -------------------------------------------------------- |
| DV     | Dataverse                           | Dataverse table or action                                |
| SP     | SharePoint                          | SharePoint list                                          |
| CF     | Instant, Child Flow, Button, Manual |
| SCH    | Scheduled                           | Periodicity of the schedule. i.e., Daily, Weekly, Hourly |
| PA     | Power Apps                          | Power Apps Name.                                         |
| OUT    | Outlook                             | Mailbox name.                                            |
| TEA    | Teams                               | Teams name.                                              |

## Event Name Codes

| Data Store            | Code | Event Name         |
| --------------------- | ---- | ------------------ |
| Dataverse, SharePoint | NEW  | New Record Created |
|                       | MOD  | Record Updated     |
|                       | DEL  | Record Deleted     |

## Rationale 

1. Having naming conventions in place makes the task of choosing names easier. 
1. Including the trigger prefix and the data store name at the beginning, makes it easier to identify and select the workflows in the UI. 
1. Having naming conventions makes it easier to group similar flows together by the name.
1. The Action/Purpose makes it very easy to see what the flow is doing.

## Examples

- **DV - Contact - NEWMOD - Send Notifications**: Sends an notification when a record is created or modified in a Dataverse contact record.
- **DV - Account - MOD - Validations**: Performs validations when an account record is updated in dataverse.
- **SP - Orders - MOD - Move out of notice wait period**: Moves an order out of wait notice period when an item is updated in the Orders SharePoint list. 
- **CF - Set Reference Number**: Child flow that sets a reference number.
- **SCH - Daily - Set Status**: Schedule flow that runs daily and sets the status.
- **PA - Orders Management - Cancel Record**: Called from the Orders Management Power App to Cancel a record.

# PA-002

All flows must have a description.

## Rationale

1. Providing a description for each flow ensures that anyone reviewing or maintaining the flow can quickly understand its purpose and functionality.
1. Descriptions help in documenting the flow's behavior, making it easier to troubleshoot and update in the future.
1. Well-documented flows improve collaboration among team members by providing clear context and reducing the learning curve for new team members.
1. Descriptions can also serve as a reference for stakeholders to understand the business logic implemented in the flow.

# PA-003
Trigger Names

Trigger names should be clear and descriptive to ensure that anyone reviewing the flow can quickly understand what initiates it.

1. **Use a Verb-Noun Format**: Start with a verb that describes the action, followed by a noun that specifies the object of the action.
1. **Include Key Details**: Incorporate important details such as the data store and the specific event that triggers the flow.
1. **Avoid Abbreviations**: Use full words instead of abbreviations to ensure clarity.

## Rationale

1. **Clarity**: Clear and descriptive trigger names make it easier to understand what initiates the flow.
1. **Documentation**: Well-named triggers serve as documentation, making it easier for team members and stakeholders to understand the flow's purpose.
1. **Troubleshooting**: Descriptive names simplify troubleshooting by providing immediate context about the trigger event.

## Examples

- When a new item is created
- When a new contact is added to Dataverse
- When a file is created in SharePoint instead of File Created SP

# PA-004

Action Names:

# PA-005

Variable Names:

# PA-006
Connection Reference Names:

# More Information
- [Matthew Devaney - Power Automate Standards](https://www.matthewdevaney.com/power-automate-coding-standards-for-cloud-flows/power-automate-standards-naming-conventions/)