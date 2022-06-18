# Component Naming

Good practices for Power Pages component naming. i.e., Web Pages, Web Templates, Basic Forms, Advanced Forms, etc.

> **Note:** The hierarchy of Power Pages components and naming of the same is highly subjective. That is, every human will have their own views and opinions on how one thing should related to another, and the name thereafter.

# PPN-001

End-users access web pages for the portal. These web pages are organized into a hierarchy as part of the solution architecture. As such, it makes sense to name portal components (such as web pages) using a hierarchical pattern.

> **Note:** A portal component is any portal configuration table record. i.e.
>
> - Web Page
> - Web Template
> - Content Snippet

Follow the below guidance when naming portal components:

| **Convention** | **Do ✔**  | **Don't ❌** |
|--|--|--|
| Prefix vendor specific components with the vendor name/acronym. | `VendorName` | `Contoso` |
| Prefix customer specific components with the customer name/acronym. | `Contoso` | `VendorName` |
| Use forward slashes (`/`) as the delimiter of components in the hierarchy. | `VendorName/FeatureOne` | `VendorName-FeatureOne` |
| Abbreviate component names without sacrificing clarity. | `VendorName/FeatureOne` | `VendorName/TheVeryFirstFeature` |
| Do not use component type names in component names. | Web Page: `VendorName/FeatureOne`<br>Content Snippet: `VendorName/FeatureOne/Title` | Web Page: `VendorName/FeatureOneWebPage`<br>Content Snippet: `VendorName/FeatureOne/TitleSnippet` |
| Child components should inherit their parent components name. | Parent: `VendorName/FeatureOne`<br>Child: `VendorName/FeatureOne/ChildFeature` | Parent: `VendorName/FeatureOne`<br>Child: `VendorName/ChildFeature` |
| Other components types for the same feature should share names. | Web Page: `VendorName/FeatureOne`<br>Page Template: `VendorName/FeatureOne`<br>Web Template: `VendorName/FeatureOne` | Web Page: `VendorName/FeatureOne`<br>Page Template: `VendorName/FirstFeature`<br>Web Template: `VendorName/Feature1Template` |
| Using [PascalCase](https://techterms.com/definition/pascalcase) when naming hierarchy components. | `VendorName/FeatureOne` | `VendorName/featureOne` |
| Do not use spaces or dashes (`-`). | `VendorName/FeatureOne` | `VendorName-Feature One` |
| Extend the existing hierarchy instead of creating a new one. | Current: `../FeatureOne/ChildFeatureOne`<br>New feature: `../FeatureOne/ChildFeatureTwo` | Current: `../FeatureOne/ChildFeatureOne`<br>New feature: `../FeatureOneChildFeatureTwo` |

## Rationale

- Hierarchy of the portal structure is clear.
- Simple naming of source control files and folders.

## Examples

Imagine a Power Pages site with the below Web Page structure for a hypothetical funding site. The following illustration shows the main funding page and it's multiple child pages. Key to note is that this design structure should be established before development begins.

![Funding site example hierarchy](/img/ppn-001-funding-site-example-hierarchy.png)

Each of the above nodes represents a **Web Page** portal component. Based on the conventions outlined herein, the naming of each of these Web Pages would be:

| **Web Page** | **Name** | **Key conventions used** |
| -------- | ---- | -- |
| Funding | `VendorName/Funding` | Vendor prefix, slash delimiter |
| Available funding | `VendorName/Funding/Search` | Abbreviation, name inheritance |
| Programme | `VendorName/Funding/Programme` | Pascal case, no spaces/dashes |
| Calendar | `VendorName/Funding/Calendar` | Extending existing hierarchy |
| Who we funded | `VendorName/Funding/History` | Abbreviation, pascal case |

### What about other component types?

So far, this example has only demonstrated the conventions applied to **Web Page** portal components. Most portal components are in some way related to a **Web Page**, either via direct association, or through a chain of interdependent portal component records. For example, a **Web Page** has a **Page Template** which in most cases, has a linked **Web Template**.

**Web Page** > **Page Template** > **Web Template**

Per the conventions, if multiple component types exist for the same feature, then the names of these components should represent this in the hierarchical pattern outline here. This would be represent using the below naming of each of these component types.

`VendorName/Funding/Search` (**Web Page**) **>** `VendorName/Funding/Search` (**Page Template**) **>** `VendorName/Funding/Search` (**Web Template**)

In a more complex example, the **Web Template** `VendorName/Funding/Search` for the `VendorName/Funding/Search` **Web Page** may have exclusive dependencies on many other component types such that the component hierarchy would mirror the below:

![Power Pages component hierarchy](/img/ppn-001-power-pages-component-hierarchy.png)

 The naming of these components, inline with the conventions, and dependent on the solution design, would be as below.

![Funding site example solution](/img/ppn-001-funding-site-example-solution.png)

### Exemptions

- Table Permissions: For this record type, it is best to provide a descriptive name.
- Millage may vary: Name is subjective and each record type should be evaluated based on what makes sense.
