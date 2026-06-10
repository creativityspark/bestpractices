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

# WF-002

Set the workflow scope to the narrowest necessary level.

1. Use **User** scope when the workflow should only run for records owned by the workflow owner.
1. Use **Business Unit** scope when it should apply to all users within the same business unit.
1. Use **Organization** scope only when the workflow must apply to all records across the entire organization.
1. Assign workflow ownership to a dedicated service account rather than a named user.

## Rationale

1. A narrower scope reduces the number of times the workflow is triggered, improving system performance.
1. Overly broad scopes can cause the workflow to run on records it was never intended to process, leading to unexpected behavior.
1. Using a service account as the workflow owner prevents the workflow from being disabled or orphaned when a named user leaves the organization or is deactivated.

## Examples

### Good

- A workflow that sends a notification to the record owner when a Case is updated, scoped to **Organization** because all case owners need the notification.
- A workflow that auto-approves expenses under $100, owned by a service account `svc_workflow@contoso.com`.

### Bad

- A workflow scoped to **Organization** that only applies to a specific team's records, triggering unnecessarily for every user in the system.
- A workflow owned by a named user `john.smith@contoso.com` — when John leaves the organization, the workflow stops running.

## More Information
1. [Configure workflow stages and steps - Microsoft Learn](https://learn.microsoft.com/en-us/power-apps/maker/data-platform/configure-workflow-steps)

# WF-003

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

# WF-004

Use child workflows to encapsulate reusable logic and keep parent workflows manageable.

1. Extract repeated logic into child workflows that can be called from multiple parent workflows.
1. Design child workflows to be self-contained — they should not rely on assumptions about the calling context.
1. Keep parent workflows focused on orchestration and decision-making, delegating specific actions to child workflows.
1. Include the word "Child" or use the Demand trigger to clearly identify child workflows.

## Rationale

1. Reusable child workflows reduce duplication. When the logic needs to change, it only needs to be updated in one place.
1. Breaking complex workflows into smaller, focused child workflows makes them easier to understand, test, and debug.
1. Self-contained child workflows can be tested independently, improving reliability.

## Examples

### Good

- A child workflow `Contact - Demand - Send Welcome Email` that handles all welcome email logic. Called by both the `Contact - Create - Onboarding` and `Lead - Update - Qualification` parent workflows.

### Bad

- The same email-sending logic duplicated in 5 different workflows. When the email template changes, all 5 must be updated manually.
- A single monolithic workflow with 30+ steps handling onboarding, email notifications, field updates, and audit logging all in one sequence.

## More Information
1. [Configure child workflows - Microsoft Learn](https://learn.microsoft.com/en-us/power-apps/maker/data-platform/configure-workflow-steps#child-workflows)

# WF-005

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
