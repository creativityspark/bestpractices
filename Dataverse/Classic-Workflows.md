# Workflows

Good practices for Dataverse Classic Workflows and Actions.

# WF-001

Workflow and Action names must follow the pattern:

```
[App Prefix] - [Table Schema Name] - [Event Name Code(s)] - [Action/Purpose]
```

- **App Prefix**: A short prefix (3 letters) that identifies the application the workflow belongs to. This helps group workflows from the same application together in any list.
- **Table Schema Name**: The name of the main table triggering this Workflow or Action.
- **Event Name Code(s)**: A short code identifying the triggering event. Combine codes when the workflow triggers on multiple events (e.g., `NEWMOD` for create and update).
- **Action/Purpose**: Brief text describing the purpose or the action taken by the Workflow or Action.

## Event Name Codes

| Code    | Event              |
| ------- | ------------------ |
| NEW     | Record Created     |
| MOD     | Record Updated     |
| NEWMOD  | Created or Updated |
| DEL     | Record Deleted     |
| ASN     | Record Assigned    |
| CHD     | Child Workflow     |
| DMD     | On Demand          |

## Rationale

1. Having naming conventions in place makes the task of choosing names easier.
1. Including the app prefix at the beginning groups all workflows belonging to the same application together when sorted alphabetically.
1. Including the table name makes it easier to identify and select the workflows in the UI.
1. Using short event name codes keeps the name concise while making the trigger immediately recognizable, and is consistent with the Power Automate flow naming conventions ([PA-001](/Power%20Automate/Cloud-Flows.md#pa-001)).

## Examples

### Good

- `CRM - Contact - NEWMOD - Send Notifications`
- `CRM - Account - MOD - Validations`
- `OMS - Order - MOD - Move Out of Notice Wait Period`
- `OMS - Product - CHD - Set Reference Number`
- `CRM - CaseBPF - MOD - Set Status`
- `OMS - CustomerRequest - DMD - Cancel Record`

### Bad

- `Send Notifications` — no prefix, no table name, no event; impossible to identify at a glance.
- `Contact - CreateUpdate - Send Notifications` — missing the app prefix; uses long event name instead of a short code.

## More Information
1. [Configure workflow stages and steps - Microsoft Learn](https://learn.microsoft.com/en-us/power-apps/maker/data-platform/configure-workflow-steps)

# WF-002

All workflows and actions must have a description. The description should summarize the workflow's purpose, the business process it supports, and any important details about its behavior.

1. **State the purpose**: Explain what the workflow does in one or two sentences.
1. **Mention the trigger**: Briefly describe what event initiates the workflow.
1. **Include business context**: Reference the business process or requirement the workflow supports.
1. **Note dependencies**: Mention any child workflows, custom actions, or external resources the workflow relies on.

## Rationale

1. Providing a description for each workflow ensures that anyone reviewing or maintaining it can quickly understand its purpose and functionality.
1. Descriptions help document the workflow's behavior, making it easier to troubleshoot and update in the future.
1. Well-documented workflows improve collaboration among team members by providing clear context and reducing the learning curve for new team members.

## Examples

### Good

- _"Triggered when a Contact record is created or updated. Sends an email notification to the account manager with the updated contact details. Calls the CRM - Contact - CHD - Send Notification Email child workflow."_
- _"Runs on demand. Cancels the selected Customer Request record and updates all related Order records to Cancelled status. Part of the Customer Request Lifecycle process."_

### Bad

- _"My workflow"_ — meaningless, provides no context.
- _"Handles stuff"_ — vague, no useful information.
- No description at all.

## More Information
1. [Configure workflow stages and steps - Microsoft Learn](https://learn.microsoft.com/en-us/power-apps/maker/data-platform/configure-workflow-steps)

# WF-003

Set the workflow scope to the narrowest necessary level.

1. Use **User** scope when the workflow should only run for records owned by the workflow owner.
1. Use **Business Unit** scope when it should apply to all users within the same business unit.
1. Use **Organization** scope only when the workflow must apply to all records across the entire organization.

## Rationale

1. A narrower scope reduces the number of times the workflow is triggered, improving system performance.
1. Overly broad scopes can cause the workflow to run on records it was never intended to process, leading to unexpected behavior.

## Examples

### Good

- A workflow that sends a notification to the record owner when a Case is updated, scoped to **Organization** because all case owners need the notification.
- A workflow that generates a report for a specific business unit's records, scoped to **Business Unit**.

### Bad

- A workflow scoped to **Organization** that only applies to a specific team's records, triggering unnecessarily for every user in the system.

## More Information
1. [Configure workflow stages and steps - Microsoft Learn](https://learn.microsoft.com/en-us/power-apps/maker/data-platform/configure-workflow-steps)

# WF-004

Assign workflow ownership to a dedicated service account rather than a named user account.

1. Create a dedicated service account (e.g., `svc_workflow@contoso.com`) to own all workflows.
1. Ensure the service account has the appropriate security roles and remains active.
1. Avoid assigning workflow ownership to individual users who may leave the organization or change roles.

## Rationale

1. When a named user leaves the organization or is deactivated, all workflows owned by that user stop running, potentially disrupting business processes.
1. A dedicated service account provides a stable owner that is not affected by personnel changes.
1. Centralizing workflow ownership under a service account makes it easier to manage permissions and audit workflow execution.

## Examples

### Good

- All production workflows owned by a service account `svc_workflow@contoso.com` with the appropriate security roles.

### Bad

- A workflow owned by `john.smith@contoso.com` — when John leaves the organization, the workflow stops running and must be manually reassigned.
- Multiple workflows owned by different individual users, making it difficult to track and maintain ownership.

## More Information
1. [Configure workflow stages and steps - Microsoft Learn](https://learn.microsoft.com/en-us/power-apps/maker/data-platform/configure-workflow-steps)

# WF-005

Prefer asynchronous (background) workflows over real-time (synchronous) workflows unless immediate validation or cancellation is required.

1. Use **asynchronous** workflows for post-processing tasks such as sending notifications, updating related records, or logging.
1. Use **real-time** workflows only when the action must happen immediately and the user must see the result before proceeding (e.g., validating data and canceling a save).
1. Never use real-time workflows for long-running operations such as sending emails, calling external services, or processing many records.

## Rationale

1. Asynchronous workflows run in the background and do not block the user interface, providing a better user experience.
1. Real-time workflows execute synchronously — the user must wait for the workflow to complete before the form responds, which can cause timeouts and frustration.
1. Long-running operations in real-time workflows risk hitting the 2-minute execution timeout, causing the entire transaction to fail.

## Examples

### Good

- An **asynchronous** workflow that sends a welcome email when a new Contact is created. The user saves the Contact and continues working immediately.
- A **real-time** workflow that validates that the `Discount Percentage` field does not exceed 50% on Order save, canceling the operation if it does.

### Bad

- A **real-time** workflow that updates 200 related Order Line Items when an Order status changes, causing the user to wait 30+ seconds.
- A **real-time** workflow that calls an external REST API to validate an address, adding network latency to every save operation.

## More Information
1. [Real-time workflows vs background workflows - Microsoft Learn](https://learn.microsoft.com/en-us/power-apps/maker/data-platform/overview-realtime-workflows)

# WF-006

Use child workflows to encapsulate reusable logic and keep parent workflows manageable.

1. Extract repeated logic into child workflows that can be called from multiple parent workflows.
1. Design child workflows to be self-contained — they should not rely on assumptions about the calling context.
1. Keep parent workflows focused on orchestration and decision-making, delegating specific actions to child workflows.
1. Use the `CHD` event code in the name to clearly identify child workflows (see [WF-001](#wf-001)).

## Rationale

1. Reusable child workflows reduce duplication. When the logic needs to change, it only needs to be updated in one place.
1. Breaking complex workflows into smaller, focused child workflows makes them easier to understand, test, and debug.
1. Self-contained child workflows can be tested independently, improving reliability.

## Examples

### Good

- A child workflow `CRM - Contact - CHD - Send Welcome Email` that handles all welcome email logic. Called by both the `CRM - Contact - NEW - Onboarding` and `CRM - Lead - MOD - Qualification` parent workflows.

### Bad

- The same email-sending logic duplicated in 5 different workflows. When the email template changes, all 5 must be updated manually.
- A single monolithic workflow with 30+ steps handling onboarding, email notifications, field updates, and audit logging all in one sequence.

## More Information
1. [Configure child workflows - Microsoft Learn](https://learn.microsoft.com/en-us/power-apps/maker/data-platform/configure-workflow-steps#child-workflows)

# WF-007

Implement error handling and early termination in workflows.

1. Add **Check Condition** steps at the beginning of the workflow to validate preconditions and terminate early if they are not met.
1. Use the **Stop Workflow** step with a status of **Cancelled** and a descriptive message when a workflow cannot or should not continue.
1. For critical business workflows, consider updating a custom status field on the record to indicate success or failure for monitoring purposes.

## Rationale

1. Without precondition checks, workflows may attempt to process records in an invalid state, leading to errors or corrupted data.
1. Terminating early with a clear status message makes it much easier to diagnose issues in the System Jobs view.
1. Custom status fields on records provide visibility to users and administrators about whether automated processing completed successfully, without requiring access to System Jobs.

## Examples

### Good

```
Step 1: Check Condition → Is Status = Active?
  If No  → Stop Workflow (Cancelled: "Record is not active. Workflow skipped.")
  If Yes → Continue with processing...
Step 2: Check Condition → Is Email populated?
  If No  → Stop Workflow (Cancelled: "Email is missing. Cannot send notification.")
  If Yes → Send Email
Step 3: Update Record → Set csp_workflow_status = "Completed"
```

### Bad

```
Step 1: Send Email  → Fails because Email field is empty
                    → Workflow shows as "Failed" in System Jobs
                    → No indication on the record of what went wrong
```

## More Information
1. [Workflow stages and steps - Microsoft Learn](https://learn.microsoft.com/en-us/power-apps/maker/data-platform/configure-workflow-steps)
