# SAFIDSEventType Schema Documentation

## Overview

**SAFIDSEventType** is a comprehensive, CloudEvents v1.0-compliant event schema for IDS (Intelligent Document Services) integration. It combines CloudEvents standard attributes with SAF domain attributes, IDS processing metadata, and process tracking information in a single, unified structure.

- **Total Properties**: 43
- **Required Properties**: 14
- **Optional Properties**: 29 (including 18 IDS extension attributes)
- **Compliance**: CloudEvents v1.0 specification
- **Security**: AES-256 encryption + ECDSA signatures with key versioning

---

## Property Categories

### 1️⃣ CloudEvents Standard Attributes (8 properties)

CloudEvents v1.0 core attributes that provide event identity, source, and type information.

| Property | Type | Required | Description |
|----------|------|----------|-------------|
| **id** | string (UUID) | ✅ Yes | Unique event identifier |
| **source** | URI | ✅ Yes | Origin/source of the event (e.g., http://www.myecohub.ch/broker) |
| **specversion** | string | ✅ Yes | CloudEvents specification version (always "1.0") |
| **type** | string | ✅ Yes | Event category: `ch.ecohub.saf.ids` (constant for IDS events) |
| datacontenttype | string | ❌ No | MIME type of data payload (e.g., "application/json") |
| dataschema | URI | ❌ No | URI reference to the business data schema |
| subject | string | ❌ No | Describes the subject of the event |
| time | string (ISO 8601) | ❌ No | Event creation timestamp (e.g., "2023-08-17T14:15:22.000Z") |

**Example**:
```json
{
  "id": "044d2e50-12d6-43e4-bb1b-7b54841c9c82",
  "source": "http://www.myecohub.ch/ecoHub-mock-broker-producer1",
  "specversion": "1.0",
  "type": "ch.ecohub.saf.ids",
  "time": "2023-08-17T14:15:22.000Z"
}
```

---

### 2️⃣ SAF Domain Attributes (5 properties)

SAF-specific attributes for authentication, authorization, and business context.

| Property | Type | Required | Description |
|----------|------|----------|-------------|
| **licenceKey** | string | ✅ Yes | License/subscription key for authentication |
| **userAgent** | object | ✅ Yes | Sender application information |
| **eventReceiver** | object | ✅ Yes | Recipient identification |
| **eventSender** | object | ✅ Yes | Sender identification |
| data | object | ❌ No | Encrypted business content (5-property security envelope) |

#### UserAgent Object
```json
{
  "name": "BS1",        // Application name
  "version": "1.0"      // Application version
}
```

#### SenderReceiver Object
```json
{
  "category": "insurer",  // Category: insurer, broker, etc.
  "id": "IDP1234567"      // Unique identifier (e.g., tax ID)
}
```

#### Data Envelope (IDSEventDataType) - 5 properties

The `data` property contains only encrypted business content, following CloudEvents v1.0 principle that metadata belongs at root level.

| Property | Type | Description |
|----------|------|-------------|
| payload | string (Base64) | Encrypted, gzip-compressed business data. Uses AES-GCM with 256-bit key, 96-bit IV, 128-bit authentication tag. |
| payloadSignature | string (Base64) | Digital signature created using ECDSA secp384r1 curve and SHA-384 hash. Encoded in ASN.1 format. |
| encryptionKey | string (Base64) | AES symmetric key encrypted with eventReceiver's public key using RSA-OAEP padding and SHA-256. |
| publicKeyVersion | string | Version identifier of the recipient's public key used to encrypt the encryptionKey. Determines which private key can decrypt. |
| signatureKeyVersion | string | Version identifier of the sender's signature key used to sign the payload. Determines which public key can verify. |

**Example**:
```json
{
  "payload": "V2UgZGlkbid0IGluY2x1ZGUgdGhlIGZ1bGwgcGF5bG9hZCBoZ...",
  "payloadSignature": "MEYCIQD76gKbAynmvE5Ndq+Tnnf/aBziZlryXkP...",
  "encryptionKey": "urpx9D/0MwvQoCz3nNcQyMpEh2VEW6X7TiMmIfH...",
  "publicKeyVersion": "1.1",
  "signatureKeyVersion": "1.3"
}
```

---

### 3️⃣ IDS Processing Metadata (18 optional extension attributes)

Receiver-centric metadata exposing document processing quality signals, recommendations, and transformation details. All attributes are **optional** (backward compatible) and prefixed with `ids` for namespace clarity.

#### Scalar Metrics (7 properties)

Simple value metrics about the processing workflow.

| Property | Type | Value Range | Description |
|----------|------|-------------|-------------|
| idsprocessingModel | string | - | Name of the AI/ML model used for extraction |
| idsmodelVersion | string | - | Version identifier of the processing model |
| idsconfidenceScore | number | 0-1 | Overall confidence score of extraction (1 = highest) |
| idsprocessingTimeMs | number | ≥ 0 | Total processing duration in milliseconds |
| idsdocumentType | string | enum | Document category (e.g., "invoice", "contract", "offer") |
| idssourceFormat | string | MIME type | Source document format (e.g., "application/pdf", "image/png") |
| idspageCount | integer | ≥ 0 | Total number of pages in source document |

**Example**:
```json
{
  "idsprocessingModel": "DocumentProcessor-v3.1",
  "idsmodelVersion": "3.1.0",
  "idsconfidenceScore": 0.94,
  "idsprocessingTimeMs": 1250,
  "idsdocumentType": "invoice",
  "idssourceFormat": "application/pdf",
  "idspageCount": 3
}
```

#### Quality Scores (4 properties)

Normalized quality assessments and integrity indicators.

| Property | Type | Value Range | Description |
|----------|------|-------------|-------------|
| idsocrQuality | number | 0-1 | OCR (Optical Character Recognition) quality confidence |
| idsdocumentQuality | string | enum: EXCELLENT, GOOD, ACCEPTABLE, POOR | Overall document quality level classification |
| idscompletenessScore | number | 0-1 | Percentage of fields successfully extracted (0 = none, 1 = all) |
| idssourceDocumentHash | string | SHA-256 hex | SHA-256 hash of source document for integrity verification |

**Example**:
```json
{
  "idsocrQuality": 0.88,
  "idsdocumentQuality": "GOOD",
  "idscompletenessScore": 0.95,
  "idssourceDocumentHash": "a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6q7r8s9t0"
}
```

#### Complex Objects (7 properties)

Structured data providing detailed insights into preprocessing, field extraction, quality assessment, and receiver recommendations.

##### idspreprocessingPipeline
**Type**: array of objects  
**Description**: Sequential preprocessing operations applied to the source document.

```json
{
  "idspreprocessingPipeline": [
    {
      "step": 1,
      "operation": "deskew",
      "applied": true
    },
    {
      "step": 2,
      "operation": "denoising",
      "applied": true
    },
    {
      "step": 3,
      "operation": "binarization",
      "applied": false
    }
  ]
}
```

##### idspreprocessingImpactAnalysis
**Type**: object  
**Description**: Summary of how preprocessing operations affected extraction quality.

```json
{
  "idspreprocessingImpactAnalysis": {
    "overallQualityChange": 0.15,
    "qualityBeforePreprocessing": 0.75,
    "qualityAfterPreprocessing": 0.90,
    "operationsWithHighestImpact": ["deskew", "denoising"],
    "estimatedImprovementFromPreprocessing": "Significant improvement in text recognition accuracy"
  }
}
```

##### idsfieldExtractionDetails
**Type**: array of objects  
**Description**: Per-field metadata including confidence, location, and alternative values.

```json
{
  "idsfieldExtractionDetails": [
    {
      "fieldPath": "invoice.invoiceNumber",
      "confidence": 0.98,
      "location": { "page": 1, "bbox": [100, 50, 200, 70] },
      "value": "INV-2023-001234",
      "alternativeValues": ["INV-2023-001234", "1NV-2023-001234"],
      "handwritten": false
    },
    {
      "fieldPath": "invoice.totalAmount",
      "confidence": 0.87,
      "location": { "page": 1, "bbox": [400, 550, 500, 570] },
      "value": "1234.56",
      "alternativeValues": ["1234.56", "1234.50"],
      "handwritten": false
    }
  ]
}
```

##### idsfieldTransformationRecord
**Type**: array of objects  
**Description**: Normalizations and transformations applied to extracted field values.

```json
{
  "idsfieldTransformationRecord": [
    {
      "fieldPath": "invoice.totalAmount",
      "originalValue": "CHF 1'234.56",
      "transformedValue": "1234.56",
      "transformationType": "currency_normalization",
      "confidence": 1.0
    },
    {
      "fieldPath": "invoice.invoiceDate",
      "originalValue": "17.08.2023",
      "transformedValue": "2023-08-17",
      "transformationType": "date_normalization",
      "confidence": 0.99
    }
  ]
}
```

##### idsdocumentQualityAssessment
**Type**: object  
**Description**: Comprehensive quality breakdown across multiple dimensions.

```json
{
  "idsdocumentQualityAssessment": {
    "overallScore": 0.89,
    "readabilityScore": 0.92,
    "completenessScore": 0.85,
    "clarityScore": 0.88,
    "issuesIdentified": [
      "Slight fold mark in top-left corner",
      "One field has low confidence extraction"
    ],
    "recommendedActions": ["Review document completeness", "Verify low-confidence field"]
  }
}
```

##### idsreceiverRecommendations ⭐ **Most Important for Receivers**
**Type**: object  
**Description**: **Receiver-centric action guidance** with field-level recommendations (ACCEPT/REVIEW/VERIFY/REJECT), priorities, and estimated review time.

```json
{
  "idsreceiverRecommendations": {
    "summary": {
      "fieldsCount": 15,
      "fieldsAccept": 12,
      "fieldsReview": 2,
      "fieldsVerify": 1,
      "documentLevelIssues": 1,
      "estimatedManualReviewMinutes": 5,
      "overallStrategy": "targeted-review"
    },
    "fieldRecommendations": [
      {
        "fieldPath": "invoice.invoiceNumber",
        "recommendation": "ACCEPT",
        "priority": 1,
        "reasons": [],
        "confidenceScore": 0.98,
        "threshold": 0.90,
        "whatToCheckFor": "None - high confidence extraction"
      },
      {
        "fieldPath": "invoice.totalAmount",
        "recommendation": "REVIEW",
        "priority": 2,
        "reasons": ["confidence_near_threshold"],
        "confidenceScore": 0.87,
        "threshold": 0.90,
        "whatToCheckFor": "Verify numerical value and currency symbol",
        "alternativeValues": ["1234.56", "1234.50"],
        "estimatedTimeMinutes": 2
      },
      {
        "fieldPath": "invoice.bankDetails",
        "recommendation": "VERIFY",
        "priority": 3,
        "reasons": ["validation_failed", "high_risk_field"],
        "confidenceScore": 0.72,
        "threshold": 0.85,
        "whatToCheckFor": "Manually validate IBAN and BIC codes",
        "estimatedTimeMinutes": 3
      }
    ],
    "documentRecommendations": {
      "pageQualityIssues": ["Slight fold mark visible on page 1"],
      "suggestedActions": ["Review document for completeness", "Verify all numeric fields"],
      "estimatedTotalReviewTime": 5
    },
    "decisionMatrix": {
      "allFieldsConfident": false,
      "documentComplete": true,
      "fastPath": false,
      "manualReviewRequired": true,
      "routingDecision": "send-to-reviewer"
    }
  }
}
```

##### idsvalidationResults
**Type**: object  
**Description**: Validation outcomes, business rules applied, and routing decisions.

```json
{
  "idsvalidationResults": {
    "syntaxValidation": {
      "passed": true,
      "issues": []
    },
    "businessRulesValidation": {
      "passed": false,
      "failedRules": [
        {
          "ruleId": "invoice_amount_range",
          "ruleName": "Invoice amount must be between CHF 10 and 1'000'000",
          "result": "passed"
        },
        {
          "ruleId": "iban_valid_format",
          "ruleName": "IBAN must be valid Swiss IBAN",
          "result": "failed",
          "reason": "Invalid check digit"
        }
      ]
    },
    "complianceValidation": {
      "passed": true,
      "checks": ["GDPR compliant", "Data retention policy followed"]
    },
    "routingDecision": {
      "targetQueue": "manual-review",
      "priority": "high",
      "reason": "Business rule validation failed - IBAN validation issue"
    }
  }
}
```

---

### 4️⃣ Process Tracking Attributes (7 properties)

Process workflow identifiers and status tracking for audit and correlation.

| Property | Type | Required | Description |
|----------|------|----------|-------------|
| **processId** | UUID | ✅ Yes | Unique identifier for this process instance |
| **processName** | string | ✅ Yes | Process name (e.g., "offer.nlpi", "invoice", "contract") |
| **processVersion** | string | ✅ Yes | Process version (e.g., "0.3.0", "1.0.0") |
| **subProcessName** | string | ✅ Yes | Sub-process identifier (e.g., "Initiate", "request", "validate") |
| **processStatus** | string | ✅ Yes | Process status (e.g., "active", "completed", "failed") |
| **subProcessStatus** | string | ✅ Yes | Sub-process status (e.g., "Created", "Received", "Processed") |
| processGroupId | UUID | ❌ No | Optional group identifier for correlating related processes |

**Example**:
```json
{
  "processId": "ff9275bf-5b35-492e-bdd2-c217e151d335",
  "processName": "offer.nlpi",
  "processVersion": "0.3.0",
  "subProcessName": "Initiate",
  "processStatus": "active",
  "subProcessStatus": "Created",
  "processGroupId": "group-abc-123"
}
```

---

## Required vs. Optional Properties

### 14 Required Properties ✅
Must be present in every valid SAFIDSEventType event:

1. `id` (CloudEvents)
2. `source` (CloudEvents)
3. `specversion` (CloudEvents)
4. `type` (CloudEvents) - Always `ch.ecohub.saf.ids`
5. `licenceKey` (SAF Domain)
6. `userAgent` (SAF Domain)
7. `eventReceiver` (SAF Domain)
8. `eventSender` (SAF Domain)
9. `processId` (Process Tracking)
10. `processName` (Process Tracking)
11. `processVersion` (Process Tracking)
12. `subProcessName` (Process Tracking)
13. `processStatus` (Process Tracking)
14. `subProcessStatus` (Process Tracking)

### 29 Optional Properties ❌
Can be included for additional context:

**CloudEvents (4)**:
- datacontenttype, dataschema, subject, time

**SAF Domain (1)**:
- data (the encrypted business content)

**IDS Processing Metadata (18)**:
- All 18 attributes (idsprocessingModel through idsvalidationResults)

**Process Tracking (1)**:
- processGroupId

---

## Design Principles

### ✅ CloudEvents v1.0 Compliance
- Adheres to CloudEvents specification for distributed event systems
- All processing metadata as **root-level extension attributes** (not nested in data)
- `data` property purposefully minimalist: contains only encrypted business content
- Namespace clarity with `ids` prefix for IDS-specific extensions

### 🔐 Security & Encryption

**Payload Encryption**:
- Algorithm: **AES-GCM** (Advanced Encryption Standard - Galois/Counter Mode)
- Key Size: **256-bit**
- Initialization Vector (IV): **96-bit**
- Authentication Tag: **128-bit**
- Compression: gzip before encryption

**Digital Signature**:
- Algorithm: **ECDSA** (Elliptic Curve Digital Signature Algorithm)
- Curve: **secp384r1** (P-384)
- Hash: **SHA-384**
- Encoding: **ASN.1 DER** (Distinguished Encoding Rules)
- Transmission: **Base64**

**Key Management**:
- AES key encrypted with RSA-OAEP (2048/4096-bit)
- Hash: **SHA-256**
- Version tracking for key rotation scenarios
- Supports multi-key environments

### 👁️ Receiver-Centric Design

The schema is purpose-built for receivers to make informed decisions about extracted data:

1. **Actionable Recommendations**: `idsreceiverRecommendations` provides explicit guidance:
   - **ACCEPT**: High confidence, proceed without review
   - **REVIEW**: Near threshold, spot-check recommended
   - **VERIFY**: Low confidence, manual validation required
   - **REJECT**: Failed validation, do not use

2. **Priority Ranking**: Fields ranked 1-4 for triage efficiency

3. **Reasons & Context**: Why each recommendation was made, not just the decision

4. **Estimated Time**: Plan review workload realistically

5. **Alternatives**: When extraction is ambiguous, alternative values provided

6. **Field-Level & Document-Level**: Both granular and holistic recommendations

### 📊 Quality Transparency

Multiple quality signals enable confidence-based decisions:

- **Confidence Scores**: 0-1 normalized across different quality dimensions
- **Quality Levels**: Semantic classifications (EXCELLENT/GOOD/ACCEPTABLE/POOR)
- **Completeness**: What percentage of fields were successfully extracted
- **Integrity**: SHA-256 hash for document verification
- **Transformation Log**: Track all normalizations applied
- **Validation Results**: Business rules, syntax checks, compliance validation

### 🔄 Backward Compatibility

- All 18 IDS extension attributes are **optional**
- Existing systems consuming this schema won't break when updated
- Minimal required payload: 14 properties + encryption envelope
- Version support through `processVersion` and key versioning

---

## File Organization

```
eventType-ids/
├── SAFIDSEventType.json                 # Main event type definition
├── IDSEventDataType.json                # 5-property data envelope schema
├── IdsProcessingExtensions.json         # Consolidated extension definitions reference
├── specific-types/                      # Individual extension type definitions
│   ├── idsprocessingModelType.json
│   ├── idsmodelVersionType.json
│   ├── idsconfidenceScoreType.json
│   ├── idsprocessingTimeMsType.json
│   ├── idsdocumentTypeType.json
│   ├── idssourceFormatType.json
│   ├── idspageCountType.json
│   ├── idsocrQualityType.json
│   ├── idsdocumentQualityType.json
│   ├── idscompletenessScoreType.json
│   ├── idssourceDocumentHashType.json
│   ├── idspreprocessingPipelineType.json
│   ├── idspreprocessingImpactAnalysisType.json
│   ├── idsfieldExtractionDetailsType.json
│   ├── idsfieldTransformationRecordType.json
│   ├── idsdocumentQualityAssessmentType.json
│   ├── idsreceiverRecommendationsType.json
│   └── idsvalidationResultsType.json
└── SCHEMA_DOCUMENTATION.md              # This file
```

---

## External References

**CloudEvents Standard**:
- Reference: `../CloudEventsType.json`
- Location: Parent Kafka-Events-Specification folder

**SAF Generic Types**:
- Reference: `../event-generic/`
- Contents: EventType, UserAgentType, SenderReceiverType, ProcessTypes, etc.

---

## Usage Examples

### Minimal Event (Acknowledgement)
Contains only required fields, no encrypted data:

```json
{
  "id": "044d2e50-12d6-43e4-bb1b-7b54841c9c82",
  "source": "http://www.myecohub.ch/broker",
  "specversion": "1.0",
  "type": "ch.ecohub.saf.ids",
  "licenceKey": "REcxZEVMZWV1UXFwOUZwaz...",
  "userAgent": { "name": "BS1", "version": "1.0" },
  "eventReceiver": { "category": "insurer", "id": "IDP1234567" },
  "eventSender": { "category": "broker", "id": "IDP7654321" },
  "processId": "ff9275bf-5b35-492e-bdd2-c217e151d335",
  "processName": "offer.nlpi",
  "processVersion": "0.3.0",
  "subProcessName": "request",
  "subProcessStatus": "Received",
  "processStatus": "active"
}
```

### Full Event with Encrypted Data + IDS Metadata
Includes data envelope and comprehensive IDS processing insights:

```json
{
  "id": "044d2e50-12d6-43e4-bb1b-7b54841c9c82",
  "source": "http://www.myecohub.ch/broker",
  "specversion": "1.0",
  "type": "ch.ecohub.saf.ids",
  "datacontenttype": "application/json",
  "time": "2023-08-17T14:15:22.000Z",
  "licenceKey": "REcxZEVMZWV1UXFwOUZwaz...",
  "userAgent": { "name": "DocumentProcessor", "version": "3.1" },
  "eventReceiver": { "category": "insurer", "id": "IDP1234567" },
  "eventSender": { "category": "broker", "id": "IDP7654321" },
  "data": {
    "payload": "V2UgZGlkbid0IGluY2x1ZGUgdGhlIGZ1bGwgcGF5bG9hZCBoZ...",
    "payloadSignature": "MEYCIQD76gKbAynmvE5Ndq+Tnnf/aBziZlryXkP...",
    "encryptionKey": "urpx9D/0MwvQoCz3nNcQyMpEh2VEW6X7TiMmIfH...",
    "publicKeyVersion": "1.1",
    "signatureKeyVersion": "1.3"
  },
  "idsprocessingModel": "DocumentProcessor-v3.1",
  "idsmodelVersion": "3.1.0",
  "idsconfidenceScore": 0.94,
  "idsprocessingTimeMs": 1250,
  "idsdocumentType": "invoice",
  "idssourceFormat": "application/pdf",
  "idspageCount": 3,
  "idsocrQuality": 0.88,
  "idsdocumentQuality": "GOOD",
  "idscompletenessScore": 0.95,
  "idsreceiverRecommendations": {
    "summary": {
      "fieldsCount": 15,
      "fieldsAccept": 12,
      "fieldsReview": 2,
      "fieldsVerify": 1,
      "estimatedManualReviewMinutes": 5,
      "overallStrategy": "targeted-review"
    }
  },
  "processId": "ff9275bf-5b35-492e-bdd2-c217e151d335",
  "processName": "offer.nlpi",
  "processVersion": "0.3.0",
  "subProcessName": "Initiate",
  "processStatus": "active",
  "subProcessStatus": "Created"
}
```

---

## Validation & Constraints

- **Type**: object
- **Additional Properties**: false (strict schema)
- **JSON Schema Version**: draft 2019-09
- **All numeric ranges**: Validated via min/max constraints
- **Enumerations**: Enforced for quality levels, statuses, recommendations
- **Format validation**: UUIDs, URIs, timestamps follow RFC standards

---

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 2.0.0 | 2026-03-31 | CloudEvents compliance refactor, 18 extension attributes, receiver-centric recommendations |
| 1.0.0 | Earlier | Initial version |

---

## Questions & Support

For questions about:
- **Schema structure**: See [SAFIDSEventType.json](SAFIDSEventType.json)
- **Extension definitions**: See [specific-types/](specific-types/) folder
- **Data envelope**: See [IDSEventDataType.json](IDSEventDataType.json)
- **CloudEvents compliance**: Reference [CloudEventsType.json](../CloudEventsType.json)
