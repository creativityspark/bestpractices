# Application Lifecycle Management (ALM)

Good practices for Power Platform Application Lifecycle Management.

# ALM-001

Establish a minimum of three separate environments — Development, Test, and Production — to support a healthy application lifecycle.

1. Create dedicated **Development** environments where makers build and test in isolation using unmanaged solutions.
1. Create a **Test/QA** environment for user acceptance testing and integration validation using managed solutions.
1. Maintain a locked-down **Production** environment that only receives tested, approved managed solutions.
1. Apply Data Loss Prevention (DLP) policies appropriate to each environment, with the most restrictive policies in Production.
1. Restrict system administrator roles in Production to a small group of authorized personnel.

## Rationale

1. Without environment separation, changes made during development can accidentally affect live users and production data.
1. A dedicated test environment allows stakeholders to validate changes before they reach production, catching bugs and regressions early.
1. Restricting Production access reduces the risk of unauthorized or untested changes being deployed directly.
1. DLP policies that match the environment's purpose prevent accidental data exposure — Development environments may need more flexibility, while Production needs strict controls.

## Examples

### Good

- Three environments configured: `Contoso-Dev`, `Contoso-Test`, `Contoso-Prod`.
- Developers work only in `Contoso-Dev`, solutions are promoted as managed to `Contoso-Test`, and after UAT sign-off, deployed as managed to `Contoso-Prod`.
- DLP policies in Production block all non-approved connectors.

### Bad

- A single environment used for development, testing, and production simultaneously.
- Developers making changes directly in the Production environment.
- No DLP policies configured, allowing any connector to be used in Production.

## More Information

