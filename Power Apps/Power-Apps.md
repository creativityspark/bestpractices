# Canvas Apps

Good practices for Power Apps Canvas Apps.

# CA-001: Control Naming Conventions

All controls must be renamed from their default names using a consistent prefix that indicates the control type, followed by a descriptive name in PascalCase.

| Prefix | Control Type    | Example              |
| ------ | --------------- | -------------------- |
| scr    | Screen          | scrHome              |
| btn    | Button          | btnSaveRecord        |
| lbl    | Label           | lblErrorMessage      |
| txt    | Text Input      | txtCustomerName      |
| cmb    | Combo Box       | cmbCountrySelector   |
| drp    | Drop Down       | drpStatusFilter      |
| gal    | Gallery         | galOrderList         |
| frm    | Form            | frmEditContact       |
| ico    | Icon            | icoDeleteItem        |
| img    | Image           | imgCompanyLogo       |
| chk    | Checkbox        | chkAgreeTerms        |
| tgl    | Toggle          | tglDarkMode          |
| dtl    | Data Table      | dtlSalesReport       |
| tmr    | Timer           | tmrAutoRefresh       |
| cnt    | Container       | cntHeaderLayout      |

1. Rename every control immediately after adding it to the screen.
1. Use PascalCase for the descriptive portion of the name.
1. Keep names concise but descriptive enough to identify the control's purpose.

## Rationale

1. Default names like `Button1`, `TextInput3`, or `Gallery2` provide no context about the control's purpose and make formulas difficult to read and maintain.
1. Prefixes make it immediately obvious what type of control is being referenced in a formula, reducing errors during development.
1. Consistent naming enables efficient searching and filtering when working with large apps containing hundreds of controls.
1. Descriptive names make formulas self-documenting, for example `btnSaveRecord.OnSelect` is far more readable than `Button3.OnSelect`.

## Examples

### Good

- `btnSubmitOrder` — clear type and purpose
- `galActiveProjects` — identifies a gallery showing active projects
- `txtSearchQuery` — text input for a search field
- `lblTotalAmount` — label displaying a total

### Bad

- `Button1` — default name, no context
- `TextInput3` — no indication of what data it captures
- `Gallery2` — no clue about what data it displays
- `saveBtn` — inconsistent format, prefix should come first

# CA-002: Variable and Collection Naming Conventions

Variables and collections must use **camelCase** notation and be prefixed with a short type indicator.

| Prefix | Type              | Example               |
| ------ | ----------------- | --------------------- |
| gbl    | Global Variable   | gblCurrentUser        |
| loc    | Context Variable  | locShowDialog         |
| col    | Collection        | colFilteredOrders     |

1. Use `gbl` for variables set with `Set()`.
1. Use `loc` for variables set with `UpdateContext()`.
1. Use `col` for collections created with `ClearCollect()` or `Collect()`.
1. The name after the prefix should clearly describe the data or state being stored.

## Rationale

1. Prefixes make it immediately clear whether a variable is global, local, or a collection, which matters for understanding scope and lifetime.
1. Consistent naming avoids confusion when multiple developers work on the same app.
1. When reviewing formulas, prefixed names help identify potential performance issues, such as excessive use of global variables.

## Examples

### Good

```
Set(gblUserRole, "Admin")
UpdateContext({locIsEditMode: true})
ClearCollect(colActiveProjects, Filter(Projects, Status = "Active"))
```

### Bad

```
Set(UserRole, "Admin")           // No prefix, unclear scope
UpdateContext({showDialog: true}) // No prefix, could be confused with a global variable
ClearCollect(Projects, ...)      // Same name as data source, causes confusion
```

# CA-003: Delegation

Use delegable functions and be aware of delegation limits when working with large data sources.

1. Use delegable functions (`Filter`, `Sort`, `Search`, `LookUp`) with delegable data sources (Dataverse, SQL, SharePoint).
1. Avoid non-delegable functions (`CountRows`, `SortByColumns` with complex expressions, `First(Sort(...))`) on large datasets.
1. Address all delegation warnings (indicated by a blue underline in the formula bar).
1. Increase the data row limit in App Settings only when necessary, and understand that non-delegable queries are still limited to that cap.

