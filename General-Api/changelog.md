## Changelog

### Version 2.0.0
  - Adjusted url path segment from /v1 to /v2
  - Replaced usages of GeneralErrorResponse with SAFErrorResponse for all endpoints. 
  - Restricted requestId parameter in all requests to be a UUID.
  - Restricted requestTime parameter in all requests to use UTC zimezone.
  - SupportedProcesses:
    - Renamed  processNames for Invoices, Commission and Contract
    - Added processNames for mandate and claimsExperience.

### Version 1.2.0
  - added orgId and membershipId to the /saf-receivers and /saf-insurers response
  - explicitly set additionalProperties to true where it was implicitly implied by JSON schema defaults (helps with code generation)

### Version 1.1.0
  - added parameter "onBehalfOf" to the saf-receivers request

### Version 1.0.0
  - SAFSupportedStandards
    - Renamed and restructured type to align with processName and processVersion in SAF events and PKI API
  - Only allow application/json as content type
  - add version prefix to all endpoints
  - removed 404 response from /saf-receivers and /saf-insurers endpoint
  - correctly marked required attributes in all types
  - allowed additionalProperties in GeneralErrorResponse and SAFErrorResponse
  - Enhanced documentation

### Version 0.3.2
  - Enhanced documentation

### Version 0.3.1
  - Enhanced documentation
### Version 0.3.0
  - Initial public release