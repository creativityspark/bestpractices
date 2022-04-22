# Forms

Good practices for Dataverse Forms. 

# FRM-001

Every table main form must have a hidden Admin tab, containing all the system attributes, including status, owner, creation, modification dates, etc.

You can use a tool like [Level up for Dynamics](https://github.com/rajyraman/Levelup-for-Dynamics-CRM) to make the tab visible and access the values. 

![Hidden Admin Tab](/img/frm-001-hidden-admin.png)

![Hidden Admin Tab](/img/frm-001-hidden-admin-2.png)

## Rationale

In many occasions there is need for testers and developers to be able to access and update these values. Having them in a hidden tab facilitates debugging and testing tasks.
