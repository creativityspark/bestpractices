# Web Resources

Good practices for Dataverse Web Resources.

## WR-001

### Title

Use a consistent naming convention with virtual folder structures for all web resources

### Description

Use a consistent naming convention with virtual folder structures for all web resources.

### Guidelines

1. Always start the name with the publisher prefix followed by a forward slash.
1. Group web resources by type using virtual folders (e.g., js/, html/, css/, img/).
1. Within each type folder, group by entity or feature.
1. Use camelCase or lowercase for file names. Avoid spaces and special characters.
1. Keep the folder hierarchy shallow - no more than 3 levels deep.

### Rationale

1. A consistent naming convention makes it easy to locate and manage web resources as the solution grows.
1. Virtual folder structures simulate a file system within Dataverse, improving organization and discoverability.
1. Grouping by entity or feature ensures that related resources are located together, simplifying maintenance.
1. Deep nesting makes navigation difficult and names excessively long.



### Examples

#### Good

Good example code snippet.
```Plain Text
contoso_/js/account/formEvents.js
contoso_/js/contact/phoneValidation.js
contoso_/js/lib/utilities.js
contoso_/html/account/quickView.html
contoso_/css/common.css
contoso_/img/icons/phone.svg
```

#### Bad

Bad example code snippet.
```Plain Text
new_script1.js
new_script2.js
accountformeventsvalidationandribbon.js
contoso_/js/features/module1/submodule2/helpers/internal/utils.js
```

### More Information

