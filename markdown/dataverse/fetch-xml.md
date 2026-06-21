# Fetch XML

Good practices for Dataverse Fetch XML queries.

## FXL-001

### Title

Always specify the columns you need explicitly using <attribute /> elements

### Description

Always specify the columns you need explicitly using <attribute /> elements. Never use <all-attributes /> in production queries.

### Guidelines

1. Always specify the columns you need explicitly using <attribute /> elements. Never use <all-attributes /> in production queries.

### Rationale

1. Retrieving all columns transfers unnecessary data, increasing memory usage, network overhead, and response time.
1. Selecting only the required columns allows the platform to optimize data retrieval and reduces the load on the Dataverse SQL backend.
1. Queries with fewer columns are easier to read and maintain.



### Examples

#### Good

Good example code snippet.
```xml
<fetch>
  <entity name="account">
    <attribute name="name" />
    <attribute name="accountnumber" />
    <attribute name="emailaddress1" />
  </entity>
</fetch>
```

#### Bad

Bad example code snippet.
```xml
<fetch>
  <entity name="account">
    <all-attributes />
  </entity>
</fetch>
```

### More Information

1. [Use FetchXML to construct a query - Microsoft Learn](https://learn.microsoft.com/en-us/power-apps/developer/data-platform/use-fetchxml-construct-query)
1. [Query data using FetchXml - Microsoft Learn](https://learn.microsoft.com/en-us/power-apps/developer/data-platform/fetchxml/overview)

## FXL-002

### Title

Use <filter> and <condition> elements to reduce the result set on the server

### Description

Use <filter> and <condition> elements to reduce the result set on the server. Never retrieve a large data set and filter it client-side.

### Guidelines

1. Apply conditions that narrow the result set as early as possible.
1. Filter on indexed columns (primary keys, lookup columns, statecode, createdon, modifiedon) whenever possible.
1. Place filters inside <link-entity> elements to reduce the joined data before it reaches the parent entity.

### Rationale

1. Server-side filtering lets the database engine use indexes and query plans to return data efficiently.
1. Client-side filtering wastes bandwidth and memory by downloading rows that will be discarded.
1. Filtering on non-indexed columns forces full table scans, which degrade performance significantly on large tables.



### Examples

#### Good

Good example code snippet.
```xml
<fetch>
  <entity name="contact">
    <attribute name="firstname" />
    <attribute name="lastname" />
    <filter type="and">
      <condition attribute="statecode" operator="eq" value="0" />
      <condition attribute="createdon" operator="last-x-days" value="30" />
    </filter>
  </entity>
</fetch>
```

#### Bad

Bad example code snippet.
```xml
<fetch>
  <entity name="contact">
    <all-attributes />
  </entity>
</fetch>
```
Bad example code snippet.
```csharp
// Anti-pattern: filtering thousands of records in memory
var recentContacts = allContacts.Where(c => c.CreatedOn > DateTime.Now.AddDays(-30));
```

### More Information

1. [Optimize performance using FetchXml - Microsoft Learn](https://learn.microsoft.com/en-us/power-apps/developer/data-platform/fetchxml/optimize-performance)
1. [Filter rows using FetchXml - Microsoft Learn](https://learn.microsoft.com/en-us/power-apps/developer/data-platform/fetchxml/filter-rows)

## FXL-003

### Title

Use paging to retrieve large data sets in manageable chunks

### Description

Use paging to retrieve large data sets in manageable chunks. Never attempt to fetch all records in a single request.

### Guidelines

1. Set the count attribute on the <fetch> element to define the page size.
1. Use the page attribute and the paging cookie returned by the platform to navigate through pages.
1. A page size between 50 and 5000 is recommended depending on the scenario. Smaller page sizes are more appropriate for interactive experiences.

### Rationale

1. Dataverse limits the number of records returned in a single request (default 5000). Queries that exceed this limit require paging to retrieve all results.
1. Fetching too many records in a single request can cause timeouts, throttling, or excessive memory usage.
1. Paging cookies improve performance on subsequent page retrievals by allowing the server to resume where it left off.



### Examples

#### Good

Good example code snippet.
```xml
<fetch page="1" count="500">
  <entity name="account">
    <attribute name="name" />
    <filter>
      <condition attribute="statecode" operator="eq" value="0" />
    </filter>
  </entity>
</fetch>
```
Good example code snippet.
```xml
<fetch page="2" count="500" paging-cookie="&lt;cookie page=&quot;1&quot;&gt;...&lt;/cookie&gt;">
  <entity name="account">
    <attribute name="name" />
    <filter>
      <condition attribute="statecode" operator="eq" value="0" />
    </filter>
  </entity>
</fetch>
```

#### Bad

Bad example code snippet.
```xml
<fetch>
  <entity name="account">
    <attribute name="name" />
  </entity>
</fetch>
```

### More Information

1. [Page results using FetchXml - Microsoft Learn](https://learn.microsoft.com/en-us/power-apps/developer/data-platform/fetchxml/page-results)

## FXL-004

### Title

Keep <link-entity> joins to a minimum

### Description

Keep <link-entity> joins to a minimum. Only join tables that are necessary for the query results.

### Guidelines

1. Avoid deeply nested <link-entity> chains (more than two levels deep).
1. If you only need to filter by a related table but do not need its columns, consider using a <link-entity> with no <attribute> elements.
1. If you need data from many related tables, consider breaking the query into multiple simpler queries instead of one complex query.

### Rationale

1. Each <link-entity> adds a SQL JOIN to the generated query, increasing complexity and execution time.
1. Deeply nested joins can cause exponential growth in the intermediate result set, leading to timeouts.
1. Simpler queries are easier to debug, maintain, and optimize.



### Examples

#### Good

Good example code snippet.
```xml
<fetch>
  <entity name="contact">
    <attribute name="firstname" />
    <attribute name="lastname" />
    <link-entity name="account" from="accountid" to="parentcustomerid" link-type="inner">
      <attribute name="name" />
      <filter>
        <condition attribute="statecode" operator="eq" value="0" />
      </filter>
    </link-entity>
  </entity>
</fetch>
```

#### Bad

Bad example code snippet.
```xml
<fetch>
  <entity name="contact">
    <all-attributes />
    <link-entity name="account" from="accountid" to="parentcustomerid">
      <all-attributes />
      <link-entity name="opportunity" from="parentaccountid" to="accountid">
        <all-attributes />
        <link-entity name="product" from="productid" to="productid">
          <all-attributes />
          <link-entity name="pricelevel" from="pricelevelid" to="pricelevelid">
            <all-attributes />
          </link-entity>
        </link-entity>
      </link-entity>
    </link-entity>
  </entity>
</fetch>
```

### More Information

1. [Join tables using FetchXml - Microsoft Learn](https://learn.microsoft.com/en-us/power-apps/developer/data-platform/fetchxml/join-tables)

## FXL-005

### Title

Choose the appropriate link-type for <link-entity> based on the data you need

### Description

Choose the appropriate link-type for <link-entity> based on the data you need.

### Guidelines

1. Use inner (the default) when you only want records that have a matching related record.
1. Use outer when you need all records from the parent entity, including those without a match in the related entity.
1. When using outer joins with aggregate queries, be aware that unmatched rows produce NULL values that affect counts and other aggregations.

### Rationale

1. Using inner when outer is needed silently drops records that do not have a related record, leading to incomplete results.
1. Using outer when inner is appropriate returns unnecessary rows with null values, increasing the result set size and potentially causing confusion.
1. Mismatched join types are a common source of bugs in FetchXML queries that are difficult to diagnose.



### Examples

#### Good

Good example code snippet.
```xml
<fetch>
  <entity name="account">
    <attribute name="name" />
    <link-entity name="contact" from="parentcustomerid" to="accountid" link-type="outer" alias="c">
      <attribute name="fullname" />
    </link-entity>
  </entity>
</fetch>
```
Good example code snippet.
```xml
<fetch>
  <entity name="account">
    <attribute name="name" />
    <link-entity name="contact" from="parentcustomerid" to="accountid" link-type="inner">
      <attribute name="fullname" />
    </link-entity>
  </entity>
</fetch>
```

#### Bad

Bad example code snippet.
```xml
<!-- This silently excludes accounts with no contacts -->
<fetch>
  <entity name="account">
    <attribute name="name" />
    <link-entity name="contact" from="parentcustomerid" to="accountid" link-type="inner">
      <attribute name="fullname" />
    </link-entity>
  </entity>
</fetch>
```

### More Information

1. [Join tables using FetchXml - Microsoft Learn](https://learn.microsoft.com/en-us/power-apps/developer/data-platform/fetchxml/join-tables)

## FXL-006

### Title

Use the no-lock attribute for read-only or reporting queries where real-time data accur...

### Description

Use the no-lock attribute for read-only or reporting queries where real-time data accuracy is not critical.

### Guidelines

1. Add no-lock="true" to the <fetch> element for queries used in dashboards, reports, or batch reads.
1. Do not use no-lock for queries that feed into write operations or where data consistency is required.

### Rationale

1. The no-lock attribute tells Dataverse to read data without acquiring shared locks, reducing lock contention and improving query performance.
1. Without no-lock, read queries can be blocked by concurrent write operations, increasing response times.
1. The trade-off is that no-lock queries may return uncommitted data (dirty reads), which is acceptable for reporting scenarios but not for transactional logic.



### Examples

#### Good

Good example code snippet.
```xml
<fetch no-lock="true">
  <entity name="opportunity">
    <attribute name="name" />
    <attribute name="estimatedvalue" />
    <filter>
      <condition attribute="statecode" operator="eq" value="0" />
    </filter>
  </entity>
</fetch>
```

#### Bad

Bad example code snippet.
```xml
<!-- Dangerous: reading uncommitted data before updating records -->
<fetch no-lock="true">
  <entity name="salesorder">
    <attribute name="totalamount" />
    <filter>
      <condition attribute="statecode" operator="eq" value="0" />
    </filter>
  </entity>
</fetch>
```

### More Information

1. [FetchXml reference - Microsoft Learn](https://learn.microsoft.com/en-us/power-apps/developer/data-platform/fetchxml/reference/)
1. [Optimize performance using FetchXml - Microsoft Learn](https://learn.microsoft.com/en-us/power-apps/developer/data-platform/fetchxml/optimize-performance)

## FXL-007

### Title

Prefer the eq and in operators over like for filter conditions

### Description

Prefer the eq and in operators over like for filter conditions. Use wildcard operators only when pattern matching is genuinely required.

### Guidelines

1. Use eq for exact value matches.
1. Use in when checking against a known set of values instead of chaining multiple or conditions.
1. Reserve like with wildcards (%) for legitimate search scenarios such as user-driven search fields.

### Rationale

1. The eq and in operators allow the database to use indexes efficiently, resulting in fast lookups.
1. The like operator with leading wildcards (e.g., %value) prevents index usage and forces a full table scan.
1. Replacing multiple or conditions with a single in condition produces a cleaner query and can improve performance.



### Examples

#### Good

Good example code snippet.
```xml
<filter type="and">
  <condition attribute="statecode" operator="eq" value="0" />
  <condition attribute="accountnumber" operator="in">
    <value>ACC-001</value>
    <value>ACC-002</value>
    <value>ACC-003</value>
  </condition>
</filter>
```

#### Bad

Bad example code snippet.
```xml
<filter type="and">
  <condition attribute="name" operator="like" value="%Contoso%" />
</filter>
```
Bad example code snippet.
```xml
<filter type="and">
  <condition attribute="name" operator="begins-with" value="Contoso" />
</filter>
```
Bad example code snippet.
```xml
<!-- Verbose and harder to maintain -->
<filter type="or">
  <condition attribute="accountnumber" operator="eq" value="ACC-001" />
  <condition attribute="accountnumber" operator="eq" value="ACC-002" />
  <condition attribute="accountnumber" operator="eq" value="ACC-003" />
</filter>
```

### More Information

1. [Filter rows using FetchXml - Microsoft Learn](https://learn.microsoft.com/en-us/power-apps/developer/data-platform/fetchxml/filter-rows)

## FXL-008

### Title

Use the top attribute on the <fetch> element when you only need a limited number of rec...

### Description

Use the top attribute on the <fetch> element when you only need a limited number of records.

### Guidelines

1. Set top when retrieving a fixed number of records (e.g., the most recent 10 orders).
1. Do not combine top with the page and count paging attributes - use one approach or the other.

### Rationale

1. The top attribute tells the server to stop processing as soon as the specified number of records is found, reducing execution time and resource usage.
1. Without top, the server may process the entire result set even if only a few records are needed.
1. Combining top with paging attributes leads to unpredictable behavior and is not supported.



### Examples

#### Good

Good example code snippet.
```xml
<fetch top="10">
  <entity name="salesorder">
    <attribute name="name" />
    <attribute name="totalamount" />
    <order attribute="createdon" descending="true" />
  </entity>
</fetch>
```

#### Bad

Bad example code snippet.
```xml
<fetch>
  <entity name="salesorder">
    <attribute name="name" />
    <attribute name="totalamount" />
    <order attribute="createdon" descending="true" />
  </entity>
</fetch>
```

### More Information

1. [FetchXml reference: fetch element - Microsoft Learn](https://learn.microsoft.com/en-us/power-apps/developer/data-platform/fetchxml/reference/fetch)
1. [Query data using FetchXml - Microsoft Learn](https://learn.microsoft.com/en-us/power-apps/developer/data-platform/fetchxml/overview)

## FXL-009

### Title

Use aggregate and grouping queries carefully

### Description

Use aggregate and grouping queries carefully. Avoid unnecessary aggregations and ensure grouping columns are indexed.

### Guidelines

1. Only use aggregate functions (count, sum, avg, min, max) when the business requirement calls for summarized data.
1. Include a groupby attribute on columns that define the grouping. Do not aggregate without grouping unless you need a single grand total.
1. When using distinct="true", verify the results are correct - outer joins can introduce unexpected duplicates or nulls.

### Rationale

1. Aggregate queries are more resource-intensive than standard retrieval queries because the server must scan and compute across potentially large data sets.
1. Grouping on non-indexed columns forces the database to sort and group large volumes of data in memory, which can cause timeouts.
1. Misuse of distinct with outer joins can produce misleading counts or silently exclude valid records.



### Examples

#### Good

Good example code snippet.
```xml
<fetch aggregate="true">
  <entity name="opportunity">
    <attribute name="ownerid" groupby="true" alias="owner" />
    <attribute name="opportunityid" aggregate="count" alias="total" />
    <filter>
      <condition attribute="statecode" operator="eq" value="0" />
    </filter>
  </entity>
</fetch>
```

#### Bad

Bad example code snippet.
```xml
<fetch aggregate="true">
  <entity name="activitypointer">
    <attribute name="activityid" aggregate="count" alias="total" />
  </entity>
</fetch>
```

### More Information

1. [Aggregate data using FetchXml - Microsoft Learn](https://learn.microsoft.com/en-us/power-apps/developer/data-platform/fetchxml/aggregate-data)

## FXL-010

### Title

Build FetchXML queries programmatically using the SDK QueryExpression-to-FetchXML conve...

### Description

Build FetchXML queries programmatically using the SDK QueryExpression-to-FetchXML conversion or dedicated builder libraries. Avoid constructing FetchXML by string concatenation.

### Guidelines

1. Use the Dataverse SDK methods (e.g., QueryExpressionToFetchXmlRequest) or community FetchXML builder tools to generate queries.
1. If string construction is unavoidable, always sanitize user input to prevent FetchXML injection.
1. Store complex or reusable FetchXML queries as saved queries or user queries in Dataverse.

### Rationale

1. String concatenation is error-prone and can introduce malformed XML, missing closing tags, or incorrect attribute escaping.
1. Unsanitized user input in dynamically built FetchXML strings can lead to injection attacks, allowing users to modify the query logic.
1. Builder tools and SDK conversions produce valid, well-formed XML every time and are easier to maintain.



### Examples

#### Good

Good example code snippet.
```csharp
var query = new QueryExpression("account");
query.ColumnSet = new ColumnSet("name", "accountnumber");
query.Criteria.AddCondition("statecode", ConditionOperator.Equal, 0);

var request = new QueryExpressionToFetchXmlRequest { Query = query };
var response = (QueryExpressionToFetchXmlResponse)service.Execute(request);
string fetchXml = response.FetchXml;
```

#### Bad

Bad example code snippet.
```csharp
// Dangerous: user input is injected directly into the query
string fetchXml = @"<fetch>
  <entity name='account'>
    <attribute name='name' />
    <filter>
      <condition attribute='name' operator='eq' value='" + userInput + @"' />
    </filter>
  </entity>
</fetch>";
```

### More Information

1. [Build queries with QueryExpression - Microsoft Learn](https://learn.microsoft.com/en-us/power-apps/developer/data-platform/org-service/build-queries-with-queryexpression)
1. [FetchXml reference - Microsoft Learn](https://learn.microsoft.com/en-us/power-apps/developer/data-platform/fetchxml/reference/)


