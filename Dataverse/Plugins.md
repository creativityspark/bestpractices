# Plugins

Good practices for Dataverse C# Plugins.

# PLG-001

Plugin class names must follow the pattern:

```
[Table Schema Name]_[Pipeline Stage][Event Name]_[Action/Purpose]
```

- **Table Schema Name**: The schema name of the table the plugin is registered against.
- **Pipeline Stage**: A short code for the pipeline stage (`PreVal`, `PreOp`, `PostOp`).
- **Event Name**: The SDK message name (`Create`, `Update`, `Delete`, `Retrieve`, etc.).
- **Action/Purpose**: Brief text describing the purpose of the plugin.

## Pipeline Stage Codes

| Code    | Pipeline Stage  |
| ------- | --------------- |
| PreVal  | Pre-Validation  |
| PreOp   | Pre-Operation   |
| PostOp  | Post-Operation  |

## Rationale

1. Consistent naming makes it easy to identify what a plugin does at a glance when browsing plugin registrations or reviewing code.
1. Including the table name and pipeline stage in the class name avoids confusion when multiple plugins are registered on the same table or event.
1. The naming convention aligns with how plugin steps are displayed in the Plugin Registration Tool.

## Examples

### Good

- `Account_PreOp_Update_ValidateEmail`
- `Contact_PostOp_Create_SendWelcomeNotification`
- `Order_PreVal_Delete_PreventActiveOrderDeletion`

### Bad

- `Plugin1` — meaningless, provides no context about the table, stage, or purpose.
- `AccountPlugin` — too generic; does not indicate the event, stage, or what it does.
- `DoStuff` — no naming structure whatsoever.

