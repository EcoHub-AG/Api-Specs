# SAFIDSEventType - Intelligent Document Services Event Schema

## Quick Navigation

| File | Purpose | Best For | View Method |
|------|---------|----------|-------------|
| **[SCHEMA_DIAGRAM.md](SCHEMA_DIAGRAM.md)** ⭐ **RECOMMENDED** | Mermaid diagram embedded in markdown - easiest viewing | Visual overview | GitHub markdown or VS Code preview |
| **[SCHEMA_DOCUMENTATION.md](SCHEMA_DOCUMENTATION.md)** | Comprehensive schema reference with all 43 properties, examples, and design principles | Implementation and detailed reference | Markdown reader |
| **[SCHEMA_STRUCTURE.mermaid](SCHEMA_STRUCTURE.mermaid)** | Standalone Mermaid file with proper syntax | Extended preview feature use | vstirbu.vscode-mermaid-preview extension |
| **[SAFIDSEventType.json](SAFIDSEventType.json)** | Main JSON Schema definition with CloudEvents compliance | Schema validators, API implementations | JSON schema tools |
| **[IDSEventDataType.json](IDSEventDataType.json)** | 5-property security envelope for encrypted business data | Security officers, encryption specialists | JSON viewer |
| **[specific-types/](specific-types/)** | 18 individual extension type definitions (one per IDS attribute) | Advanced users, custom validators | JSON schema tools |

---

## 🎨 Viewing the Schema Diagram

We provide **3 ways** to view the schema visualization:

### 1️⃣ **Easiest: SCHEMA_DIAGRAM.md** (Recommended ⭐)
- **File**: [SCHEMA_DIAGRAM.md](SCHEMA_DIAGRAM.md)
- **Works in**: GitHub, VS Code, any Markdown preview
- **How**: Just click the file and view in your browser/editor
- **✅ Best for**: Quick visual overview

