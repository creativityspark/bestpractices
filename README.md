# Power Platform Best Practices

The purpose of this repository is to gather and share best practices for Power Platform configuration and development.

You can easily clone this repository and incorporate these good practices into the documentation of your own project, adapting them to your needs.

# Why Standards and Good Practices Matter

Adopting consistent standards and good practices is essential for delivering quality Power Platform projects. Without shared guidelines, teams tend to produce inconsistent solutions that are difficult to maintain, troubleshoot, and hand over. Clear standards provide the following benefits:

- **Quality** — Well-defined rules reduce defects and ensure that solutions behave predictably across environments.
- **Maintainability** — Consistent naming, structure, and patterns make it easier for any team member to understand, modify, and extend existing components.
- **Collaboration** — When everyone follows the same conventions, peer reviews are faster, onboarding is smoother, and knowledge transfer becomes straightforward.
- **Scalability** — Standards that enforce separation of concerns, reuse, and proper ALM practices allow projects to grow without accumulating technical debt.
- **Compliance** — Documented practices help organizations meet audit and governance requirements by providing traceability and accountability.

Investing time in standards early in a project pays dividends throughout its entire lifecycle.

# Summary

Below is a quick reference of every rule contained in this repository, organized by module.

## [Canvas Apps](/Power%20Apps/Power-Apps.md)