## More Information
1. [Write a plug-in - Microsoft Learn](https://learn.microsoft.com/en-us/power-apps/developer/data-platform/write-plug-in)

# PLG-002

Always throw `InvalidPluginExecutionException` for business rule violations and validation errors. Never throw generic .NET exceptions from plugin code.

1. Use `InvalidPluginExecutionException` to communicate validation failures, business rule violations, or any condition that should cancel the operation and display a message to the user.
1. Catch unexpected exceptions and wrap them with `InvalidPluginExecutionException` before re-throwing, including a user-friendly message.
1. Do not include HTML, stack traces, or sensitive data in the exception message.

## Rationale

1. `InvalidPluginExecutionException` is the only exception type that the platform recognizes and surfaces as a user-friendly message in the UI. Generic exceptions result in an unhelpful "ISV Unexpected" error.
1. Wrapping unexpected exceptions ensures that the user and support staff receive actionable error messages instead of cryptic system errors.
1. Including sensitive data or stack traces in exception messages poses a security risk, as these messages are displayed to end users.

## Examples

### Good

```csharp
if (string.IsNullOrEmpty(email))
{
    throw new InvalidPluginExecutionException(
        "The Email field is required. Please provide a valid email address before saving.");
}
```

```csharp
try
{
    // Business logic
}
catch (Exception ex)
{
    tracingService.Trace("Unexpected error: {0}", ex.ToString());
    throw new InvalidPluginExecutionException(
        "An unexpected error occurred while processing the record. Please contact support.", ex);
}
```

### Bad

```csharp
// Throws a generic exception — user sees "ISV Unexpected" with no useful message
throw new Exception("Something went wrong");
```

```csharp
// Exposes stack trace and internal details to the end user
throw new InvalidPluginExecutionException(ex.ToString());
```

## More Information
1. [Use InvalidPluginExecutionException in plug-ins - Microsoft Learn](https://learn.microsoft.com/en-us/power-apps/developer/data-platform/best-practices/business-logic/use-invalidpluginexecutionexception-plugin-workflow-activities)

# PLG-003

Always use `ITracingService` to log diagnostic information at key points in the plugin execution flow.

1. Obtain the `ITracingService` instance from the `IServiceProvider` and use it to log execution flow, input values, and error details.
1. Log at the beginning and end of the plugin, before and after key operations, and before throwing exceptions.
1. Never use `Console.WriteLine`, `Debug.WriteLine`, or any other logging mechanism — only `ITracingService` is supported.

## Rationale

1. `ITracingService` writes to the Plugin Trace Log, which is the only supported diagnostic mechanism for Dataverse plugins running in sandbox isolation.
1. Detailed trace logs are essential for diagnosing production issues, especially when you cannot attach a debugger.
1. Tracing before throwing `InvalidPluginExecutionException` captures the context leading to the error, making postmortem analysis significantly easier.

## Examples

### Good

```csharp
public void Execute(IServiceProvider serviceProvider)
{
    var tracingService = (ITracingService)serviceProvider.GetService(typeof(ITracingService));
    tracingService.Trace("Plugin execution started.");

    var context = (IPluginExecutionContext)serviceProvider.GetService(typeof(IPluginExecutionContext));
    tracingService.Trace("Message: {0}, Entity: {1}, Depth: {2}",
        context.MessageName, context.PrimaryEntityName, context.Depth);

    try
    {
        // Business logic
        tracingService.Trace("Validation passed. Updating record.");
    }
    catch (Exception ex)
    {
        tracingService.Trace("Error: {0}", ex.ToString());
        throw new InvalidPluginExecutionException("An error occurred. Please contact support.", ex);
    }
}
```

### Bad

```csharp
// No tracing at all — impossible to diagnose issues in production
public void Execute(IServiceProvider serviceProvider)
{
    var context = (IPluginExecutionContext)serviceProvider.GetService(typeof(IPluginExecutionContext));
    // Business logic with no trace statements
}
```

```csharp
// Using Console.WriteLine — output is lost in the Dataverse sandbox environment
Console.WriteLine("Plugin started");
```

## More Information
1. [Use ITracingService in plug-ins - Microsoft Learn](https://learn.microsoft.com/en-us/power-apps/developer/data-platform/best-practices/business-logic/use-itracingservice-plugins)
1. [Debug plug-ins - Microsoft Learn](https://learn.microsoft.com/en-us/power-apps/developer/data-platform/debug-plug-in)

# PLG-004

Plugins must be stateless. Do not use instance variables, static fields, or singletons to store data between plugin executions.

1. Do not declare instance fields or static fields that hold state across executions.
1. All data needed for execution must be obtained from the `IServiceProvider` and the execution context within the `Execute` method.
1. The only safe use of class-level fields is for immutable configuration values set in the constructor from the plugin's unsecure or secure configuration strings.

## Rationale

1. The Dataverse platform may cache and reuse plugin instances across multiple executions and threads. Instance or static state can be shared unpredictably, leading to race conditions, data corruption, and hard-to-reproduce bugs.
1. Plugins are expected to execute in a thread-safe, stateless manner. Any data that persists between invocations violates this contract.

## Examples

### Good

```csharp
public class AccountPostCreate : IPlugin
{
    private readonly string _config; // Immutable, set once in constructor

    public AccountPostCreate(string unsecureConfig, string secureConfig)
    {
        _config = unsecureConfig; // Safe: set once, never modified
    }

    public void Execute(IServiceProvider serviceProvider)
    {
        // All state is obtained from serviceProvider
        var context = (IPluginExecutionContext)serviceProvider.GetService(typeof(IPluginExecutionContext));
        var target = (Entity)context.InputParameters["Target"];
        // Process target...
    }
}
```

### Bad

```csharp
public class AccountPostCreate : IPlugin
{
    private int _executionCount = 0; // Shared across threads — race condition
    private Entity _lastProcessedEntity; // Leaks data between executions

    public void Execute(IServiceProvider serviceProvider)
    {
        _executionCount++;
        _lastProcessedEntity = (Entity)context.InputParameters["Target"];
    }
}
```

## More Information
1. [Write a plug-in - Microsoft Learn](https://learn.microsoft.com/en-us/power-apps/developer/data-platform/write-plug-in)
1. [Best practices for plug-in and workflow development - Microsoft Learn](https://learn.microsoft.com/en-us/power-apps/developer/data-platform/best-practices/business-logic)

# PLG-005

Always check the execution depth to prevent infinite plugin loops.

1. Check `IPluginExecutionContext.Depth` at the beginning of the plugin and return early if the depth exceeds the expected value.
1. The appropriate depth threshold depends on your scenario, but a depth of 1 is typical for most plugins that should only execute on the original trigger.

## Rationale

1. When a plugin modifies a record, it can trigger other plugins (or itself again) on the same or related tables, creating a recursive loop.
1. Dataverse enforces a maximum execution depth (currently 8). Exceeding this limit terminates the pipeline with a runtime error, causing a poor user experience and potential data inconsistency.
1. An early depth check avoids unnecessary processing and protects against infinite recursion.

## Examples

### Good

```csharp
public void Execute(IServiceProvider serviceProvider)
{
    var context = (IPluginExecutionContext)serviceProvider.GetService(typeof(IPluginExecutionContext));

    if (context.Depth > 1)
    {
        return; // Avoid recursive execution
    }

    // Continue with business logic
}
```

### Bad

```csharp
public void Execute(IServiceProvider serviceProvider)
{
    var context = (IPluginExecutionContext)serviceProvider.GetService(typeof(IPluginExecutionContext));
    var service = ((IOrganizationServiceFactory)serviceProvider.GetService(typeof(IOrganizationServiceFactory)))
        .CreateOrganizationService(context.UserId);

    // Updates the same record, which triggers this plugin again — infinite loop
    var target = (Entity)context.InputParameters["Target"];
    target["description"] = "Updated by plugin";
    service.Update(target);
}
```

## More Information
1. [IPluginExecutionContext.Depth Property - Microsoft Learn](https://learn.microsoft.com/en-us/dotnet/api/microsoft.xrm.sdk.ipluginexecutioncontext.depth)
1. [Best practices for plug-in and workflow development - Microsoft Learn](https://learn.microsoft.com/en-us/power-apps/developer/data-platform/best-practices/business-logic)

# PLG-006

Never use `new ColumnSet(true)` when retrieving records. Always specify only the columns you need.

1. When calling `Retrieve` or `RetrieveMultiple`, explicitly list the required columns using `new ColumnSet("column1", "column2")`.
1. Never pass `true` to the `ColumnSet` constructor, as this retrieves all columns on the table.

## Rationale

1. Retrieving all columns incurs unnecessary database load, increases memory consumption, and degrades plugin performance.
1. Tables evolve over time — new columns may be added that increase payload size or that the plugin's security context is not authorized to read, potentially causing runtime errors.
1. Specifying only the needed columns makes the plugin's data requirements explicit and self-documenting.

## Examples

### Good

```csharp
var account = service.Retrieve("account", accountId, new ColumnSet("name", "emailaddress1"));
```

```csharp
var query = new QueryExpression("contact")
{
    ColumnSet = new ColumnSet("firstname", "lastname", "emailaddress1")
};
query.Criteria.AddCondition("statecode", ConditionOperator.Equal, 0);
var contacts = service.RetrieveMultiple(query);
```

### Bad

```csharp
// Retrieves ALL columns — wasteful and fragile
var account = service.Retrieve("account", accountId, new ColumnSet(true));
```

```csharp
var query = new QueryExpression("contact")
{
    ColumnSet = new ColumnSet(true) // All columns fetched for every contact
};
var contacts = service.RetrieveMultiple(query);
```

## More Information
1. [Do not retrieve Entity all columns via query APIs - Microsoft Learn](https://learn.microsoft.com/en-us/power-apps/developer/data-platform/best-practices/work-with-data/retrieve-specific-columns-entity-via-query-apis)

# PLG-007

Use pre-images and post-images instead of issuing additional `Retrieve` calls to access field values before or after the operation.

1. Register entity images (pre-image and/or post-image) on the plugin step in the Plugin Registration Tool with only the attributes you need.
1. Access images via `context.PreEntityImages` and `context.PostEntityImages`.
1. Always check that the image exists before accessing it.

## Rationale

1. Entity images are loaded by the platform as part of the pipeline and do not incur an additional Retrieve call to the database, improving plugin performance.
1. Pre-images provide the field values before the operation, which is essential for comparison logic (e.g., detecting field changes).
1. Registering only the needed attributes in the image reduces the data payload and keeps the plugin efficient.

## Examples

### Good

```csharp
if (context.PreEntityImages.Contains("PreImage"))
{
    var preImage = context.PreEntityImages["PreImage"];
    var previousStatus = preImage.GetAttributeValue<OptionSetValue>("statuscode");
    var currentStatus = target.GetAttributeValue<OptionSetValue>("statuscode");

    if (previousStatus?.Value != currentStatus?.Value)
    {
        tracingService.Trace("Status changed from {0} to {1}.", previousStatus?.Value, currentStatus?.Value);
        // Handle status change
    }
}
```

### Bad

```csharp
// Issues an unnecessary Retrieve call to get the previous value
var previousRecord = service.Retrieve("account", target.Id, new ColumnSet("statuscode"));
var previousStatus = previousRecord.GetAttributeValue<OptionSetValue>("statuscode");
```

## More Information
1. [Define entity images - Microsoft Learn](https://learn.microsoft.com/en-us/power-apps/developer/data-platform/register-plug-in#define-entity-images)
1. [Best practices for plug-in and workflow development - Microsoft Learn](https://learn.microsoft.com/en-us/power-apps/developer/data-platform/best-practices/business-logic)

# PLG-008

Register plugins in the correct pipeline stage based on the type of logic they perform.

1. Use **Pre-Validation** for lightweight checks that should run before the database transaction begins (e.g., permission checks, canceling invalid operations).
1. Use **Pre-Operation** for logic that must modify the target entity's data before it is saved to the database (e.g., setting default values, computed fields).
1. Use **Post-Operation** for logic that must execute after the record has been committed (e.g., creating related records, sending notifications, audit logging).

## Rationale

1. Pre-Validation plugins run outside the database transaction, so rejecting an operation at this stage avoids starting and rolling back a transaction unnecessarily.
1. Pre-Operation plugins can modify the `Target` entity directly, and the changes are included in the same database transaction — no additional `Update` call is needed.
1. Post-Operation plugins have access to the final state of the record (including auto-generated fields like the record ID on Create), making them the correct stage for dependent operations.

## Examples

### Good

```csharp
// Pre-Validation: reject deletion of active orders early, before the transaction starts
if (context.MessageName == "Delete")
{
    var preImage = context.PreEntityImages["PreImage"];
    if (preImage.GetAttributeValue<OptionSetValue>("statecode")?.Value == 0)
    {
        throw new InvalidPluginExecutionException("Active orders cannot be deleted.");
    }
}
```

```csharp
// Pre-Operation: set a computed field before the record is saved
var target = (Entity)context.InputParameters["Target"];
target["fullname"] = $"{target.GetAttributeValue<string>("firstname")} {target.GetAttributeValue<string>("lastname")}";
// No Update call needed — changes are saved as part of the transaction
```

### Bad

```csharp
// Post-Operation: modifying the target and calling Update — extra database round-trip
// This should have been done in Pre-Operation
var target = (Entity)context.InputParameters["Target"];
target["fullname"] = $"{target["firstname"]} {target["lastname"]}";
service.Update(target); // Unnecessary Update call
```

## More Information
1. [Event execution pipeline - Microsoft Learn](https://learn.microsoft.com/en-us/power-apps/developer/data-platform/event-framework)
1. [Write a plug-in - Microsoft Learn](https://learn.microsoft.com/en-us/power-apps/developer/data-platform/write-plug-in)

# PLG-009

Do not use `ExecuteMultipleRequest` inside plugin code. Use it only from external client applications.

1. When a plugin needs to create or update multiple records, use individual `IOrganizationService` calls within the plugin.
1. Reserve `ExecuteMultipleRequest` for external integrations, data migration tools, and client-side batch operations.

## Rationale

1. `ExecuteMultipleRequest` inside a plugin can cause recursive triggers, bypass depth tracking, and lead to unexpected behavior in the pipeline.
1. Each operation within an `ExecuteMultiple` call may trigger its own set of plugins and workflows, compounding execution time and potentially exceeding the 2-minute timeout for synchronous plugins.
1. `ExecuteMultipleRequest` is designed for client-side batching to reduce network round-trips. Inside a plugin, network latency is not a factor since the call is already executing on the server.

## Examples

### Good

```csharp
// Create related records individually inside the plugin
foreach (var detail in orderDetails)
{
    var entity = new Entity("orderdetail");
    entity["productid"] = detail.ProductId;
    entity["quantity"] = detail.Quantity;
    entity["salesorderid"] = new EntityReference("salesorder", orderId);
    service.Create(entity);
}
```

### Bad

```csharp
// Using ExecuteMultiple inside a plugin — risk of recursion and timeouts
var request = new ExecuteMultipleRequest
{
    Requests = new OrganizationRequestCollection(),
    Settings = new ExecuteMultipleSettings { ContinueOnError = false, ReturnResponses = true }
};
foreach (var detail in orderDetails)
{
    request.Requests.Add(new CreateRequest { Target = detail });
}
service.Execute(request); // Avoid this inside plugins
```

## More Information
1. [Do not use batch request types in plug-ins and workflow activities - Microsoft Learn](https://learn.microsoft.com/en-us/power-apps/developer/data-platform/best-practices/business-logic/do-not-use-batch-request-types-in-plug-ins-and-workflow-activities)

# PLG-010

Register plugins only for the specific messages and tables required. Register only the filtering attributes necessary for Update messages.

1. Do not register a plugin on all entities or all messages if it only applies to specific ones.
1. When registering on the `Update` message, specify filtering attributes so the plugin only fires when relevant fields change.
1. Limit plugin step registration to the minimum scope needed.

## Rationale

1. Unnecessary plugin registrations add overhead to every operation on the registered table, even when the plugin logic does not apply.
1. Filtering attributes on Update steps prevent the plugin from executing on every field change, significantly reducing unnecessary executions.
1. A narrower registration scope makes the system more predictable and easier to debug.

## Examples

### Good

- A plugin registered on the `Update` message of the `Account` table with filtering attributes set to `emailaddress1, statuscode` — it only fires when the email or status changes.

### Bad

- A plugin registered on the `Update` message of the `Account` table with no filtering attributes — it fires on every single field update, including irrelevant changes like modifying the description.
- A plugin registered on all messages of a table when it only needs to run on `Create`.

## More Information
1. [Register a plug-in - Microsoft Learn](https://learn.microsoft.com/en-us/power-apps/developer/data-platform/register-plug-in)

# PLG-011

Do not use multithreading, `Task.Run`, `Parallel.ForEach`, or any form of asynchronous parallelism inside plugin code.

1. All plugin logic must execute synchronously on the calling thread.
1. Do not use `Task`, `Thread`, `Parallel`, `async/await`, or `ThreadPool` inside plugins.

## Rationale

1. Dataverse plugins execute in a sandboxed environment with strict resource constraints. The platform does not support multithreading, and spawning threads can cause crashes, data corruption, or unpredictable behavior.
1. Background threads may outlive the plugin execution context, losing access to the `IOrganizationService`, `ITracingService`, and other platform services.
1. The sandbox environment may terminate threads at any time without warning, leading to partially completed operations.

## Examples

### Good

```csharp
// Sequential processing — safe and predictable
foreach (var record in recordsToProcess)
{
    service.Update(record);
}
```

### Bad

```csharp
// Parallel processing inside a plugin — unstable and unsupported
Parallel.ForEach(recordsToProcess, record =>
{
    service.Update(record);
});
```

```csharp
// async/await inside a plugin — not supported in the sandbox
await Task.Run(() => service.Update(record));
```

## More Information
1. [Plug-in design best practices - Microsoft Learn](https://learn.microsoft.com/en-us/power-apps/developer/data-platform/best-practices/business-logic)

# PLG-012

Keep synchronous plugins lightweight. Offload long-running or non-critical work to asynchronous plugins or Power Automate flows.

1. Synchronous plugins (Pre-Validation, Pre-Operation, Post-Operation synchronous) block the user's save operation. Keep execution time to a minimum.
1. Move non-critical processing such as notifications, audit logging, and external API calls to asynchronous (Post-Operation Async) plugin steps or Power Automate flows.
1. Be aware of the 2-minute timeout limit for synchronous plugins.

## Rationale

1. Synchronous plugins execute within the user's request pipeline. Slow plugins cause the UI to freeze, resulting in a poor user experience.
1. If a synchronous plugin exceeds the 2-minute timeout, the entire operation fails and rolls back, potentially causing data loss.
1. Asynchronous processing decouples the user experience from background work, improving responsiveness without sacrificing functionality.

## Examples

### Good

- A synchronous Pre-Operation plugin that validates a field format — executes in milliseconds.
- An asynchronous Post-Operation plugin that sends an email notification after a Case is created.

### Bad

- A synchronous Post-Operation plugin that calls an external REST API to validate an address, adding 3–5 seconds of network latency to every save.
- A synchronous plugin that processes 500 related records in a loop, causing a 30-second delay on the form.

## More Information
1. [Best practices for plug-in and workflow development - Microsoft Learn](https://learn.microsoft.com/en-us/power-apps/developer/data-platform/best-practices/business-logic)
1. [Troubleshoot plug-ins - Microsoft Learn](https://learn.microsoft.com/en-us/power-apps/developer/data-platform/troubleshoot-plug-in)
