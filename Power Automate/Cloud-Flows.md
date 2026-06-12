# Cloud Flows

Good practices for Power Automate flows.

# PA-001: Naming

Cloud flow names must follow the pattern:

```
[App Prefix] - [Connector Prefix] - [Data Store] - [Event Name Code(s)] - [Action/Purpose]
```

- App Prefix: A 3-letter code that identifies the application the flow belongs to. This ensures all flows for the same app appear grouped together in lists. If the flow belongs to multiple apps or is shared across applications, omit this prefix.
- Connector Prefix: Identifies the connector used in the trigger of the flow.
- Data Store: Identifies what data is behind the trigger. For example, for Dataverse, it will be the table name. If the trigger is SharePoint, it will be the library.
- Event Name Code(s): Action that triggered the flow, like record creation or update. Combine codes when the flow triggers on multiple events (e.g., `NEWMOD` for create and update).
- Action/Purpose: Brief text describing the purpose or the action taken by the flow.

\* If the connector does not have a data store associated, like a manual trigger, this can be skipped.

## Trigger Prefixes and Data Stores

| Prefix | Connector                           | Data Store                                               |
| ------ | ----------------------------------- | -------------------------------------------------------- |
| DV     | Dataverse                           | Dataverse table or action                                |
| SP     | SharePoint                          | SharePoint list                                          |
| CF     | Instant, Child Flow, Button, Manual | N/A                                                      |
| SCH    | Scheduled                           | Periodicity of the schedule. i.e., Daily, Weekly, Hourly |
| PA     | Power Apps                          | Power Apps name                                          |
| OUT    | Outlook                             | Mailbox name                                             |
| TEA    | Teams                               | Teams name                                               |

## Event Name Codes

| Data Store            | Code | Event Name         |
| --------------------- | ---- | ------------------ |
| Dataverse, SharePoint | NEW  | New Record Created |
|                       | MOD  | Record Updated     |
|                       | DEL  | Record Deleted     |

## Rationale

1. Having naming conventions in place makes the task of choosing names easier.
1. The app prefix groups all flows belonging to the same application together in alphabetical lists, making it easy to find and manage them.
1. Including the trigger prefix and the data store name makes it easier to identify and select the flows in the UI.
1. Having naming conventions makes it easier to group similar flows together by the name.
1. The Action/Purpose makes it very easy to see what the flow is doing.

## Examples

- **ORM - DV - Contact - NEWMOD - Send Notifications**: Sends a notification when a record is created or modified in a Dataverse Contact record. Part of the Orders Management (ORM) app.
- **ORM - DV - Account - MOD - Validations**: Performs validations when an Account record is updated in Dataverse. Part of the Orders Management (ORM) app.
- **ORM - SP - Orders - MOD - Move out of notice wait period**: Moves an order out of the wait notice period when an item is updated in the Orders SharePoint list. Part of the Orders Management (ORM) app.
- **HRO - CF - Set Reference Number**: Child flow that sets a reference number. Part of the HR Onboarding (HRO) app.
- **HRO - SCH - Daily - Set Status**: Scheduled flow that runs daily and sets the status. Part of the HR Onboarding (HRO) app.
- **PA - Orders Management - Cancel Record**: Called from the Orders Management Power App to cancel a record. Shared across multiple apps, so no app prefix is used.

