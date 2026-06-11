# Power Pages

Good practices for Power Pages site development and configuration.

# PP-001: Table Permissions

Always configure table permissions for every Dataverse table exposed on the portal. Use the most restrictive scope that satisfies the business requirement.

1. Enable table permissions on every table surfaced through entity lists, basic forms, or advanced forms.
1. Prefer **Contact** or **Self** scope over **Global** scope for user-facing data.
1. Grant only the operations that are needed (Read, Create, Write, Delete, Append, Append To).
1. Never grant **Global** scope with full CRUD permissions to the Anonymous Users web role.

## Rationale

1. Table permissions are the primary data-security mechanism in Power Pages. If they are not configured, data may be exposed to unauthorized users.
1. Using the narrowest scope ensures that users can only access records that belong to them or their account, following the principle of least privilege.
1. Overly broad permissions increase the risk of data leakage and non-compliance with privacy regulations.

## Examples

### Good

| Table         | Web Role   | Scope   | Permissions       | Reason                                            |
| ------------- | ---------- | ------- | ----------------- | ------------------------------------------------- |
| Case          | Customer   | Contact | Read, Create      | Customers see only their own cases                |
| Knowledge Article | Anonymous | Global | Read              | Public knowledge base accessible to everyone      |
| Order         | Customer   | Account | Read              | Customers see orders for their account            |

### Bad

| Table         | Web Role   | Scope   | Permissions            | Problem                                                 |
| ------------- | ---------- | ------- | ---------------------- | ------------------------------------------------------- |
| Case          | Customer   | Global  | Read, Write, Delete    | Customers can see and delete cases from other customers  |
| Contact       | Anonymous  | Global  | Read                   | Exposes all contact records to unauthenticated users     |

