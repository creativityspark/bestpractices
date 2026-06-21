# Cloud Flows

Good practices for Power Automate flows.

## PA-001

### Title

Name cloud flows using the standard pattern

### Description

Cloud flow names must follow a consistent pattern that identifies the owning app, trigger connector, data source, triggering event, and business purpose.

### Guidelines

1. Use the pattern "[App Prefix] - [Connector Prefix] - [Data Store] - [Event Name Code(s)] - [Action/Purpose]" when naming cloud flows.
1. Use a 3-letter app prefix to group flows that belong to the same application.
1. Omit the app prefix when the flow is shared across multiple applications.
1. Use the connector prefix to identify the connector used by the trigger.
1. Use the data store segment to identify the table, list, mailbox, app, schedule, or other trigger-backed store.
1. Omit the data store segment when the trigger does not have an associated data store, such as a manual trigger.
1. Use event name codes such as NEW, MOD, and DEL, and combine codes when multiple events trigger the flow.
1. Use a brief action or purpose segment that clearly describes what the flow does.

### Rationale

1. Having naming conventions in place makes the task of choosing names easier.
1. The app prefix groups all flows belonging to the same application together in alphabetical lists, making them easier to find and manage.
1. Including the trigger prefix and data store name makes it easier to identify and select flows in the UI.
1. Consistent naming conventions make it easier to group similar flows together by name.
1. The action or purpose segment makes it easy to understand what the flow is doing.

### Pattern

```
[App Prefix] - [Connector Prefix] - [Data Store] - [Event Name Code(s)] - [Action/Purpose]
```

### Pattern Segments

| Name | Description | Optional |
| ---- | ----------- | -------- |
| App Prefix | A 3-letter code that identifies the application the flow belongs to. | Yes |
| Connector Prefix | Identifies the connector used in the trigger of the flow. | No |
| Data Store | Identifies the data source behind the trigger, such as a Dataverse table, SharePoint list, mailbox, schedule period, or app name. | Yes |
| Event Name Code(s) | Identifies the event that triggered the flow, such as create, update, delete, or a combination of those events. | No |
| Action/Purpose | Brief text describing the purpose or the action taken by the flow. | No |

### Examples

#### Good

- ORM - DV - Contact - NEWMOD - Send Notifications: Sends a notification when a Dataverse Contact record is created or modified for the Orders Management app.
- ORM - DV - Account - MOD - Validations: Performs validations when an Account record is updated in Dataverse for the Orders Management app.
- ORM - SP - Orders - MOD - Move out of notice wait period: Handles updates to the Orders SharePoint list for the Orders Management app.
- HRO - CF - Set Reference Number: Names a child flow that sets a reference number for the HR Onboarding app.
- HRO - SCH - Daily - Set Status: Names a scheduled flow that runs daily and sets status for the HR Onboarding app.
- PA - Orders Management - Cancel Record: Omits the app prefix because the flow is shared across multiple apps and is triggered from Power Apps.

#### Bad

- Send Notifications: Omits the app, connector, data store, and event segments required to make the name self-descriptive.
- ORM - Contact - Send Notifications: Omits the connector prefix and event code segments.

### More Information

