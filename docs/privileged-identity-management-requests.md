# Privileged Identity Management (PIM) requests

Accessing resources in the `production` or `test` environments requires elevated
privileges. We do this through Azure’s Privileged Identity Management (PIM)
request system.

To make a PIM request:

1. Visit
   [this page](https://portal.azure.com/#blade/Microsoft_Azure_PIMCommon/ActivationMenuBlade/azurerbac).
2. Activate the "Contributor" role for the environment you want to access.
3. Give a reason for your request and submit.
4. The requests for `production` and `test` must now be
   [approved by another team member](#approving-a-pim-request).

## Approving a PIM request

Only
[members](https://portal.azure.com/#view/Microsoft_AAD_IAM/GroupDetailsMenuBlade/~/Members/groupId/c462b698-350b-4766-b09c-3f7a0943441c)
of the “s165-Teaching Qualifications Service-Managers USR” Active Directory
group can approve a PIM request.

When somebody makes a PIM request, anyone who can approve it should receive an
email to their `@digital.education.gov.uk` address. If not, they can view all
pending requests
[here](https://portal.azure.com/?Microsoft_Azure_PIMCommon=true#blade/Microsoft_Azure_PIMCommon/ApproveRequestMenuBlade/azurerbac).
