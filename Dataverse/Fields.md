# Tables

Good practices for Dataverse Table Fields. 

# FLD-001

Naming Rules:

1. The [*Snake Case*](https://en.wikipedia.org/wiki/Snake_case) notation must be used in the Name.
1. Avoid abbreviations on Display or Name as much as possible.
1. Make your Display Name as descriptive as possible, remembering this value can be changed if necessary.
1. Make the Display Name unique.
1. If you need to use the same Display Name of an existing system field, change the system field Display Name to include the OOTB (Out-of-the-box) prefix. 
1. If the field type is Lookup it must end with the "_id" suffix.
1. If the field type is Lookup, remember to check the Relationship name, and adjust it to use the [*Snake Case*](https://en.wikipedia.org/wiki/Snake_case) notation.
- If you have multiple fields grouped logically, use the same prefix to all of them on the Name and Display Name. 

## Rationale

1. The Snake Case syntax facilitates the reading of the name, and is aligned with the underscore character used between the publisher prefix and the name. It makes clear that the name refers to a table in the c# or Type Script early bound generated code.
1. Abbreviations are not always understood by everybody.
1. Unique Display Names avoids confusion for Developers and Users alike. 
1. Ending Lookup fields with the "_id" suffix makes it clear the field is an [Entity Reference](https://docs.microsoft.com/en-us/dotnet/api/microsoft.xrm.sdk.entityreference) when working with code.
1. Multiple fields grouped logically with the same prefix, will make it easier to identify and see as a group in the Dataverse designers. 

## Examples

1. Several fields grouped logically: csp_review_due_date, csp_review_completed_on, csp_review_link instead of csp_due_date_review, csp_review_completed_on, csp_link_review

![Field Naming Rules](/img/fld-001-naming-rules.png)

# FLD-002

1. Always include a description remembering that it will be shown as a tooltip in the user interface. 
1. If the field is for internal system purposes, start the description with "System Field.". Remember also to include it in the hidden admin tab [FRM-001](/Dataverse/Forms.md#frm-001)

![Field Description](/img/fld-002-description.png)

## Rationale

1. Descriptions facilitates understanding the use and purpose of any field, for both Users and Developers.

# FLD-003

Choose the most specific and appropriate data type for each field.

1. Use **Whole Number** or **Decimal** for numeric data instead of Text.
1. Use **Date and Time** or **Date Only** for date values instead of Text.
1. Use **Choice** (Option Set) for fields with a fixed set of predefined values instead of Text.
1. Use **Lookup** fields to establish relationships to other tables instead of storing IDs or names in Text fields.
1. Use **Currency** for monetary values to leverage built-in currency handling and exchange rate support.
1. Set appropriate **maximum length** for Text fields based on realistic data needs. Avoid leaving the default 100 or setting unnecessarily large limits.

## Rationale

1. Using the correct data type enables built-in validation, formatting, filtering, and sorting that Text fields do not provide.
1. Storing dates or numbers as Text prevents proper comparison, grouping, and reporting in views and charts.
1. Lookup fields maintain referential integrity and enable relationship-based security, views, and navigation.
1. Oversized Text fields waste storage and can lead to poor data quality when users enter unstructured content.

## Examples

### Good

| Field Purpose     | Data Type     | Example                 |
| ----------------- | ------------- | ----------------------- |
| Birth Date        | Date Only     | 1990-05-15              |
| Order Total       | Currency      | $1,250.00               |
| Country           | Lookup        | → Country table record  |
| Priority          | Choice        | High, Medium, Low       |
| Quantity          | Whole Number  | 42                      |

### Bad

| Field Purpose     | Data Type     | Problem                                                  |
| ----------------- | ------------- | -------------------------------------------------------- |
| Birth Date        | Text          | Cannot sort, filter by date, or calculate age            |
| Order Total       | Text          | No currency formatting, no aggregation in views          |
| Country           | Text          | Inconsistent values ("US", "USA", "United States")       |
| Priority          | Text          | No validation; users can enter any value                 |

## More Information
1. [Types of columns - Microsoft Learn](https://learn.microsoft.com/en-us/power-apps/maker/data-platform/types-of-fields)

# FLD-004

Use **Global Choices** (Global Option Sets) for values that are shared across multiple tables. Use **Local Choices** for values specific to a single table.

1. If the same set of values is used in more than one table (e.g., Status, Priority, Category), create it as a Global Choice.
1. If the values are unique to one table and will never be reused, create a Local Choice.
1. If the set of valid values is large (more than ~25 items) or changes frequently, consider using a Lookup to a reference table instead of a Choice field.

## Rationale

1. Global Choices ensure consistency across tables. When the list is updated, the change is reflected everywhere it is used.
1. Local Choices are simpler to manage and do not impact other tables when modified.
1. Very large or frequently changing option sets are better modeled as reference tables with Lookup fields, which are easier to maintain and do not require solution deployments to update values.

## Examples

### Good

- A **Global Choice** named `Priority` with values High, Medium, Low — used in the Case, Task, and Order tables.
- A **Local Choice** named `Case Origin` with values Phone, Email, Web — specific to the Case table only.
- A **Lookup** to a `Product Category` reference table when there are 50+ categories that change quarterly.

### Bad

- Three separate **Local Choices** named "Priority" in the Case, Task, and Order tables, each with slightly different values (e.g., one has "Critical" and the others don't).
- A **Global Choice** with 100+ items that requires a solution deployment every time a new value is added.

## More Information
1. [Create and edit global choices - Microsoft Learn](https://learn.microsoft.com/en-us/power-apps/maker/data-platform/create-edit-global-option-sets)

# FLD-005

Set the field requirement level deliberately based on business needs.

1. Set a field as **Business Required** only when the record is invalid without that value.
1. Use **Business Recommended** to guide users toward filling in important but not mandatory fields.
1. Default to **Optional** unless there is a clear business reason to require the field.
1. Avoid making too many fields required, as it slows down data entry and can frustrate users.

## Rationale

1. Business Required fields are enforced at the platform level, including during imports, API calls, and workflow-created records — not just UI forms.
1. Over-requiring fields leads to users entering placeholder or junk data (e.g., "N/A", "TBD", "123") just to save the record, reducing data quality.
1. Business Recommended provides a visual cue (blue asterisk) without blocking the save, offering a good middle ground for important but non-critical data.

## Examples

### Good

| Field           | Requirement Level     | Reason                                         |
| --------------- | --------------------- | ---------------------------------------------- |
| Email (Contact) | Business Required     | Primary communication channel; record invalid without it |
| Phone           | Business Recommended  | Important but not always available at creation |
| Middle Name     | Optional              | Rarely needed for business processes           |

### Bad

| Field           | Requirement Level     | Problem                                        |
| --------------- | --------------------- | ---------------------------------------------- |
| Middle Name     | Business Required     | Users enter "N/A" to bypass the requirement    |
| All 30 fields   | Business Required     | Data entry becomes painfully slow              |

## More Information
1. [Set managed properties for columns - Microsoft Learn](https://learn.microsoft.com/en-us/power-apps/maker/data-platform/set-managed-properties-for-field)

# FLD-006

Enable Column-Level Security for fields containing sensitive or confidential data.

1. Identify fields that contain personally identifiable information (PII), financial data, or other sensitive content.
1. Create Field Security Profiles and assign them to the appropriate security roles or teams.
1. Do not overuse column-level security. Apply it only where access must be restricted beyond what row-level and table-level security provide.
1. Regularly review Field Security Profile assignments as team membership and business requirements change.

## Rationale

1. Column-level security ensures that sensitive data (e.g., Social Security Numbers, salary information, medical records) is visible only to authorized users, even if they have access to the record itself.
1. Without column-level security, any user with read access to a table can see all columns, which may violate data privacy regulations (e.g., GDPR, HIPAA).
1. Overusing column-level security can make the system harder to maintain and may impact performance due to additional security checks on every data retrieval.

## Examples

### Good

- Column-level security enabled on the `salary` and `social_security_number` fields of the Employee table, with a Field Security Profile granting access only to HR team members.

### Bad

- No column-level security on the Employee table, allowing any user with read access to see salary and SSN data.
- Column-level security applied to 50+ fields across the system, including non-sensitive fields like `first_name` and `email`, adding unnecessary complexity.

## More Information
1. [Column-level security - Microsoft Learn](https://learn.microsoft.com/en-us/power-platform/admin/field-level-security)