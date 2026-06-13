# JavaScript Client Scripts

Good practices for Dataverse JavaScript client scripts in model-driven apps.

# JS-001

Use the `formContext` object obtained from the execution context parameter instead of the deprecated `Xrm.Page` global object.

1. Always pass the `executionContext` parameter to your event handler functions.
1. Obtain the form context by calling `executionContext.getFormContext()`.
1. Never reference `Xrm.Page` directly in new code.
1. Migrate existing code that uses `Xrm.Page` to use `formContext` as soon as possible.

## Rationale

1. `Xrm.Page` has been deprecated since Dynamics 365 version 9.0 and may be removed in a future release.
1. Using `formContext` makes your functions reusable across main forms, quick create forms, and dialogs.
1. The execution context pattern is the only approach supported in the Unified Interface.

## Examples

### Good

```javascript
function onLoad(executionContext) {
    var formContext = executionContext.getFormContext();
    var name = formContext.getAttribute("name").getValue();
}
```

### Bad

```javascript
function onLoad() {
    // Xrm.Page is deprecated and will be removed in a future release
    var name = Xrm.Page.getAttribute("name").getValue();
}
```

## More Information
1. [Client API form context - Microsoft Learn](https://learn.microsoft.com/en-us/power-apps/developer/model-driven-apps/clientapi/clientapi-form-context)
1. [Xrm.Page deprecation - Microsoft Learn](https://learn.microsoft.com/en-us/power-apps/developer/model-driven-apps/clientapi/reference/xrm-page)

# JS-002

Organize your code using namespaces to avoid polluting the global scope.

1. Wrap all functions in a namespace object using the `var MyNamespace = MyNamespace || {};` pattern.
1. Use a multi-level namespace that reflects the publisher, module, and entity (e.g., `Contoso.Sales.Account`).
1. Register event handlers using the fully qualified namespace path (e.g., `Contoso.Sales.Account.onLoad`).
1. Never define standalone global functions.

## Rationale

1. Model-driven apps load all registered web resources into the same global scope. Without namespaces, function name collisions can cause unexpected behavior.
1. Namespaces make it clear which entity and module a function belongs to, improving readability and maintainability.
1. The fully qualified name in event registration makes it easier to trace which script handles each event.

## Examples

### Good

```javascript
var Contoso = Contoso || {};
Contoso.Account = Contoso.Account || {};

Contoso.Account.onLoad = function (executionContext) {
    var formContext = executionContext.getFormContext();
    // form logic here
};

Contoso.Account.onSave = function (executionContext) {
    var formContext = executionContext.getFormContext();
    // save logic here
};
```

### Bad

```javascript
// Global functions risk naming collisions with other web resources
function onLoad(executionContext) {
    var formContext = executionContext.getFormContext();
}

function onSave(executionContext) {
    var formContext = executionContext.getFormContext();
}
```

## More Information
1. [Organize your code - Microsoft Learn](https://learn.microsoft.com/en-us/power-apps/developer/model-driven-apps/clientapi/client-scripting-best-practices)
1. [Client scripting in model-driven apps - Microsoft Learn](https://learn.microsoft.com/en-us/power-apps/developer/model-driven-apps/client-scripting)

# JS-003

Use only supported Dataverse Client API methods. Never manipulate the DOM directly or use unsupported libraries like jQuery to interact with form controls.

1. Use `formContext.getAttribute()` and `formContext.getControl()` to read and manipulate form data and controls.
1. Never use `document.getElementById()`, `document.querySelector()`, or jQuery selectors to access form elements.
1. Do not modify CSS classes, styles, or HTML attributes on form controls directly.
1. Do not reference internal control IDs or class names, as these change without notice between platform updates.

## Rationale

1. Microsoft only supports interactions through the documented Client API. Any DOM manipulation is unsupported and can break silently after platform updates.
1. The internal HTML structure of model-driven app forms changes frequently. Scripts relying on DOM elements will stop working without warning.
1. Direct DOM manipulation can interfere with the platform's own rendering logic, causing visual glitches and data inconsistencies.

## Examples

### Good

```javascript
function hideField(formContext) {
    formContext.getControl("telephone1").setVisible(false);
}

function setFieldValue(formContext) {
    formContext.getAttribute("firstname").setValue("John");
}

function disableField(formContext) {
    formContext.getControl("emailaddress1").setDisabled(true);
}
```

### Bad

```javascript
function hideField() {
    // Direct DOM manipulation is unsupported and will break
    document.getElementById("telephone1").style.display = "none";
}

function setFieldValue() {
    // jQuery is not supported for form control interaction
    $("#firstname").val("John");
}

function disableField() {
    // Accessing internal DOM elements will fail after platform updates
    document.querySelector("[data-id='emailaddress1']").setAttribute("disabled", "true");
}
```

## More Information
1. [Client API reference - Microsoft Learn](https://learn.microsoft.com/en-us/power-apps/developer/model-driven-apps/clientapi/reference)
1. [Best practices for client scripting - Microsoft Learn](https://learn.microsoft.com/en-us/power-apps/developer/model-driven-apps/clientapi/client-scripting-best-practices)

# JS-004

Always use asynchronous API calls. Never use synchronous `XMLHttpRequest` or any blocking network call.

1. Use `Xrm.WebApi` methods (`retrieveRecord`, `retrieveMultipleRecords`, `createRecord`, `updateRecord`, `deleteRecord`) which are asynchronous by default.
1. Use `async/await` or `.then()` / `.catch()` to handle asynchronous results.
1. Never pass `false` as the async parameter to `XMLHttpRequest.open()`.
1. For async `OnSave` handlers, return a `Promise` so the platform knows when your operation has completed.

## Rationale

1. Synchronous network calls block the browser's main thread, freezing the UI until the call completes. This creates a poor user experience.
1. Synchronous `XMLHttpRequest` is deprecated in modern browsers and will be removed in future versions.
1. The Dataverse platform is optimized for asynchronous operations. Synchronous calls bypass these optimizations and can cause timeouts.

## Examples

### Good

```javascript
async function getAccountName(accountId) {
    try {
        var result = await Xrm.WebApi.retrieveRecord(
            "account", accountId, "?$select=name"
        );
        return result.name;
    } catch (error) {
        console.error(error.message);
    }
}
```

### Bad

```javascript
function getAccountName(accountId) {
    // Synchronous XMLHttpRequest blocks the UI
    var req = new XMLHttpRequest();
    req.open("GET",
        Xrm.Utility.getGlobalContext().getClientUrl() +
        "/api/data/v9.2/accounts(" + accountId + ")?$select=name",
        false // synchronous - NEVER do this
    );
    req.send();
    return JSON.parse(req.responseText).name;
}
```

## More Information
1. [Xrm.WebApi - Microsoft Learn](https://learn.microsoft.com/en-us/power-apps/developer/model-driven-apps/clientapi/reference/xrm-webapi)
1. [Async event handlers - Microsoft Learn](https://learn.microsoft.com/en-us/power-apps/developer/model-driven-apps/clientapi/async-event-handlers)

# JS-005

When using `Xrm.WebApi`, retrieve only the columns you need by using the `$select` query option.

1. Always specify a `$select` clause with only the fields your logic requires.
1. Avoid calling `retrieveRecord` or `retrieveMultipleRecords` without `$select`, which returns all columns.
1. When using `$expand` for related records, also apply `$select` on the expanded entity.

## Rationale

1. Retrieving all columns returns unnecessary data, increasing payload size and response time.
1. Selecting only the required fields reduces memory consumption and improves performance, especially on mobile clients.
1. Excessive data retrieval can contribute to API throttling when combined with multiple concurrent calls.

## Examples

### Good

```javascript
// Retrieves only the name and account number
Xrm.WebApi.retrieveRecord(
    "account", accountId,
    "?$select=name,accountnumber"
).then(function (result) {
    console.log(result.name);
});
```

### Bad

```javascript
// Retrieves all columns — unnecessary data transfer
Xrm.WebApi.retrieveRecord(
    "account", accountId
).then(function (result) {
    console.log(result.name);
});
```

## More Information
1. [Retrieve a table row using the Web API - Microsoft Learn](https://learn.microsoft.com/en-us/power-apps/developer/data-platform/webapi/retrieve-entity-using-web-api)
1. [Query data using the Web API - Microsoft Learn](https://learn.microsoft.com/en-us/power-apps/developer/data-platform/webapi/query-data-web-api)

# JS-006

Implement proper error handling in all asynchronous operations. Provide user-friendly feedback when errors occur.

1. Use `.catch()` on every `Promise` chain or wrap `async/await` calls in `try/catch` blocks.
1. Display meaningful error messages to users using `Xrm.Navigation.openAlertDialog`.
1. In async `OnSave` handlers, call `eventArgs.preventDefault()` inside the `catch` block to prevent saving with invalid or incomplete data.
1. Do not silently swallow errors.

## Rationale

1. Unhandled promise rejections can cause scripts to fail silently, leaving the user unaware that an operation did not complete.
1. Without `preventDefault()` in an `OnSave` error handler, the record may be saved in an inconsistent state.
1. Clear error messages help users and support teams diagnose issues faster.

## Examples

### Good

```javascript
async function onSave(executionContext) {
    var eventArgs = executionContext.getEventArgs();
    try {
        var result = await Xrm.WebApi.retrieveRecord(
            "account", accountId, "?$select=creditlimit"
        );
        if (result.creditlimit < 0) {
            eventArgs.preventDefault();
            Xrm.Navigation.openAlertDialog({
                text: "Credit limit must be a positive value."
            });
        }
    } catch (error) {
        eventArgs.preventDefault();
        Xrm.Navigation.openAlertDialog({
            text: "An error occurred while validating: " + error.message
        });
    }
}
```

### Bad

```javascript
async function onSave(executionContext) {
    // No error handling — if the API call fails, the record saves with invalid data
    var result = await Xrm.WebApi.retrieveRecord(
        "account", accountId, "?$select=creditlimit"
    );
    if (result.creditlimit < 0) {
        executionContext.getEventArgs().preventDefault();
    }
}
```

## More Information
1. [Async event handlers - Microsoft Learn](https://learn.microsoft.com/en-us/power-apps/developer/model-driven-apps/clientapi/async-event-handlers)
1. [Xrm.Navigation - Microsoft Learn](https://learn.microsoft.com/en-us/power-apps/developer/model-driven-apps/clientapi/reference/xrm-navigation)

# JS-007

Prefer out-of-the-box features (business rules, calculated fields, Power Automate) over client scripts when they can achieve the same result.

1. Use business rules for simple field visibility, requirement levels, and default value logic.
1. Use calculated or rollup columns for derived values that do not require user interaction.
1. Use Power Automate or plug-ins for server-side logic that must execute regardless of how the record is modified.
1. Reserve client scripting for complex scenarios that cannot be achieved declaratively.

## Rationale

1. Business rules and calculated fields are easier to maintain and do not require development skills to modify.
1. Client scripts only execute when a user interacts with the form. Logic implemented only in scripts is bypassed by imports, API calls, workflows, and plug-ins.
1. Reducing the number of custom scripts lowers the maintenance burden and the risk of upgrade-related issues.

## Examples

### Good

- A business rule sets the Phone field as required when the Contact Method is "Phone". No script is needed.
- A calculated column computes the total order amount from line items. The value is always correct regardless of how the record is updated.

### Bad

- A JavaScript `OnLoad` handler hides a field based on a simple condition that could be handled by a business rule.
- A client script recalculates a total on every field change, but the total is incorrect when records are created via data import because the script never runs.

## More Information
1. [Create business rules - Microsoft Learn](https://learn.microsoft.com/en-us/power-apps/maker/data-platform/create-business-rules-recommendations-apply-logic-form)
1. [Define calculated columns - Microsoft Learn](https://learn.microsoft.com/en-us/power-apps/maker/data-platform/define-calculated-fields)

# JS-008

Follow a consistent naming convention for web resource files.

1. Use the pattern `[prefix]_/scripts/[module]/[entity]_[purpose].js` (e.g., `csp_/scripts/sales/account_form.js`).
1. Include the publisher prefix to avoid collisions across solutions.
1. Use lowercase and underscores for the file name. Avoid spaces and special characters.
1. Group related scripts into virtual folders using the `/` separator in the web resource name.

## Rationale

1. A consistent naming convention makes it easy to locate, filter, and manage web resources in a solution with dozens or hundreds of scripts.
1. Virtual folders in the web resource name reflect the logical module structure, improving discoverability.
1. Including the publisher prefix prevents name collisions when multiple solutions are installed in the same environment.

## Examples

### Good

| Web Resource Name                     | Purpose                              |
| ------------------------------------- | ------------------------------------ |
| `csp_/scripts/sales/account_form.js`  | Account form event handlers          |
| `csp_/scripts/sales/contact_form.js`  | Contact form event handlers          |
| `csp_/scripts/shared/utils.js`        | Shared utility functions             |
| `csp_/scripts/service/case_ribbon.js` | Case entity ribbon command handlers  |

### Bad

| Web Resource Name      | Problem                                                 |
| ---------------------- | ------------------------------------------------------- |
| `script1.js`           | No prefix, no context, impossible to identify purpose   |
| `AccountFormScript.js` | Missing publisher prefix, no module grouping            |
| `my scripts.js`        | Contains a space, no prefix, no structure               |

## More Information
1. [Web resource naming conventions - Microsoft Learn](https://learn.microsoft.com/en-us/power-apps/developer/model-driven-apps/web-resources)

# JS-009

Register scripts only on the forms and events where they are needed. Do not load scripts globally if they are only used by a single entity or form.

1. Add web resource libraries only to the forms that require them.
1. Register event handlers (OnLoad, OnChange, OnSave) only for the specific fields and events your logic targets.
1. Pass the execution context as the first parameter when registering event handlers.
1. If a script is only needed for a specific form, do not add it to all forms of that entity.

## Rationale

1. Loading unnecessary scripts increases form load time because the browser must download, parse, and execute each web resource.
1. Event handlers that run on every form load without a clear purpose add processing overhead and increase the risk of errors.
1. Targeting scripts precisely makes the system easier to debug, because developers can quickly identify which scripts affect a given form.

## Examples

### Good

- The `account_form.js` web resource is added only to the Account main form and registered for the `OnLoad` event with "Pass execution context as first parameter" enabled.
- The `contact_phone_validation.js` script is registered on the `OnChange` event of the `telephone1` field only.

### Bad

- A large utility library is added to every form in the solution, even though only one form uses it.
- An `OnLoad` handler is registered on all entity forms "just in case", adding unnecessary processing on every form open.

## More Information
1. [Add script to a form event - Microsoft Learn](https://learn.microsoft.com/en-us/power-apps/developer/model-driven-apps/clientapi/events-forms-grids)

# JS-010

Avoid hard-coding entity names, field names, GUIDs, or option set values in your scripts. Use constants or configuration data.

1. Define entity names, field logical names, and option set values as constants at the top of your namespace.
1. Never hard-code record GUIDs. Look up records dynamically or use alternate keys.
1. If your logic depends on environment-specific values (e.g., a team ID or queue ID), retrieve them at runtime or store them in a configuration entity.

## Rationale

1. Hard-coded values make scripts fragile. If a field is renamed, an option set value changes, or the script is moved to a different environment, the script breaks.
1. GUIDs differ between development, test, and production environments. Hard-coded GUIDs will fail in at least one environment.
1. Centralizing constants at the top of the file makes the script easier to review and update.

## Examples

### Good

```javascript
var Contoso = Contoso || {};
Contoso.Account = Contoso.Account || {};

// Constants
Contoso.Account.Fields = {
    STATUS: "statuscode",
    CATEGORY: "accountcategorycode",
    CREDIT_LIMIT: "creditlimit"
};

Contoso.Account.StatusValues = {
    ACTIVE: 1,
    INACTIVE: 2
};

Contoso.Account.onLoad = function (executionContext) {
    var formContext = executionContext.getFormContext();
    var status = formContext.getAttribute(Contoso.Account.Fields.STATUS).getValue();
    if (status === Contoso.Account.StatusValues.ACTIVE) {
        formContext.getControl(Contoso.Account.Fields.CREDIT_LIMIT).setVisible(true);
    }
};
```

### Bad

```javascript
function onLoad(executionContext) {
    var formContext = executionContext.getFormContext();
    // Hard-coded field names and option set values scattered throughout
    var status = formContext.getAttribute("statuscode").getValue();
    if (status === 1) {
        formContext.getControl("creditlimit").setVisible(true);
    }
}
```

## More Information
1. [Client scripting in model-driven apps - Microsoft Learn](https://learn.microsoft.com/en-us/power-apps/developer/model-driven-apps/client-scripting)

# JS-011

Use `setNotification` and `clearNotification` on controls to display inline validation messages instead of alert dialogs for field-level validation.

1. Call `formContext.getControl("fieldname").setNotification("message", "uniqueId")` to show a validation error next to the field.
1. Call `formContext.getControl("fieldname").clearNotification("uniqueId")` when the validation error is resolved.
1. Reserve `Xrm.Navigation.openAlertDialog` for critical errors or informational messages that are not tied to a specific field.

## Rationale

1. Inline notifications provide immediate visual feedback next to the relevant field, making it clear what needs to be corrected.
1. Alert dialogs interrupt the user's workflow and are disruptive when used for simple validation errors.
1. A field with an active notification prevents the record from being saved, enforcing data quality without additional `OnSave` logic.

## Examples

### Good

```javascript
Contoso.Contact.onPhoneChange = function (executionContext) {
    var formContext = executionContext.getFormContext();
    var phone = formContext.getAttribute("telephone1").getValue();

    if (phone && !/^\d{10}$/.test(phone)) {
        formContext.getControl("telephone1")
            .setNotification("Phone number must be 10 digits.", "phoneValidation");
    } else {
        formContext.getControl("telephone1")
            .clearNotification("phoneValidation");
    }
};
```

### Bad

```javascript
function onPhoneChange(executionContext) {
    var formContext = executionContext.getFormContext();
    var phone = formContext.getAttribute("telephone1").getValue();

    if (phone && !/^\d{10}$/.test(phone)) {
        // Alert dialogs are disruptive for field-level validation
        Xrm.Navigation.openAlertDialog({
            text: "Phone number must be 10 digits."
        });
    }
}
```

## More Information
1. [Control.setNotification - Microsoft Learn](https://learn.microsoft.com/en-us/power-apps/developer/model-driven-apps/clientapi/reference/controls/setnotification)
1. [Control.clearNotification - Microsoft Learn](https://learn.microsoft.com/en-us/power-apps/developer/model-driven-apps/clientapi/reference/controls/clearnotification)

# JS-012

Check the form type before executing logic that should only run on specific form modes (create, update, read-only).

1. Use `formContext.ui.getFormType()` to determine the current form mode.
1. Gate logic that should only run during record creation (type `1`) or update (type `2`) using an explicit check.
1. Avoid running initialization logic on read-only or disabled forms where it is unnecessary.

## Rationale

1. Logic that sets default values should only run on create forms. Running it on update forms would overwrite existing data.
1. Skipping unnecessary logic on read-only forms improves load performance.
1. Explicitly checking the form type makes the script's intent clear and prevents subtle bugs.

## Examples

### Good

```javascript
Contoso.Case.onLoad = function (executionContext) {
    var formContext = executionContext.getFormContext();
    var formType = formContext.ui.getFormType();

    // 1 = Create
    if (formType === 1) {
        formContext.getAttribute("prioritycode").setValue(2); // Normal
    }
};
```

### Bad

```javascript
function onLoad(executionContext) {
    var formContext = executionContext.getFormContext();
    // Sets default priority on every form open, overwriting existing values on updates
    formContext.getAttribute("prioritycode").setValue(2);
}
```

## More Information
1. [formContext.ui.getFormType - Microsoft Learn](https://learn.microsoft.com/en-us/power-apps/developer/model-driven-apps/clientapi/reference/formcontext-ui/getformtype)
