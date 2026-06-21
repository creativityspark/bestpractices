# Component Naming

Good practices for Power Pages component naming. i.e., Web Pages, Web Templates, Basic Forms, Advanced Forms, etc.

## PPN-001

### Title

End-users access web pages for the portal

### Description

End-users access web pages for the portal. These web pages are organized into a hierarchy as part of the solution architecture. As such, it makes sense to name portal components (such as web pages) using a hierarchical pattern. > Note: A portal component is any portal configuration table record. i.e. > > - Web Page > - Web Template > - Content Snippet Follow the below guidance when naming portal components: | Convention | Do ✔  | Don't ❌ | |--|--|--| | Prefix vendor specific components with the vendor name/acronym. | VendorName | Contoso | | Prefix customer specific components with the customer name/acronym. | Contoso | VendorName | | Use forward slashes (/) as the delimiter of components in the hierarchy. | VendorName/FeatureOne | VendorName-FeatureOne | | Abbreviate component names without sacrificing clarity. | VendorName/FeatureOne | VendorName/TheVeryFirstFeature | | Do not use component type names in component names. | Web Page: VendorName/FeatureOne<br>Content Snippet: VendorName/FeatureOne/Title | Web Page: VendorName/FeatureOneWebPage<br>Content Snippet: VendorName/FeatureOne/TitleSnippet | | Child components should inherit their parent components name. | Parent: VendorName/FeatureOne<br>Child: VendorName/FeatureOne/ChildFeature | Parent: VendorName/FeatureOne<br>Child: VendorName/ChildFeature | | Other components types for the same feature should share names. | Web Page: VendorName/FeatureOne<br>Page Template: VendorName/FeatureOne<br>Web Template: VendorName/FeatureOne | Web Page: VendorName/FeatureOne<br>Page Template: VendorName/FirstFeature<br>Web Template: VendorName/Feature1Template | | Using PascalCase when naming hierarchy components. | VendorName/FeatureOne | VendorName/featureOne | | Do not use spaces or dashes (-). | VendorName/FeatureOne | VendorName-Feature One | | Extend the existing hierarchy instead of creating a new one. | Current: ../FeatureOne/ChildFeatureOne<br>New feature: ../FeatureOne/ChildFeatureTwo | Current: ../FeatureOne/ChildFeatureOne<br>New feature: ../FeatureOneChildFeatureTwo |

### Guidelines

1. End-users access web pages for the portal. These web pages are organized into a hierarchy as part of the solution architecture. As such, it makes sense to name portal components (such as web pages) using a hierarchical pattern. > Note: A portal component is any portal configuration table record. i.e. > > - Web Page > - Web Template > - Content Snippet Follow the below guidance when naming portal components: | Convention | Do ✔  | Don't ❌ | |--|--|--| | Prefix vendor specific components with the vendor name/acronym. | VendorName | Contoso | | Prefix customer specific components with the customer name/acronym. | Contoso | VendorName | | Use forward slashes (/) as the delimiter of components in the hierarchy. | VendorName/FeatureOne | VendorName-FeatureOne | | Abbreviate component names without sacrificing clarity. | VendorName/FeatureOne | VendorName/TheVeryFirstFeature | | Do not use component type names in component names. | Web Page: VendorName/FeatureOne<br>Content Snippet: VendorName/FeatureOne/Title | Web Page: VendorName/FeatureOneWebPage<br>Content Snippet: VendorName/FeatureOne/TitleSnippet | | Child components should inherit their parent components name. | Parent: VendorName/FeatureOne<br>Child: VendorName/FeatureOne/ChildFeature | Parent: VendorName/FeatureOne<br>Child: VendorName/ChildFeature | | Other components types for the same feature should share names. | Web Page: VendorName/FeatureOne<br>Page Template: VendorName/FeatureOne<br>Web Template: VendorName/FeatureOne | Web Page: VendorName/FeatureOne<br>Page Template: VendorName/FirstFeature<br>Web Template: VendorName/Feature1Template | | Using PascalCase when naming hierarchy components. | VendorName/FeatureOne | VendorName/featureOne | | Do not use spaces or dashes (-). | VendorName/FeatureOne | VendorName-Feature One | | Extend the existing hierarchy instead of creating a new one. | Current: ../FeatureOne/ChildFeatureOne<br>New feature: ../FeatureOne/ChildFeatureTwo | Current: ../FeatureOne/ChildFeatureOne<br>New feature: ../FeatureOneChildFeatureTwo |

### Rationale

1. Hierarchy of the portal structure is clear.
1. Simple naming of source control files and folders.



### Examples

#### Good

- Table Permissions: For this record type, it is best to provide a descriptive name.
- Millage may vary: Name is subjective and each record type should be evaluated based on what makes sense.

#### Bad

- Violates the rule requirements.

### More Information

1. [Microsoft Learn - Power Platform Documentation](https://learn.microsoft.com/en-us/power-platform/)


