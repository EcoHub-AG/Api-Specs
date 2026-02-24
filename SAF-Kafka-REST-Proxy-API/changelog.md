# SAF Kafka REST Proxy API Changelog

### Version 1.1.0
  - Improved documentation
  - ProcessNameType
    - renamed the enum values for proxy standards. These values were not yet used on the platform, therefore this change is treated as MINOR, not MAJOR.
    - added enum values for remaining legacy standards
  - SubProcessNameType
    - renamed the enum values for proxy standards. These values were not yet used on the platform, therefore this change is treated as MINOR, not MAJOR.
    - added enum values for remaining legacy standards 
  - added endpoint to consume commission topic
  - added endpoint to consume invoice topic
  - added endpoint to consume contract topic
  - added endpoint to consume mandate topic
  - added endpoint to consume claimsExperience topic

### Version 1.0.0
  - added version prefix to all endpoints
  - updated schemaVersionId and keySchemaVersionId header value for POST /in endpoint
  - ProcessNameType
    - Added values for proxy standards
  - SubProcessNameType
    - Added values for proxy standards
  - SubProcessStatusType
    - Renamed enum value "Responsed" to "Responded"
  - OfferNLPIErrorEventType
    - Prohibit additional properties
    - Restructured the type and replaced error codes
    - The data attribute is now mandatory
    - Added mandatory property 'processVersion'
    - Added property processGroupId
  - EventDataType
    - renamed "payLoadSignature" to "payloadSignature"
    - "payloadSignature" and "signatureKeyVersion" are now mandatory
    - removed minLength requirement from publicKeyVersion and signatureKeyVersion
    - added minItems requirement to "links" property
  - EventMessageDataType
    - Removed property "md5MessageHash"
    - Added mandatory properties "messageSignature" and "signatureKeyVersion"
    - removed minLength requirement from publicKeyVersion
    - Prohibit additional properties
  - EventType
    - Changed format of the values to reverse-dns
  - LicenseKeyType
    - Renamed to "LicenceKeyType"
  - SenderReceiverType
    - Added property 'onBehalfBy'
  - SAFErrorEventType
    - Added mandatory property 'processVersion'
    - Added property processGroupId
  - SAFEventType
    - Added mandatory property 'processVersion'
    - Added property processGroupId
  - SAFInquiryEventType
    - Added mandatory property 'processVersion'
    - Added property processGroupId
  

### Version 0.3.4
  - Adjusted type of the key property of the response when consuming messages

### Version 0.3.3
  - Enhanced documentation

### Version 0.3.2
  - Fixed schemaVersionId header value
  - Enhanced documentation

### Version 0.3.1
  - Fixing content type definitions
  - Added SAFErrorEventType and OfferNLPIErrorEventType as valid types to POST to /in
  - Updated documentation (descriptions and examples). 
  - EventDataType
    - Prohibit additional properties
  - SAFErrorEventType
    - Prohibit additional properties
  - UserAgentType
    - Prohibit additional properties       
### Version 0.3.0 (20.08.2024)
- Initial public release