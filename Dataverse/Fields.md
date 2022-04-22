# Tables

Good practices for Dataverse Table Fields. 

# FLD-001

Naming Rules:

- The [*Snake Case*](https://en.wikipedia.org/wiki/Snake_case) notation must be used in the Name.
- Avoid abbreviations on Display or Name as much as possible.
- Make your Display Name as descriptive as possible, remembering this value can be changed if necessary.
- Make the display name unique.
- If you need to use the same Display Name of an existing system field, change the system field Display Name to include the OOTB (Out-of-the-box) prefix. 
- If the field type is Lookup it must end with the "_id" suffix.
- If the field type is Lookup, remember to check the Relationship name, and adjust it to use the [*Snake Case*](https://en.wikipedia.org/wiki/Snake_case)  notation.
- If you have multiple fields grouped logically, use the same prefix to all of them on the Name and Display Name. 

## Rationale

- The Snake Case syntax facilitates the reading of the name, and is aligned with the underscore character used between the publisher prefix and the name. It makes clear that the name refers to a table in the c# or Type Script early bound generated code.
- Abbreviations are not always understood by everybody.
- Unique Display Names avoids confusion for Developers and Users alike. 
- Ending Lookup fields with the "_id" suffix makes it clear the field is an [Entity Reference](https://docs.microsoft.com/en-us/dotnet/api/microsoft.xrm.sdk.entityreference) when working with code.
- Multiple fields grouped logically with the same prefix, will make it easier to identify and see as a group in the Dataverse designers. 

## Examples

- Several fields grouped logically: csp_review_due_date, csp_review_completed_on, csp_review_link instead of csp_due_date_review, csp_review_completed_on, csp_link_review

![hidden-admin](/img/fld-001-naming-rules.png)

# FLD-002

- Always include a description remembering that it will be shown as a tooltip in the user interface. 
- If the field is for internal system purposes, start the description with "System Field.". Remember also to include it in the hidden admin tab [FRM-001](/Dataverse/Forms.md#frm-001)

![hidden-admin](/img/fld-002-description.png)

## Rationale

- Descriptions facilitates understanding the use and purpose of any field, for both Users and Developers. 