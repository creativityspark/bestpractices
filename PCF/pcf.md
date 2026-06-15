# PCF Controls

Good practices for Power Apps Component Framework (PCF) code components.

# PCF-001

Always deploy production builds of code components to Dataverse. Never deploy development builds to non-development environments.

1. Build code components using `npm run build -- --buildMode production` or `msbuild /p:configuration=Release` before deploying.
1. Development builds include unminified code, source maps, and debugging aids that increase bundle size significantly.
1. Set up an automated build pipeline to ensure production builds are always used for deployment.

## Rationale

1. Development builds are significantly larger than production builds and adversely affect load times and overall performance.
1. Large development bundles may be blocked from deployment due to exceeding size limits.
1. Production builds apply minification, tree-shaking, and other optimizations that are essential for a good end-user experience.

## Examples

### Good

Building with production mode before deploying:

```shell
npm run build -- --buildMode production
```

Using MSBuild with Release configuration:

```shell
msbuild /p:configuration=Release
```

### Bad

Deploying a development build directly:

```shell
npm run build
# Then importing the solution without switching to production mode
```

Forgetting to set the build mode in CI/CD pipelines:

```yaml
# Missing --buildMode production flag
- script: npm run build
```

## More Information

1. [Best practices and guidance for code components - Microsoft Learn](https://learn.microsoft.com/en-us/power-apps/developer/component-framework/code-components-best-practices)
1. [Debugging custom controls - Microsoft Learn](https://learn.microsoft.com/en-us/power-apps/developer/component-framework/debugging-custom-controls)

# PCF-002

Always clean up resources inside the `destroy` method. Remove event listeners, close WebSockets, and unmount React components to prevent memory leaks.

1. Use the `destroy` method to close any open `WebSocket` connections.
1. Remove event listeners that were added to elements outside the container element.
1. If using React, call `ReactDOM.unmountComponentAtNode` inside the `destroy` method to properly tear down the React component tree.
1. Clear any pending timers (`setTimeout`, `setInterval`) or animation frames.

## Rationale

1. Code components can be loaded and unloaded multiple times within a single browser session, especially in model-driven apps. Failing to clean up resources causes memory leaks that degrade performance over time.
1. Orphaned event listeners continue to fire after the component is removed from the DOM, potentially causing errors or unexpected behavior.
1. React components that are not properly unmounted will retain references to stale DOM nodes and state, leading to memory leaks and console errors.

## Examples

### Good

```typescript
public destroy(): void {
    window.removeEventListener("resize", this._onResize);
    clearInterval(this._pollingInterval);
    ReactDOM.unmountComponentAtNode(this._container);
}
```

### Bad

```typescript
public destroy(): void {
    // Empty destroy method — resources are never cleaned up
}
```

```typescript
// Adding a global event listener without ever removing it
public init(context: ComponentFramework.Context<IInputs>): void {
    window.addEventListener("resize", this._onResize);
}

public destroy(): void {
    // Missing: window.removeEventListener("resize", this._onResize);
}
```

## More Information

1. [Control.destroy - Microsoft Learn](https://learn.microsoft.com/en-us/power-apps/developer/component-framework/reference/control/destroy)
1. [Best practices and guidance for code components - Microsoft Learn](https://learn.microsoft.com/en-us/power-apps/developer/component-framework/code-components-best-practices)

# PCF-003

Minimize calls to `notifyOutputChanged`. Avoid calling it on every keystroke or mouse move event. Instead, debounce or trigger it when the user interaction completes, such as on blur or mouse-up events.

1. Do not call `notifyOutputChanged` inside high-frequency event handlers such as `onkeypress`, `onmousemove`, or `oninput`.
1. Use a debounce or throttle mechanism to batch rapid changes into a single notification.
1. Prefer triggering `notifyOutputChanged` on events that signal the end of an interaction, such as `onblur`, `onchange`, or `onmouseup`.

## Rationale

1. Each call to `notifyOutputChanged` triggers the hosting context to call `getOutputs` and propagate changes to the parent context. Excessive calls create unnecessary processing overhead.
1. In canvas apps, frequent output changes can trigger formula re-evaluation cascades, severely degrading app performance.
1. Debouncing provides a smoother user experience by only committing the final value after the user finishes interacting.

## Examples

### Good

```typescript
private _onInputBlur = (): void => {
    this._value = this._inputElement.value;
    this._notifyOutputChanged();
};

public init(context: ComponentFramework.Context<IInputs>): void {
    this._inputElement.addEventListener("blur", this._onInputBlur);
}
```

Using a debounce approach:

```typescript
private _debouncedNotify = debounce(() => {
    this._notifyOutputChanged();
}, 300);

private _onInput = (): void => {
    this._value = this._inputElement.value;
    this._debouncedNotify();
};
```

### Bad

```typescript
// Calling notifyOutputChanged on every keystroke
private _onKeyPress = (): void => {
    this._value = this._inputElement.value;
    this._notifyOutputChanged();
};
```

```typescript
// Calling notifyOutputChanged on mouse move
private _onMouseMove = (event: MouseEvent): void => {
    this._position = { x: event.clientX, y: event.clientY };
    this._notifyOutputChanged();
};
```

## More Information

1. [Best practices and guidance for code components - Microsoft Learn](https://learn.microsoft.com/en-us/power-apps/developer/component-framework/code-components-best-practices)

# PCF-004

Always handle null or undefined property values in the `updateView` method. Data may not be ready when `updateView` is first called, and your component must gracefully handle this state.

1. Check for null or undefined values on all bound properties before using them.
1. Provide a visual loading indicator or a sensible default when data is not yet available.
1. Expect that a subsequent `updateView` call will include the actual values once data is ready.

## Rationale

1. The hosting context may call `updateView` before the bound data has loaded, passing null values for properties that will eventually have data.
1. Attempting to use null values without checking leads to runtime errors that break the component.
1. Providing a loading state improves user experience by giving visual feedback that data is being fetched.

## Examples

### Good

```typescript
public updateView(context: ComponentFramework.Context<IInputs>): void {
    const value = context.parameters.inputValue.raw;

    if (value === null || value === undefined) {
        this._container.innerHTML = "";
        this._container.appendChild(this._loadingSpinner);
        return;
    }

    this._renderContent(value);
}
```

### Bad

```typescript
public updateView(context: ComponentFramework.Context<IInputs>): void {
    // Directly using the value without null checking — will throw if null
    const value = context.parameters.inputValue.raw;
    this._container.innerText = value.toString();
}
```

## More Information

1. [Control.updateView - Microsoft Learn](https://learn.microsoft.com/en-us/power-apps/developer/component-framework/reference/control/updateview)
1. [Best practices and guidance for code components - Microsoft Learn](https://learn.microsoft.com/en-us/power-apps/developer/component-framework/code-components-best-practices)

# PCF-005

Always scope CSS rules to your code component's container. Never use global CSS selectors that could affect other components or the host application.

1. Use the automatically generated CSS class applied to your component's container `DIV` element to scope all styles.
1. The scoped class follows the pattern `Namespace.ComponentName`.
1. If using a third-party CSS framework, wrap it in a namespace or use a namespaced version.
1. Avoid using overly broad selectors like `div`, `input`, or `*` without scoping them to your component.

## Rationale

1. Globally scoped CSS can unintentionally override styles of the host application (model-driven app, canvas app, or portal), causing layout or styling issues.
1. Multiple code components on the same page may conflict with each other if they use global styles.
1. Scoped CSS ensures your component is visually self-contained and predictable regardless of where it is rendered.

## Examples

### Good

```css
.SampleNamespace\.LinearInputComponent .slider-control {
    width: 100%;
    height: 24px;
}

.SampleNamespace\.LinearInputComponent .slider-label {
    font-size: 14px;
    color: #333;
}
```

### Bad

```css
/* Global selector — affects ALL inputs on the page */
input {
    border: 2px solid blue;
    font-size: 16px;
}

/* Overly broad selector — affects all divs */
div {
    padding: 10px;
    margin: 5px;
}
```

```css
/* Unscoped class name — may conflict with other components */
.slider-control {
    width: 100%;
}
```

## More Information

1. [Best practices and guidance for code components - Microsoft Learn](https://learn.microsoft.com/en-us/power-apps/developer/component-framework/code-components-best-practices)

# PCF-006

Avoid using `innerHTML` to render dynamic content. Use DOM APIs such as `document.createElement`, or use a framework like React to build the UI safely.

1. Never assign user-provided or data-bound values directly to `innerHTML`.
1. Use `document.createElement` and `textContent` for simple DOM construction.
1. For complex UIs, use React or another framework that automatically escapes content and prevents XSS vulnerabilities.
1. If HTML rendering is absolutely required, sanitize the content using a trusted library such as DOMPurify.

## Rationale

1. Setting `innerHTML` with unsanitized content exposes the component to Cross-Site Scripting (XSS) attacks, where malicious scripts can be injected and executed in the user's browser.
1. Frameworks like React use a virtual DOM that automatically escapes string values, preventing injection attacks by default.
1. DOM APIs like `createElement` and `textContent` are inherently safe because they do not parse HTML.

## Examples

### Good

Using DOM APIs safely:

```typescript
const label = document.createElement("span");
label.textContent = context.parameters.displayText.raw ?? "";
this._container.appendChild(label);
```

Using React (auto-escapes content):

```tsx
const MyComponent: React.FC<{ text: string }> = ({ text }) => (
    <div>{text}</div>
);
```

### Bad

```typescript
// Directly injecting data into innerHTML — XSS vulnerability
this._container.innerHTML =
    `<span>${context.parameters.displayText.raw}</span>`;
```

```typescript
// User-controlled data rendered as HTML
this._container.innerHTML = userProvidedHtml;
```

## More Information

1. [OWASP XSS Prevention Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/Cross-Site_Scripting_Prevention_Cheat_Sheet.html)
1. [Best practices and guidance for code components - Microsoft Learn](https://learn.microsoft.com/en-us/power-apps/developer/component-framework/code-components-best-practices)

# PCF-007

Use path-based imports when importing from Fluent UI React to reduce bundle size. Avoid importing from the package root.

1. Import individual components using their specific path, such as `@fluentui/react/lib/Button`.
1. Avoid importing from the root `@fluentui/react` barrel export.
1. Alternatively, configure tree-shaking in `tsconfig.json` by setting `"module": "es2015"` and `"moduleResolution": "node"`.

## Rationale

1. The PCF build toolchain does not enable tree-shaking by default. Importing from the root barrel export bundles the entire Fluent UI library, significantly increasing the component's size.
1. Path-based imports ensure only the specific component code is included in the bundle, reducing load times.
1. Smaller bundles improve performance, especially when multiple code components are loaded on the same page.

## Examples

### Good

```typescript
import { PrimaryButton } from "@fluentui/react/lib/Button";
import { TextField } from "@fluentui/react/lib/TextField";
import { Dropdown } from "@fluentui/react/lib/Dropdown";
```

### Bad

```typescript
// Imports the entire Fluent UI library into the bundle
import { PrimaryButton, TextField, Dropdown } from "@fluentui/react";
```

## More Information

1. [Fluent UI - Advanced Usage](https://github.com/microsoft/fluentui/wiki/Advanced-Usage)
1. [Best practices and guidance for code components - Microsoft Learn](https://learn.microsoft.com/en-us/power-apps/developer/component-framework/code-components-best-practices)

# PCF-008

Use the `init` method to request network resources such as metadata or configuration data. Do not defer these requests to `updateView`.

1. Initiate any required network calls (metadata, configuration, reference data) inside the `init` method.
1. If the data has not yet returned when `updateView` is called, display a loading indicator.
1. Store the results of network calls in instance variables for use in subsequent `updateView` calls.

## Rationale

1. The `init` method is called once when the component is first loaded, making it the ideal place for one-time setup and data fetching.
1. Deferring network calls to `updateView` means they execute on every re-render, causing redundant requests and poor performance.
1. Fetching data early in `init` reduces the time the user sees a loading state, since the request starts before the first render.

## Examples

### Good

```typescript
public init(
    context: ComponentFramework.Context<IInputs>,
    notifyOutputChanged: () => void,
    state: ComponentFramework.Dictionary
): void {
    this._notifyOutputChanged = notifyOutputChanged;
    this._isLoading = true;

    this._fetchMetadata(context).then((metadata) => {
        this._metadata = metadata;
        this._isLoading = false;
        this._notifyOutputChanged();
    });
}

public updateView(context: ComponentFramework.Context<IInputs>): void {
    if (this._isLoading) {
        this._showLoadingIndicator();
        return;
    }
    this._renderWithMetadata(this._metadata);
}
```

### Bad

```typescript
// Fetching data inside updateView — runs on every re-render
public updateView(context: ComponentFramework.Context<IInputs>): void {
    fetch("/api/metadata")
        .then((response) => response.json())
        .then((data) => {
            this._renderWithMetadata(data);
        });
}
```

## More Information

1. [Control.init - Microsoft Learn](https://learn.microsoft.com/en-us/power-apps/developer/component-framework/reference/control/init)
1. [Best practices and guidance for code components - Microsoft Learn](https://learn.microsoft.com/en-us/power-apps/developer/component-framework/code-components-best-practices)

# PCF-009

Always check API availability before using platform-specific APIs. Not all APIs are available in every host (model-driven apps, canvas apps, portals).

1. Check whether an API exists on the `context` object before calling it.
1. Provide a graceful fallback or inform the user when a required API is unavailable.
1. Refer to the PCF API reference documentation for per-host availability.

## Rationale

1. The `context.webAPI` is not available in canvas apps. Calling it without a check will result in runtime errors.
1. Code components are designed to work across multiple hosts (model-driven apps, canvas apps, and portals), each with different API support.
1. Defensive checks future-proof the component against changes in API availability across platform updates.

## Examples

### Good

```typescript
public updateView(context: ComponentFramework.Context<IInputs>): void {
    if (context.webAPI) {
        context.webAPI
            .retrieveMultipleRecords("account", "?$top=10")
            .then((result) => this._renderRecords(result.entities));
    } else {
        this._renderFallbackMessage(
            "This component requires Web API access."
        );
    }
}
```

### Bad

```typescript
// Calling webAPI without checking availability — fails in canvas apps
public updateView(context: ComponentFramework.Context<IInputs>): void {
    context.webAPI
        .retrieveMultipleRecords("account", "?$top=10")
        .then((result) => this._renderRecords(result.entities));
}
```

## More Information

1. [Power Apps component framework API reference - Microsoft Learn](https://learn.microsoft.com/en-us/power-apps/developer/component-framework/reference/)
1. [Best practices and guidance for code components - Microsoft Learn](https://learn.microsoft.com/en-us/power-apps/developer/component-framework/code-components-best-practices)

# PCF-010

Do not use `window.localStorage` or `window.sessionStorage` to persist data in code components. Use the framework-provided mechanisms instead.

1. Avoid reading from or writing to `window.localStorage` and `window.sessionStorage`.
1. Use bound properties and `notifyOutputChanged` to pass data back to the hosting context.
1. If state persistence is needed, store data in Dataverse or use the `state` parameter of the `init` method for transient state.

## Rationale

1. Data stored in web storage is not secure and could be accessed by other scripts running on the same domain.
1. Web storage is tied to the specific browser and device, so data stored there is not reliably available across sessions, devices, or users.
1. The hosting context (model-driven apps, canvas apps) manages its own data flow. Bypassing it with web storage creates inconsistencies and makes the component harder to test and debug.

## Examples

### Good

```typescript
// Using bound properties to persist data
public getOutputs(): IOutputs {
    return {
        savedValue: this._currentValue,
    };
}

// Using the state parameter for transient state
public init(
    context: ComponentFramework.Context<IInputs>,
    notifyOutputChanged: () => void,
    state: ComponentFramework.Dictionary
): void {
    if (state && state["lastViewedTab"]) {
        this._activeTab = state["lastViewedTab"];
    }
}
```

### Bad

```typescript
// Storing data in localStorage — insecure and unreliable
public init(
    context: ComponentFramework.Context<IInputs>
): void {
    localStorage.setItem("myComponent_value", this._currentValue);
}

public updateView(context: ComponentFramework.Context<IInputs>): void {
    this._currentValue = localStorage.getItem("myComponent_value") ?? "";
}
```

## More Information

1. [Best practices and guidance for code components - Microsoft Learn](https://learn.microsoft.com/en-us/power-apps/developer/component-framework/code-components-best-practices)

# PCF-011

Bundle all required modules as part of your code component. Do not rely on external `<script>` tags or globally loaded libraries.

1. Install all dependencies via `npm` and import them in your TypeScript code.
1. Do not assume that any external library is already loaded in the host application.
1. Do not inject `<script>` or `<link>` tags into the document to load external resources.

## Rationale

1. Code components run in isolated contexts and cannot rely on global scripts being available on the page.
1. Injecting `<script>` tags introduces unpredictable loading order, potential conflicts with other components, and security risks.
1. Bundling all dependencies ensures the component works reliably in offline scenarios and across all host types (model-driven apps, canvas apps, portals).

## Examples

### Good

```shell
npm install chart.js
```

```typescript
import { Chart } from "chart.js";

public init(context: ComponentFramework.Context<IInputs>): void {
    const canvas = document.createElement("canvas");
    this._container.appendChild(canvas);
    this._chart = new Chart(canvas, { /* config */ });
}
```

### Bad

```typescript
// Injecting a script tag to load an external library
public init(context: ComponentFramework.Context<IInputs>): void {
    const script = document.createElement("script");
    script.src = "https://cdn.jsdelivr.net/npm/chart.js";
    document.head.appendChild(script);
}
```

```typescript
// Assuming a globally available library
public init(context: ComponentFramework.Context<IInputs>): void {
    // Chart is assumed to be available globally — will fail
    const chart = new (window as any).Chart(canvas, { /* config */ });
}
```

## More Information

1. [Best practices and guidance for code components - Microsoft Learn](https://learn.microsoft.com/en-us/power-apps/developer/component-framework/code-components-best-practices)

# PCF-012

Ensure code components are accessible. Provide keyboard navigation alternatives and use ARIA attributes so that screen readers can accurately describe the component's interface.

1. Ensure all interactive elements can be reached and operated via keyboard (Tab, Enter, Escape, arrow keys).
1. Add `aria-label`, `aria-role`, and other ARIA attributes to convey the component's structure and state to assistive technologies.
1. Use semantic HTML elements (`button`, `input`, `select`) instead of generic `div` or `span` for interactive elements.
1. Test with screen readers and browser accessibility inspection tools.

## Rationale

1. Power Apps is used in enterprise environments where accessibility compliance (WCAG) is often a legal requirement.
1. Keyboard-only users and screen-reader users cannot interact with components that rely solely on mouse or touch events.
1. Using semantic HTML and ARIA attributes allows assistive technologies to provide an accurate representation of the component, improving usability for all users.

## Examples

### Good

```typescript
const button = document.createElement("button");
button.textContent = "Submit";
button.setAttribute("aria-label", "Submit the form");
button.addEventListener("keydown", (e) => {
    if (e.key === "Enter" || e.key === " ") {
        this._onSubmit();
    }
});
this._container.appendChild(button);
```

```tsx
<Dropdown
    label="Select a country"
    ariaLabel="Country selector"
    options={this._countryOptions}
    onChange={this._onCountryChange}
/>
```

### Bad

```typescript
// Using a div as a button — not keyboard accessible, no ARIA role
const fakeButton = document.createElement("div");
fakeButton.textContent = "Submit";
fakeButton.onclick = () => this._onSubmit();
this._container.appendChild(fakeButton);
```

```typescript
// No ARIA attributes — screen readers cannot describe the control
const input = document.createElement("input");
input.type = "text";
// Missing: aria-label or associated label element
this._container.appendChild(input);
```

## More Information

1. [Accessible Rich Internet Applications (ARIA) - MDN](https://developer.mozilla.org/en-US/docs/Web/Accessibility/ARIA)
1. [Create accessible canvas apps - Microsoft Learn](https://learn.microsoft.com/en-us/power-apps/maker/canvas-apps/accessible-apps)
1. [Best practices and guidance for code components - Microsoft Learn](https://learn.microsoft.com/en-us/power-apps/developer/component-framework/code-components-best-practices)