### 2️⃣ **Advanced: SCHEMA_STRUCTURE.mermaid** (With Extension)
- **File**: [SCHEMA_STRUCTURE.mermaid](SCHEMA_STRUCTURE.mermaid)
- **Extension needed**: [vstirbu.vscode-mermaid-preview](https://marketplace.visualstudio.com/items?itemName=vstirbu.vscode-mermaid-preview)
- **How**: Install extension, right-click file, select "Open in Mermaid Preview"
- **✅ Best for**: Interactive editing and viewing in VS Code

### 3️⃣ **Interactive Editor: Mermaid Live**
- **Link**: https://mermaid.live
- **How**: Copy content from SCHEMA_DIAGRAM.md or SCHEMA_STRUCTURE.mermaid, paste into editor
- **✅ Best for**: Exporting to PNG/SVG or real-time editing

---

A **CloudEvents v1.0-compliant** event schema for transmitting document processing results and recommendations in the SAF (Selise Application Framework) ecosystem.

### Key Characteristics

✅ **43 Properties** organized into 4 semantic categories
✅ **14 Required**, 29 optional (backward compatible)
✅ **18 IDS Extension Attributes** with receiver-centric recommendations
✅ **AES-256 Encryption** + ECDSA digital signatures
✅ **Quality Transparency** via confidence scores, validation results, and transformation logs
✅ **Receiver-Focused** with actionable guidance (ACCEPT/REVIEW/VERIFY/REJECT)

---

## Property Structure

```
SAFIDSEventType (43 properties)
├── CloudEvents Standard (8)
│   ├── Required: id, source, specversion, type
│   └── Optional: datacontenttype, dataschema, subject, time
├── SAF Domain (5)
│   ├── Required: licenceKey, userAgent, eventReceiver, eventSender
│   └── Optional: data (encrypted business content)
├── IDS Processing Metadata (18 - all optional)
│   ├── Scalar Metrics (7): model, version, confidence, processing time, etc.
│   ├── Quality Scores (4): OCR quality, document quality, completeness, hash
│   └── Complex Objects (7): extraction details, recommendations, validation results
└── Process Tracking (7)
    ├── Required: processId, processName, processVersion, etc.
    └── Optional: processGroupId
```

---

## Getting Started

### 1. Quick Overview
Start with the **property table in SCHEMA_DOCUMENTATION.md** to see all 43 properties at a glance.

### 2. Visual Understanding
View the **Mermaid diagram** using any of these methods:
- ✅ **Easiest**: Open [SCHEMA_STRUCTURE.md](SCHEMA_STRUCTURE.md) and view in GitHub or VS Code Markdown preview
- ✅ **VS Code**: Open `SCHEMA_STRUCTURE.mermaid` with [Mermaid Preview Extension](https://marketplace.visualstudio.com/items?itemName=vstirbu.vscode-mermaid-preview)
- ✅ **Online**: Paste into [Mermaid Live Editor](https://mermaid.live)

### 3. Detailed Reference
Read **SCHEMA_DOCUMENTATION.md** for:
- Full property descriptions with type constraints
- Security & encryption details
- Design principles & receiver-centric approach
- Real-world JSON examples

### 4. Implementation
Use **SAFIDSEventType.json** for:
- Schema validation
- API documentation generation
- Client code generation
- Integration testing

---

## Key Design Features

### 🎯 Receiver-Centric Recommendations

The **`idsreceiverRecommendations`** attribute provides explicit guidance to receivers:

```
- ACCEPT: High confidence, proceed without review (~0.95+ confidence)
- REVIEW: Near threshold, spot-check recommended (~0.85-0.94)
- VERIFY: Low confidence, manual validation required (~0.70-0.84)
- REJECT: Failed validation, do not use (<0.70)
```

Each field includes:
- Why the recommendation was made
- Alternative values when extraction is ambiguous
- Estimated time for manual review
- Priority ranking for triage

### 🔐 Security

**Payload**: AES-GCM (256-bit key, 96-bit IV, 128-bit auth tag)
**Signature**: ECDSA secp384r1 + SHA-384
**Key Encryption**: RSA-OAEP + SHA-256
**Versioning**: Support for key rotation and multi-key scenarios

### 📊 Quality Transparency

Multiple quality signals enable confidence-based decisions:
- Confidence scores (0-1 normalized)
- Quality classifications (EXCELLENT/GOOD/ACCEPTABLE/POOR)
- Completeness percentage (fields extracted)
- Document hash (SHA-256)
- Transformation log (all normalizations)
- Validation results (business rules, syntax, compliance)

### ✅ CloudEvents Compliance

✓ All metadata as root-level extension attributes (not nested in data)
✓ `data` property contains only business content
✓ Version-agnostic (can evolve without breaking consumers)
✓ Namespace clarity with `ids` prefix

---

## Real-World Examples

### Acknowledgement Event (Minimal)
```json
{
  "id": "uuid-here",
  "source": "http://broker.com",
  "specversion": "1.0",
  "type": "ch.ecohub.saf.ids",
  "licenceKey": "...",
  "userAgent": { "name": "BS1", "version": "1.0" },
  "eventReceiver": { "category": "insurer", "id": "IDP123" },
  "eventSender": { "category": "broker", "id": "IDP456" },
  "processId": "uuid", "processName": "offer.nlpi",
  "processVersion": "0.3.0", "subProcessName": "request",
  "processStatus": "active"
}
```
(14 required properties only)

### Full Processing Event (With Recommendations)
See **SCHEMA_DOCUMENTATION.md** for complete example with:
- Encrypted data envelope
- All 18 IDS processing attributes
- Field-level recommendations with confidence scores
- Quality assessment and validation results

---

## File References

**Internal References**:
- `IDSEventDataType.json` - Data envelope schema
- `specific-types/` - Individual extension definitions

**External References**:
- `../CloudEventsType.json` - CloudEvents standard attributes
- `../event-generic/` - Generic SAF types (EventType, UserAgentType, etc.)

---

## Use Cases

✅ Document processing result transmission
✅ Quality signal distribution to integrated systems
✅ Receiver recommendations for manual review triage
✅ Audit trail and compliance documentation
✅ Multi-party event routing and validation
✅ Key rotation and version management
✅ Processing transparency and explainability

---

## Version Information

**Current Version**: 2.0.0
**Release Date**: March 31, 2026
**Schema Specification**: JSON Schema draft 2019-09
**Compliance**: CloudEvents v1.0

### Version 2.0.0 Changes
- Full CloudEvents v1.0 compliance
- 18 granular extension attributes
- Receiver-centric recommendation system
- Simplified, modular extension definitions
- Enhanced security and encryption details
- Per-field quality and transformation tracking

---

## Related Documentation

- [SAF Standards Repository](https://github.com/EcoHub-AG/Standards)
- [CloudEvents Specification](https://cloudevents.io/)
- [Kafka Events Specification](../README.md)

---

## Questions?

For implementation questions, see the property tables in **SCHEMA_DOCUMENTATION.md**.
For visual guidance, open **SCHEMA_STRUCTURE.mmd** in a Mermaid viewer.
For integration, use **SAFIDSEventType.json** directly with your validator.
