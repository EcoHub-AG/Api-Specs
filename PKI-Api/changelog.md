## Changelog

### Version 3.0.0
  - Added new SupportedProcesses for SAF AI Data Structuring "aiDataStructuring" to SAFInsurersResponse and SAFReceiverResponse

### Version 2.0.0
  - Adjusted url path segment from /v1 to /v2
  - PublicKeyResponse: property 'activatedAt' is now optional
  - PublicKeyStatusType: Added value "Expired"
  - SupportedProcesses:
    - Renamed  processNames for Invoices, Commission and Contract
    - Added processNames for mandate and claimsExperience.

### Version 1.2.0
  - Removed enum value "Verified" from ecoHubStatus in PublicKeyResponse
  - Added property "verificationStatus" to PublicKeyResponse

### Version 1.1.0
  - Added an endpoint to retrieve the signature key of a member with a specific version.

### Version 1.0.2
  - Corrected the API specification to include missing enum values in "supportedProcesses" that have been 
    returned by the implementation since v1.0.0. This was a documentation error. Clients on earlier 
    specifications may already receive these values.

### Version 1.0.1
  - Corrected the response type in the specification for the /members/{idpNumber}/keys/{keyType}
     endpoint from object to list. This change aligns the documentation with the actual implementation. No changes to the API behavior.
  - Further clarifications in existing documentation

### Version 1.0.0
  - Introducing major version prefix for all endpoints
  - Introducing new property keyType, to support the digital signature public keys
  - Adjust /members endpoint to use /keys instead of /key, as there are now multiple
  - GET /keys returns a list of keys instead of a single object
  - Introducing new property supportedProcesses, to restrict keys to be used with certain core processes.
  - allow additionalProperties in PublicKeyResponse
  - mark mandatory properties in PublicKeyResponse
  - allow additional properties in PublicKeyVerifyResponse
  - allow additional properties in PublicKeyVerifyChallenge
  - mark mandatory properties in PublicKeyVerifyChallenge
  - mark mandatory properties in PublicKeyVerifyRequest

### Version 0.4.1 (30.01.2025)
  - Enhanced documentation

### Version 0.4.0 (26.12.2024)
  - Removing unused paths for insurers and brokers
  - Only allow application/json as content type
  - Enhanced documentation
### Version 0.3.0 (11.07.2024)

- Initial public release of the public key store api, that is needed to retrieve the receivers public key and to manage your own public key.