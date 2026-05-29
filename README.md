# arcadia-sysmlv2-lib

**arcadia-sysmlv2-lib** is an open SysML v2 library that formalizes the core concepts of the Arcadia methodology using the SysML v2 and KerML standard foundations.

The goal of this project is to provide a reusable, extensible, and tool-agnostic semantic layer to support Arcadia-based modeling in modern SysML v2 environments.

## 🎯 Objectives and Scope

**arcadia-sysmlv2-lib** aims to provide a principled and practical alignment between the Arcadia methodology and the SysML v2 standard.

> ⚠️ **Project status:** This project is currently under active development. Most important concepts of Arcadia have been covered. See the doc directory for more information.

The library is designed to:

- provide a SysML v2 formalization of Arcadia concepts  
- stay close to the Arcadia methodology intent  
- respect SysML v2 principles (notably the strict separation between structure and behavior)  
- leverage native SysML v2 constructs whenever possible  
- avoid unnecessary semantic duplication  
- enable reuse across tools (e.g., SysON, Papyrus Web, Sirius-based tools)  
- remain adaptable to different MBSE toolchains  
- offer clear guidance on how Arcadia maps to SysML v2  
- provide ready-to-use examples and project structure  

This library is **not intended to be a strict one-to-one mechanical translation of how Arcadia has been implemented in Capella**, but rather a well-founded semantic alignment with SysML v2.

## 📁 Repository Structure

### `/doc`

Contains detailed documentation explaining how Arcadia/Capella concepts are mapped to the SysML v2 language, including:
- modeling principles  
- mapping rationale  
- design decisions  
- known limitations and assumptions  

This is the recommended starting point to understand the library and how to use it.

### `/examples`

Provides sample models demonstrating how to use the Arcadia library in practice.

These examples illustrate:
- how to import the library  
- how to instantiate Arcadia concepts  
- recommended modeling patterns  

### `/lib`

Contains the formal definition of Arcadia concepts expressed in **SysML v2 (.sysml)**.

**arcadia.sysml**  
Includes the semantic foundation of the library, such as:
- Components  
- Functions  
- Exchanges  
- supporting Arcadia concepts  

The library is designed to remain:
- modular  
- extensible  
- compliant with SysML v2 semantics  

**ArcadiaDefaultStructure.sysml**  
Provides the default model organization expected for an Arcadia-based SysML v2 project.


## 🚀 Getting Started

1. Clone the repository:

```bash
git clone https://github.com/<your-org>/arcadia-sysmlv2-lib.git
```
2. Import the library from the /lib folder into your SysML v2 environment.
3. Explore the /examples to understand recommended usage.
4. Read the /doc folder for the full mapping rationale.

## 🤝 Contributing

Contributions are welcome. Typical contributions include:
- improvements to the mapping
- additional examples
- clarification of documentation
- extensions of the library

Please open an issue or submit a pull request.

## 📜 License
EPL v2

## ✉️ Contact

Maintained by Obeo, Thales and contributors.
