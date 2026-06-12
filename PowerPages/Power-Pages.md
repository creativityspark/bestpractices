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
1. [Power Pages security - Microsoft Learn](https://learn.microsoft.com/en-us/power-pages/security/power-pages-security)

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
1. [Power Pages security - Microsoft Learn](https://learn.microsoft.com/en-us/power-pages/security/power-pages-security)

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

# PP-004: Header and Footer Output Caching

Enable header and footer output caching to improve portal performance. This caching mechanism applies specifically to the header and footer web templates, which are rendered on every page and can become a performance bottleneck on high-traffic sites.

> **Note:** This rule covers header and footer output caching. For broader page-level caching strategies, consider implementing caching at the CDN or reverse-proxy level as part of your infrastructure design.

1. Set the site setting `Header/OutputCache/Enabled` to `true` and `Footer/OutputCache/Enabled` to `true`.
1. Set `Header/OutputCache/Duration` and `Footer/OutputCache/Duration` to a value in seconds that reflects how frequently the header and footer content changes.
1. Avoid placing highly dynamic or user-specific content directly in header or footer web templates when caching is enabled.
1. If personalized elements (e.g., user name, notifications) must appear in the header, load them asynchronously via JavaScript after the cached header has rendered.

## Rationale

1. The header and footer web templates are rendered on every single page of the portal. Without caching, the Liquid code in these templates executes on every request, adding unnecessary overhead.
1. Caching headers and footers significantly reduces server-side rendering time, especially when they contain FetchXML queries, content snippets, or complex Liquid logic.
1. Placing dynamic per-user content in cached headers or footers causes all users to see the same cached output, leading to incorrect information being displayed.

## Examples

### Good

| Site Setting                       | Value   | Reason                                         |
| ---------------------------------- | ------- | ---------------------------------------------- |
| `Header/OutputCache/Enabled`       | `true`  | Enables caching for the header web template    |
| `Footer/OutputCache/Enabled`       | `true`  | Enables caching for the footer web template    |
| `Header/OutputCache/Duration`      | `3600`  | 1-hour cache; header content rarely changes    |
| `Footer/OutputCache/Duration`      | `3600`  | 1-hour cache; footer content rarely changes    |

### Bad

| Site Setting                       | Value     | Problem                                                           |
| ---------------------------------- | --------- | ----------------------------------------------------------------- |
| `Header/OutputCache/Enabled`       | `false`   | Header Liquid code executes on every page load                    |
| `Header/OutputCache/Duration`      | `10`      | Too short; frequent cache invalidation negates the benefit        |
| Header template includes `{{ user.fullname }}` inline | N/A | All users see the same cached name after the first render |

## More Information
1. [Enable header and footer output caching - Microsoft Learn](https://learn.microsoft.com/en-us/power-pages/configure/enable-header-footer-output-caching)

# PP-005: Basic and Advanced Forms

Configure forms with proper validation and table permissions. Use basic forms for simple data entry and advanced forms for multi-step processes.

1. Always pair forms with table permissions that enforce the correct scope and operations for the target table.
1. Enable field-level validation (required fields, data types, ranges) to ensure data quality.
1. Use advanced forms (multi-step forms) when the data collection process has a logical workflow with multiple stages.
1. Avoid exposing system fields or sensitive columns on portal forms (e.g., `ownerid`, `createdby`, `modifiedby`, `statecode`, `statuscode`, internal pricing fields, or security-related columns such as password hashes).
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
1. [Multistep forms in Power Pages - Microsoft Learn](https://learn.microsoft.com/en-us/power-pages/getting-started/multistep-forms)

# PP-006: Custom JavaScript

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

# PP-007: ALM and Source Control

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
1. [Power Pages ALM overview - Microsoft Learn](https://learn.microsoft.com/en-us/power-pages/configure/portals-alm)
1. [Power Platform CLI overview - Microsoft Learn](https://learn.microsoft.com/en-us/power-platform/developer/cli/introduction)

# PP-008: Anonymous Access

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
1. [Power Pages security - Microsoft Learn](https://learn.microsoft.com/en-us/power-pages/security/power-pages-security)

# PP-009: Content Snippets

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