1. [Web resources in model-driven apps - Microsoft Learn](https://learn.microsoft.com/en-us/power-apps/developer/model-driven-apps/web-resources)

## WR-002

### Title

Every web resource must have a display name and a description that explain its purpose...

### Description

Every web resource must have a display name and a description that explain its purpose and usage.

### Guidelines

1. Set a clear Display Name that describes what the web resource does.
1. Write a Description that includes the entity or feature it supports, the events it handles, and any dependencies on other web resources.
1. If the web resource is a shared library, list the web resources that depend on it.

### Rationale

1. Dataverse solutions can contain hundreds of web resources. Without display names and descriptions, it is difficult to determine the purpose of each resource.
1. Descriptions reduce the risk of accidental modification or deletion by making the resource's usage and dependencies clear.
1. Good metadata helps onboard new developers and simplifies solution maintenance.



### Examples

#### Good

- Display Name: Account Form Events
- Description: Handles OnLoad, OnSave, and OnChange events for the Account main form. Depends on contoso\/js/lib/utilities.js. Registered on the Account Main Form._

#### Bad

- Display Name: Script1
- Description: (empty)

### More Information

1. [Create or edit web resources - Microsoft Learn](https://learn.microsoft.com/en-us/power-apps/developer/model-driven-apps/create-edit-web-resources)

## WR-003

### Title

Sanitize all user input and dynamic data rendered in HTML web resources to prevent Cros...

### Description

Sanitize all user input and dynamic data rendered in HTML web resources to prevent Cross-Site Scripting (XSS).

### Guidelines

1. Never use innerHTML to render user-supplied or entity data. Use textContent or DOM APIs to create elements safely.
1. Do not use eval(), new Function(), or setTimeout/setInterval with string arguments.
1. If you must render HTML from dynamic data, use a sanitization library such as DOMPurify.
1. Add a Content Security Policy <meta> tag to your HTML web resources to restrict script and style sources.

### Rationale

1. Dataverse records may contain data entered by external users or imported from other systems. This data could contain malicious scripts.
1. XSS vulnerabilities can lead to session hijacking, data theft, or unauthorized actions performed on behalf of the logged-in user.
1. A Content Security Policy provides an additional layer of defense by restricting which resources the browser is allowed to load and execute.



### Examples

#### Good

Good example code snippet.
```html
<meta http-equiv="Content-Security-Policy"
      content="default-src 'self'; script-src 'self'; style-src 'self'; object-src 'none'">
```
Good example code snippet.
```javascript
// Using textContent to safely render data
var output = document.getElementById("output");
output.textContent = recordName; // Safe — HTML is not parsed
```

#### Bad

Bad example code snippet.
```javascript
// Using innerHTML with unsanitized data — vulnerable to XSS
var output = document.getElementById("output");
output.innerHTML = "<h1>" + recordName + "</h1>";

// Using eval to process data
eval("var data = " + serverResponse);
```

### More Information

1. [Content Security Policy (CSP) - MDN Web Docs](https://developer.mozilla.org/en-US/docs/Web/HTTP/CSP)
1. [DOMPurify - GitHub](https://github.com/cure53/DOMPurify)
1. [Cross-site scripting prevention - OWASP](https://cheatsheetseries.owasp.org/cheatsheets/Cross-Site_Scripting_Prevention_Cheat_Sheet.html)

## WR-004

### Title

Optimize all image web resources for size and use SVG format whenever possible

### Description

Optimize all image web resources for size and use SVG format whenever possible.

### Guidelines

1. Use SVG format for icons, logos, and any graphics that can be represented as vectors.
1. Compress raster images (PNG, JPG, GIF) before uploading them as web resources. Use tools such as TinyPNG, Squoosh, or ImageOptim.
1. Choose the appropriate raster format: PNG for images requiring transparency, JPG for photographs, and avoid BMP or TIFF entirely.
1. Keep image dimensions appropriate for their usage context - do not upload a 4000×3000 image for a 32×32 icon.
1. Avoid embedding large Base64-encoded images in HTML or CSS web resources.

### Rationale

1. SVG files are resolution-independent, scale perfectly on all screen sizes, and are typically much smaller than raster equivalents for icons and simple graphics.
1. Unoptimized images are the most common cause of large solution sizes and slow form load times.
1. Dataverse has a 5 MB file size limit per web resource. Optimizing images ensures you stay well within this limit.
1. Base64-encoded images bypass browser caching and inflate the size of the parent HTML or CSS file.



### Examples

#### Good

- A table icon uploaded as a 2 KB SVG file at contoso_/img/icons/customer.svg.
- A product photograph compressed from 3.2 MB to 180 KB using TinyPNG before uploading as contoso_/img/products/widget.jpg.

#### Bad

- A 1.5 MB PNG file used as a 32×32 table icon when a 2 KB SVG would suffice.
- An uncompressed 4000×3000 BMP screenshot uploaded as a dashboard background.
- A 500 KB Base64-encoded logo embedded directly inside an HTML web resource.

### More Information

1. [Image web resources - Microsoft Learn](https://learn.microsoft.com/en-us/power-apps/developer/model-driven-apps/image-web-resources)
1. [SVG on the web - MDN Web Docs](https://developer.mozilla.org/en-US/docs/Web/SVG)
1. [Squoosh - Image compression tool](https://squoosh.app/)

## WR-005

### Title

Prefix all CSS class and ID names with the project or publisher prefix to avoid collisi...

### Description

Prefix all CSS class and ID names with the project or publisher prefix to avoid collisions with platform styles.

### Guidelines

1. Use a short, consistent prefix derived from your publisher or project name for all CSS selectors (e.g., .csp-header, #csp-sidebar).
1. Do not use generic class names such as .header, .container, or .active without a prefix.
1. Keep CSS in external .css web resource files rather than inline <style> blocks in HTML web resources.
1. Avoid using !important to override platform styles - this creates fragile dependencies on the platform's internal CSS.

### Rationale

1. HTML web resources are loaded inside iframes, but in some contexts (e.g., custom pages, embedded resources) CSS can leak across boundaries. Prefixed selectors eliminate the risk of collisions.
1. Generic class names are commonly used by the platform's own stylesheets. Overriding them can cause unexpected visual side effects.
1. External CSS files can be cached by the browser separately from the HTML, improving load times on subsequent visits.
1. Using !important to fight platform styles breaks when Microsoft updates their CSS, leading to unpredictable rendering.



### Examples

#### Good

Good example code snippet.
```css
.csp-dashboard-header {
    font-size: 18px;
    color: #333333;
}

.csp-status-badge {
    padding: 4px 8px;
    border-radius: 4px;
}
```

#### Bad

Bad example code snippet.
```css
.header {
    font-size: 18px;
    color: #333333;
}

.container {
    width: 100% !important;
}
```

### More Information

1. [CSS web resources - Microsoft Learn](https://learn.microsoft.com/en-us/power-apps/developer/model-driven-apps/css-web-resources)

## WR-006

### Title

Keep HTML web resources lightweight, responsive, and well-structured

### Description

Keep HTML web resources lightweight, responsive, and well-structured.

### Guidelines

1. Always include a proper <!DOCTYPE html> declaration, a <html lang="..."> attribute, and <meta charset="utf-8">.
1. Keep the HTML structure minimal - avoid unnecessary wrapper elements and deeply nested DOM trees.
1. Use responsive design techniques (relative units, media queries, or a lightweight CSS framework) so the resource renders correctly at different sizes.
1. Load JavaScript and CSS from separate web resource files rather than inlining them in the HTML.
1. Consider accessibility: use semantic HTML elements, provide alt attributes on images, and ensure sufficient color contrast.

### Rationale

1. A proper doctype and character set declaration ensure consistent rendering across all supported browsers.
1. HTML web resources are often displayed inside iframes on forms and dashboards. Excessive DOM complexity increases rendering time within the already constrained iframe.
1. Users may resize the form pane or access it from different screen sizes. Responsive design prevents clipped or broken layouts.
1. Separating concerns (HTML, CSS, JS) improves cacheability and makes individual files easier to maintain and update independently.



### Examples

#### Good

Good example code snippet.
```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="Content-Security-Policy"
          content="default-src 'self'; script-src 'self'; style-src 'self'; object-src 'none'">
    <link rel="stylesheet" href="contoso_/css/dashboard.css">
    <title>Customer Dashboard</title>
</head>
<body>
    <main id="csp-dashboard">
        <h1>Customer Overview</h1>
        <div id="csp-dashboard-content"></div>
    </main>
    <script src="contoso_/js/dashboard/main.js"></script>
</body>
</html>
```

#### Bad

Bad example code snippet.
```html
<html>
<body>
<script>
    // Hundreds of lines of inline JavaScript
</script>
<style>
    /* Hundreds of lines of inline CSS */
</style>
<div><div><div><div><div>Deeply nested content</div></div></div></div></div>
</body>
</html>
```

### More Information

1. [Webpage (HTML) web resources - Microsoft Learn](https://learn.microsoft.com/en-us/power-apps/developer/model-driven-apps/webpage-html-web-resources)

## WR-007

### Title

Declare dependencies between web resources explicitly using the dependency configuratio...

### Description

Declare dependencies between web resources explicitly using the dependency configuration in the solution.

### Guidelines

1. Use the web resource dependency settings in the form editor or solution explorer to declare which web resources depend on others.
1. Do not dynamically load web resources at runtime using custom script loaders unless there is no alternative.
1. When a JavaScript library depends on a shared utility library, add the utility as a dependency so the platform loads it first.
1. Before exporting a solution, use the Dependency Checker in Solution Explorer to verify that all required web resources are included.

### Rationale

1. Explicitly declared dependencies ensure the platform loads web resources in the correct order, preventing runtime errors caused by missing references.
1. Dynamic script loading hides dependencies from the solution system. When the solution is exported and imported into another environment, dynamically loaded resources may be missing, causing silent failures.
1. The Dependency Checker prevents broken solutions from being deployed to downstream environments by catching missing components before export.



### Examples

#### Good

- The form library list shows contoso/js/lib/utilities.js loaded before contoso/js/account/formEvents.js, because the dependency is declared in the form configuration.
- The solution's Dependency Checker reports no missing components before export.

#### Bad

- A script dynamically loads a utility library at runtime using a custom loadScript() function. The utility library is not included in the solution, and the script fails silently in the target environment after import.
- Two JavaScript libraries are added to a form without specifying their load order, causing intermittent "function is not defined" errors.

### More Information

1. [Web resource dependencies - Microsoft Learn](https://learn.microsoft.com/en-us/power-apps/developer/model-driven-apps/web-resource-dependencies)
1. [Solution dependency management - Microsoft Learn](https://learn.microsoft.com/en-us/power-platform/alm/solution-dependency-management)

## WR-008

### Title

Periodically audit and remove unused web resources from the solution

### Description

Periodically audit and remove unused web resources from the solution.

### Guidelines

1. Review the solution's web resources regularly and identify any that are no longer referenced by forms, dashboards, SiteMaps, or other web resources.
1. Before deleting a web resource, verify that it is not referenced by any component using the Show Dependencies feature in Solution Explorer.
1. Remove web resources that were added for testing or prototyping and are no longer needed.
1. Document the audit in the project's change log or release notes.

### Rationale

1. Orphaned web resources increase solution size, making exports and imports slower and consuming unnecessary storage.
1. Unused resources create confusion for developers who may waste time trying to understand their purpose or inadvertently modify them.
1. Keeping the solution clean reduces the risk of accidentally deploying obsolete or conflicting code to production.



### Examples

#### Good

- A quarterly review identifies three JavaScript libraries that were replaced six months ago. They are verified as unused via Show Dependencies and removed from the solution.

#### Bad

- A solution contains 40 web resources, but only 15 are actively used. The remaining 25 are leftovers from previous development cycles that no one has reviewed or cleaned up.
- A developer deletes a web resource without checking dependencies, breaking a form that still references it.

### More Information

1. [View dependencies for a component - Microsoft Learn](https://learn.microsoft.com/en-us/power-apps/maker/data-platform/view-component-dependencies)

## WR-009

### Title

Use RESX web resources for multi-language support instead of hardcoding strings in HTML...

### Description

Use RESX web resources for multi-language support instead of hardcoding strings in HTML or JavaScript files.

### Guidelines

1. Create a default RESX file (e.g., contoso_/resx/Strings.resx) containing all user-facing strings.
1. Create additional RESX files for each supported language using the locale code suffix (e.g., contoso_/resx/Strings.1036.resx for French).
1. Use the Xrm.Utility.getResourceString() method to retrieve localized strings at runtime.
1. Use the user's language setting (Xrm.Utility.getGlobalContext().userSettings.languageId) to determine which RESX file to load.
1. Keep string keys consistent across all RESX files and use descriptive key names.

### Rationale

1. Hardcoded strings force a code change and redeployment every time a translation needs to be added or updated.
1. RESX files can be handed to translators without exposing application code.
1. The platform's built-in getResourceString() method handles RESX parsing and fallback automatically, reducing custom code.
1. Consistent keys across language files ensure that missing translations are immediately detectable.



### Examples

#### Good

Good example code snippet.
```xml
<!-- contoso_/resx/Strings.resx (default — English) -->
<data name="greeting_message" xml:space="preserve">
    <value>Welcome to the Customer Portal</value>
</data>
<data name="save_button_label" xml:space="preserve">
    <value>Save</value>
</data>
```
Good example code snippet.
```xml
<!-- contoso_/resx/Strings.1036.resx (French) -->
<data name="greeting_message" xml:space="preserve">
    <value>Bienvenue sur le portail client</value>
</data>
<data name="save_button_label" xml:space="preserve">
    <value>Enregistrer</value>
</data>
```
Good example code snippet.
```javascript
// Retrieving a localized string at runtime
var greeting = Xrm.Utility.getResourceString("contoso_/resx/Strings", "greeting_message");
```

#### Bad

Bad example code snippet.
```javascript
// Hardcoded strings in JavaScript — no localization support
var greeting = "Welcome to the Customer Portal";
var saveLabel = "Save";
```
Bad example code snippet.
```html
<!-- Hardcoded strings in HTML — requires code change for every language -->
<h1>Welcome to the Customer Portal</h1>
<button>Save</button>
```

### More Information

1. [String (RESX) web resources - Microsoft Learn](https://learn.microsoft.com/en-us/power-apps/developer/model-driven-apps/resx-web-resources)
1. [Use RESX files to localize web resources - Microsoft Learn](https://learn.microsoft.com/en-us/power-apps/developer/model-driven-apps/custom-html-resx-localization)