## More Information
1. [Matthew Devaney - Power Automate Coding Standards](https://www.matthewdevaney.com/power-automate-coding-standards-for-cloud-flows/)
1. [Microsoft Power Platform Guidance - Naming Conventions](https://learn.microsoft.com/en-us/power-platform/guidance/adoption/naming-conventions)

# PA-002: Description

All flows must have a description. The description should summarize the flow's purpose, the business process it supports, and any important details about its behavior.

1. **State the purpose**: Explain what the flow does in one or two sentences.
1. **Mention the trigger**: Briefly describe what initiates the flow.
1. **Include business context**: Reference the business process or requirement the flow supports.
1. **Note dependencies**: Mention any child flows, external APIs, or shared resources the flow relies on.

## Rationale

1. Providing a description for each flow ensures that anyone reviewing or maintaining the flow can quickly understand its purpose and functionality.
1. Descriptions help in documenting the flow's behavior, making it easier to troubleshoot and update in the future.
1. Well-documented flows improve collaboration among team members by providing clear context and reducing the learning curve for new team members.
1. Descriptions can also serve as a reference for stakeholders to understand the business logic implemented in the flow.

## Examples

### Good

- _"Triggered when a Contact record is created or modified in Dataverse. Sends an email notification to the account manager with the updated contact details. Calls the CF - Send Notification Email child flow."_
- _"Runs daily at 6:00 AM. Queries all open orders older than 30 days and updates their status to Expired. Part of the Order Lifecycle Management process."_

### Bad

- _"My flow"_ (meaningless, no context)
- _"Handles stuff"_ (vague, no useful information)
- No description at all

# PA-003: Trigger Names

Trigger names should be clear and descriptive to ensure that anyone reviewing the flow can quickly understand what initiates it.

1. **Use a Verb-Noun Format**: Start with a verb that describes the action, followed by a noun that specifies the object of the action.
1. **Include Key Details**: Incorporate important details such as the data store and the specific event that triggers the flow.
1. **Avoid Abbreviations**: Use full words instead of abbreviations to ensure clarity.

## Rationale

1. **Clarity**: Clear and descriptive trigger names make it easier to understand what initiates the flow.
1. **Documentation**: Well-named triggers serve as documentation, making it easier for team members and stakeholders to understand the flow's purpose.
1. **Troubleshooting**: Descriptive names simplify troubleshooting by providing immediate context about the trigger event.

## Examples

### Good

- `When a new item is created`
- `When a new contact is added to Dataverse`
- `When a file is created in SharePoint`

### Bad

- `File Created SP` (abbreviated, unclear)
- `Manually trigger a flow` (default name, not descriptive)
- `Recurrence` (default name, no indication of purpose)

# PA-004: Action Names

All actions must be renamed from their default names to clear, descriptive names that explain what the action does.

1. **Use a Verb-Noun Format**: Start with a verb that describes the action, followed by a noun that specifies the object. For example, `Get Customer Details` instead of `Get_item`.
1. **Include Key Details**: Incorporate important details such as the data source and the entity being acted upon.
1. **Be Consistent**: Use the same naming style (e.g., Title Case) across all actions in a flow.
1. **Avoid Default Names**: Never leave the auto-generated action names like `Apply_to_each`, `Condition`, or `Compose`.

## Rationale

1. Descriptive action names make the flow self-documenting and easier to understand at a glance.
1. When troubleshooting errors in flow run history, descriptive action names make it immediately obvious where the failure occurred.
1. Expressions that reference other actions (e.g., `outputs('Get_Customer_Details')`) become much more readable when actions are named descriptively.
1. When multiple team members work on the same flow, clear action names reduce the need for additional documentation.

## Examples

### Good

- `Get Customer by Email`
- `Send Approval Email to Manager`
- `Filter Active Orders`
- `Update Contact Status to Inactive`
- `Apply to Each Invoice Line`
- `Check if Account Exists`
- `Parse JSON Response from API`

### Bad

- `Get_item` (default name, unclear which item)
- `Compose` (default name, no indication of purpose)
- `Apply_to_each` (default name, unclear what is being iterated)
- `Condition` (default name, unclear what is being evaluated)
- `HTTP` (default name, unclear what endpoint is being called)

# PA-005: Variable Names

Variable names must use **camelCase** notation and be prefixed with a short type indicator to make the data type immediately obvious.

| Prefix | Data Type | Example            |
| ------ | --------- | ------------------ |
| str    | String    | strCustomerName    |
| int    | Integer   | intRetryCount      |
| bool   | Boolean   | boolIsApproved     |
| arr    | Array     | arrEmailRecipients |
| obj    | Object    | objApiResponse     |
| flt    | Float     | fltTotalAmount     |

1. **Use descriptive names**: The name should clearly indicate the purpose of the variable.
1. **Avoid abbreviations**: Use full words to ensure clarity.
1. **Avoid generic names**: Names like `temp`, `x`, or `var1` should never be used.

## Rationale

1. Type prefixes make it immediately clear what kind of data the variable holds without needing to inspect its initialization.
1. Using camelCase notation is consistent with the expression language used in Power Automate.
1. Descriptive variable names make the flow self-documenting and easier to maintain.
1. When referencing variables in expressions, clear names prevent confusion and reduce errors.

## Examples

### Good

- `strCustomerFullName`
- `intNumberOfRetries`
- `boolIsEligibleForDiscount`
- `arrPendingApprovals`
- `objOrderDetails`

### Bad

- `x` (no indication of purpose or type)
- `temp` (unclear and generic)
- `var1` (unclear and generic)
- `name` (no type prefix, ambiguous)
- `n` (single character, meaningless)

# PA-006: Connection Reference Names

Connection reference names must follow the pattern:

```
[Publisher Prefix] - [Connector Name] - [Purpose/Context]
```

- Publisher Prefix: The solution publisher prefix to identify the owning solution.
- Connector Name: The name of the connector (e.g., Dataverse, SharePoint, Outlook).
- Purpose/Context: A brief description of what the connection is used for or the environment context.

1. **Use service accounts**: Connections should use service accounts rather than personal user accounts.
1. **Reuse connection references**: Share connection references across flows within the same solution instead of creating duplicates.
1. **Document the connection**: Include a description explaining the purpose and the account used.

## Rationale

1. Descriptive connection reference names make it easier to manage connections across environments during solution deployment.
1. Using service accounts prevents flow failures when individual users leave the organization or change roles.
1. Reusing connection references reduces the number of connections that need to be configured when deploying solutions to new environments.
1. Including the purpose in the name helps administrators quickly identify and troubleshoot connection issues.

## Examples

### Good

- `csp - Dataverse - Main Application`
- `csp - SharePoint - Document Library`
- `csp - Outlook - Service Notifications`
- `csp - Teams - Approval Notifications`

### Bad

- `My Connection` (no structure, no context)
- `Dataverse` (missing publisher prefix and purpose)
- `John's SharePoint` (personal account reference, no standard format)
- `New Connection Reference` (default name, meaningless)

# PA-007: Error Handling

All cloud flows must implement error handling using the **Scope-based Try-Catch-Finally** pattern.

1. **Try Scope**: Contains the main business logic of the flow.
1. **Catch Scope**: Configured to run after the Try Scope has **failed**, **timed out**, or been **skipped**. Contains error notification and logging actions.
1. **Finally Scope**: Configured to run after the Catch Scope regardless of its outcome. Contains cleanup actions.

The Catch Scope should at minimum:
1. Log the error details (flow name, action that failed, error message) to a centralized location (e.g., Dataverse table, SharePoint list).
1. Send a notification to the flow owner or a support team.
1. Terminate the flow with a **Failed** status and include the error message.

## Rationale

1. Without error handling, flow failures can go unnoticed, leading to data inconsistencies and broken business processes.
1. The Scope-based pattern is the standard approach to error handling in Power Automate, as there is no native try-catch construct.
1. Centralized error logging provides a single place to monitor and troubleshoot all flow failures.
1. Sending notifications ensures that failures are addressed promptly.

## Examples

### Good

```
Scope: Try - Process Invoice
    ├── Get Invoice from SharePoint
    ├── Validate Invoice Data
    └── Create Record in Dataverse
Scope: Catch - Handle Errors (Run after: Try has failed, timed out, skipped)
    ├── Log Error to Dataverse Errors Table
    ├── Send Error Notification to Support Team
    └── Terminate with Failed Status
Scope: Finally - Cleanup (Run after: Catch)
    └── Update Processing Status
```

### Bad

- No error handling at all — the flow silently fails.
- Using individual "Configure Run After" on each action instead of grouping logic into Scopes.
- Catching errors but not logging or notifying anyone.

## More Information
1. [Microsoft Learn - Power Automate Limits and Configuration](https://learn.microsoft.com/en-us/power-automate/limits-and-config)

# PA-008: Initialize Variables at the Top

All variables must be initialized at the very beginning of the flow, before any other actions or logic.

1. Group all `Initialize Variable` actions together at the top of the flow.
1. Use a **Scope** named `Initialize Variables` to group them visually.
1. Do not initialize variables inside conditions, loops, or other branches.

## Rationale

1. Power Automate requires variables to be initialized at the top level of the flow — they cannot be initialized inside conditions, loops, or scopes that run in parallel.
1. Grouping all variable initializations at the top provides a clear overview of all the data the flow uses.
1. It makes it easier to identify and update default values when reviewing the flow.
1. A dedicated Scope for initialization keeps the flow organized and collapsible.

## Examples

### Good

```
Scope: Initialize Variables
    ├── Initialize strCustomerEmail
    ├── Initialize intRetryCount
    ├── Initialize boolIsProcessed
    └── Initialize arrResults
Scope: Try - Main Logic
    └── ...
```

### Bad

```
Get Items from SharePoint
Initialize strCustomerEmail        ← Mixed with other actions
Condition: Check Status
    ├── Yes: Initialize intCount   ← Inside a condition (will cause an error)
    └── No: ...
```

# PA-009: Avoid Hardcoded Values

Avoid hardcoding values such as URLs, email addresses, IDs, or configuration settings directly in flow actions or expressions. Use **Environment Variables** instead.

1. Store configurable values in **Environment Variables** within the solution.
1. Reference environment variables in your flow expressions.
1. For values that change between environments (dev, test, production), environment variables are mandatory.

## Rationale

1. Hardcoded values break flows when deploying across environments (e.g., development to production) because URLs, IDs, and endpoints differ.
1. Environment variables can be updated without modifying the flow definition, reducing the risk of introducing errors.
1. Using environment variables makes it easy to see all configurable values in one place.
1. It simplifies the deployment process across multiple environments through solution management.

## Examples

### Good

- Referencing an environment variable for a SharePoint site URL: `@{parameters('env_SharePointSiteUrl')}`
- Using an environment variable for a notification email: `@{parameters('env_SupportTeamEmail')}`
- Storing an API key in an environment variable: `@{parameters('env_ExternalApiKey')}`

### Bad

- Hardcoding a SharePoint URL: `https://contoso.sharepoint.com/sites/Operations`
- Hardcoding an email address: `support@contoso.com`
- Hardcoding a record GUID: `a1b2c3d4-e5f6-7890-abcd-ef1234567890`

# PA-010: Use Child Flows for Reusability

Extract reusable logic into **Child Flows** to avoid duplicating actions across multiple flows.

1. A child flow should perform a single, well-defined task.
1. Use clear input and output parameters to define the child flow's interface.
1. Name child flows with the `CF -` prefix as defined in [PA-001](#pa-001-naming).
1. Child flows must be **solution-aware** so they can be deployed across environments.

## Rationale

1. Duplicating the same logic across multiple flows leads to maintenance problems — a bug fix or change must be applied to every copy.
1. Child flows promote a modular design where each flow has a single responsibility.
1. Child flows reduce the total number of actions per flow, keeping flows under the 500-action limit and improving performance in the designer.
1. Changes to shared logic only need to be made in one place when using child flows.

## Examples

### Good

- A child flow `CF - Set Reference Number` that generates and assigns a reference number, called from multiple parent flows.
- A child flow `CF - Send Notification Email` that accepts a recipient, subject, and body as inputs, used across all notification scenarios.
- A child flow `CF - Validate Address` that validates and standardizes address data, reused by multiple record creation flows.

### Bad

- Copying and pasting the same 15 actions for sending a notification email into 10 different flows.
- A single monolithic flow with 400+ actions that handles multiple unrelated processes.
- Creating child flows for trivial single-action operations where the overhead is not justified.

# PA-011: Add Notes to Complex Actions

Use the built-in **Notes** feature to document complex expressions, business logic, and non-obvious design decisions within the flow.

1. Add notes to actions that contain complex expressions or formulas.
1. Document the business rule or requirement that drives a particular condition or branch.
1. Explain any workarounds or non-obvious implementations.

## Rationale

1. Power Automate expressions can be difficult to read, especially when they involve nested functions. Notes provide human-readable context.
1. Business rules are often not obvious from the flow structure alone. Notes help future maintainers understand the *why* behind the logic.
1. Notes are visible directly in the designer, making them more discoverable than external documentation.
1. When troubleshooting, notes can save significant time by explaining the expected behavior.

## Examples

### Good

- Adding a note to a complex Compose action: _"Calculates the fiscal quarter based on the invoice date. Fiscal year starts in April."_
- Adding a note to a Condition action: _"Checks if the order total exceeds the auto-approval threshold defined by Finance ($5,000)."_
- Adding a note to an HTTP action: _"Calls the external tax calculation API. Retry logic is handled by the parent Scope."_

### Bad

- No notes anywhere in a flow with 50+ actions and complex expressions.
- Adding obvious notes like _"This sends an email"_ on a `Send an email` action.

# PA-012: Solution-Aware Flows

All cloud flows must be created inside a **Solution**. Avoid creating flows outside of solutions (known as "non-solution flows" or "My Flows").

1. Create all flows within a managed or unmanaged solution.
1. Use a consistent solution publisher prefix.
1. Include all related components (connection references, environment variables, child flows) in the same solution.

## Rationale

1. Solution-aware flows can be exported and imported across environments, enabling proper Application Lifecycle Management (ALM).
1. Non-solution flows cannot be easily migrated between environments and are tied to the creator's account.
1. Solution-aware flows support connection references, which decouple the flow from specific user connections.
1. Solutions enable version control, change tracking, and managed deployments through pipelines.

## Examples

### Good

- Creating a flow inside the `Orders Management` solution alongside its related tables, connection references, and environment variables.
- Using a solution publisher prefix `csp` and including all flows for a business process in one solution.

### Bad

- Creating a flow from the **My Flows** section of the Power Automate portal.
- Having related flows scattered across multiple solutions with no clear organization.
- Creating flows outside of solutions and manually recreating them in each environment.

## More Information
1. [Microsoft Learn - Solutions Overview](https://learn.microsoft.com/en-us/power-apps/maker/data-platform/solutions-overview)

# PA-013: Dataverse Trigger Configuration

Dataverse triggers must always be configured with the specific fields that should trigger the flow, and must include condition expressions to filter the triggering events.

1. **Select triggering columns**: In the trigger's **Column filter** property, specify only the columns that should cause the flow to run. Never leave this empty to trigger on all column changes.
1. **Add filter expressions**: Use the trigger's **Filter rows** property to include condition expressions (OData filter) that limit when the flow fires (e.g., only when a status changes to a specific value).
1. **Combine column and row filters**: Use both column filters and row filter expressions together to ensure the flow only triggers when the relevant data changes meet the expected criteria.

## Rationale

1. Without a column filter, the flow triggers on every update to the record, even for irrelevant field changes. This leads to unnecessary flow runs, wasted API calls, and potential throttling.
1. Condition expressions on the trigger prevent the flow from running when the data change does not match the business scenario, reducing execution costs and avoiding unwanted side effects.
1. Properly filtered triggers improve overall environment performance and reduce the risk of hitting Power Automate daily execution limits.
1. Explicit trigger configuration serves as documentation, making it clear what conditions the flow is designed to handle.

## Examples

### Good

- Column filter set to `statuscode` and filter expression `statuscode eq 5` — the flow only triggers when the Status Reason changes to the Approved value.
- Column filter set to `emailaddress1,telephone1` — the flow only triggers when the primary email or phone number changes.
- Column filter set to `csp_review_status` and filter expression `csp_review_status eq 100000001` — the flow only triggers when the review status changes to Complete.

### Bad

- No column filter set — the flow triggers on every field update, including system fields like `modifiedon`.
- No filter expression — the flow triggers for all status values, not just the one the business logic requires.
- Relying on a Condition action inside the flow to check field values instead of filtering at the trigger level — wastes a flow run for every non-matching event.

## More Information
1. [Microsoft Learn - Dataverse Connector Triggers](https://learn.microsoft.com/en-us/connectors/commondataserviceforapps/#triggers)
1. [Microsoft Learn - Limits of Triggers in Dataverse](https://learn.microsoft.com/en-us/power-automate/dataverse/trigger-limits)

# PA-014: Dataverse Query Optimization

When querying Dataverse, minimize the number of columns and rows retrieved to optimize performance and reduce API consumption.

1. **Minimize columns**: Use the **Select columns** property or FetchXML `attribute` elements to retrieve only the fields needed by the flow. Never retrieve all columns.
1. **Set page size and count**: When using FetchXML queries, always set the `count` attribute on the `<fetch>` element to limit the number of rows per page (e.g., `<fetch count="50">`).
1. **Add filters**: Always include `<filter>` elements in FetchXML or OData `$filter` expressions to restrict the rows returned to only those needed by the flow.
1. **Avoid unbounded queries**: Never use a List Rows action or FetchXML query without a filter — always constrain the result set.

## Rationale

1. Retrieving all columns increases response payload size, slows down the flow, and consumes more API throughput capacity.
1. Without a row count limit, large tables can return thousands of rows, causing the flow to hit Dataverse API limits and time out.
1. Filters reduce the load on the Dataverse platform, improving performance for both the flow and other users sharing the same environment.
1. Optimized queries reduce the number of API requests consumed, helping stay within the daily Power Platform request limits.

## Examples

### Good

FetchXML with selected attributes, count, and filter:
```xml
<fetch count="50">
  <entity name="contact">
    <attribute name="fullname" />
    <attribute name="emailaddress1" />
    <filter>
      <condition attribute="statuscode" operator="eq" value="1" />
    </filter>
  </entity>
</fetch>
```

List Rows action with selected columns and filter:
- **Select columns**: `fullname,emailaddress1`
- **Filter rows**: `statuscode eq 1`
- **Row count**: `50`

### Bad

- Using List Rows with no column selection — retrieves all columns for every row.
- FetchXML without a `count` attribute — retrieves all matching rows without pagination.
- No filter applied — retrieves the entire table regardless of how many rows are actually needed.
- Using `<all-attributes />` in FetchXML instead of specifying individual `<attribute>` elements.

## More Information
1. [Microsoft Learn - Query Data Using FetchXML](https://learn.microsoft.com/en-us/power-apps/developer/data-platform/use-fetchxml-construct-query)
1. [Microsoft Learn - Optimize Performance for Dataverse](https://learn.microsoft.com/en-us/power-apps/developer/data-platform/optimize-performance)