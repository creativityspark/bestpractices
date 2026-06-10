# Forms

Good practices for Dataverse Forms. 

# FRM-001

1. Every table main form must have a hidden **Admin** tab, containing all the system attributes, including state, status, owner, creation, owning business unit, modification dates, etc.

You can use a tool like [Level up for Dynamics](https://github.com/rajyraman/Levelup-for-Dynamics-CRM) to make the tab visible and access the values. 

![Hidden Admin Tab](/img/frm-001-hidden-admin.png)

![Hidden Admin Tab](/img/frm-001-hidden-admin-2.png)

## Rationale

1. In many occasions there is need for testers and developers to be able to access and update these values. Having them in a hidden tab facilitates debugging and testing tasks.

# FRM-002

Organize form content using tabs and sections with clear, descriptive names.

1. Use tabs to represent major logical groupings of information (e.g., "General", "Details", "Related Records").
1. Use sections within tabs to further organize related fields.
1. Place the most frequently used fields and tabs first.
1. Limit the number of tabs to 3-5 to avoid overwhelming users.
1. Limit sections to 5-7 fields each to keep forms readable.
1. Name tabs and sections using clear, user-friendly language. Avoid technical jargon.

## Rationale

1. Well-organized forms improve user productivity by reducing the time needed to find and fill in information.
1. Logical grouping of fields reduces cognitive load and improves data entry accuracy.
1. Too many tabs or fields on a single section creates a cluttered interface that overwhelms users.

## Examples

### Good

```
Tab: General
  Section: Customer Information     → Name, Email, Phone
  Section: Address                  → Street, City, Country

Tab: Order History
  Section: Recent Orders            → Subgrid with last 10 orders
```

### Bad

```
Tab: Tab1
  Section: Section1  → Name, Email, Phone, Street, City, Country,
                        Order Date, Total, Status, Notes, Category,
                        Priority, Source, Rating, ...
```

## More Information
1. [Design productive main forms - Microsoft Learn](https://learn.microsoft.com/en-us/power-apps/maker/model-driven-apps/design-productive-forms)

# FRM-003

Optimize form load performance by minimizing the number of controls and scripts loaded on the form.

1. Limit the number of subgrids on a single form. Each subgrid triggers an additional data query on load.
1. Set non-essential tabs to expand only when clicked ("collapsed by default") to defer data loading.
1. Avoid adding unnecessary web resources, timers, or custom controls that increase load time.
1. Keep JavaScript event handlers lean and use asynchronous calls for any Web API operations.
1. Minimize the number of business rules per form. Consolidate overlapping rules where possible.

## Rationale

1. Every control on a form contributes to load time. Subgrids, quick view forms, and web resources each trigger additional server requests.
1. Deferring the loading of non-essential tabs significantly reduces initial form load time, especially on forms with many related records.
1. Poorly optimized JavaScript or excessive business rules can block the form rendering pipeline and degrade the user experience.

## Examples

### Good

- A form with 2 subgrids in the "Related Records" tab, which is collapsed by default.
- JavaScript web resources loaded only on forms that require them, using asynchronous `Xrm.WebApi` calls.

### Bad

- A form with 6 subgrids all visible on the first tab, causing 6+ simultaneous data queries on form load.
- A synchronous `XMLHttpRequest` call in the `OnLoad` event that blocks form rendering for several seconds.

## More Information
1. [Optimize form performance - Microsoft Learn](https://learn.microsoft.com/en-us/power-apps/maker/model-driven-apps/optimize-form-performance)

# FRM-004

When using business rules on forms, set the scope appropriately and avoid duplicating logic.

1. Set the scope to **Table** if the rule should apply across all forms, views, and server-side operations (e.g., imports, API calls).
1. Set the scope to a **specific Form** only if the logic is unique to that form.
1. Avoid duplicating the same logic in both business rules and JavaScript. Choose one approach and be consistent.
1. Name business rules descriptively following a pattern like: `[Table Name] - [Purpose]`.

## Rationale

1. Table-scoped business rules enforce logic server-side, which means the rules apply even when records are created via imports, workflows, or API calls — not just the UI.
1. Form-scoped rules only execute when a user opens that specific form, which can lead to inconsistent data if records are modified through other channels.
1. Duplicating logic between business rules and JavaScript increases maintenance effort and creates a risk of conflicting behavior.

## Examples

### Good

- A business rule named `Contact - Set Phone Required When Type Is Customer` scoped to the Table level, ensuring the phone number is always required regardless of how the Contact is created.

### Bad

- A business rule that hides a field, combined with a JavaScript `OnLoad` handler that also hides the same field, causing confusion about which one controls the behavior.
- A form-scoped business rule that sets a field as required, but records created via data import skip the rule entirely, resulting in incomplete data.

## More Information
1. [Create business rules - Microsoft Learn](https://learn.microsoft.com/en-us/power-apps/maker/data-platform/create-business-rules-recommendations-apply-logic-form)

# FRM-005

Use Quick View Forms to display related record information without requiring navigation away from the current form.

1. Design Quick View Forms to show only the most relevant summary fields from the related record.
1. Keep Quick View Forms small — ideally 3-5 fields.
1. Do not use Quick View Forms for data entry. They are read-only by design.
1. Avoid placing multiple Quick View Forms on the same tab, as each one generates an additional data query.

## Rationale

1. Quick View Forms provide contextual information from related records directly on the parent form, reducing the need for users to navigate between records.
1. Overloading Quick View Forms with too many fields defeats their purpose and impacts form load time.
1. Each Quick View Form triggers a separate data retrieval call, so excessive use on a single form degrades performance.

## Examples

### Good

- A Quick View Form on the Case form showing the related Customer's name, phone number, and account tier — just enough context for the support agent.

### Bad

- A Quick View Form on the Case form displaying 15+ fields from the Customer record, including fields that are rarely relevant to case handling.
- Three Quick View Forms on the same form tab, each loading data from different related tables simultaneously.

## More Information
1. [Create and edit quick view forms - Microsoft Learn](https://learn.microsoft.com/en-us/power-apps/maker/model-driven-apps/create-edit-quick-view-forms)