1. [Overview of ALM with Microsoft Power Platform - Microsoft Learn](https://learn.microsoft.com/en-us/power-platform/alm/overview-alm)
1. [Environments overview - Microsoft Learn](https://learn.microsoft.com/en-us/power-platform/admin/environments-overview)
1. [Data loss prevention policies - Microsoft Learn](https://learn.microsoft.com/en-us/power-platform/admin/wp-data-loss-prevention)

# ALM-002

Always deploy **managed solutions** to Test, UAT, and Production environments. Reserve unmanaged solutions exclusively for Development.

1. Export solutions as **managed** when deploying to any environment beyond Development.
1. Never import unmanaged solutions into Production or Test environments.
1. Use **solution upgrades** (not delete-and-reimport) to update managed solutions in target environments.
1. Keep the unmanaged (source) version of every solution in your Development environment and source control for future modifications.

## Rationale

1. Managed solutions lock components, preventing accidental modifications in Production that bypass your ALM process.
1. Unmanaged solutions do not clean up when removed — deleting an unmanaged solution leaves all its components behind, creating untracked customizations.
1. Managed solutions support clean uninstall: removing a managed solution removes all of its components, making rollback straightforward.
1. The upgrade mechanism for managed solutions allows incremental updates while preserving data and removing deprecated components.

## Examples

### Good

- Solution exported as managed from Dev and imported into Test for validation.
- After UAT sign-off, the same managed solution is imported into Production.
- An updated version is deployed using the **Upgrade** option, which removes deprecated components automatically.

### Bad

- An unmanaged solution imported into Production so a developer can "quickly fix something."
- Deleting a managed solution and reimporting a new version instead of using the upgrade process, which causes data loss.
- Customizations made directly in Production outside of any solution, creating untracked changes.

## More Information

1. [Managed and unmanaged solutions - Microsoft Learn](https://learn.microsoft.com/en-us/power-platform/alm/solution-concepts-alm)
1. [Apply solution upgrade or update - Microsoft Learn](https://learn.microsoft.com/en-us/power-platform/alm/update-solutions-alm)

# ALM-003

Create a dedicated **solution publisher** with a short, unique prefix and apply consistent naming conventions to all solutions.

1. Use a publisher prefix of **3 to 5 lowercase characters** that represents your organization or project (e.g., `contoso`, `adw`).
1. Never use the default publisher (`CDS Default Publisher` with prefix `cr`), as it is shared and cannot be changed later.
1. Use the same publisher across all environments (Dev, Test, Prod) to ensure consistency during deployments.
1. Name solutions clearly using a pattern like `PublisherPrefix_SolutionPurpose` (e.g., `Contoso_SalesOperations`).
1. Apply **semantic versioning** (Major.Minor.Build.Revision) to all solutions.

## Rationale

1. The publisher prefix is permanently prepended to all custom tables, columns, and components. Choosing a meaningful prefix avoids confusion and conflicts with other publishers or ISV solutions.
1. The default publisher is shared across the organization — using it means your components mix with others, making it impossible to distinguish ownership.
1. A consistent publisher across environments ensures that solution imports are recognized as updates rather than new solutions.
1. Semantic versioning provides a clear history of changes and makes it easy to identify which version is deployed in each environment.

## Examples

### Good

- Publisher: `Contoso Ltd`, prefix: `contoso`, deployed consistently in Dev, Test, and Prod.
- Solution name: `Contoso_HROnboarding`, version `1.2.0.0`.
- All custom tables use the `contoso_` prefix: `contoso_Employee`, `contoso_OnboardingTask`.

### Bad

- Using the default `CDS Default Publisher` with prefix `cr` for production solutions.
- Publisher prefix `mycompanyglobaltradingsolutions` — too long, making schema names unreadable.
- Solution version left at `1.0.0.0` across all deployments with no version history.
- Different publishers used in Dev and Prod, causing import conflicts.

## More Information

1. [Create a solution publisher - Microsoft Learn](https://learn.microsoft.com/en-us/power-apps/maker/data-platform/create-solution#create-a-solution-publisher)
1. [Solution publisher prefix - Microsoft Learn](https://learn.microsoft.com/en-us/power-apps/developer/data-platform/introduction-solutions#solution-publisher)

# ALM-004

Use **environment variables** to store configuration values that differ between environments instead of hardcoding them in apps, flows, or plugins.

1. Create environment variables for URLs, feature flags, email addresses, thresholds, and any value that changes across Dev, Test, and Production.
1. Always add environment variables to your solution so they are transported with it during deployments.
1. Reference the environment variable in your apps and flows rather than typing the value directly.
1. Set environment-specific **current values** in each target environment after importing the solution.
1. Mark environment variables that hold secrets or sensitive data as the **Secret** data type.

## Rationale

1. Hardcoded values require editing the app or flow and republishing every time you move between environments, which is error-prone and breaks automation.
1. Environment variables allow the same solution to be deployed to multiple environments without modification — only the current value changes per environment.
1. Secret environment variables are encrypted and not displayed in the UI, providing a basic level of protection for sensitive configuration.
1. Including environment variables in the solution ensures they are tracked, versioned, and deployed together with the components that depend on them.

## Examples

### Good

```
// Environment variable: contoso_SharePointSiteUrl
// Dev value:  https://contoso-dev.sharepoint.com/sites/hr
// Test value: https://contoso-test.sharepoint.com/sites/hr
// Prod value: https://contoso.sharepoint.com/sites/hr

// In a Power Automate flow, the SharePoint action references
// the environment variable instead of a hardcoded URL.
```

### Bad

```
// URL hardcoded directly in a Power Automate flow action:
// Site Address: https://contoso.sharepoint.com/sites/hr
//
// When deployed to Test, the flow still points to Production SharePoint,
// causing test data to be written to the live site.
```

```
// API key pasted directly into an HTTP action:
// Authorization: Bearer sk-abc123secretkey
//
// The secret is visible to anyone who can edit the flow
// and is exported with the solution in plain text.
```

## More Information

1. [Environment variables overview - Microsoft Learn](https://learn.microsoft.com/en-us/power-apps/maker/data-platform/environmentvariables)
1. [Use environment variables in solutions - Microsoft Learn](https://learn.microsoft.com/en-us/power-apps/maker/data-platform/environmentvariables#use-environment-variables-in-solutions)

# ALM-005

Use **connection references** in solutions instead of embedding connections directly, so that flows and apps can be rebound to environment-specific connections during deployment.

1. Create connection references in your solution before building flows or apps that use connectors.
1. Reference the connection reference in every flow action and app data source instead of using a direct connection.
1. During managed solution import in a target environment, map each connection reference to an existing connection owned by a service account or appropriate user.
1. Use **service principal connections** for non-interactive flows to avoid dependency on individual user accounts.

## Rationale

1. Without connection references, imported flows fail because the embedded connection belongs to the developer's account, which does not exist or is not authorized in the target environment.
1. Connection references decouple the connector identity from the solution, allowing different credentials in Dev, Test, and Production.
1. Service principal connections ensure flows continue to run even when individual employees leave the organization or change roles.
1. Connection references are the only supported mechanism for ALM-friendly connector management in Power Platform solutions.

## Examples

### Good

- A solution contains a connection reference `contoso_SharePointConnection` of type SharePoint.
- All flows in the solution use `contoso_SharePointConnection` for their SharePoint actions.
- When importing to Production, the admin maps `contoso_SharePointConnection` to a service account's SharePoint connection.

### Bad

- A flow uses a direct connection tied to `developer@contoso.com`. When imported to Production, the flow fails because that user has no permissions in Production.
- Multiple flows each create their own connection during import, resulting in dozens of orphaned connections with no clear ownership.
- A flow runs under a departing employee's connection. When their account is disabled, all dependent flows stop working.

## More Information

1. [Connection references overview - Microsoft Learn](https://learn.microsoft.com/en-us/power-apps/maker/data-platform/create-connection-reference)
1. [Use service principal with connection references - Microsoft Learn](https://learn.microsoft.com/en-us/power-platform/admin/power-automate-authentication#use-service-principal-based-authentication)

# ALM-006

Store all solution artifacts in source control (Git) to enable version history, collaboration, code reviews, and automated pipelines.

1. Use the **Power Platform CLI** (`pac solution clone` and `pac solution unpack`) to decompose solutions into source-friendly individual files.
1. Store the unpacked solution files in a Git repository (Azure DevOps or GitHub).
1. Adopt a branching strategy (e.g., trunk-based development or GitFlow) suitable for your team size.
1. Require **pull requests** with peer review before merging changes to the main branch.
1. Include all custom code (plugins, PCF controls, web resources) alongside the unpacked solution in the same repository.

## Rationale

1. Without source control, there is no history of what changed, when, or by whom — making it impossible to audit, compare, or roll back changes.
1. Unpacking solutions into individual files makes diffs meaningful and enables line-level code reviews of configuration changes.
1. Branching strategies allow multiple developers to work in parallel without overwriting each other's changes.
1. Pull request reviews catch issues before they are merged, improving solution quality and spreading knowledge across the team.

## Examples

### Good

```
Repository structure:
├── src/
│   └── ContosoHR/
│       ├── Entities/
│       │   ├── contoso_Employee/
│       │   └── contoso_OnboardingTask/
│       ├── Workflows/
│       ├── CanvasApps/
│       ├── PluginAssemblies/
│       └── Solution.xml
├── pipelines/
│   └── build-and-deploy.yml
└── README.md
```

- Developer creates a feature branch, makes changes in Dev, exports and unpacks the solution, commits, and opens a pull request.
- A reviewer inspects the diff to verify only intended changes are included.

### Bad

- Solution `.zip` files emailed between team members or stored on a shared drive with names like `Solution_v2_final_FINAL.zip`.
- No version history — when something breaks, there is no way to determine what changed or revert to a previous state.
- All developers working in the same Dev environment with no branching, overwriting each other's changes.

## More Information

1. [Source control with solution files - Microsoft Learn](https://learn.microsoft.com/en-us/power-platform/alm/use-source-control-solution-files)
1. [Power Platform CLI - Microsoft Learn](https://learn.microsoft.com/en-us/power-platform/developer/cli/introduction)
1. [ALM developer guide - Microsoft Learn](https://learn.microsoft.com/en-us/power-platform/alm/alm-for-developers)

# ALM-007

Automate solution export, packing, validation, and import using CI/CD pipelines instead of performing manual deployments.

1. Use **Power Platform Build Tools** for Azure DevOps or **GitHub Actions for Power Platform** to build your pipelines.
1. Use **service principal authentication** (not personal accounts) for pipeline connections to Power Platform environments.
1. Structure pipelines with distinct stages: **Build** (export, unpack, validate), **Test** (deploy managed to Test, run tests), and **Release** (deploy managed to Production with approvals).
1. Include approval gates before Production deployments to enforce sign-off from stakeholders.
1. Store pipeline definitions in source control alongside your solution.

## Rationale

1. Manual deployments are error-prone — steps may be skipped, the wrong solution version may be imported, or environment variables may be misconfigured.
1. Automated pipelines ensure every deployment follows the same validated process, reducing human error and increasing reliability.
1. Service principals provide stable, auditable authentication that does not depend on individual user accounts or require interactive sign-in.
1. Approval gates enforce governance and prevent untested changes from reaching Production.

## Examples

### Good

```yaml
# Azure DevOps pipeline (simplified)
stages:
  - stage: Build
    jobs:
      - job: ExportAndPack
        steps:
          - task: PowerPlatformToolInstaller@2
          - task: PowerPlatformExportSolution@2
            inputs:
              SolutionName: ContosoHR
              Managed: true
          - task: PowerPlatformChecker@2
            inputs:
              FilesToAnalyze: '$(Build.ArtifactStagingDirectory)/*.zip'

  - stage: DeployToTest
    dependsOn: Build
    jobs:
      - deployment: DeployTest
        environment: Contoso-Test
        strategy:
          runOnce:
            deploy:
              steps:
                - task: PowerPlatformImportSolution@2
                  inputs:
                    SolutionInputFile: '$(Pipeline.Workspace)/**/ContosoHR_managed.zip'

  - stage: DeployToProd
    dependsOn: DeployToTest
    jobs:
      - deployment: DeployProd
        environment: Contoso-Prod  # has approval gate configured
        strategy:
          runOnce:
            deploy:
              steps:
                - task: PowerPlatformImportSolution@2
                  inputs:
                    SolutionInputFile: '$(Pipeline.Workspace)/**/ContosoHR_managed.zip'
```

### Bad

- A developer manually exports a solution from Dev, downloads the `.zip`, and imports it into Production from the browser.
- Pipeline authenticates using a developer's personal credentials — when the developer changes their password, all pipelines break.
- No approval gates: a pipeline automatically deploys to Production after a commit, with no human review.

## More Information

1. [Power Platform Build Tools for Azure DevOps - Microsoft Learn](https://learn.microsoft.com/en-us/power-platform/alm/devops-build-tools)
1. [GitHub Actions for Power Platform - Microsoft Learn](https://learn.microsoft.com/en-us/power-platform/alm/devops-github-actions)
1. [Use service principal authentication - Microsoft Learn](https://learn.microsoft.com/en-us/power-platform/admin/create-users-assign-online-security-roles#create-an-application-user)

# ALM-008

Integrate the **Power Platform Solution Checker** into your CI/CD pipeline to automatically validate solutions for best practice violations, performance issues, and security concerns before deployment.

1. Add the Solution Checker task to your build pipeline and run it on every build or pull request.
1. Configure the pipeline to **fail on critical or high-severity issues** so that problematic solutions are not deployed.
1. Export checker reports as pipeline artifacts for audit and troubleshooting.
1. Review and resolve all warnings regularly, not just critical errors.

## Rationale

1. The Solution Checker detects common problems — such as missing plugin registration steps, non-delegable queries, and accessibility violations — that are difficult to catch during manual review.
1. Running the checker automatically on every build ensures consistent quality enforcement without relying on individuals to remember to run it.
1. Failing the build on critical issues prevents known problems from reaching Test or Production environments.
1. Archived reports provide an audit trail showing the quality state of every deployed version.

## Examples

### Good

```yaml
# Solution Checker step in Azure DevOps pipeline
- task: PowerPlatformChecker@2
  inputs:
    PowerPlatformSPN: 'ServiceConnection'
    FilesToAnalyze: '$(Build.ArtifactStagingDirectory)/ContosoHR_managed.zip'
    RuleSet: 'Solution Checker'
    ErrorLevel: 'HighIssueCount'
    ErrorThreshold: '0'    # Fail on any high-severity issue
    FailOnPowerAppsCheckerAnalysis: true
```

- Pipeline fails when a critical issue is detected, blocking deployment until the issue is fixed.
- Checker report is saved as a build artifact and reviewed by the team.

### Bad

- Solution Checker is never run — issues are discovered by users in Production.
- Checker is configured but its results are ignored — the pipeline always proceeds regardless of findings.
- Checker is only run manually by one team member before major releases, missing issues in intermediate deployments.

## More Information

1. [Power Platform Checker - Microsoft Learn](https://learn.microsoft.com/en-us/power-platform/alm/checker-api/overview)
1. [Use Solution Checker in pipelines - Microsoft Learn](https://learn.microsoft.com/en-us/power-platform/alm/devops-build-tools#solution-checker)

# ALM-009

Apply **semantic versioning** to every solution and increment the version number with each deployment to maintain a clear release history.

1. Use the format **Major.Minor.Build.Revision** (e.g., `1.0.0.0`).
1. Increment **Major** for breaking changes or large feature releases.
1. Increment **Minor** for new features that are backward-compatible.
1. Increment **Build** for bug fixes and patches.
1. Never deploy two different builds with the same version number.
1. Automate version incrementing in your CI/CD pipeline to avoid manual mistakes.

## Rationale

1. Without versioning, there is no way to determine which version of a solution is deployed in a given environment or to compare differences between deployments.
1. Semantic versioning communicates the scope and risk of a change at a glance — a major version bump signals breaking changes, while a build increment signals a safe patch.
1. Unique version numbers per deployment enable rollback: if a deployment causes issues, you can identify exactly which version to revert to.
1. Automated version incrementing eliminates the common mistake of forgetting to update the version, which can cause import failures or confusion.

## Examples

### Good

- `1.0.0.0` — Initial release.
- `1.1.0.0` — New feature added (leave approval workflow).
- `1.1.1.0` — Bug fix (corrected email notification template).
- `2.0.0.0` — Major redesign with schema changes (requires data migration).
- Version is incremented automatically by the CI/CD pipeline on each build.

### Bad

- Every deployment uses version `1.0.0.0` — no way to distinguish releases.
- Version numbers are incremented randomly with no pattern: `1.0.0.0` → `3.5.0.0` → `2.1.0.0`.
- Version is updated manually and sometimes forgotten, causing import warnings or failures in the target environment.

## More Information

1. [Solution versioning - Microsoft Learn](https://learn.microsoft.com/en-us/power-platform/alm/update-solutions-alm)
1. [Semantic Versioning specification](https://semver.org/)