## More Information
1. [Table permissions in Power Pages - Microsoft Learn](https://learn.microsoft.com/en-us/power-pages/security/table-permissions)
1. [Power Pages security best practices - Microsoft Learn](https://learn.microsoft.com/en-us/power-pages/security/best-practices)

# PP-002: Web Roles

Define granular web roles that map to distinct user personas. Assign table permissions, page permissions, and site settings through web roles rather than directly to users.

1. Create a separate web role for each user persona (e.g., Customer, Partner, Internal Reviewer).
1. Avoid creating a single "super user" role that grants access to everything.
1. Assign web roles to contacts explicitly through business logic or administrative processes, not as blanket defaults for all authenticated users.
1. Periodically review web role assignments to remove access that is no longer needed.

## Rationale

1. Web roles are the foundation of the Power Pages security model. Well-defined roles make it easy to understand and audit who has access to what.
1. A single overly permissive role leads to security issues and makes it difficult to restrict access later without breaking functionality.
1. Explicit role assignment prevents new users from automatically inheriting permissions they should not have.

## Examples

### Good

- A **Customer** web role with Read and Create permissions on the Case table (Contact scope).
- A **Partner** web role with Read permissions on the Product Catalog table (Global scope) and Write permissions on the Partner Application table (Contact scope).
- A **Site Administrator** web role assigned only to a small group of internal users.

### Bad

- A single **Authenticated User** web role that grants Read, Write, and Delete on all tables with Global scope.
- A **Customer** web role that is automatically assigned to every registered user without validation.

## More Information
1. [Create web roles for Power Pages - Microsoft Learn](https://learn.microsoft.com/en-us/power-pages/security/create-web-roles)
1. [Power Pages security best practices - Microsoft Learn](https://learn.microsoft.com/en-us/power-pages/security/best-practices)

# PP-003: Liquid Templates

Keep Liquid templates focused on presentation logic. Avoid embedding complex business logic or heavy data processing in Liquid code.

1. Use Liquid for data shaping and rendering, not for calculations or business rules.
1. Modularize templates using `{% include %}` to promote reusability and readability.
1. Use whitespace control tags (`{%-` and `-%}`) to minimize unnecessary whitespace in rendered output.
1. Always check for null values before accessing object properties to prevent rendering errors.
1. Escape user-generated content with `{{ variable | escape }}` to prevent cross-site scripting (XSS).

## Rationale

1. Liquid is interpreted at runtime on every page load. Complex logic in Liquid increases server-side rendering time and degrades performance.
1. Business logic belongs in Dataverse plugins or Power Automate flows where it can be tested, versioned, and reused independently.
1. Modular templates are easier to maintain, debug, and review during code reviews.
1. Unescaped user content in templates can introduce XSS vulnerabilities.

## Examples

### Good

```liquid
{%- fetchxml recent_cases -%}
  <fetch top="5">
    <entity name="incident">
      <attribute name="title" />
      <attribute name="createdon" />
      <order attribute="createdon" descending="true" />
      <filter type="and">
        <condition attribute="statecode" operator="eq" value="0" />
      </filter>
    </entity>
  </fetch>
{%- endfetchxml -%}

<ul>
  {% for case in recent_cases.results.entities %}
    <li>{{ case.title | escape }} - {{ case.createdon | date: "yyyy-MM-dd" }}</li>
  {% endfor %}
</ul>
```

### Bad

```liquid
<!-- Heavy business logic in Liquid -->
{% assign total = 0 %}
{% for item in order_items %}
  {% assign line_total = item.quantity | times: item.unit_price %}
  {% assign discount = line_total | times: item.discount_percent | divided_by: 100 %}
  {% assign total = total | plus: line_total | minus: discount %}
{% endfor %}
<!-- Unescaped user content -->
<p>{{ user.fullname }}</p>
```

## More Information
1. [Liquid overview - Microsoft Learn](https://learn.microsoft.com/en-us/power-pages/configure/liquid/liquid-overview)
1. [Work with Liquid templates - Microsoft Learn](https://learn.microsoft.com/en-us/power-pages/configure/liquid/liquid-types)

# PP-004: FetchXML Queries

Write efficient FetchXML queries by selecting only the columns you need, filtering early, and limiting the result set.

1. Select only the attributes required for the current view. Avoid using `all-attributes`.
1. Apply `<filter>` conditions to restrict the data returned at the database level.
1. Use the `top` or `count` attribute on the `<fetch>` element to limit the number of records returned.
1. Use `paging-cookie` for paginated result sets.
1. Always alias linked entities for clarity and to avoid ambiguity.

## Rationale

1. Fetching all attributes returns unnecessary data, increasing page load time and memory usage.
1. Filtering early reduces the amount of data transferred from Dataverse, improving response times.
1. Unbounded queries can return thousands of records, causing timeouts or excessive rendering times on the portal.
1. Paging ensures consistent performance regardless of data volume.

## Examples

### Good

```liquid
{% fetchxml active_accounts %}
  <fetch top="10">
    <entity name="account">
      <attribute name="name" />
      <attribute name="emailaddress1" />
      <filter type="and">
        <condition attribute="statecode" operator="eq" value="0" />
      </filter>
      <order attribute="name" />
    </entity>
  </fetch>
{% endfetchxml %}
```

### Bad

```liquid
{% fetchxml all_accounts %}
  <fetch>
    <entity name="account">
      <all-attributes />
    </entity>
  </fetch>
{% endfetchxml %}
```

## More Information
1. [Use FetchXML in Power Pages - Microsoft Learn](https://learn.microsoft.com/en-us/power-pages/configure/liquid/liquid-fetchxml)

# PP-005: Page Output Caching

Enable page output caching for pages that do not require real-time data. Configure cache duration and vary parameters appropriately.

1. Set the site setting `OutputCache:Enabled` to `true`.
1. Set `OutputCache:Duration` to a value in seconds that reflects how frequently the content changes.
1. Use `OutputCache:VaryByParam` to differentiate cached content when pages serve different results based on query string parameters.
1. Avoid caching pages with highly personalized or user-specific content unless you vary by user.

## Rationale

1. Output caching reduces the number of Liquid rendering passes and Dataverse queries per page load, significantly improving response times.
1. Without caching, every request triggers a full server-side rendering cycle, which is expensive on high-traffic sites.
1. Incorrect vary parameters can cause users to see stale or another user's cached content.

## Examples

### Good

| Site Setting               | Value   | Reason                                     |
| -------------------------- | ------- | ------------------------------------------ |
| `OutputCache:Enabled`      | `true`  | Enables output caching site-wide           |
| `OutputCache:Duration`     | `300`   | 5-minute cache for semi-static content     |
| `OutputCache:VaryByParam`  | `id`    | Caches separate versions per record ID     |

### Bad

| Site Setting               | Value     | Problem                                                       |
| -------------------------- | --------- | ------------------------------------------------------------- |
| `OutputCache:Enabled`      | `false`   | No caching; every request renders from scratch                |
| `OutputCache:Duration`     | `86400`   | 24-hour cache on a page with frequently changing data         |
| `OutputCache:VaryByParam`  | *(empty)* | All users see the same cached page regardless of parameters   |

## More Information
1. [Page output caching in Power Pages - Microsoft Learn](https://learn.microsoft.com/en-us/power-pages/configure/page-output-caching)

# PP-006: Basic and Advanced Forms

Configure forms with proper validation and table permissions. Use basic forms for simple data entry and advanced forms for multi-step processes.

1. Always pair forms with table permissions that enforce the correct scope and operations for the target table.
1. Enable field-level validation (required fields, data types, ranges) to ensure data quality.
1. Use advanced forms (multi-step forms) when the data collection process has a logical workflow with multiple stages.
1. Avoid exposing system fields or sensitive columns on portal forms.
1. Set the form mode (Insert, Edit, Read Only) explicitly and do not rely on default behavior.

## Rationale

1. Forms without table permissions allow any authenticated user (or anonymous user) to submit or read data without restriction.
1. Client-side validation alone is insufficient; table permissions enforce security on the server side.
1. Exposing unnecessary fields increases the attack surface and may leak internal information.
1. Explicit form modes prevent accidental data modifications.

## Examples

### Good

- A **Contact Us** basic form in Insert mode paired with table permissions granting Create-only access to the Inquiry table for Anonymous Users.
- An **Application Form** implemented as an advanced form with three steps: Personal Details → Upload Documents → Review & Submit. Each step validates required fields before allowing progression.

### Bad

- A basic form for the Account table in Edit mode with no table permissions configured, allowing any user to modify any account record.
- A single-step form that collects 30+ fields across unrelated categories, resulting in poor user experience and high abandonment rates.

## More Information
1. [Basic forms in Power Pages - Microsoft Learn](https://learn.microsoft.com/en-us/power-pages/configure/basic-forms)
1. [Advanced forms in Power Pages - Microsoft Learn](https://learn.microsoft.com/en-us/power-pages/configure/advanced-form-overview)

# PP-007: Custom JavaScript

Minimize custom JavaScript on portal pages. When JavaScript is necessary, follow secure coding practices and keep scripts maintainable.

1. Use out-of-the-box Power Pages features (form metadata, entity lists, content snippets) before resorting to custom JavaScript.
1. Never hard-code Dataverse record GUIDs, URLs, or environment-specific values in JavaScript files.
1. Store reusable scripts as web files and reference them consistently across pages.
1. Avoid inline `<script>` blocks in web templates where possible; use external web files instead.
1. Do not store sensitive logic (e.g., security checks, pricing calculations) in client-side scripts, as they can be inspected and modified by users.

## Rationale

1. Excessive JavaScript increases page load time and introduces maintenance overhead that is harder to track than server-side configuration.
1. Hard-coded GUIDs and URLs break when the solution is migrated to another environment.
1. Client-side code is fully visible to users and should never be relied upon for security or business-critical calculations.
1. Centralizing scripts in web files allows for versioning, caching, and consistent deployment.

## Examples

### Good

- Using the form metadata **Required** property to enforce mandatory fields instead of writing JavaScript to add validation.
- Storing a utility script as a web file at `/js/custom-validation.js` and referencing it in the page template.

### Bad

- A 500-line inline `<script>` block in a web template that hard-codes entity GUIDs and environment URLs.
- Client-side JavaScript that hides the "Delete" button instead of using table permissions to revoke the Delete operation.

## More Information
1. [Add custom JavaScript to Power Pages - Microsoft Learn](https://learn.microsoft.com/en-us/power-pages/configure/add-custom-javascript)

# PP-008: ALM and Source Control

Manage Power Pages configuration as code using the Power Platform CLI. Store portal artifacts in source control and deploy through automated pipelines.

1. Use `pac paportal download` to extract portal configuration to a local folder and commit it to source control.
1. Use `pac paportal upload` to deploy portal changes from source control to the target environment.
1. Maintain separate environments for Development, Test, and Production.
1. Never make configuration changes directly in the Production environment.
1. Integrate portal deployment steps into your CI/CD pipeline (Azure DevOps, GitHub Actions, or similar).
1. Parameterize environment-specific values (URLs, connection strings, feature flags) so they are not hard-coded in portal artifacts.

## Rationale

1. Without source control, it is impossible to track who changed what and when, making troubleshooting and rollbacks difficult.
1. Manual deployments are error-prone and unrepeatable. Automated pipelines ensure consistent, auditable deployments.
1. Direct changes in Production bypass testing and peer review, increasing the risk of introducing defects.
1. Environment-specific values baked into portal code cause failures when promoting between environments.

## Examples

### Good

- Portal artifacts are stored in a Git repository with a clear folder structure matching the `pac paportal download` output.
- A CI/CD pipeline runs on every pull request merge: it downloads the latest portal configuration, applies it to the Test environment, and runs smoke tests before promoting to Production.

### Bad

- Developers edit web templates directly in the Production Power Pages Design Studio without any change tracking.
- Portal configuration is shared between developers via email or file shares with no version history.

## More Information
1. [Power Pages ALM overview - Microsoft Learn](https://learn.microsoft.com/en-us/power-pages/configure/power-pages-alm)
1. [Power Platform CLI overview - Microsoft Learn](https://learn.microsoft.com/en-us/power-platform/developer/cli/introduction)

# PP-009: Anonymous Access

Restrict anonymous access to the minimum set of pages and data required for unauthenticated users. Explicitly review every permission granted to the Anonymous Users web role.

1. Only grant the **Anonymous Users** web role access to public-facing content such as the home page, knowledge base, or contact forms.
1. Never grant Write or Delete table permissions to the Anonymous Users role unless there is a justified and reviewed business need (e.g., anonymous form submission).
1. Use page permissions to restrict which pages are visible to unauthenticated visitors.
1. Periodically audit anonymous access settings to ensure no unintended data exposure.

## Rationale

1. The Anonymous Users web role applies to every visitor who has not logged in. Broad permissions on this role expose data to the entire internet.
1. Anonymous Write or Delete permissions can be exploited for spam, data pollution, or denial-of-service attacks.
1. As the site evolves, new pages or tables may inadvertently inherit anonymous access if defaults are too permissive.

## Examples

### Good

- The Anonymous Users web role has Read-only access to the Knowledge Article table (Global scope) and no access to any other tables.
- A public **Contact Us** form grants the Anonymous Users role Create-only access to the Inquiry table, with no Read, Write, or Delete permissions.

### Bad

- The Anonymous Users web role has Global Read access to the Contact, Account, and Case tables, exposing customer data to anyone.
- No page permissions configured, so all portal pages are visible to unauthenticated users including administrative dashboards.

## More Information
1. [Power Pages security best practices - Microsoft Learn](https://learn.microsoft.com/en-us/power-pages/security/best-practices)

# PP-010: Content Snippets

Use content snippets for reusable text, labels, and messages that appear across multiple pages. Avoid duplicating the same content in multiple web templates.

1. Create content snippets for any text that appears on more than one page (e.g., footer disclaimers, cookie notices, error messages).
1. Use descriptive names that follow a consistent naming convention (see [PPN-001](/PowerPages/Component-Naming.md)).
1. Leverage content snippets for multi-language support by providing translated values for each enabled language.
1. Do not use content snippets for large blocks of HTML or complex Liquid logic; use web templates instead.

## Rationale

1. Content snippets provide a single source of truth for repeated text, making updates easier and ensuring consistency across the site.
1. Translators can manage content snippets directly without modifying web templates, simplifying localization workflows.
1. Duplicating content in multiple templates leads to inconsistencies when one instance is updated but others are forgotten.

## Examples

### Good

- A content snippet named `VendorName/Footer/Disclaimer` containing the legal disclaimer text, referenced in the footer web template with `{% snippet 'VendorName/Footer/Disclaimer' %}`.
- A content snippet named `VendorName/Errors/GenericMessage` used across all error pages to display a consistent user-friendly error message.

### Bad

- The same disclaimer text copy-pasted into five different web templates. When the legal team updates the text, only two of the five templates are updated.
- A content snippet containing 200 lines of HTML and Liquid code that should be a web template instead.

## More Information
1. [Content snippets in Power Pages - Microsoft Learn](https://learn.microsoft.com/en-us/power-pages/configure/customize-content-snippets)
