### Version 1.0.0
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
      

### Version 0.3.5
  - Changed definition of the kafka message key from uuid to object with processId

### Version 0.3.4
  - Fixed schema registry urls

### Version 0.3.3
  - Enhanced documentation

### Version 0.3.2
  - Enhanced documentation

### Version 0.3.1
  - Added SafErrorEvent and OfferNLPIErrorEvent as valid messages for all operations.
  - Updated documentation (descriptions and examples).
  - EventDataType
    - Prohibit additional properties
  - SAFErrorEventType
    - Prohibit additional properties
  - UserAgentType
    - Prohibit additional properties

### Version 0.2.4 (20.08.2024) - Initial public release