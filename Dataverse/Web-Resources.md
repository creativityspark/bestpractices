# Web Resources

Good practices for Dataverse Web Resources.

# WR-001

Use a consistent naming convention with virtual folder structures for all web resources.

1. Always start the name with the publisher prefix followed by a forward slash.
1. Group web resources by type using virtual folders (e.g., `scripts/`, `html/`, `css/`, `images/`).
1. Within each type folder, group by entity or feature.
1. Use camelCase or lowercase for file names. Avoid spaces and special characters.
1. Keep the folder hierarchy shallow — no more than 3 levels deep.

## Rationale

1. A consistent naming convention makes it easy to locate and manage web resources as the solution grows.
1. Virtual folder structures simulate a file system within Dataverse, improving organization and discoverability.
1. Grouping by entity or feature ensures that related resources are located together, simplifying maintenance.
1. Deep nesting makes navigation difficult and names excessively long.

## Examples

### Good

```
contoso_/scripts/account/formEvents.js
contoso_/scripts/contact/phoneValidation.js
contoso_/scripts/lib/utilities.js
contoso_/html/account/quickView.html
contoso_/css/common.css
contoso_/images/icons/phone.svg
```

### Bad

```
new_script1.js
new_script2.js
accountformeventsvalidationandribbon.js
contoso_/scripts/features/module1/submodule2/helpers/internal/utils.js
```

