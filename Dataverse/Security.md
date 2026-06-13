# Security Roles

Good practices for Dataverse Security Roles.

# SEC-001

Never modify out-of-the-box (OOB) security roles. Always create custom security roles tailored to your organization's needs.

1. Do not edit system roles such as System Administrator, System Customizer, or Basic User.
1. When you need a role similar to an existing OOB role, copy it and customize the copy.
1. Use a consistent naming convention for custom roles that includes the publisher prefix and the business function (e.g., `csp_Sales_Manager`, `csp_Finance_Analyst`).
1. Avoid generic names like `Custom Role 1` or `New Role`.

## Rationale

1. Out-of-the-box roles may be overwritten or reset during platform updates, causing unexpected permission changes.
1. Modifying OOB roles makes it difficult to troubleshoot issues because the baseline behavior is no longer known.
1. Custom roles are included in solutions and can be promoted across environments in a controlled manner.
1. A clear naming convention makes it easier to identify the purpose of each role when managing security across multiple environments.

## Examples

### Good

- A custom role named `csp_Account_Manager` created by copying the Salesperson role and removing unnecessary privileges such as marketing list management.
- A custom role named `csp_Read_Only_Auditor` with only Read privileges on business data tables, used for compliance reviews.

### Bad

- Editing the OOB Salesperson role directly to remove privileges, which may be overwritten in the next platform update.
- A custom role named `Role1` with no indication of its purpose or target audience.

