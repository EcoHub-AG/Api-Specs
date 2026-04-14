# 📊 Viewing the SAFIDSEventType Diagram

## ✅ Quick Answer: Which File to Use?

### **Best Option: SCHEMA_DIAGRAM.md** (Works Everywhere)
- **File**: [`SCHEMA_DIAGRAM.md`](SCHEMA_DIAGRAM.md)
- **How to view**: 
  - Click the file in GitHub/VS Code and it renders automatically
  - No installation needed
  - Works on GitHub, VS Code, any Markdown viewer
- **Result**: See the full schema hierarchy diagram instantly

### **Alternative: SCHEMA_STRUCTURE.mermaid** (With Mermaid Extension)
- **File**: [`SCHEMA_STRUCTURE.mermaid`](SCHEMA_STRUCTURE.mermaid)
- **Extension needed**: Install [`vstirbu.vscode-mermaid-preview`](https://marketplace.visualstudio.com/items?itemName=vstirbu.vscode-mermaid-preview)
- **How to use**: 
  - Install extension in VS Code
  - Right-click the .mermaid file
  - Select "Open Preview"
- **Result**: Interactive diagram viewer in VS Code

### **Online Option: Mermaid Live Editor**
- **Link**: https://mermaid.live
- **How**: Copy diagram code and paste into editor
- **Benefit**: Can export to PNG/SVG

---

## 🐛 If the Diagram Isn't Showing

### **GitHub Users**: 
Go straight to [`SCHEMA_DIAGRAM.md`](SCHEMA_DIAGRAM.md) - it should render automatically.

### **VS Code Users**:
1. Open [`SCHEMA_DIAGRAM.md`](SCHEMA_DIAGRAM.md) file
2. Click the Markdown preview icon (top right)
3. You should see the diagram rendered inline
4. OR install the Mermaid extension for [`SCHEMA_STRUCTURE.mermaid`](SCHEMA_STRUCTURE.mermaid)

### **If Still Not Working**:
- Try refreshing your browser (GitHub)
- Restart VS Code
- Copy/paste the diagram code into https://mermaid.live to verify syntax

---

## 📁 Documentation Files

| File | Purpose | View With |
|------|---------|-----------|
| **SCHEMA_DIAGRAM.md** ⭐ | Full diagram + formatting guide | GitHub/VS Code markdown preview |
| **SCHEMA_DOCUMENTATION.md** | Complete reference (all 43 properties) | Text editor/browser |
| **SCHEMA_STRUCTURE.mermaid** | Pure Mermaid syntax | vstirbu.vscode-mermaid-preview extension |
| **README.md** | Overview & navigation | Markdown viewer |

---

## 💡 What You'll See

The diagram shows the SAFIDSEventType structure with:
- **4 Main Categories**: CloudEvents Standard, SAF Domain, IDS Metadata, Process Tracking
- **Color Coding**: Each category has a distinct color
- **43 Total Properties**: 14 required, 29 optional
- **18 IDS Attributes**: Organized into Scalar Metrics, Quality Scores, and Complex Objects

---

## 🚀 Next Steps

1. **View the diagram**: Open [`SCHEMA_DIAGRAM.md`](SCHEMA_DIAGRAM.md)
2. **Read the details**: Check [`SCHEMA_DOCUMENTATION.md`](SCHEMA_DOCUMENTATION.md) for complete property reference
3. **Use in code**: Reference [`SAFIDSEventType.json`](SAFIDSEventType.json) for JSON schema validation