## More Information
1. [Web resources in model-driven apps - Microsoft Learn](https://learn.microsoft.com/en-us/power-apps/developer/model-driven-apps/web-resources)

# WR-002

Use namespaces to avoid polluting the global scope in JavaScript web resources.

1. Define a namespace object for your organization or project and attach all functions to it.
1. Use the Immediately Invoked Function Expression (IIFE) pattern or ES module patterns to encapsulate code.
1. Never declare functions or variables directly in the global scope.

## Rationale

1. Multiple web resources may be loaded on the same form. Global variables and functions from different scripts can collide, causing unpredictable behavior.
1. Namespaces make it clear which project or module a function belongs to, improving readability and debuggability.
1. Encapsulated code is easier to test and maintain because it does not depend on or interfere with other scripts.

## Examples

### Good

```javascript
var Contoso = Contoso || {};
Contoso.Account = {
    onLoad: function (executionContext) {
        var formContext = executionContext.getFormContext();
        // Form load logic
    },
    onSave: function (executionContext) {
        var formContext = executionContext.getFormContext();
        // Save logic
    }
};
```

### Bad

```javascript
function onLoad(executionContext) {
    var formContext = executionContext.getFormContext();
    // Form load logic
}

function onSave(executionContext) {
    var formContext = executionContext.getFormContext();
    // Save logic
}

var accountName = "";
```

## More Information
1. [Organize your code using namespaces - Microsoft Learn](https://learn.microsoft.com/en-us/power-apps/developer/model-driven-apps/clientapi/client-scripting-best-practices#organize-your-code-using-namespaces)

# WR-003

Use only supported Client API and Web API methods. Never use unsupported or undocumented APIs.

1. Only use methods documented in the [Client API Reference](https://learn.microsoft.com/en-us/power-apps/developer/model-driven-apps/clientapi/reference) and the [Dataverse Web API](https://learn.microsoft.com/en-us/power-apps/developer/data-platform/webapi/overview).
1. Do not directly manipulate the DOM of model-driven app forms. Use the `formContext` API instead.
1. Do not use internal objects such as `Mscrm.*`, `Xrm.Internal.*`, or other undocumented namespaces.
1. Do not access `Xrm` through `window.parent.Xrm` in HTML web resources — use the context object passed via the `getContentWindow` method or the `Xrm` object passed to the resource.

## Rationale

1. Unsupported APIs may change or be removed without notice during platform updates, breaking your solution.
1. Direct DOM manipulation bypasses the application's rendering pipeline and will break when Microsoft updates the UI framework.
1. Microsoft does not provide support or fix issues caused by the use of unsupported APIs, leaving your organization responsible for troubleshooting and remediation.

## Examples

### Good

```javascript
// Using supported Client API to get a field value
var formContext = executionContext.getFormContext();
var accountName = formContext.getAttribute("name").getValue();

// Using supported Web API to retrieve data
Xrm.WebApi.retrieveRecord("account", accountId, "?$select=name,revenue").then(
    function (result) { /* handle result */ },
    function (error) { /* handle error */ }
);
```

### Bad

```javascript
// Directly manipulating the DOM to read a field value
var accountName = document.getElementById("name_i").value;

// Using undocumented internal API
var userId = Mscrm.CrmHeader.CURRENT_USER_ID;

// Accessing Xrm from parent window in an HTML web resource
var formContext = window.parent.Xrm.Page;
```

## More Information
1. [Client API Reference - Microsoft Learn](https://learn.microsoft.com/en-us/power-apps/developer/model-driven-apps/clientapi/reference)
1. [Client scripting best practices - Microsoft Learn](https://learn.microsoft.com/en-us/power-apps/developer/model-driven-apps/clientapi/client-scripting-best-practices)
1. [Supported and unsupported customizations - Microsoft Learn](https://learn.microsoft.com/en-us/power-apps/developer/data-platform/supported-customizations)

# WR-004

Avoid using jQuery or other heavy third-party libraries in JavaScript web resources. Use modern vanilla JavaScript instead.

1. Do not include jQuery for DOM manipulation, AJAX calls, or event handling — modern JavaScript and the Client API cover all of these scenarios.
1. If a third-party library is absolutely necessary, evaluate its size, maintenance status, and compatibility with the platform before including it.
1. Remove unused libraries from the solution to reduce load times.

## Rationale

1. jQuery adds unnecessary weight to form load times. Modern browsers natively support all functionality that jQuery was originally created to provide.
1. Microsoft may change the internal DOM structure of forms at any time. jQuery selectors that target form elements will break when the UI is updated.
1. Third-party libraries can introduce security vulnerabilities and conflict with the platform's own scripts.
1. The Dataverse Client API and Web API provide all the supported methods needed to interact with forms and data.

## Examples

### Good

```javascript
// Using vanilla JavaScript for DOM manipulation in an HTML web resource
var element = document.querySelector("#output");
element.textContent = "Hello, World!";

// Using the fetch API for HTTP calls in an HTML web resource
fetch("/api/data/v9.2/accounts?$select=name")
    .then(function (response) { return response.json(); })
    .then(function (data) { /* handle data */ });
```

### Bad

```javascript
// Loading jQuery just to set text content
$("#output").text("Hello, World!");

// Using jQuery for AJAX when the Web API is available
$.ajax({
    url: "/api/data/v9.2/accounts?$select=name",
    type: "GET",
    success: function (data) { /* handle data */ }
});
```

## More Information
1. [Client scripting best practices - Microsoft Learn](https://learn.microsoft.com/en-us/power-apps/developer/model-driven-apps/clientapi/client-scripting-best-practices)
1. [You Might Not Need jQuery](https://youmightnotneedjquery.com/)

# WR-005

Always use asynchronous operations. Never use synchronous API calls or blocking operations in web resources.

1. Use `Xrm.WebApi` methods, which are asynchronous by design, for all data operations.
1. Never use synchronous `XMLHttpRequest` calls.
1. Use Promises or async/await patterns for any operation that involves server communication.
1. Keep event handlers (`OnLoad`, `OnSave`, `OnChange`) lightweight and non-blocking.

## Rationale

1. Synchronous calls block the UI thread, freezing the form and degrading the user experience.
1. Modern browsers are deprecating synchronous `XMLHttpRequest` on the main thread and may block them entirely in future updates.
1. Asynchronous patterns allow the form to remain responsive while data is being fetched or saved.

## Examples

### Good

```javascript
Contoso.Account = {
    onLoad: async function (executionContext) {
        var formContext = executionContext.getFormContext();
        try {
            var result = await Xrm.WebApi.retrieveRecord(
                "account", formContext.data.entity.getId(),
                "?$select=name,revenue"
            );
            // Process result
        } catch (error) {
            console.error("Error retrieving account: " + error.message);
        }
    }
};
```

### Bad

```javascript
function onLoad(executionContext) {
    var xhr = new XMLHttpRequest();
    xhr.open("GET", "/api/data/v9.2/accounts(00000000-0000-0000-0000-000000000000)", false);
    xhr.send(); // Synchronous — blocks the UI thread
    var data = JSON.parse(xhr.responseText);
}
```

## More Information
1. [Interact with HTTP and HTTPS resources asynchronously - Microsoft Learn](https://learn.microsoft.com/en-us/power-apps/developer/model-driven-apps/clientapi/client-scripting-best-practices#interact-with-http-and-https-resources-asynchronously)
1. [Xrm.WebApi - Microsoft Learn](https://learn.microsoft.com/en-us/power-apps/developer/model-driven-apps/clientapi/reference/xrm-webapi)

# WR-006

Load JavaScript web resources only on the forms and events where they are needed.

1. Do not add a JavaScript library to a form unless it contains event handlers registered on that form.
1. When registering event handlers, specify only the events that are actually used (e.g., `OnLoad`, `OnSave`, `OnChange`).
1. Remove any web resource references from forms where they are no longer needed.
1. Place shared utility functions in a separate library and load it only on forms that require it.

## Rationale

1. Every web resource added to a form increases the initial load time, as the browser must download and parse the script before rendering the form.
1. Unused scripts waste bandwidth and consume memory on the client device.
1. Keeping form script registrations clean makes it easier to understand and maintain the form's behavior.

## Examples

### Good

- The `contoso_/scripts/account/formEvents.js` library is loaded only on the Account main form, where its `onLoad` and `onSave` handlers are registered.
- A shared `contoso_/scripts/lib/utilities.js` library is loaded only on the three forms that use its validation functions.

### Bad

- A single `contoso_/scripts/allFormEvents.js` file containing handlers for every entity is loaded on every form in the application.
- A JavaScript library is still referenced on a form even though all its event registrations were removed months ago.

## More Information
1. [Optimize form performance - Microsoft Learn](https://learn.microsoft.com/en-us/power-apps/maker/model-driven-apps/optimize-form-performance)

# WR-007

Optimize Web API calls by selecting only the columns you need and applying filters.

1. Always use the `$select` query option to retrieve only the columns required by your logic.
1. Use the `$filter` query option to narrow down the result set.
1. Use `$top` to limit the number of records when you only need a subset.
1. Use batch requests (`$batch`) when you need to make multiple API calls to reduce the number of HTTP roundtrips.
1. Cache results when the data is static or rarely changes (e.g., option set metadata, configuration records).

## Rationale

1. Retrieving all columns transfers unnecessary data over the network, slowing down the response and increasing load on the server.
1. Large unfiltered result sets consume more memory and processing time on both client and server.
1. Batch requests reduce the number of HTTP connections and improve overall performance.
1. Caching avoids repeated calls for data that does not change frequently.

## Examples

### Good

```javascript
// Select only the columns needed
Xrm.WebApi.retrieveMultipleRecords(
    "contact",
    "?$select=fullname,emailaddress1&$filter=statecode eq 0&$top=10"
).then(function (results) {
    // Process results
});
```

### Bad

```javascript
// Retrieving all columns without any filter
Xrm.WebApi.retrieveMultipleRecords("contact").then(function (results) {
    // Processing all contacts with all fields
});
```

## More Information
1. [Query data using the Web API - Microsoft Learn](https://learn.microsoft.com/en-us/power-apps/developer/data-platform/webapi/query-data-web-api)
1. [Execute batch operations - Microsoft Learn](https://learn.microsoft.com/en-us/power-apps/developer/data-platform/webapi/execute-batch-operations-using-web-api)

# WR-008

Sanitize all user input and dynamic data rendered in HTML web resources to prevent Cross-Site Scripting (XSS).

1. Never use `innerHTML` to render user-supplied or entity data. Use `textContent` or DOM APIs to create elements safely.
1. Do not use `eval()`, `new Function()`, or `setTimeout`/`setInterval` with string arguments.
1. If you must render HTML from dynamic data, use a sanitization library such as [DOMPurify](https://github.com/cure53/DOMPurify).
1. Add a Content Security Policy `<meta>` tag to your HTML web resources to restrict script and style sources.

## Rationale

1. Dataverse records may contain data entered by external users or imported from other systems. This data could contain malicious scripts.
1. XSS vulnerabilities can lead to session hijacking, data theft, or unauthorized actions performed on behalf of the logged-in user.
1. A Content Security Policy provides an additional layer of defense by restricting which resources the browser is allowed to load and execute.

## Examples

### Good

```html
<meta http-equiv="Content-Security-Policy"
      content="default-src 'self'; script-src 'self'; style-src 'self'; object-src 'none'">
```

```javascript
// Using textContent to safely render data
var output = document.getElementById("output");
output.textContent = recordName; // Safe — HTML is not parsed
```

### Bad

```javascript
// Using innerHTML with unsanitized data — vulnerable to XSS
var output = document.getElementById("output");
output.innerHTML = "<h1>" + recordName + "</h1>";

// Using eval to process data
eval("var data = " + serverResponse);
```

## More Information
1. [Content Security Policy (CSP) - MDN Web Docs](https://developer.mozilla.org/en-US/docs/Web/HTTP/CSP)
1. [DOMPurify - GitHub](https://github.com/cure53/DOMPurify)
1. [Cross-site scripting prevention - OWASP](https://cheatsheetseries.owasp.org/cheatsheets/Cross-Site_Scripting_Prevention_Cheat_Sheet.html)

# WR-009

Use TypeScript for developing JavaScript web resources and use a build pipeline to transpile and minify the output.

1. Write source code in TypeScript for type safety and better tooling support.
1. Use a build tool such as Webpack, Vite, or Rollup to bundle and minify the output.
1. Deploy only the minified, transpiled JavaScript file as the web resource — not the TypeScript source.
1. Store the TypeScript source code in source control (e.g., Git) alongside the solution.
1. Use type definitions for the Dataverse Client API (e.g., `@types/xrm`) for IntelliSense and compile-time validation.

## Rationale

1. TypeScript catches errors at compile time that would otherwise only surface at runtime, reducing bugs in production.
1. Minified files are smaller and load faster, improving form performance.
1. A build pipeline enforces consistent code quality through linting, type checking, and automated testing before deployment.
1. Storing source code in version control enables collaboration, code reviews, and change tracking.

## Examples

### Good

```
Source code (in Git):
  src/account/formEvents.ts

Build output (deployed as web resource):
  contoso_/scripts/account/formEvents.js  (minified, transpiled)
```

### Bad

- Writing JavaScript directly in the Dataverse web resource editor with no source control.
- Deploying unminified TypeScript source files as web resources.
- Multiple developers editing the same web resource directly in the browser without version control.

## More Information
1. [TypeScript - Official Website](https://www.typescriptlang.org/)
1. [@types/xrm - npm](https://www.npmjs.com/package/@types/xrm)
1. [Use of webpack to bundle web resource files - Microsoft Learn](https://learn.microsoft.com/en-us/power-apps/developer/model-driven-apps/best-practices/business-logic/use-webpack-to-bundle-web-resource-files)

# WR-010

Every web resource must have a display name and a description that explain its purpose and usage.

1. Set a clear **Display Name** that describes what the web resource does.
1. Write a **Description** that includes the entity or feature it supports, the events it handles, and any dependencies on other web resources.
1. If the web resource is a shared library, list the web resources that depend on it.

## Rationale

1. Dataverse solutions can contain hundreds of web resources. Without display names and descriptions, it is difficult to determine the purpose of each resource.
1. Descriptions reduce the risk of accidental modification or deletion by making the resource's usage and dependencies clear.
1. Good metadata helps onboard new developers and simplifies solution maintenance.

## Examples

### Good

- **Display Name**: _Account Form Events_
- **Description**: _Handles OnLoad, OnSave, and OnChange events for the Account main form. Depends on contoso\_/scripts/lib/utilities.js. Registered on the Account Main Form._

### Bad

- **Display Name**: _Script1_
- **Description**: _(empty)_

## More Information
1. [Create or edit web resources - Microsoft Learn](https://learn.microsoft.com/en-us/power-apps/developer/model-driven-apps/create-edit-web-resources)