## Rationale

1. Non-delegable operations only process up to 500 records by default (maximum 2000), meaning results may be incomplete without any visible error to the end user.
1. Delegation pushes query processing to the data source, which is far more efficient than pulling all records to the client.
1. Ignoring delegation warnings in production apps can lead to missing data and incorrect business decisions.

## Examples

### Good

```
// Delegable: filtering is pushed to Dataverse
Filter(Orders, Status = "Active" && CreatedOn > DateAdd(Today(), -30, TimeUnit.Days))

// Delegable: LookUp on a supported column
LookUp(Customers, CustomerID = galOrders.Selected.CustomerID)
```

### Bad

```
// Non-delegable: CountRows on a filtered large table returns incorrect count
CountRows(Filter(Orders, Status = "Active"))

// Non-delegable: in operator is not delegable for most data sources
Filter(Orders, Status in ["Active", "Pending"])

// Non-delegable: using a local collection to join, pulls all records to client
AddColumns(colOrders, "CustomerName", LookUp(Customers, CustomerID = ThisRecord.CustomerID).Name)
```

## More Information
1. [Understand delegation in a canvas app - Microsoft Learn](https://learn.microsoft.com/en-us/power-apps/maker/canvas-apps/delegation-overview)
1. [Delegation list for canvas apps - Microsoft Learn](https://learn.microsoft.com/en-us/power-apps/maker/canvas-apps/delegation-list)

# CA-004: Optimize App Initialization

Keep `App.OnStart` lean and use `Concurrent()` to parallelize independent data calls.

1. Only initialize truly global data and variables in `App.OnStart`.
1. Wrap independent data calls in `Concurrent()` to run them in parallel.
1. Defer screen-specific data loading to the screen's `OnVisible` property.
1. Use `App.StartScreen` to set the initial screen instead of using `Navigate()` in `App.OnStart`.

## Rationale

1. All logic in `App.OnStart` runs before the app becomes interactive. Heavy initialization causes long loading times and a poor user experience.
1. `Concurrent()` can significantly reduce startup time by running multiple data calls simultaneously instead of sequentially.
1. Loading data in `OnVisible` ensures it is only fetched when the user actually navigates to that screen, reducing unnecessary network calls.
1. `Navigate()` in `App.OnStart` is not recommended by Microsoft and may be deprecated; `App.StartScreen` is the supported replacement.

## Examples

### Good

```
// App.OnStart: only essential global data, parallelized
Concurrent(
    Set(gblCurrentUser, LookUp(Users, Email = User().Email)),
    ClearCollect(colConfigSettings, ConfigSettings)
);

// App.StartScreen
If(gblCurrentUser.Role = "Admin", scrAdminDashboard, scrHome)

// Screen OnVisible: screen-specific data
ClearCollect(colOrders, Filter(Orders, AssignedTo = gblCurrentUser.Email))
```

### Bad

```
// App.OnStart: too much logic, sequential calls, Navigate used
Set(gblCurrentUser, LookUp(Users, Email = User().Email));
ClearCollect(colOrders, Filter(Orders, AssignedTo = gblCurrentUser.Email));
ClearCollect(colProducts, Products);
ClearCollect(colCustomers, Customers);
ClearCollect(colRegions, Regions);
Navigate(scrHome);
```

## More Information
1. [Optimizing app load time - Microsoft Learn](https://learn.microsoft.com/en-us/power-apps/maker/canvas-apps/fast-app-loading)
1. [Concurrent function - Microsoft Learn](https://learn.microsoft.com/en-us/power-apps/maker/canvas-apps/functions/function-concurrent)

# CA-005: Error Handling

Use `IfError` and `Notify` to handle errors gracefully and provide meaningful feedback to users.

1. Wrap data operations (`Patch`, `SubmitForm`, `Remove`) with `IfError` to catch failures.
1. Use `Notify()` with the appropriate notification type to inform users of success or failure.
1. Validate user input before submitting data using functions like `IsBlank`, `IsMatch`, and form validation.
1. Log errors to a data source or collection for troubleshooting when building production apps.

## Rationale

1. Unhandled errors result in silent failures where users believe their action succeeded when it did not, leading to data loss or inconsistency.
1. Providing clear error messages improves the user experience and reduces support requests.
1. Input validation prevents unnecessary calls to the data source and catches issues early in the user flow.
1. Error logging enables developers to identify recurring issues and improve app reliability.

## Examples

### Good

```
// Wrapping Patch with error handling
IfError(
    Patch(Orders, Defaults(Orders), {Title: txtOrderTitle.Text, Status: "New"}),
    Notify("Failed to create order. Please try again.", NotificationType.Error),
    Notify("Order created successfully.", NotificationType.Success)
);

// Input validation before submission
If(
    IsBlank(txtCustomerName.Text),
    Notify("Customer name is required.", NotificationType.Warning),
    SubmitForm(frmEditContact)
);
```

### Bad

```
// No error handling: user has no idea if this succeeded
Patch(Orders, Defaults(Orders), {Title: txtOrderTitle.Text});

// No input validation: submits empty or invalid data
SubmitForm(frmEditContact);
```

## More Information
1. [IfError function - Microsoft Learn](https://learn.microsoft.com/en-us/power-apps/maker/canvas-apps/functions/function-iferror)
1. [Notify function - Microsoft Learn](https://learn.microsoft.com/en-us/power-apps/maker/canvas-apps/functions/function-notify)

# CA-006: Responsive Design

Use containers and relative sizing to build apps that adapt to different screen sizes and form factors.

1. Use **Horizontal** and **Vertical Containers** for layout instead of manually positioning controls with fixed X/Y coordinates.
1. Use relative values such as `Parent.Width`, `Parent.Height`, and percentage-based calculations for control dimensions.
1. Avoid hard-coded pixel values for width, height, and positioning.
1. Test your app on multiple screen sizes and devices during development.

## Rationale

1. Hard-coded positions and sizes break when the app is used on a different screen size, orientation, or device than the one it was designed on.
1. Containers automatically manage the layout of their children, reducing the amount of manual positioning formulas.
1. Responsive design ensures that the app is usable on mobile, tablet, and desktop without building separate versions.
1. Power Apps is increasingly used on mobile devices, making responsive design a practical necessity.

## Examples

### Good

```
// Container-based layout with relative sizing
cntHeader.Width:  Parent.Width
cntHeader.Height: 60
galOrders.Width:  Parent.Width
galOrders.Height: Parent.Height - cntHeader.Height

// Responsive font size
lblTitle.Size: If(Parent.Width < 600, 14, 20)
```

### Bad

```
// Fixed positioning: breaks on different screen sizes
btnSave.X: 950
btnSave.Y: 700
btnSave.Width: 200
btnSave.Height: 50

// Gallery with fixed width that doesn't adapt
galOrders.Width: 1200
```

## More Information
1. [Build responsive canvas apps - Microsoft Learn](https://learn.microsoft.com/en-us/power-apps/maker/canvas-apps/build-responsive-apps)
1. [Create responsive layouts with containers - Microsoft Learn](https://learn.microsoft.com/en-us/power-apps/maker/canvas-apps/create-responsive-layout-container)

# CA-007: Media Optimization

Optimize images and media assets to reduce app load time and overall app size.

1. Compress and resize images before uploading them to the app. Use only the resolution needed for display.
1. Remove unused media files from the app's Media library.
1. For frequently changing images, reference them via URL instead of embedding them in the app.
1. Avoid auto-playing videos or loading heavy media controls on the app's start screen.

## Rationale

1. Every embedded media file increases the app package size, which directly impacts download and load times for all users.
1. Uncompressed images are one of the most common causes of slow canvas apps.
1. Referencing images via URL avoids bloating the app package and allows assets to be updated without republishing the app.
1. Heavy media on the start screen delays the time to first interaction.

## Examples

### Good

- Images resized to the maximum dimensions they will be displayed at (e.g., 300×300px for a thumbnail, not 3000×3000px).
- Company logo uploaded as a compressed PNG or SVG, under 100 KB.
- Product images loaded from a SharePoint library or Blob Storage URL.

### Bad

- A 5 MB uncompressed TIFF image used for a 100×100px icon.
- 20+ unused images still present in the Media library.
- A video auto-playing on the home screen, adding several seconds to the initial load.

## More Information
1. [Tips and best practices to improve performance of canvas apps - Microsoft Learn](https://learn.microsoft.com/en-us/power-apps/maker/canvas-apps/performance-tips)

# CA-008: Component Reuse

Use **Canvas Components** to encapsulate repeated UI patterns and shared logic into reusable building blocks.

1. Create components for UI elements that appear on multiple screens (e.g., headers, navigation bars, search bars, confirmation dialogs).
1. Expose configurable **Custom Properties** (input and output) so the component adapts to different contexts.
1. Keep components lightweight: avoid embedding complex data calls or heavy logic inside the component.
1. Document each component's purpose and its custom properties.

## Rationale

1. Without components, repeated UI elements must be copied across screens. Any change requires updating every copy, which is error-prone and time-consuming.
1. Components enforce consistency across the app by ensuring the same UI and behavior is used everywhere.
1. Configurable properties make components flexible enough to be reused in different screens or even different apps (via component libraries).
1. Lightweight components load faster and are easier to test and debug.

## Examples

### Good

- A `cmpHeader` component with custom properties for `Title` (Text) and `ShowBackButton` (Boolean), reused across all screens.
- A `cmpConfirmDialog` component that accepts `Message` and `OnConfirm` action properties, used wherever a confirmation is needed.

### Bad

- The same header layout (logo, title, navigation buttons) manually duplicated on every screen with slight inconsistencies between copies.
- A component that internally calls `ClearCollect()` to fetch data from a data source, making it hard to test and slow to load.

## More Information
1. [Create a canvas component - Microsoft Learn](https://learn.microsoft.com/en-us/power-apps/maker/canvas-apps/create-component)
1. [Component libraries - Microsoft Learn](https://learn.microsoft.com/en-us/power-apps/maker/canvas-apps/component-library)

# CA-009: Accessibility

Design apps to be accessible to all users, including those using assistive technologies.

1. Set the `AccessibleLabel` property on all interactive controls (buttons, inputs, galleries, icons).
1. Ensure sufficient color contrast between text and background, following WCAG 2.1 AA guidelines (minimum contrast ratio of 4.5:1 for normal text).
1. Ensure all interactive elements are reachable and usable via keyboard navigation (Tab, Enter, Escape).
1. Use the built-in **Accessibility Checker** in Power Apps Studio to identify and fix issues.
1. Avoid conveying information through color alone; use text, icons, or patterns as well.

## Rationale

1. Accessible apps can be used by people with visual, motor, or cognitive disabilities, ensuring inclusivity and compliance with accessibility standards.
1. Many organizations are required to meet accessibility standards (such as WCAG, Section 508, or EN 301 549) for internal and external applications.
1. Accessible design often improves usability for all users, not just those using assistive technologies.
1. The Accessibility Checker identifies common issues automatically, making it easy to catch problems early.

## Examples

### Good

```
// Descriptive accessible labels
btnSaveRecord.AccessibleLabel: "Save the current record"
icoDeleteItem.AccessibleLabel: "Delete " & ThisItem.Title
galOrders.AccessibleLabel: "List of active orders"

// Sufficient contrast
lblWarning.Color: RGBA(178, 34, 34, 1)     // Dark red text
lblWarning.Fill: RGBA(255, 255, 255, 1)     // White background
```

### Bad

```
// Missing accessible labels: screen readers announce "Button" with no context
btnSaveRecord.AccessibleLabel: ""

// Insufficient contrast: light gray text on white background
lblWarning.Color: RGBA(200, 200, 200, 1)
lblWarning.Fill: RGBA(255, 255, 255, 1)

// Information conveyed by color alone with no text or icon
icoStatus.Color: If(ThisItem.Status = "Active", Green, Red)
```

## More Information
1. [Accessibility properties in Power Apps - Microsoft Learn](https://learn.microsoft.com/en-us/power-apps/maker/canvas-apps/controls/properties-accessibility)
1. [Accessibility checker - Microsoft Learn](https://learn.microsoft.com/en-us/power-apps/maker/canvas-apps/accessibility-checker)
1. [Web Content Accessibility Guidelines (WCAG) 2.1](https://www.w3.org/TR/WCAG21/)