| Rule ID                                                                                 | Description                                                                                    |
| --------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------- |
| [CA-001](/Power%20Apps/Power-Apps.md#ca-001-control-naming-conventions)                 | Control naming conventions — rename all controls using a consistent type prefix and PascalCase |
| [CA-002](/Power%20Apps/Power-Apps.md#ca-002-variable-and-collection-naming-conventions) | Variable and collection naming conventions — use camelCase with a short type prefix            |
| [CA-003](/Power%20Apps/Power-Apps.md#ca-003-delegation)                                 | Delegation — use delegable functions and be aware of delegation limits                         |
| [CA-004](/Power%20Apps/Power-Apps.md#ca-004-optimize-app-initialization)                | Optimize app initialization — keep App.OnStart lean and use Concurrent()                       |
| [CA-005](/Power%20Apps/Power-Apps.md#ca-005-error-handling)                             | Error handling — use IfError and Notify to handle errors gracefully                            |
| [CA-006](/Power%20Apps/Power-Apps.md#ca-006-responsive-design)                          | Responsive design — use containers and relative sizing for different screen sizes              |
| [CA-007](/Power%20Apps/Power-Apps.md#ca-007-media-optimization)                         | Media optimization — optimize images and media to reduce app load time                         |
| [CA-008](/Power%20Apps/Power-Apps.md#ca-008-component-reuse)                            | Component reuse — use Canvas Components for repeated UI patterns and shared logic              |
| [CA-009](/Power%20Apps/Power-Apps.md#ca-009-accessibility)                              | Accessibility — design apps to be accessible to users with assistive technologies              |
| [CA-010](/Power%20Apps/Power-Apps.md#ca-010)                                            | Never reference controls from one screen on another screen                                     |

## [Cloud Flows](/Power%20Automate/Cloud-Flows.md)

| Rule ID                                           | Description                                                                      |
| ------------------------------------------------- | -------------------------------------------------------------------------------- |
| [PA-001](/Power%20Automate/Cloud-Flows.md#pa-001) | Cloud flow names must follow a defined naming pattern                            |
| [PA-002](/Power%20Automate/Cloud-Flows.md#pa-002) | All flows must have a description summarizing their purpose and business process |
| [PA-003](/Power%20Automate/Cloud-Flows.md#pa-003) | Trigger names should be clear and descriptive                                    |
| [PA-004](/Power%20Automate/Cloud-Flows.md#pa-004) | All actions must be renamed to clear, descriptive names                          |
| [PA-005](/Power%20Automate/Cloud-Flows.md#pa-005) | Variable names must use camelCase with a short type prefix                       |
| [PA-006](/Power%20Automate/Cloud-Flows.md#pa-006) | Connection reference names must follow a defined naming pattern                  |
| [PA-007](/Power%20Automate/Cloud-Flows.md#pa-007) | Implement error handling using the Scope-based Try-Catch-Finally pattern         |
| [PA-008](/Power%20Automate/Cloud-Flows.md#pa-008) | Initialize all variables at the very beginning of the flow                       |
| [PA-009](/Power%20Automate/Cloud-Flows.md#pa-009) | Avoid hardcoded values — use Environment Variables instead                       |
| [PA-010](/Power%20Automate/Cloud-Flows.md#pa-010) | Extract reusable logic into Child Flows                                          |
| [PA-011](/Power%20Automate/Cloud-Flows.md#pa-011) | Add notes to complex actions to document expressions and business logic          |
| [PA-012](/Power%20Automate/Cloud-Flows.md#pa-012) | All cloud flows must be created inside a Solution                                |
| [PA-013](/Power%20Automate/Cloud-Flows.md#pa-013) | Configure Dataverse triggers with specific triggering fields and conditions      |
| [PA-014](/Power%20Automate/Cloud-Flows.md#pa-014) | Minimize the number of columns and rows retrieved when querying Dataverse        |

## [Power Pages](/PowerPages/Power-Pages.md)

| Rule ID                                     | Description                                                                                   |
| ------------------------------------------- | --------------------------------------------------------------------------------------------- |
| [PP-001](/PowerPages/Power-Pages.md#pp-001) | Configure table permissions for every exposed Dataverse table with the most restrictive scope |
| [PP-002](/PowerPages/Power-Pages.md#pp-002) | Define granular web roles mapped to distinct user personas                                    |
| [PP-003](/PowerPages/Power-Pages.md#pp-003) | Keep Liquid templates focused on presentation logic only                                      |
| [PP-004](/PowerPages/Power-Pages.md#pp-004) | Enable header and footer output caching for performance                                       |
| [PP-005](/PowerPages/Power-Pages.md#pp-005) | Configure forms with proper validation and table permissions                                  |
| [PP-006](/PowerPages/Power-Pages.md#pp-006) | Minimize custom JavaScript and follow secure coding practices                                 |
| [PP-007](/PowerPages/Power-Pages.md#pp-007) | Manage configuration as code using the Power Platform CLI and source control                  |
| [PP-008](/PowerPages/Power-Pages.md#pp-008) | Restrict anonymous access to the minimum required set of pages and data                       |
| [PP-009](/PowerPages/Power-Pages.md#pp-009) | Use content snippets for reusable text, labels, and messages                                  |

## [Power Pages — Component Naming](/PowerPages/Component-Naming.md)

| Rule ID                                            | Description                                                                                      |
| -------------------------------------------------- | ------------------------------------------------------------------------------------------------ |
| [PPN-001](/PowerPages/Component-Naming.md#ppn-001) | Name portal components using a hierarchical pattern with a vendor/customer prefix and PascalCase |

## [Model Driven Apps](/Model%20Driven%20Apps/Model-Driven-Apps.md)

| Rule ID                                                        | Description                                                                         |
| -------------------------------------------------------------- | ----------------------------------------------------------------------------------- |
| [MDA-001](/Model%20Driven%20Apps/Model-Driven-Apps.md#mda-001) | Create separate apps for each distinct user role or business function               |
| [MDA-002](/Model%20Driven%20Apps/Model-Driven-Apps.md#mda-002) | Design sitemap navigation with logical grouping and clear labels                    |
| [MDA-003](/Model%20Driven%20Apps/Model-Driven-Apps.md#mda-003) | Design system views to be focused, performant, and aligned with user needs          |
| [MDA-004](/Model%20Driven%20Apps/Model-Driven-Apps.md#mda-004) | Design dashboards to surface actionable insights, not just raw data                 |
| [MDA-005](/Model%20Driven%20Apps/Model-Driven-Apps.md#mda-005) | Follow client scripting best practices for JavaScript in Model Driven Apps          |
| [MDA-006](/Model%20Driven%20Apps/Model-Driven-Apps.md#mda-006) | Create custom security roles following the principle of least privilege             |
| [MDA-007](/Model%20Driven%20Apps/Model-Driven-Apps.md#mda-007) | Package all customizations in managed solutions with a structured solution strategy |
| [MDA-008](/Model%20Driven%20Apps/Model-Driven-Apps.md#mda-008) | Every app must have a description explaining its purpose and target audience        |

## [Copilot Studio](/Copilot%20Studio/copilot-studio.md)

| Rule ID                                              | Description                                                                        |
| ---------------------------------------------------- | ---------------------------------------------------------------------------------- |
| [CS-001](/Copilot%20Studio/copilot-studio.md#cs-001) | All topics must use a consistent naming convention indicating category and purpose |
| [CS-002](/Copilot%20Studio/copilot-studio.md#cs-002) | Design specific, varied, and non-overlapping trigger phrases across topics         |
| [CS-003](/Copilot%20Studio/copilot-studio.md#cs-003) | Customize fallback and error system topics for a helpful user experience           |
| [CS-004](/Copilot%20Studio/copilot-studio.md#cs-004) | Configure knowledge sources carefully and apply guardrails for generative answers  |
| [CS-005](/Copilot%20Studio/copilot-studio.md#cs-005) | Enable end-user authentication and follow security best practices                  |
| [CS-006](/Copilot%20Studio/copilot-studio.md#cs-006) | Use solution-based development and environment separation for ALM                  |
| [CS-007](/Copilot%20Studio/copilot-studio.md#cs-007) | Establish a thorough testing strategy and use built-in analytics                   |
| [CS-008](/Copilot%20Studio/copilot-studio.md#cs-008) | Plan deployment channels and design conversations to match each channel            |
| [CS-009](/Copilot%20Studio/copilot-studio.md#cs-009) | Apply responsible AI principles and configure content moderation                   |

## [Dataverse — Tables](/Dataverse/Tables.md)

| Rule ID                                 | Description                                                                        |
| --------------------------------------- | ---------------------------------------------------------------------------------- |
| [TAB-001](/Dataverse/Tables.md#tab-001) | Use Snake Case in schema names and avoid abbreviations                             |
| [TAB-002](/Dataverse/Tables.md#tab-002) | Avoid creating custom tables to replace existing system tables                     |
| [TAB-003](/Dataverse/Tables.md#tab-003) | Every table must have an SVG icon configured as a web resource                     |
| [TAB-004](/Dataverse/Tables.md#tab-004) | Choose the appropriate ownership type based on security requirements               |
| [TAB-005](/Dataverse/Tables.md#tab-005) | Enable auditing only where required by business or compliance needs                |
| [TAB-006](/Dataverse/Tables.md#tab-006) | Define alternate keys for tables that participate in data integration or migration |
| [TAB-007](/Dataverse/Tables.md#tab-007) | Configure relationship cascade behaviors deliberately                              |
| [TAB-008](/Dataverse/Tables.md#tab-008) | Every table must have a description explaining its purpose                         |

## [Dataverse — Forms](/Dataverse/Forms.md)

| Rule ID                                | Description                                                                   |
| -------------------------------------- | ----------------------------------------------------------------------------- |
| [FRM-001](/Dataverse/Forms.md#frm-001) | Every main form must have a hidden Admin tab containing all system attributes |
| [FRM-002](/Dataverse/Forms.md#frm-002) | Organize form content using tabs and sections with clear names                |
| [FRM-003](/Dataverse/Forms.md#frm-003) | Optimize form load performance by minimizing controls and scripts             |
| [FRM-004](/Dataverse/Forms.md#frm-004) | Set business rule scope appropriately and avoid duplicating logic             |
| [FRM-005](/Dataverse/Forms.md#frm-005) | Use Quick View Forms to display related record information                    |
| [FRM-006](/Dataverse/Forms.md#frm-006) | Every form must have a description explaining its purpose and audience        |

## [Dataverse — Fields](/Dataverse/Fields.md)

| Rule ID                                 | Description                                                                    |
| --------------------------------------- | ------------------------------------------------------------------------------ |
| [FLD-001](/Dataverse/Fields.md#fld-001) | Use Snake Case, avoid abbreviations, use _id suffix for lookups                |
| [FLD-002](/Dataverse/Fields.md#fld-002) | Every field must include a description shown as a tooltip                      |
| [FLD-003](/Dataverse/Fields.md#fld-003) | Choose the most specific and appropriate data type for each field              |
| [FLD-004](/Dataverse/Fields.md#fld-004) | Use Global Choices for shared values and Local Choices for single-table values |
| [FLD-005](/Dataverse/Fields.md#fld-005) | Set the field requirement level based on business needs                        |
| [FLD-006](/Dataverse/Fields.md#fld-006) | Enable Column-Level Security for sensitive or confidential data                |

## [Dataverse — Classic Workflows](/Dataverse/Classic-Workflows.md)

| Rule ID                                          | Description                                                                          |
| ------------------------------------------------ | ------------------------------------------------------------------------------------ |
| [WF-001](/Dataverse/Classic-Workflows.md#wf-001) | Workflow and Action names must follow a defined naming pattern                       |
| [WF-002](/Dataverse/Classic-Workflows.md#wf-002) | All workflows must have a description summarizing purpose, trigger, and dependencies |
| [WF-003](/Dataverse/Classic-Workflows.md#wf-003) | Set the workflow scope to the narrowest necessary level                              |
| [WF-004](/Dataverse/Classic-Workflows.md#wf-004) | Assign workflow ownership to a dedicated service account                             |
| [WF-005](/Dataverse/Classic-Workflows.md#wf-005) | Prefer asynchronous workflows unless immediate validation is required                |
| [WF-006](/Dataverse/Classic-Workflows.md#wf-006) | Use child workflows to encapsulate reusable logic                                    |
| [WF-007](/Dataverse/Classic-Workflows.md#wf-007) | Implement error handling and early termination in workflows                          |

## [Dataverse — Fetch XML](/Dataverse/Fetch-Xml.md)

| Rule ID                                    | Description                                                               |
| ------------------------------------------ | ------------------------------------------------------------------------- |
| [FXL-001](/Dataverse/Fetch-Xml.md#fxl-001) | Always specify columns explicitly; never use all-attributes in production |
| [FXL-002](/Dataverse/Fetch-Xml.md#fxl-002) | Use filters and conditions to reduce results on the server                |
| [FXL-003](/Dataverse/Fetch-Xml.md#fxl-003) | Use paging for large data sets; never fetch all records at once           |
| [FXL-004](/Dataverse/Fetch-Xml.md#fxl-004) | Keep link-entity joins to a minimum                                       |
| [FXL-005](/Dataverse/Fetch-Xml.md#fxl-005) | Choose the appropriate link-type (inner vs. outer) based on data needs    |
| [FXL-006](/Dataverse/Fetch-Xml.md#fxl-006) | Use the no-lock attribute for read-only or reporting queries              |
| [FXL-007](/Dataverse/Fetch-Xml.md#fxl-007) | Prefer eq and in operators over like; limit wildcard usage                |
| [FXL-008](/Dataverse/Fetch-Xml.md#fxl-008) | Use the top attribute when only a limited number of records is needed     |
| [FXL-009](/Dataverse/Fetch-Xml.md#fxl-009) | Use aggregate and grouping queries carefully                              |
| [FXL-010](/Dataverse/Fetch-Xml.md#fxl-010) | Build FetchXML queries programmatically; avoid string concatenation       |

## [Dataverse — Security Roles](/Dataverse/Security.md)

| Rule ID                                   | Description                                                                       |
| ----------------------------------------- | --------------------------------------------------------------------------------- |
| [SEC-001](/Dataverse/Security.md#sec-001) | Never modify out-of-the-box security roles; create custom roles instead           |
| [SEC-002](/Dataverse/Security.md#sec-002) | Apply the Principle of Least Privilege when assigning permissions                 |
| [SEC-003](/Dataverse/Security.md#sec-003) | Assign security roles to teams instead of individual users                        |
| [SEC-004](/Dataverse/Security.md#sec-004) | Separate security roles by functional purpose: application access vs. data access |
| [SEC-005](/Dataverse/Security.md#sec-005) | Set the appropriate access level for each privilege deliberately                  |
| [SEC-006](/Dataverse/Security.md#sec-006) | Review and audit security role assignments on a regular schedule                  |
| [SEC-007](/Dataverse/Security.md#sec-007) | Test security roles in a non-production environment before deploying              |

## [Dataverse — Plugins](/Dataverse/Plugins.md)

| Rule ID                                  | Description                                                               |
| ---------------------------------------- | ------------------------------------------------------------------------- |
| [PLG-001](/Dataverse/Plugins.md#plg-001) | Plugin class names must use a namespace-based naming convention           |
| [PLG-002](/Dataverse/Plugins.md#plg-002) | Always throw InvalidPluginExecutionException for business rule violations |
| [PLG-003](/Dataverse/Plugins.md#plg-003) | Always use ITracingService to log diagnostic information                  |
| [PLG-004](/Dataverse/Plugins.md#plg-004) | Plugins must be stateless; do not use instance variables or static fields |
| [PLG-005](/Dataverse/Plugins.md#plg-005) | Design plugins to be idempotent                                           |
| [PLG-006](/Dataverse/Plugins.md#plg-006) | Never use new ColumnSet(true); specify only the columns you need          |
| [PLG-007](/Dataverse/Plugins.md#plg-007) | Use pre-images and post-images instead of additional Retrieve calls       |
| [PLG-008](/Dataverse/Plugins.md#plg-008) | Register plugins in the correct pipeline stage                            |
| [PLG-009](/Dataverse/Plugins.md#plg-009) | Do not use ExecuteMultipleRequest inside plugin code                      |
| [PLG-010](/Dataverse/Plugins.md#plg-010) | Register plugins only for the specific messages and tables required       |
| [PLG-011](/Dataverse/Plugins.md#plg-011) | Do not use multithreading or async parallelism inside plugin code         |
| [PLG-012](/Dataverse/Plugins.md#plg-012) | Keep synchronous plugins lightweight; offload long-running work           |

## [Dataverse — JavaScript Client Scripts](/Dataverse/Javascript.md)

| Rule ID                                   | Description                                                                      |
| ----------------------------------------- | -------------------------------------------------------------------------------- |
| [JS-001](/Dataverse/Javascript.md#js-001) | Use the formContext object instead of the deprecated Xrm.Page                    |
| [JS-002](/Dataverse/Javascript.md#js-002) | Organize code using namespaces to avoid polluting the global scope               |
| [JS-003](/Dataverse/Javascript.md#js-003) | Use only supported Client API methods; never manipulate the DOM directly         |
| [JS-004](/Dataverse/Javascript.md#js-004) | Always use asynchronous API calls; never use synchronous requests                |
| [JS-005](/Dataverse/Javascript.md#js-005) | Retrieve only needed columns when using Xrm.WebApi                               |
| [JS-006](/Dataverse/Javascript.md#js-006) | Implement proper error handling in all asynchronous operations                   |
| [JS-007](/Dataverse/Javascript.md#js-007) | Prefer out-of-the-box features over client scripts when possible                 |
| [JS-008](/Dataverse/Javascript.md#js-008) | Follow consistent naming conventions for web resource files                      |
| [JS-009](/Dataverse/Javascript.md#js-009) | Register scripts only on forms and events where needed                           |
| [JS-010](/Dataverse/Javascript.md#js-010) | Avoid hardcoding entity names, field names, GUIDs, or option set values          |
| [JS-011](/Dataverse/Javascript.md#js-011) | Use setNotification/clearNotification for inline validation                      |
| [JS-012](/Dataverse/Javascript.md#js-012) | Check the form type before executing mode-specific logic                         |
| [JS-013](/Dataverse/Javascript.md#js-013) | Document all functions using JSDoc syntax                                        |
| [JS-014](/Dataverse/Javascript.md#js-014) | Write client scripts in TypeScript when possible                                 |
| [JS-015](/Dataverse/Javascript.md#js-015) | Remove all console.log, console.debug, and debugger statements before deployment |

## [Dataverse — Web Resources](/Dataverse/Web-Resources.md)

| Rule ID                                      | Description                                                          |
| -------------------------------------------- | -------------------------------------------------------------------- |
| [WR-001](/Dataverse/Web-Resources.md#wr-001) | Use a consistent naming convention with virtual folder structures    |
| [WR-002](/Dataverse/Web-Resources.md#wr-002) | Every web resource must have a display name and description          |
| [WR-003](/Dataverse/Web-Resources.md#wr-003) | Sanitize all user input to prevent XSS in HTML web resources         |
| [WR-004](/Dataverse/Web-Resources.md#wr-004) | Optimize all image web resources and use SVG format when possible    |
| [WR-005](/Dataverse/Web-Resources.md#wr-005) | Prefix all CSS class and ID names with the project/publisher prefix  |
| [WR-006](/Dataverse/Web-Resources.md#wr-006) | Keep HTML web resources lightweight, responsive, and well-structured |
| [WR-007](/Dataverse/Web-Resources.md#wr-007) | Declare dependencies between web resources explicitly                |
| [WR-008](/Dataverse/Web-Resources.md#wr-008) | Periodically audit and remove unused web resources                   |
| [WR-009](/Dataverse/Web-Resources.md#wr-009) | Use RESX web resources for multi-language support                    |

## [PCF Controls](/PCF/pcf.md)

| Rule ID                        | Description                                                                              |
| ------------------------------ | ---------------------------------------------------------------------------------------- |
| [PCF-001](/PCF/pcf.md#pcf-001) | Always deploy production builds; never deploy development builds to non-dev environments |
| [PCF-002](/PCF/pcf.md#pcf-002) | Clean up resources inside the destroy method to prevent memory leaks                     |
| [PCF-003](/PCF/pcf.md#pcf-003) | Minimize calls to notifyOutputChanged; debounce or trigger on completion                 |
| [PCF-004](/PCF/pcf.md#pcf-004) | Handle null or undefined property values in updateView                                   |
| [PCF-005](/PCF/pcf.md#pcf-005) | Scope CSS rules to your component's container; never use global selectors                |
| [PCF-006](/PCF/pcf.md#pcf-006) | Avoid using innerHTML for dynamic content; use DOM APIs or React                         |
| [PCF-007](/PCF/pcf.md#pcf-007) | Use path-based imports from Fluent UI React to reduce bundle size                        |
| [PCF-008](/PCF/pcf.md#pcf-008) | Use the init method to request network resources                                         |
| [PCF-009](/PCF/pcf.md#pcf-009) | Check API availability before using platform-specific APIs                               |
| [PCF-010](/PCF/pcf.md#pcf-010) | Do not use window.localStorage or window.sessionStorage                                  |
| [PCF-011](/PCF/pcf.md#pcf-011) | Bundle all required modules; do not rely on external script tags                         |
| [PCF-012](/PCF/pcf.md#pcf-012) | Ensure code components are accessible with keyboard navigation and ARIA                  |
| [PCF-013](/PCF/pcf.md#pcf-013) | Make PCF controls easy to debug using the local test harness                             |
| [PCF-014](/PCF/pcf.md#pcf-014) | Always provide unit tests to protect against regressions                                 |

## [Application Lifecycle Management](/ALM/ALM.md)

| Rule ID                        | Description                                                                         |
| ------------------------------ | ----------------------------------------------------------------------------------- |
| [ALM-001](/ALM/ALM.md#alm-001) | Establish a minimum of three environments: Development, Test, and Production        |
| [ALM-002](/ALM/ALM.md#alm-002) | Always deploy managed solutions to non-dev environments                             |
| [ALM-003](/ALM/ALM.md#alm-003) | Create a dedicated solution publisher with a short, unique prefix                   |
| [ALM-004](/ALM/ALM.md#alm-004) | Use environment variables for configuration values that differ between environments |
| [ALM-005](/ALM/ALM.md#alm-005) | Use connection references instead of embedding connections directly                 |
| [ALM-006](/ALM/ALM.md#alm-006) | Store all solution artifacts in source control for version history and automation   |
| [ALM-007](/ALM/ALM.md#alm-007) | Automate solution export, packing, validation, and import using CI/CD pipelines     |
| [ALM-008](/ALM/ALM.md#alm-008) | Integrate the Power Platform Solution Checker into CI/CD                            |
| [ALM-009](/ALM/ALM.md#alm-009) | Apply semantic versioning and increment the version with each deployment            |

# Structure

- The pages are categorized by technology within the Power Platform.
- Every good practice must include a unique ID and the rationale behind it.
- Each rule must include examples where applicable.
- Optionally, links to additional information and references may be provided.

The inclusion of a unique ID makes referencing and linking easier. You can use the rule ID when performing peer reviews or pull requests.

# How to Clone and Use in Azure DevOps

You can import this repository into Azure DevOps and use it as a living reference for your project team.

1. **Copy the repository URL.** On GitHub, click the **Code** button and copy the HTTPS clone URL:
   ```
   https://github.com/creativityspark/bestpractices.git
   ```

2. **Import into Azure DevOps.** In your Azure DevOps project, go to **Repos** → **Files** → **Import a repository**. Paste the GitHub URL and click **Import**. Azure DevOps will create a full copy of the repository.

3. **Clone locally.** Once imported, clone the Azure DevOps repository to your local machine:
   ```bash
   git clone https://dev.azure.com/<org>/<project>/_git/bestpractices
   ```

4. **Adapt to your project.** Review the rules and modify, remove, or add practices to match your project's specific needs. Update the summary tables in this README accordingly.

5. **Integrate with your workflow.** Link rule IDs in pull request comments and code review checklists. You can also add the repository as a wiki in Azure DevOps by going to **Overview** → **Wiki** → **Publish code as wiki** and selecting the repository.

# Contribution

Contribution is encouraged through pull requests and issues. Pull requests will be accepted as long as the submitted content adheres to the structure described in this document: every rule must include a unique ID, a rationale, and examples where applicable. Additionally, contributors must update the summary tables in this README to reflect any new, modified, or removed rules.

# License

This repository and its contents are shared under the terms of the [MIT license](/LICENSE).
