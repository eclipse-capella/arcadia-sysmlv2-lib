# SysML v2 Arcadia Library mappings

## Contents

- [Introduction](#introduction)
- [Purpose and audience](#purpose-and-audience)
- [How to read this document](#how-to-read-this-document)
- [Design principles](#design-principles)
- [Open points register](#open-points-register)
- Concepts and mappings, with the prefix of their row identifiers
  1. [ArcadiaElement](mapping/01-ArcadiaElement.md) (`ELEM`)
  2. [ArcadiaPackage](mapping/02-ArcadiaPackage.md) (`PKGM`)
  3. [Default model structure](mapping/03-DefaultModelStructure.md) (`STRUCT`)
  4. [Packages](mapping/04-Packages.md) (`PKG`)
  5. [Component](mapping/05-Component.md) (`COMP`)
  6. [Node and Behavior Components](mapping/06-NodeAndBehaviorComponents.md) (`NODE`)
  7. [Deployment](mapping/07-Deployment.md) (`DEPL`)
  8. [Function](mapping/08-Function.md) (`FUNC`)
  9. [Function Port](mapping/09-FunctionPort.md) (`FPORT`)
  10. [Functional Chain](mapping/10-FunctionalChain.md) (`FC`)
  11. [Functional Exchange](mapping/11-FunctionalExchange.md) (`FE`)
  12. [Component Exchange](mapping/12-ComponentExchange.md) (`CE`)
  13. [Component Port](mapping/13-ComponentPort.md) (`CP`)
  14. [Exchange Allocation](mapping/14-ExchangeAllocation.md) (`EA`)
  15. [Realization](mapping/15-Realization.md) (`REAL`)
  16. [Exchange Item](mapping/16-ExchangeItem.md) (`EI`)
  17. [Requirements](mapping/17-Requirements.md) (`REQ`)
  18. [Capability](mapping/18-Capability.md) (`CAP`)
  19. [Mission](mapping/19-Mission.md) (`MIS`)
  20. [Property values](mapping/20-PropertyValues.md) (`PV`)
  21. [Views](mapping/21-Views.md) (`VIEW`)

## Introduction

Arcadia is a model-based systems engineering (MBSE) method. It guides engineers through the analysis, the design and the validation of complex systems, with a structured approach based on engineering perspectives. Capella is the open-source desktop modeling workbench that implements Arcadia: it provides dedicated diagrams, automation and methodological guidance to build consistent system architectures.

The Arcadia SysML v2 library provides an implementation of the Arcadia method in SysML v2. It captures the core Arcadia concepts, such as components, functions, exchanges and capabilities, in line with the SysML v2 language and its reuse mechanisms. Used with appropriate tooling, it brings to SysML v2 the abstraction, the simplification and the methodological guidance of Arcadia.

## Purpose and audience

This document is the reference for the Arcadia SysML v2 library. For each Arcadia concept, as implemented in Capella, it states how the concept is expressed in SysML v2 with the library, why, and what is deliberately left out or not decided yet.

It is written for:

- modelers who build Arcadia models in SysML v2 with the library;
- tool providers who implement Arcadia support on top of a SysML v2 tool;
- teams who migrate Capella models to SysML v2.

## How to read this document

Each concept has its own file, always organized in the same way:

1. **Library definition**: the corresponding extract of `lib/arcadia.sysml`.
2. **Mapping**: a table with one row per Capella concept, property or relationship.
3. **Example**: a SysML v2 extract that uses the rows of the table.
4. **Decisions**, **Tooling requirements**, **SysML v2 limitations** and **Open points**: the explanations that do not fit in the table.

### The mapping table

| Column | Content |
| --- | --- |
| ID | Stable identifier of the row (for example `COMP-04`), to be used in issues, pull requests and tools. The prefix identifies the section (see Contents); sections refer to each other with it ("see the REAL section") |
| Capella concept | Name of the concept as the Capella user sees it |
| Capella metamodel | Class or feature of the Capella metamodel (for example `pa::PhysicalComponent.nature`) |
| Treatment | How the concept is handled, with one of the values below |
| In SysML v2 | The library element or the SysML v2 construct to use |
| Meaning | What the concept means in Arcadia |
| Rationale | Why this treatment was chosen, with a reference to the design principles (P1 to P6) |

### Treatment values

| Value | Meaning |
| --- | --- |
| `Library` | Defined in the library (definition, attribute or alias) |
| `Native` | A native SysML v2 construct is used as is; nothing is added to the library |
| `Derived` | Not stored in the model: computed by tooling from other elements |
| `Typing` | Expressed by the type of the element, not by a property |
| `Not translated – <reason>` | Decided: the concept is not reproduced. The reason is one of `legacy`, `rarely used`, `replaced by <mechanism>`, `out of library scope` |
| `Deferred – <open point>` | Not decided yet. The row refers to an entry of the open points register |

A concept that is `Not translated` or `Deferred` has no SysML v2 counterpart for now: the "In SysML v2" column reads "none".

### Examples

Every example of this document is taken from a model file of the `examples/concepts` folder, validated with the SysML v2 pilot implementation. Each section names its file. Comments in the examples refer to the row identifiers of the mapping table. `examples/optical-mouse.sysml` remains the complete reference model.

### Terms

| Term | Meaning |
| --- | --- |
| Arcadia | The model-based systems engineering method |
| Capella | The desktop modeling workbench that implements Arcadia. "Capella" always designates this tool and its metamodel |
| Engineering perspectives | Operational Analysis (OA), System Analysis (SA), Logical Architecture (LA), Physical Architecture (PA) and EPBS |
| REC / RPL | Capella mechanism for reusing model elements: a Replicable Elements Collection (REC) and its Replicas (RPL) |
| Definition / usage | The SysML v2 pattern in which a definition (`part def`, `action def`…) is reused by usages (`part`, `action`…) |
| Tooling | Any tool that edits, displays or transforms models built with the library |

## Design principles

These principles drive every design decision recorded in this document. They are listed in priority order: in case of conflict, the higher one wins.

- **P1 Standard SysML v2 usage first.** Our first priority is that Arcadia models built with this library are as close as possible to a standard use of SysML v2. We do not aim at a one-to-one transposition of Capella's implementation of Arcadia: we take the Arcadia methodology and look at how it is best and most efficiently implemented on a SysML v2 foundation.
- **P2 Interoperability.** One of the reasons for P1: the models must remain usable in other tools (simulation, analysis, verification, etc.).
- **P3 Minimal semantic layer.** The library adds only what is essential to Arcadia: the Arcadia Essential Core Concepts (Function, Component, Exchange…) and the few properties they need (for example `isActor`, `isHuman`). This layer exists so that users and tool providers can easily recognize and manipulate Arcadia models; it is kept minimal because every addition moves the models away from a standard use of SysML v2 (P1).
- **P4 Native Capella usage.** We do not reproduce, and do not migrate, concepts that are very rarely used or not used at all in native Capella.
- **P5 Migration.** Migrating Capella models to SysML v2 remains possible, even if it is harder than with a one-to-one mapping. It yields to P1 and P2.
- **P6 Generic concepts.** Generic concepts (Function, Component, Port) rather than engineering-perspective–specific ones, to ease tooling and the move or copy of elements between perspectives.

## Open points register

All the points that are not decided or not covered yet are listed here, and only here. The sections refer to them by their identifier.

| ID | Subject | Section | Owner | Issue |
| --- | --- | --- | --- | --- |
| OP-EPBS | EPBS perspective: only its place in the default model structure exists | Default model structure | SLA | — |
| OP-ID | Identifiers of Capella elements (`id`, `sid`): kept, for example for the traceability of a migration, or not translated? | ArcadiaElement | SLA | — |
| OP-CONSTRAINTS | Constraints attached to elements (free text, guards of transitions, scenarios) | ArcadiaElement | SLA | — |
| OP-PKG-FIELDS | Are the description and status fields of Capella packages really used? | Packages | SLA, with TGS | — |
| OP-PKG-IN-COMPONENT | Interface, data and capability packages owned by a component: allowed by the Capella metamodel, not described here. What tells such a package from a component package, and what can it contain? | Packages | SLA | — |
| OP-PV-ENUM | Enumeration property values (a value chosen in a user-defined list) | Property values | SLA | — |
| OP-PV-SHARED | Shared property values: values defined in a Property Value Pkg and applied to elements by reference | Packages, Property values | SLA | — |
| OP-KIND | Kind of a Physical Component: not translated, or an optional attribute? | Component | SLA | — |
| OP-REC | Reuse of elements (REC/RPL, definitions and usages), abstract and generalized components | Component | SLA | — |
| OP-SUBPARTS | Restrict `subparts` to components (`ref part subparts[*] : Component :>> subparts;`). It would also give tools an indication to leave the views out of the sub-components | Component, Views | SLA, with TWE | — |
| OP-DEPLOY-OTHER | Other deployment classes of the Capella metamodel (`InstanceDeploymentLink`, `TypeDeploymentLink`, `DeploymentAspect`, `DeploymentConfiguration`): to be translated or not? | Deployment | SLA | — |
| OP-PHYS | Physical Links and Physical Ports of Node Components, Physical Paths | Node and Behavior Components | SLA | — |
| OP-SCENARIOS | Scenarios, and their relationship with Functional Chains (keep separate, merge or unify?) | Function | SLA | — |
| OP-ROUTING | Routing functions (Duplicate, Split, Gather, Route, Select) translated to control nodes: the syntax is accepted by the pilot implementation, but (1) the ends of a `FunctionalExchange` are typed `Function` and a control node is not a `Function`, and (2) there is no obvious place for the condition of a Route or Select function when the node only routes data flows. Alternative: keep them as ordinary functions | Function | SLA | — |
| OP-INOUT | Should `inout` parameters be allowed on functions? | Function Port | SLA | — |
| OP-FC-JUNCTION | A link between two involvements of the same Function gives no succession: to be validated | Functional Chain | SLA, with TWE | — |
| OP-FC-REPEAT | A chain that references the same chain several times is not handled | Functional Chain | SLA | — |
| OP-FC-TRACE | Capella trace objects of Functional Chains (control flow): is the solution based on successions sufficient? | Functional Chain | SLA | — |
| OP-FC-CONTEXT | "Exchange Context" property of the Functional Chain Involvement Link | Functional Chain | SLA | — |
| OP-FC-KIND | Kind field of Functional Chains (SIMPLE, COMPOSITE, FRAGMENT): probably rarely used, to be confirmed | Functional Chain | SLA | — |
| OP-FC-COMPONENTS | Derived relationship giving the components involved in a Functional Chain | Functional Chain | SLA | — |
| OP-CATEGORIES | Exchange categories (functional and component exchanges) | Functional Exchange, Component Exchange | SLA | #33 |
| OP-CE-KIND | Kind of a Component Exchange (ASSEMBLY, DELEGATION, FLOW) and delegation | Component Exchange | SLA | #34 |
| OP-PORT-DIR | Direction of a Component Port: stored, computed or used as a check? | Component Port | SLA | — |
| OP-PORT-ALLOC-TYPE | `allocatedFunctionPorts` of `ComponentPort` is typed by `ExchangeItem`: its name says function ports, its type says exchange items. Rename it, retype it, or keep it? | Component Port | SLA | — |
| OP-INTERFACES | Interfaces, provided and required interfaces, and their impact on Component Ports | Component Port | SLA | — |
| OP-DATA | Data modeling and the fields of Exchange Items (exchange mechanism, exchange item elements), and the "Predefined Types" package created by default in Data | Exchange Item | SLA | — |
| OP-CAP | Capabilities: pre and post conditions, inheritance, extends and includes | Capability | SLA | #35 |
| OP-MISSION | Missions: only in System Analysis? | Mission | SLA | — |
| OP-MODES | Modes and States | (no section yet) | SLA | — |
