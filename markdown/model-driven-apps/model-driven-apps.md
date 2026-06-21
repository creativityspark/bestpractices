# General

Good practices for Model Driven Apps.

## MDA-001

### Title

Create separate Model Driven Apps for each distinct user role or business function inst...

### Description

Create separate Model Driven Apps for each distinct user role or business function instead of building a single app for all users.

### Guidelines

1. Identify the key personas (e.g., Sales, Customer Service, Back Office) and create a dedicated app for each.
1. Include only the tables, forms, views, and dashboards that are relevant to the target audience.
1. Assign the app to the appropriate security roles so that users only see the app designed for them.
1. Use a meaningful app name and icon that clearly conveys the app's purpose.

### Rationale

1. A single app containing every table and dashboard overwhelms users with information they do not need, reducing productivity.
1. Smaller, role-specific apps load faster because they contain fewer components.
1. Restricting app access by security role enforces the principle of least privilege and reduces the risk of unauthorized data access.
1. Tailored apps are easier to maintain because changes to one role's experience do not impact others.



### Examples

#### Good

- A "Customer Service Hub" app containing Cases, Knowledge Articles, and Queues - tailored for support agents.
- A "Sales Operations" app containing Leads, Opportunities, and Quotes - tailored for the sales team.
- A "Back Office Administration" app containing configuration tables, security roles, and audit logs - tailored for system administrators.

#### Bad

- A single "CRM App" that includes every table in the system, forcing sales reps to scroll past support tables and admin settings to find what they need.
- One app shared across all roles with no security role restrictions, giving every user access to every feature.

### More Information

