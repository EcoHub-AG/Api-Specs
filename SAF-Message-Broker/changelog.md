### Version 1.2.0
  - Added support for Generic Exchange events (`ch.ecohub.saf.generic`) on the IN topic
  - Added channel and operation to consume the generic OUT topic
  - Added dedicated Generic Exchange processName schema
  - ProcessNameType: added new value for claimsExpierence.nlpi
  - Added channel and operation to consume the claimsExpierence.nlpi OUT topic
  - Aligned schema documentation with the actual implementation; this does not change the SAF Message Broker API behavior
    - Fix max.message.bytes of the `IN` topic to be 8388608 instead of 8338608
    - Optional CloudEvents attributes are no longer documented as explicitly nullable; if not set, they should be omitted
    - Normalized the `processId` format annotation to `uuid`
  - Added `SAFIDSEventType` (`ch.ecohub.saf.ids`) for Intelligent Data Structuring events
  - Root-level scalar projections for Kafka-level filtering and routing: `idsconfidenceScore`, `idsdocumentQuality`, `idsisValid`, `idsroutingDecision`, `idsrequiresHumanReview`, `idsreviewReason`
  - `idsdocumentQuality` enum: `excellent`, `high`, `medium`, `low`, `poor`
  - `IDSEventDataType` with fully typed component schemas for all IDS metadata groups: `IDSBasicProcessingMetadataType`, `IDSDocumentQualityMetricsType`, `IDSDetailedExtractionDataType`, `IDSDocumentQualityAssessmentType`, `IDSReceiverRecommendationsType`, `IDSValidationResultsType`, `IDSFieldExtractionAuditType` and their supporting sub-types
  - `idsdetailedExtractionData`, `idsdocumentQualityAssessment`, `idsreceiverRecommendations`, and `idsfieldExtractionAudit` are nullable (optional processing output)
  - Added endpoint to consume the IDS OUT topic (`/{ecohubId}/ids/out`)

### Version 1.1.0
  - Improved documentation
  - increased max.message.bytes to 8388608 bytes (8MB) for all topics
  - ProcessNameType
    - renamed the enum values for proxy standards. These values were not yet supported by the platform and could not be used yet, therefore this change is treated as MINOR, not MAJOR.
    - added enum values for remaining legacy standards
  - SubProcessNameType
    - renamed the enum values for proxy standards. These values were not yet supported by the platform and could not be used yet, therefore this change is treated as MINOR, not MAJOR.
    - added enum values for remaining legacy standards
  - added operation to consume commission topic
  - added operation to consume invoice topic
  - added operation to consume contract topic
  - added operation to consume mandate topic
  - added operation to consume claimsExperience topic

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