## More Information
1. [Security roles and privileges - Microsoft Learn](https://learn.microsoft.com/en-us/power-platform/admin/security-roles-privileges)
1. [Create or edit a security role - Microsoft Learn](https://learn.microsoft.com/en-us/power-apps/maker/data-platform/create-edit-security-role)

# SEC-002

Apply the Principle of Least Privilege when assigning security role permissions.

1. Grant users only the minimum privileges required to perform their job functions.
1. Start with no permissions and add only what is needed, rather than starting with full access and removing privileges.
1. Restrict the System Administrator role to a small number of core administrators. Never assign it for convenience.
1. For service accounts and integrations, create dedicated roles with only the API-level permissions required for the specific tables and operations involved.

## Rationale

1. Over-privileged users can accidentally or intentionally modify or delete data they should not have access to.
1. Restricting access reduces the blast radius of compromised accounts or misconfigured automations.
1. Granting System Administrator to non-admin users bypasses all security controls and audit boundaries, creating compliance risks.
1. Service accounts with broad permissions are a common attack vector. Limiting them to specific tables and operations reduces risk.

## Examples

### Good

| Role                         | Permissions                         | Scope         |
| ---------------------------- | ----------------------------------- | ------------- |
| `csp_Sales_Rep`              | Read/Write on Account, Contact, Opportunity | User level    |
| `csp_Finance_Viewer`         | Read-only on Invoice, Payment       | Business Unit |
| `csp_Integration_Service`    | Read/Write on Order, Product via API only | Organization  |

### Bad

| Role                         | Problem                                                      |
| ---------------------------- | ------------------------------------------------------------ |
| System Administrator         | Assigned to 20 users "because it's easier"                   |
| `csp_General_User`           | Organization-level Read/Write/Delete on all tables           |
| `csp_Integration_Service`    | Full System Administrator privileges for a data sync process |

## More Information
1. [Dataverse security best practices - Microsoft Learn](https://learn.microsoft.com/en-us/power-platform/admin/data-platform-security-best-practices)
1. [Security roles and privileges - Microsoft Learn](https://learn.microsoft.com/en-us/power-platform/admin/security-roles-privileges)

# SEC-003

Assign security roles to teams instead of individual users whenever possible.

1. Use **Owner Teams** to group users by business function or department and assign security roles to the team.
1. Use **Azure AD Group Teams** to automatically sync membership from Azure Active Directory security groups into Dataverse teams with assigned roles.
1. Use **Access Teams** for sharing individual records with ad-hoc groups of users without granting broad table-level permissions.
1. Reserve direct user-level role assignments for exceptional cases only, and document the reason.

## Rationale

1. Assigning roles to teams reduces administrative overhead. When a user joins or leaves a team, their permissions update automatically.
1. Azure AD Group Teams eliminate manual user management in Dataverse by leveraging the organization's existing identity infrastructure.
1. Direct user-level assignments are difficult to audit and maintain at scale, especially when users change roles or leave the organization.
1. Access Teams provide a lightweight mechanism for record-level sharing without inflating the number of security roles.

## Examples

### Good

- An Owner Team named `Sales Team - North America` with the `csp_Sales_Rep` role assigned. New sales reps are added to the team and immediately inherit the correct permissions.
- An Azure AD Group Team linked to the `Finance Department` security group in Azure AD, with the `csp_Finance_Analyst` role assigned. User membership is managed centrally in Azure AD.

### Bad

- Each of the 50 sales reps has the `csp_Sales_Rep` role assigned directly to their user record. When the role changes, all 50 assignments must be updated manually.
- An Access Team used to grant broad table-level Read/Write permissions instead of sharing individual records.

## More Information
1. [Manage teams - Microsoft Learn](https://learn.microsoft.com/en-us/power-platform/admin/manage-teams)
1. [Manage group teams - Microsoft Learn](https://learn.microsoft.com/en-us/power-platform/admin/manage-group-teams)

# SEC-004

Separate security roles by functional purpose: one set for application access and another for data access.

1. Create **application roles** that control which model-driven apps, dashboards, and navigation areas a user can see.
1. Create **data roles** that control CRUD (Create, Read, Update, Delete) permissions on specific tables and at specific access levels (User, Business Unit, Parent: Child, Organization).
1. Combine application and data roles by assigning both to the same user or team, rather than merging all privileges into a single role.

## Rationale

1. Mixing application navigation and data access privileges into one role leads to overly complex roles that are difficult to understand, test, and maintain.
1. Separating concerns allows you to reuse data roles across different apps and reuse app roles across different data access levels.
1. When troubleshooting access issues, smaller and focused roles make it easier to identify which role is granting or blocking a specific privilege.

## Examples

### Good

- A user has two roles: `csp_CRM_App_Access` (grants access to the CRM model-driven app and its sitemap areas) and `csp_Account_Manager_Data` (grants Read/Write on Account, Contact, and Opportunity at the Business Unit level).
- When a new model-driven app is introduced, a new app access role is created without modifying existing data roles.

### Bad

- A single role `csp_CRM_Full` that includes app access, table CRUD permissions, and custom entity permissions all in one. Changing a data permission requires editing a role that also controls app navigation.
- Five nearly identical roles that differ only in which app they grant access to, each duplicating the same data permissions.

## More Information
1. [Security roles and privileges - Microsoft Learn](https://learn.microsoft.com/en-us/power-platform/admin/security-roles-privileges)

# SEC-005

Set the appropriate access level (User, Business Unit, Parent: Child Business Units, Organization) for each privilege deliberately.

1. Default to **User** level access unless there is a clear business requirement for broader visibility.
1. Use **Business Unit** level when users need to see records owned by anyone in their department.
1. Use **Parent: Child Business Units** when managers need visibility into their own and subordinate departments.
1. Use **Organization** level only for reference data or scenarios where all users must see all records.

## Rationale

1. Access levels are often set to Organization by default for convenience, which exposes data across the entire organization and defeats the purpose of row-level security.
1. Overly broad access levels can violate data privacy regulations and internal data governance policies.
1. Choosing the correct access level ensures that the business unit and team hierarchy is leveraged to control data visibility without additional customization.

## Examples

### Good

| Table         | Privilege | Access Level             | Reason                                                   |
| ------------- | --------- | ------------------------ | -------------------------------------------------------- |
| Opportunity   | Read      | Business Unit            | Sales reps need to see all opportunities in their region |
| Case          | Read      | User                     | Agents should only see their own cases                   |
| Country       | Read      | Organization             | Reference data needed by all users                       |
| Customer      | Write     | User                     | Only the account owner should edit customer records      |

### Bad

| Table         | Privilege | Access Level  | Problem                                                        |
| ------------- | --------- | ------------- | -------------------------------------------------------------- |
| Opportunity   | Read      | Organization  | Sales reps in every region can see all opportunities           |
| Case          | Delete    | Organization  | Any user can delete any case in the system                     |
| Employee      | Read      | Organization  | Salary and personal data visible to the entire organization    |

## More Information
1. [Security roles and privileges - Microsoft Learn](https://learn.microsoft.com/en-us/power-platform/admin/security-roles-privileges)
1. [Dataverse security best practices - Microsoft Learn](https://learn.microsoft.com/en-us/power-platform/admin/data-platform-security-best-practices)

# SEC-006

Review and audit security role assignments on a regular schedule.

1. Establish a periodic review cycle (e.g., quarterly) to validate that all role assignments are still appropriate.
1. Remove security roles from users who have changed positions or left the organization.
1. Identify and eliminate role sprawl by consolidating roles that have overlapping or redundant privileges.
1. Use the Dataverse audit log and the Power Platform Admin Center to monitor privileged operations and detect anomalies.

## Rationale

1. User responsibilities change over time, and stale role assignments lead to **privilege creep** — users accumulating more access than they need.
1. Former employees or contractors who retain active security roles represent a significant security risk.
1. Uncontrolled role proliferation makes the security model harder to understand, test, and enforce.
1. Regular audits are often required for compliance with standards such as SOC 2, ISO 27001, and GDPR.

## Examples

### Good

- A quarterly review process where the security team exports all user-role assignments, compares them against the HR system of record, and removes stale assignments.
- A documented role matrix mapping each security role to the job titles and departments that should hold it, used as the baseline for each review.

### Bad

- No review process in place. A user who moved from Finance to Marketing two years ago still has the `csp_Finance_Admin` role.
- 30 custom security roles exist in the environment, but no one can explain the difference between `csp_Sales_User`, `csp_Sales_Access`, and `csp_Sales_Basic`.

## More Information
1. [Auditing overview - Microsoft Learn](https://learn.microsoft.com/en-us/power-platform/admin/manage-dataverse-auditing)
1. [View user access with security role checker - Microsoft Learn](https://learn.microsoft.com/en-us/power-platform/admin/database-security)

# SEC-007

Test security roles in a non-production environment before deploying to production.

1. Create test user accounts (or use the **impersonation** feature) with only the security roles being tested — never test with an administrator account.
1. Validate all CRUD operations, app access, dashboard visibility, and form behavior for each role.
1. Test both positive scenarios (user can do what they should) and negative scenarios (user cannot do what they should not).
1. Include security role testing as part of your solution deployment checklist.

## Rationale

1. Security misconfigurations are difficult to detect through code review alone. Runtime testing with realistic accounts is the only reliable way to validate effective permissions.
1. Testing with an administrator account masks permission issues because administrators bypass all security checks.
1. Catching security gaps in development or test environments prevents data exposure incidents in production.

## Examples

### Good

- A test user named `test_sales_rep@contoso.com` with only the `csp_Sales_Rep` role, used to verify that the user can create and edit Opportunities but cannot delete Accounts.
- A test checklist that includes: "Verify that the Finance Viewer role cannot export data from the Employee table."

### Bad

- Testing all security roles by logging in as System Administrator and assuming "it works for everyone."
- Deploying a new security role to production without testing, resulting in 200 users losing access to critical forms on a Monday morning.

## More Information
1. [Environments overview - Microsoft Learn](https://learn.microsoft.com/en-us/power-platform/admin/environments-overview)
1. [Security roles and privileges - Microsoft Learn](https://learn.microsoft.com/en-us/power-platform/admin/security-roles-privileges)