1. [Matthew Devaney - Power Automate Coding Standards](https://www.matthewdevaney.com/power-automate-coding-standards-for-cloud-flows/)
1. [Microsoft Power Platform Guidance - Naming Conventions](https://learn.microsoft.com/en-us/power-platform/guidance/adoption/naming-conventions)

## PA-002

### Title

Add meaningful descriptions to all flows

### Description

Every flow must have a description that summarizes its purpose, the business process it supports, and important details about how it behaves.

### Guidelines

1. State the purpose of the flow in one or two sentences.
1. Mention what triggers the flow.
1. Include the business process or requirement the flow supports.
1. Note any child flows, external APIs, or shared resources the flow relies on.

### Rationale

1. Providing a description for each flow ensures that anyone reviewing or maintaining it can quickly understand its purpose and functionality.
1. Descriptions help document the flow's behavior, making it easier to troubleshoot and update in the future.
1. Well-documented flows improve collaboration by providing context and reducing the learning curve for new team members.
1. Descriptions also help stakeholders understand the business logic implemented in the flow.



### Examples

#### Good

- Triggered when a Contact record is created or modified in Dataverse. Sends an email notification to the account manager with the updated contact details. Calls the CF - Send Notification Email child flow.: Clearly states the trigger, purpose, and dependency.
- Runs daily at 6:00 AM. Queries all open orders older than 30 days and updates their status to Expired. Part of the Order Lifecycle Management process.: Includes timing, behavior, and business context.

#### Bad

- My flow: Meaningless and provides no context.
- Handles stuff: Vague and not actionable for maintainers.
- No description at all.

### More Information

1. [Microsoft Learn - Power Automate Documentation](https://learn.microsoft.com/en-us/power-automate/)

## PA-003

### Title

Give triggers clear descriptive names

### Description

Trigger names should be clear and descriptive so reviewers can quickly understand what initiates the flow.

### Guidelines

1. Use a verb-noun format for trigger names.
1. Include key details such as the data store and triggering event.
1. Avoid abbreviations and prefer full words for clarity.

### Rationale

1. Clear and descriptive trigger names make it easier to understand what initiates the flow.
1. Well-named triggers serve as documentation for team members and stakeholders.
1. Descriptive names simplify troubleshooting by providing immediate context.



### Examples

#### Good

- When a new item is created: Clearly describes the event in plain language.
- When a new contact is added to Dataverse: Includes both the event and the data source.
- When a file is created in SharePoint: Uses full words and identifies the source system.

#### Bad

- File Created SP: Abbreviated and unclear.
- Manually trigger a flow: Default name that does not describe the business purpose.
- Recurrence: Default name with no indication of what the schedule is for.

### More Information

1. [Microsoft Power Platform Guidance - Naming Conventions](https://learn.microsoft.com/en-us/power-platform/guidance/adoption/naming-conventions)

## PA-004

### Title

Rename actions with clear descriptive names

### Description

All actions must be renamed from their default names to clear, descriptive names that explain what each action does.

### Guidelines

1. Use a verb-noun format for action names.
1. Include key details such as the data source and entity being acted on.
1. Use a consistent naming style, such as Title Case, across all actions in a flow.
1. Never leave default auto-generated action names such as Apply_to_each, Condition, Compose, or HTTP.

### Rationale

1. Descriptive action names make the flow self-documenting and easier to understand at a glance.
1. In run history, descriptive action names make it immediately obvious where a failure occurred.
1. Expressions that reference other actions are much more readable when actions are named descriptively.
1. Clear action names reduce the need for additional documentation when multiple team members work on the same flow.



### Examples

#### Good

- Get Customer by Email: Describes both the action and the lookup key.
- Send Approval Email to Manager: Explains the action and the recipient.
- Filter Active Orders: Clearly describes the filtering purpose.
- Update Contact Status to Inactive: Identifies both the entity and intended state change.
- Apply to Each Invoice Line: Makes the loop target explicit.
- Check if Account Exists: Explains the condition being evaluated.
- Parse JSON Response from API: Identifies both the action and the data source.

#### Bad

- Get_item: Default name and unclear which item is retrieved.
- Compose: Default name with no business meaning.
- Apply_to_each: Default name and unclear what is being iterated.
- Condition: Default name and unclear what is being evaluated.
- HTTP: Default name and unclear what endpoint is being called.

### More Information

1. [Microsoft Learn - Power Automate Documentation](https://learn.microsoft.com/en-us/power-automate/)

## PA-005

### Title

Name variables with typed camelCase

### Description

Variable names must use camelCase notation and a short type prefix so the data type is immediately obvious.

### Guidelines

1. Use a short type prefix such as str, int, bool, arr, obj, or flt at the start of each variable name.
1. Use camelCase after the type prefix.
1. Use descriptive names that clearly indicate the purpose of the variable.
1. Avoid abbreviations, generic names, and meaningless one-character identifiers.

### Rationale

1. Type prefixes make it immediately clear what kind of data the variable holds without inspecting its initialization.
1. camelCase notation is consistent with the expression language used in Power Automate.
1. Descriptive variable names make the flow self-documenting and easier to maintain.
1. Clear variable names reduce confusion and errors when variables are referenced in expressions.



### Examples

#### Good

- strCustomerFullName: String variable with a descriptive name.
- intNumberOfRetries: Integer variable that clearly expresses its purpose.
- boolIsEligibleForDiscount: Boolean variable that reads as a condition.
- arrPendingApprovals: Array variable with a meaningful collection name.
- objOrderDetails: Object variable that clearly identifies its contents.

#### Bad

- x: No indication of purpose or type.
- temp: Generic and unclear.
- var1: Generic and unclear.
- name: Missing a type prefix and ambiguous.
- n: Single-character name with no meaning.

### More Information

1. [Microsoft Learn - Power Automate Documentation](https://learn.microsoft.com/en-us/power-automate/)

## PA-006

### Title

Name connection references using the standard pattern

### Description

Connection reference names must follow a standard pattern that identifies the solution publisher, the connector, and the purpose or context of the connection.

### Guidelines

1. Use the pattern "[Publisher Prefix] - [Connector Name] - [Purpose/Context]" for connection references.
1. Use the solution publisher prefix to identify the owning solution.
1. Use the connector name segment to identify the connector, such as Dataverse, SharePoint, Outlook, or Teams.
1. Use a purpose or context segment that briefly describes how the connection is used or what environment it belongs to.
1. Use service accounts instead of personal user accounts for connections.
1. Reuse connection references across flows in the same solution instead of creating duplicates.
1. Document the connection with a description that explains its purpose and the account used.

### Rationale

1. Descriptive connection reference names make it easier to manage connections across environments during solution deployment.
1. Using service accounts prevents failures when individual users leave the organization or change roles.
1. Reusing connection references reduces the number of connections that must be configured when deploying solutions to new environments.
1. Including the purpose in the name helps administrators identify and troubleshoot connection issues quickly.

### Pattern

```
[Publisher Prefix] - [Connector Name] - [Purpose/Context]
```

### Pattern Segments

| Name | Description | Optional |
| ---- | ----------- | -------- |
| Publisher Prefix | The solution publisher prefix that identifies the owning solution. | No |
| Connector Name | The connector name, such as Dataverse, SharePoint, Outlook, or Teams. | No |
| Purpose/Context | A brief description of what the connection is used for or the environment context. | No |

### Examples

#### Good

- csp - Dataverse - Main Application: Identifies the publisher, connector, and business context.
- csp - SharePoint - Document Library: Names the connector reference according to the required structure.
- csp - Outlook - Service Notifications: Describes how the connection is used.
- csp - Teams - Approval Notifications: Includes the publisher prefix and purpose.

#### Bad

- My Connection: No structure and no context.
- Dataverse: Missing the publisher prefix and purpose.
- John's SharePoint: Uses a personal account reference and no standard format.
- New Connection Reference: Default name with no meaning.

### More Information

1. [Microsoft Learn - Solutions Overview](https://learn.microsoft.com/en-us/power-apps/maker/data-platform/solutions-overview)

## PA-007

### Title

Implement scope-based try-catch-finally error handling

### Description

All cloud flows must implement error handling using the Scope-based Try-Catch-Finally pattern.

### Guidelines

1. Put the main business logic inside a Try scope.
1. Configure a Catch scope to run after the Try scope has failed, timed out, or been skipped.
1. Configure a Finally scope to run after the Catch scope regardless of outcome.
1. In the Catch scope, log the flow name, failed action, and error message to a centralized location.
1. In the Catch scope, send a notification to the flow owner or support team.
1. In the Catch scope, terminate the flow with a Failed status and include the error message.

### Rationale

1. Without error handling, flow failures can go unnoticed, leading to data inconsistencies and broken business processes.
1. The scope-based pattern is the standard approach to error handling in Power Automate because there is no native try-catch construct.
1. Centralized error logging provides a single place to monitor and troubleshoot flow failures.
1. Sending notifications helps ensure failures are addressed promptly.



### Examples

#### Good

Uses dedicated Try, Catch, and Finally scopes to group business logic, error handling, and cleanup.
```Plain Text
Scope: Try - Process Invoice
    Get Invoice from SharePoint
    Validate Invoice Data
    Create Record in Dataverse
Scope: Catch - Handle Errors (Run after: Try has failed, timed out, skipped)
    Log Error to Dataverse Errors Table
    Send Error Notification to Support Team
    Terminate with Failed Status
Scope: Finally - Cleanup (Run after: Catch)
    Update Processing Status

```

#### Bad

- No error handling at all, so the flow silently fails.
- Uses individual Configure Run After settings on each action instead of grouping logic into scopes.
- Catches errors but does not log them or notify anyone.

### More Information

1. [Microsoft Learn - Power Automate Limits and Configuration](https://learn.microsoft.com/en-us/power-automate/limits-and-config)

## PA-008

### Title

Initialize all variables at the start of the flow

### Description

All variables must be initialized at the beginning of the flow before any other actions or logic.

### Guidelines

1. Group all Initialize Variable actions together at the top of the flow.
1. Use a scope named Initialize Variables to group the initialization actions visually.
1. Do not initialize variables inside conditions, loops, or other branches.

### Rationale

1. Power Automate requires variables to be initialized at the top level of the flow and not inside conditions, loops, or parallel scopes.
1. Grouping variable initialization at the top provides a clear overview of all data used by the flow.
1. Keeping default values together makes them easier to identify and update.
1. A dedicated initialization scope keeps the flow organized and collapsible.



### Examples

#### Good

Groups all variable initialization actions at the top of the flow inside a dedicated scope.
```Plain Text
Scope: Initialize Variables
    Initialize strCustomerEmail
    Initialize intRetryCount
    Initialize boolIsProcessed
    Initialize arrResults
Scope: Try - Main Logic
    ...

```

#### Bad

Mixes initialization with other actions and initializes a variable inside a condition branch.
```Plain Text
Get Items from SharePoint
Initialize strCustomerEmail
Condition: Check Status
    Yes: Initialize intCount
    No: ...

```

### More Information

1. [Microsoft Learn - Power Automate Documentation](https://learn.microsoft.com/en-us/power-automate/)

## PA-009

### Title

Use environment variables instead of hardcoded values

### Description

Avoid hardcoding URLs, email addresses, IDs, or configuration settings directly in flow actions or expressions, and use environment variables instead.

### Guidelines

1. Store configurable values in environment variables within the solution.
1. Reference environment variables in flow expressions.
1. Treat environment variables as mandatory for values that change between development, test, and production environments.

### Rationale

1. Hardcoded values break flows during deployment across environments because URLs, IDs, and endpoints differ.
1. Environment variables can be updated without modifying the flow definition, reducing the risk of introducing errors.
1. Environment variables make configurable values easier to find and manage in one place.
1. They simplify multi-environment deployment through solution management.



### Examples

#### Good

- @{parameters('env_SharePointSiteUrl')}: References an environment variable for a SharePoint site URL.
- @{parameters('env_SupportTeamEmail')}: References an environment variable for a notification email address.
- @{parameters('env_ExternalApiKey')}: References an environment variable for an API key.

#### Bad

- https://contoso.sharepoint.com/sites/Operations: Hardcoded SharePoint URL.
- support@contoso.com: Hardcoded email address.
- a1b2c3d4-e5f6-7890-abcd-ef1234567890: Hardcoded record GUID.

### More Information

1. [Microsoft Learn - Solutions Overview](https://learn.microsoft.com/en-us/power-apps/maker/data-platform/solutions-overview)

## PA-010

### Title

Extract reusable logic into child flows

### Description

Reusable logic should be extracted into child flows to avoid duplicating the same actions across multiple cloud flows.

### Guidelines

1. Use child flows for single, well-defined tasks.
1. Define clear input and output parameters for each child flow.
1. Name child flows with the CF prefix as described in PA-001.
1. Make child flows solution-aware so they can be deployed across environments.

### Rationale

1. Duplicating the same logic across multiple flows creates maintenance problems because fixes and changes must be applied everywhere.
1. Child flows promote modular design and help each flow keep a single responsibility.
1. Child flows reduce the number of actions in parent flows, helping stay under designer and platform limits.
1. Shared logic only needs to be updated in one place when child flows are used.



### Examples

#### Good

- CF - Set Reference Number: Child flow that generates and assigns a reference number for reuse across multiple parent flows.
- CF - Send Notification Email: Child flow that accepts recipient, subject, and body inputs for reuse across notification scenarios.
- CF - Validate Address: Child flow that validates and standardizes address data for reuse by multiple record creation flows.

#### Bad

- Copying and pasting the same 15 actions for sending a notification email into 10 different flows.
- A single monolithic flow with more than 400 actions that handles multiple unrelated processes.
- Creating child flows for trivial single-action operations where the overhead is not justified.

### More Information

1. [Microsoft Learn - Power Automate Documentation](https://learn.microsoft.com/en-us/power-automate/)

## PA-011

### Title

Use notes to document complex logic

### Description

Use the built-in Notes feature to document complex expressions, business logic, and non-obvious design decisions within the flow.

### Guidelines

1. Add notes to actions that contain complex expressions or formulas.
1. Document the business rule or requirement behind a condition or branch.
1. Explain any workaround or non-obvious implementation detail.

### Rationale

1. Power Automate expressions can be difficult to read, especially when they involve nested functions, so notes provide essential human-readable context.
1. Business rules are often not obvious from flow structure alone, and notes help maintainers understand why the logic exists.
1. Notes are visible directly in the designer, which makes them more discoverable than external documentation.
1. Notes can save significant troubleshooting time by explaining expected behavior.



### Examples

#### Good

- Add a note to a complex Compose action: "Calculates the fiscal quarter based on the invoice date. Fiscal year starts in April."
- Add a note to a Condition action: "Checks if the order total exceeds the auto-approval threshold defined by Finance ($5,000)."
- Add a note to an HTTP action: "Calls the external tax calculation API. Retry logic is handled by the parent Scope."

#### Bad

- No notes anywhere in a flow with more than 50 actions and complex expressions.
- Adding obvious notes like "This sends an email" on a Send an email action.

### More Information

1. [Microsoft Learn - Power Automate Documentation](https://learn.microsoft.com/en-us/power-automate/)

## PA-012

### Title

Create all cloud flows inside solutions

### Description

All cloud flows must be created inside solutions and should not be created as non-solution flows or personal My Flows.

### Guidelines

1. Create all flows within a managed or unmanaged solution.
1. Use a consistent solution publisher prefix.
1. Keep related components such as connection references, environment variables, and child flows in the same solution.

### Rationale

1. Solution-aware flows can be exported and imported across environments, enabling proper ALM.
1. Non-solution flows are difficult to migrate between environments and are tied to the creator's account.
1. Solution-aware flows support connection references, which decouple flows from specific user connections.
1. Solutions enable version control, change tracking, and managed deployments through pipelines.



### Examples

#### Good

- Creating a flow inside the Orders Management solution alongside its related tables, connection references, and environment variables.
- csp: Uses a consistent solution publisher prefix and groups related flows in one solution.

#### Bad

- Creating a flow from the My Flows section of the Power Automate portal.
- Having related flows scattered across multiple solutions with no clear organization.
- Creating flows outside of solutions and manually recreating them in each environment.

### More Information

1. [Microsoft Learn - Solutions Overview](https://learn.microsoft.com/en-us/power-apps/maker/data-platform/solutions-overview)

## PA-013

### Title

Filter Dataverse triggers by columns and conditions

### Description

Dataverse triggers must specify the columns that should trigger the flow and include filter expressions that limit triggering events to the intended business scenario.

### Guidelines

1. In the trigger's Column filter property, specify only the columns that should cause the flow to run.
1. Never leave the Column filter empty when only specific field changes are relevant.
1. In the trigger's Filter rows property, add OData conditions that limit when the flow fires.
1. Use column filters and row filters together so the flow only runs when relevant data changes meet the expected criteria.

### Rationale

1. Without a column filter, the flow triggers on every update, including irrelevant field changes, which wastes runs and API calls.
1. Trigger-level filter expressions prevent the flow from running when data changes do not match the business scenario.
1. Properly filtered triggers improve environment performance and reduce the risk of hitting execution limits.
1. Explicit trigger configuration makes intended behavior easier to understand and maintain.



### Examples

#### Good

- Column filter set to statuscode and filter expression statuscode eq 5 so the flow only triggers when Status Reason changes to Approved.
- Column filter set to emailaddress1,telephone1 so the flow only triggers when the primary email or phone number changes.
- Column filter set to csp_review_status and filter expression csp_review_status eq 100000001 so the flow only triggers when review status changes to Complete.

#### Bad

- No column filter set, so the flow triggers on every field update including system fields such as modifiedon.
- No filter expression, so the flow triggers for all status values instead of just the required business state.
- Using a Condition action inside the flow to check field values instead of filtering at the trigger level, which wastes a flow run for every non-matching event.

### More Information

1. [Microsoft Learn - Dataverse Connector Triggers](https://learn.microsoft.com/en-us/connectors/commondataserviceforapps/#triggers)
1. [Microsoft Learn - Limits of Triggers in Dataverse](https://learn.microsoft.com/en-us/power-automate/dataverse/trigger-limits)

## PA-014

### Title

Minimize Dataverse query columns and rows

### Description

When querying Dataverse, retrieve only the columns and rows required by the flow to improve performance and reduce API consumption.

### Guidelines

1. Use Select columns or FetchXML attribute elements to retrieve only the fields the flow needs.
1. Never retrieve all columns.
1. When using FetchXML, set the count attribute on the fetch element to limit the number of rows per page.
1. Add filter elements in FetchXML or OData filter expressions to restrict rows to only those needed by the flow.
1. Never use List Rows or FetchXML queries without a filter that constrains the result set.

### Rationale

1. Retrieving all columns increases payload size, slows the flow, and consumes more API throughput capacity.
1. Without a row count limit, large tables can return thousands of rows and cause timeouts or API limit issues.
1. Filters reduce load on Dataverse, improving performance for both the flow and other users in the environment.
1. Optimized queries reduce API request consumption and help stay within daily Power Platform request limits.



### Examples

#### Good

FetchXML with selected attributes, a count limit, and a filter.
```XML
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
List Rows action configured with selected columns, a filter, and a row count.
```Plain Text
Select columns: fullname,emailaddress1
Filter rows: statuscode eq 1
Row count: 50

```

#### Bad

- Using List Rows with no column selection, which retrieves all columns for every row.
- Using FetchXML without a count attribute, which retrieves all matching rows without pagination.
- Applying no filter, which retrieves the entire table regardless of how many rows are needed.
- Using <all-attributes /> in FetchXML instead of specifying individual attribute elements.

### More Information

1. [Microsoft Learn - Query Data Using FetchXML](https://learn.microsoft.com/en-us/power-apps/developer/data-platform/use-fetchxml-construct-query)
1. [Microsoft Learn - Optimize Performance for Dataverse](https://learn.microsoft.com/en-us/power-apps/developer/data-platform/optimize-performance)