1. [Model-driven app overview - Microsoft Learn](https://learn.microsoft.com/en-us/power-apps/maker/model-driven-apps/model-driven-app-overview)
1. [Control access to model-driven apps with security roles - Microsoft Learn](https://learn.microsoft.com/en-us/power-apps/maker/model-driven-apps/model-driven-app-share)

## MDA-002

### Title

Design the sitemap navigation with logical grouping, clear labels, and minimal nesting

### Description

Design the sitemap navigation with logical grouping, clear labels, and minimal nesting.

### Guidelines

1. Group related tables under meaningful areas and groups (e.g., "Sales" containing Leads, Opportunities, and Accounts).
1. Place the most frequently used items first in each group.
1. Avoid nesting more than two levels deep.
1. Use descriptive labels instead of internal jargon or abbreviations.
1. Assign icons to each sitemap entry for faster visual recognition.

### Rationale

1. A well-organized sitemap reduces the time users spend searching for the right table or dashboard.
1. Deep nesting makes navigation confusing and increases the number of clicks to reach common tasks.
1. Clear labels reduce training needs and help new users onboard faster.
1. Icons provide visual cues that improve navigation speed, especially on smaller screens.



### Examples

#### Good

- Leads
- Opportunities
- Quotes
- Accounts
- Contacts
- Active Cases
- Knowledge Articles
Good example code snippet.
```Plain Text
Area: Sales
  Group: Pipeline
    - Leads
    - Opportunities
    - Quotes
  Group: Customers
    - Accounts
    - Contacts

Area: Service
  Group: Cases
    - Active Cases
    - Knowledge Articles
```

#### Bad

- tbl_lead
- tbl_opp
- tbl_quot
- tbl_acc
- tbl_cont
- tbl_case
- tbl_ka
- tbl_ord
- tbl_inv
Bad example code snippet.
```Plain Text
Area: Area1
  Group: Group1
    Subarea: Subgroup1
      - tbl_lead
      - tbl_opp
      - tbl_quot
      - tbl_acc
      - tbl_cont
      - tbl_case
      - tbl_ka
      - tbl_ord
      - tbl_inv
```

### More Information

1. [Create a model-driven app site map - Microsoft Learn](https://learn.microsoft.com/en-us/power-apps/maker/model-driven-apps/create-site-map-app)
1. [UI/UX design components for model-driven apps - Microsoft Learn](https://learn.microsoft.com/en-us/dynamics365/guidance/develop/ui-ux-component-details-model-driven-apps)

## MDA-003

### Title

Design system views to be focused, performant, and aligned with how users consume data

### Description

Design system views to be focused, performant, and aligned with how users consume data.

### Guidelines

1. Display only the columns that users need in each view. Avoid adding every column to a single view.
1. Set appropriate default sorting and filtering so the most relevant records appear first.
1. Create purpose-specific views (e.g., "My Active Cases", "Cases Due Today") instead of relying solely on generic views.
1. Limit views to 6-8 columns to keep them readable without horizontal scrolling.
1. Avoid using complex calculated or rollup columns in high-traffic views, as they can degrade query performance.

### Rationale

1. Views with too many columns load more data than necessary, increasing query time and degrading user experience.
1. Purpose-specific views help users find the right records faster and reduce the need for manual filtering.
1. Calculated and rollup columns require additional server processing at query time, which can cause slow load times on views accessed frequently.
1. Consistent, well-designed views reduce user errors and the need for ad-hoc Advanced Find queries.



### Examples

#### Good

- Conforms to the rule requirements.

#### Bad

- Violates the rule requirements.

### More Information

1. [Create or edit a model-driven app view - Microsoft Learn](https://learn.microsoft.com/en-us/power-apps/maker/model-driven-apps/create-edit-views)
1. [Optimize form performance - Microsoft Learn](https://learn.microsoft.com/en-us/power-apps/maker/model-driven-apps/optimize-form-performance)

## MDA-004

### Title

Design dashboards to surface actionable insights, not just raw data

### Description

Design dashboards to surface actionable insights, not just raw data.

### Guidelines

1. Include only charts and lists that drive decisions or highlight areas requiring attention.
1. Create role-specific dashboards instead of a single all-purpose dashboard.
1. Limit the number of components per dashboard to 4-6 to avoid visual clutter and slow load times.
1. Use interactive dashboards when users need to filter and drill down into data directly from the dashboard.
1. Set the most relevant dashboard as the default for each security role.

### Rationale

1. Dashboards overloaded with charts and lists become noise rather than insight, reducing their value.
1. Each component on a dashboard triggers a separate data query. Too many components degrade load time.
1. Interactive dashboards allow users to act on data without navigating away, improving productivity.
1. Role-specific dashboards ensure users see KPIs relevant to their job function.



### Examples

#### Good

- A "Service Manager Dashboard" with:
- Chart: Cases by Priority (last 30 days)
- Chart: Average Resolution Time (trend)
- List: Cases Escalated Today
- List: SLA Violations This Week

#### Bad

- A single "Main Dashboard" with 10+ charts and lists covering Sales, Service, Marketing, and Admin data - used by everyone regardless of role.
- A dashboard with lists showing all records (unfiltered), providing no insight beyond what a view already offers.

### More Information

1. [Create or edit a model-driven app dashboard - Microsoft Learn](https://learn.microsoft.com/en-us/power-apps/maker/model-driven-apps/create-edit-dashboards)

## MDA-005

### Title

Follow client scripting best practices when writing JavaScript for Model Driven Apps

### Description

Follow client scripting best practices when writing JavaScript for Model Driven Apps.

### Guidelines

1. Use namespaces to avoid global variable conflicts. Define all functions under a project-specific namespace (e.g., Contoso.Account).
1. Always use executionContext.getFormContext() instead of the deprecated Xrm.Page.
1. Use async/await with Xrm.WebApi for all data operations. Never use synchronous XMLHttpRequest calls.
1. Register event handlers using their fully qualified namespace (e.g., Contoso.Account.onLoad) instead of anonymous functions.
1. Handle errors using try/catch blocks and display user-friendly messages via Xrm.Navigation.openAlertDialog.
1. Pass executionContext as the first parameter to all event handler functions.

### Rationale

1. Global variables can conflict with other scripts or future platform updates, causing unpredictable behavior.
1. Xrm.Page is deprecated and may be removed in future updates. getFormContext() is the supported replacement.
1. Synchronous calls block the UI thread, causing the form to freeze during data operations.
1. Named functions registered via their namespace are easier to debug, trace, and manage across forms.
1. Unhandled errors in client scripts can silently fail or produce confusing browser errors for end users.



### Examples

#### Good

Good example code snippet.
```javascript
var Contoso = Contoso || {};
Contoso.Account = {
    onLoad: async function (executionContext) {
        "use strict";
        var formContext = executionContext.getFormContext();
        try {
            var result = await Xrm.WebApi.retrieveRecord(
                "account",
                formContext.data.entity.getId(),
                "?$select=name,revenue"
            );
            // Process result
        } catch (error) {
            Xrm.Navigation.openAlertDialog({ text: error.message });
        }
    }
};
```

#### Bad

Bad example code snippet.
```javascript
// No namespace — pollutes global scope
function onLoad() {
    // Uses deprecated Xrm.Page
    var name = Xrm.Page.getAttribute("name").getValue();

    // Synchronous XMLHttpRequest — blocks the UI
    var xhr = new XMLHttpRequest();
    xhr.open("GET", "/api/data/v9.2/accounts", false);
    xhr.send();
}
```

### More Information

1. [Client scripting in model-driven apps - Microsoft Learn](https://learn.microsoft.com/en-us/power-apps/developer/model-driven-apps/clientapi/client-scripting)
1. [Xrm.WebApi reference - Microsoft Learn](https://learn.microsoft.com/en-us/power-apps/developer/model-driven-apps/clientapi/reference/xrm-webapi)
1. [Best practices for client scripting - Microsoft Learn](https://learn.microsoft.com/en-us/power-apps/developer/model-driven-apps/best-practices/business-logic/interact-http-https-resources-asynchronously)

## MDA-006

### Title

Create custom security roles following the principle of least privilege instead of modi...

### Description

Create custom security roles following the principle of least privilege instead of modifying out-of-the-box roles.

### Guidelines

1. Clone the out-of-the-box role that most closely matches the required access, then customize the clone.
1. Grant only the minimum table and field permissions needed for each role.
1. Use field security profiles for sensitive fields (e.g., salary, SSN) that should be restricted even within a role.
1. Assign security roles via Azure AD security groups or Dataverse teams rather than directly to individual users.
1. Test every custom security role in a non-production environment with a dedicated test user before deploying to production.

### Rationale

1. Modifying out-of-the-box roles can be overwritten during platform updates, causing unexpected permission changes.
1. Excessive permissions violate the principle of least privilege and increase the surface area for data breaches or accidental modifications.
1. Assigning roles via security groups simplifies user management and ensures consistency when onboarding or offboarding users.
1. Untested security roles can inadvertently grant or restrict access, leading to production issues that are difficult to diagnose.



### Examples

#### Good

- Clone the "Customer Service Representative" role, remove access to financial tables, and name it "Tier 1 Support Agent".
- Create a field security profile to restrict the credit_limit column on the Account table to the Finance team only.
- Assign the "Sales Representative" role to the "Sales Team" Azure AD security group.

#### Bad

- Granting the "System Administrator" role to all users to avoid access-related support tickets.
- Editing the out-of-the-box "Salesperson" role directly instead of cloning it, risking changes being overwritten on platform updates.
- Assigning security roles to individual users one by one, making it difficult to track who has what access.

### More Information

1. [Security roles and privileges - Microsoft Learn](https://learn.microsoft.com/en-us/power-platform/admin/security-roles-privileges)
1. [Field security profiles - Microsoft Learn](https://learn.microsoft.com/en-us/power-platform/admin/field-level-security)

## MDA-007

### Title

Package all customizations in managed solutions and follow a structured solution strategy

### Description

Package all customizations in managed solutions and follow a structured solution strategy.

### Guidelines

1. Use a consistent publisher prefix across all solutions in the organization.
1. Separate customizations into layered solutions (e.g., Core, Feature, App) to enable independent deployment and rollback.
1. Never make unmanaged customizations directly in production. All changes must flow through the development environment and be deployed as managed solutions.
1. Use environment variables for settings that differ across environments (e.g., API URLs, connection references).
1. Store solution exports in source control (e.g., Git) and automate deployments via CI/CD pipelines.

### Rationale

1. Unmanaged customizations in production cannot be cleanly upgraded or rolled back, leading to environment drift and support issues.
1. Layered solutions allow teams to deploy and update features independently without affecting the core data model or other features.
1. A consistent publisher prefix prevents naming conflicts and makes it easy to identify which components belong to your organization.
1. Environment variables eliminate the need to manually reconfigure settings after each deployment, reducing errors and deployment time.
1. Source control and CI/CD ensure traceability, repeatability, and the ability to revert to a known good state.



### Examples

#### Good

Good example code snippet.
```Plain Text
Solution: Contoso Core (contoso_core)
  → Tables, fields, relationships, option sets

Solution: Contoso Sales App (contoso_sales)
  → Sales-specific forms, views, dashboards, sitemap

Solution: Contoso Service App (contoso_service)
  → Service-specific forms, views, dashboards, sitemap
```

#### Bad

- All customizations in a single monolithic solution that takes 30+ minutes to import and cannot be partially rolled back.
- Making quick fixes directly in the production environment as unmanaged customizations, bypassing the development and testing process.
- Different developers using different publisher prefixes, resulting in mixed prefixes across tables and fields.

### More Information

1. [Solutions overview - Microsoft Learn](https://learn.microsoft.com/en-us/power-apps/maker/data-platform/solutions-overview)
1. [ALM best practices - Microsoft Learn](https://learn.microsoft.com/en-us/power-platform/alm/overview-alm)
1. [Use environment variables in solutions - Microsoft Learn](https://learn.microsoft.com/en-us/power-apps/maker/data-platform/environmentvariables)

## MDA-008

### Title

Every Model Driven App must have a description that explains its purpose, target audien...

### Description

Every Model Driven App must have a description that explains its purpose, target audience, and scope.

### Guidelines

1. State the purpose: Explain what the app is for in one or two sentences.
1. Identify the audience: Specify which security roles or teams are expected to use this app.
1. Define the scope: List the key tables, dashboards, and business processes included in the app.

### Rationale

1. Organizations often have multiple Model Driven Apps. Without descriptions, administrators cannot easily determine which app serves which purpose.
1. Descriptions help during onboarding, making it clear which app a new user should access based on their role.
1. Clear scope documentation prevents duplication of features across apps and supports governance decisions.



### Examples

#### Good

- "Customer Service Hub for the Tier 1 and Tier 2 support teams. Includes Cases, Knowledge Articles, Queues, and the Case Resolution dashboard. Assigned to the Customer Service Representative and Customer Service Manager security roles."
- "Sales Operations app for the inside sales team. Covers Leads, Opportunities, Quotes, and the Sales Pipeline dashboard. Restricted to the Sales Representative and Sales Manager roles."

#### Bad

- "App 1" - provides no context about the app's purpose or audience.
- No description at all - administrators must open and inspect the app to understand what it contains.

### More Information

1. [Create a model-driven app - Microsoft Learn](https://learn.microsoft.com/en-us/power-apps/maker/model-driven-apps/build-first-model-driven-app)


