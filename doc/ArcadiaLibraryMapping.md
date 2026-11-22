# SysML v2 Arcadia Library mappings

## Contents

- [Introduction](#introduction)
- [Purpose and audience](#purpose-and-audience)
- [How to read this document](#how-to-read-this-document)
- [Design principles](#design-principles)
- [Open points register](#open-points-register)
- Concepts and mappings, with the prefix of their row identifiers
  1. [ArcadiaElement](mapping/01-ArcadiaElement.md) (`ELEM`) – example: [arcadia-element.sysml](../examples/concepts/arcadia-element.sysml)
  2. [ArcadiaPackage](mapping/02-ArcadiaPackage.md) (`PKGM`) – example: [arcadia-package.sysml](../examples/concepts/arcadia-package.sysml)
  3. [Default model structure](mapping/03-DefaultModelStructure.md) (`STRUCT`) – example: [default-structure.sysml](../examples/concepts/default-structure.sysml)
  4. [Packages](mapping/04-Packages.md) (`PKG`) – example: [packages.sysml](../examples/concepts/packages.sysml)
  5. [Component](mapping/05-Component.md) (`COMP`) – example: [component.sysml](../examples/concepts/component.sysml)
  6. [Node and Behavior Components](mapping/06-NodeAndBehaviorComponents.md) (`NODE`) – example: [node-behavior.sysml](../examples/concepts/node-behavior.sysml)
  7. [Deployment](mapping/07-Deployment.md) (`DEPL`) – example: [node-behavior.sysml](../examples/concepts/node-behavior.sysml)
  8. [Function](mapping/08-Function.md) (`FUNC`) – example: [function.sysml](../examples/concepts/function.sysml)
  9. [Function Port](mapping/09-FunctionPort.md) (`FPORT`) – example: [function.sysml](../examples/concepts/function.sysml)
  10. [Functional Chain](mapping/10-FunctionalChain.md) (`FC`) – example: [functional-chain.sysml](../examples/concepts/functional-chain.sysml)
  11. [Functional Exchange](mapping/11-FunctionalExchange.md) (`FE`) – example: [exchanges.sysml](../examples/concepts/exchanges.sysml)
  12. [Component Exchange](mapping/12-ComponentExchange.md) (`CE`) – example: [exchanges.sysml](../examples/concepts/exchanges.sysml)
  13. [Component Port](mapping/13-ComponentPort.md) (`CP`) – example: [exchanges.sysml](../examples/concepts/exchanges.sysml)
  14. [Exchange Allocation](mapping/14-ExchangeAllocation.md) (`EA`) – example: [exchanges.sysml](../examples/concepts/exchanges.sysml)
  15. [Realization](mapping/15-Realization.md) (`REAL`) – example: [realization.sysml](../examples/concepts/realization.sysml)
  16. [Exchange Item](mapping/16-ExchangeItem.md) (`EI`) – example: [exchange-item.sysml](../examples/concepts/exchange-item.sysml)
  17. [Requirements](mapping/17-Requirements.md) (`REQ`) – example: [requirements.sysml](../examples/concepts/requirements.sysml)
  18. [Capability](mapping/18-Capability.md) (`CAP`) – example: [capability.sysml](../examples/concepts/capability.sysml)
  19. [Mission](mapping/19-Mission.md) (`MIS`) – example: [capability.sysml](../examples/concepts/capability.sysml)
  20. [Property values](mapping/20-PropertyValues.md) (`PV`) – example: [property-values.sysml](../examples/concepts/property-values.sysml)
  21. [Views](mapping/21-Views.md) (`VIEW`) – example: [views.sysml](../examples/concepts/views.sysml)

## Introduction

Arcadia is a model-based systems engineering (MBSE) method. It guides engineers through the analysis, the design and the validation of complex systems, with a structured approach based on engineering perspectives. Capella is the open-source desktop modeling workbench that implements Arcadia: it provides dedicated diagrams, automation and methodological guidance to build consistent system architectures.

The Arcadia SysML v2 library provides an implementation of the Arcadia method in SysML v2. It captures the core Arcadia concepts, such as components, functions, exchanges and capabilities, in line with the SysML v2 language and its reuse mechanisms. Used with appropriate tooling, it brings to SysML v2 the abstraction, the simplification and the methodological guidance of Arcadia.

This document is aligned with Arcadia SysML v2 library version 0.1.0.

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

Every example of this document is taken from a model file of the `examples/concepts` folder, validated with the SysML v2 pilot implementation. The Contents and each section link to its file. Comments in the examples refer to the row identifiers of the mapping table. `examples/optical-mouse.sysml` remains the complete reference model.

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
| <a id="op-epbs"></a>[OP-EPBS](mapping/03-DefaultModelStructure.md#open-points) | EPBS perspective: only its place in the default model structure exists | [Default model structure](mapping/03-DefaultModelStructure.md#open-points) | SLA | — |
| <a id="op-id"></a>[OP-ID](mapping/01-ArcadiaElement.md#open-points) | Identifiers of Capella elements (`id`, `sid`): kept, for example for the traceability of a migration, or not translated? | [ArcadiaElement](mapping/01-ArcadiaElement.md#open-points) | SLA | — |
| <a id="op-constraints"></a>[OP-CONSTRAINTS](mapping/01-ArcadiaElement.md#open-points) | Constraints attached to elements (free text, guards of transitions, scenarios) | [ArcadiaElement](mapping/01-ArcadiaElement.md#open-points) | SLA | — |
| <a id="op-pkg-fields"></a>[OP-PKG-FIELDS](mapping/04-Packages.md#open-points) | Are the description and status fields of Capella packages really used? | [Packages](mapping/04-Packages.md#open-points) | SLA, with TGS | — |
| <a id="op-pkg-in-component"></a>[OP-PKG-IN-COMPONENT](mapping/04-Packages.md#open-points) | Interface, data and capability packages owned by a component: allowed by the Capella metamodel, not described here. What tells such a package from a component package, and what can it contain? | [Packages](mapping/04-Packages.md#open-points) | SLA | — |
| <a id="op-pv-enum"></a>[OP-PV-ENUM](mapping/20-PropertyValues.md#open-points) | Enumeration property values (a value chosen in a user-defined list) | [Property values](mapping/20-PropertyValues.md#open-points) | SLA | — |
| <a id="op-pv-shared"></a>[OP-PV-SHARED](mapping/04-Packages.md#open-points) | Shared property values: values defined in a Property Value Pkg and applied to elements by reference | [Packages](mapping/04-Packages.md#open-points), [Property values](mapping/20-PropertyValues.md#open-points) | SLA | — |
| <a id="op-kind"></a>[OP-KIND](mapping/05-Component.md#open-points) | Kind of a Physical Component: not translated, or an optional attribute? | [Component](mapping/05-Component.md#open-points) | SLA | — |
| <a id="op-rec"></a>[OP-REC](mapping/05-Component.md#open-points) | Reuse of elements (REC/RPL, definitions and usages), abstract and generalized components | [Component](mapping/05-Component.md#open-points) | SLA | — |
| <a id="op-subparts"></a>[OP-SUBPARTS](mapping/05-Component.md#open-points) | Restrict `subparts` to components (`ref part subparts[*] : Component :>> subparts;`). It would also give tools an indication to leave the views out of the sub-components | [Component](mapping/05-Component.md#open-points), [Views](mapping/21-Views.md#open-points) | SLA, with TWE | — |
| <a id="op-deploy-other"></a>[OP-DEPLOY-OTHER](mapping/07-Deployment.md#open-points) | Other deployment classes of the Capella metamodel (`InstanceDeploymentLink`, `TypeDeploymentLink`, `DeploymentAspect`, `DeploymentConfiguration`): to be translated or not? | [Deployment](mapping/07-Deployment.md#open-points) | SLA | — |
| <a id="op-phys"></a>[OP-PHYS](mapping/06-NodeAndBehaviorComponents.md#open-points) | Physical Links and Physical Ports of Node Components, Physical Paths | [Node and Behavior Components](mapping/06-NodeAndBehaviorComponents.md#open-points) | SLA | — |
| <a id="op-scenarios"></a>[OP-SCENARIOS](mapping/08-Function.md#open-points) | Scenarios, and their relationship with Functional Chains (keep separate, merge or unify?) | [Function](mapping/08-Function.md#open-points) | SLA | — |
| <a id="op-routing"></a>[OP-ROUTING](mapping/08-Function.md#open-points) | Routing functions (Duplicate, Split, Gather, Route, Select) translated to control nodes: the syntax is accepted by the pilot implementation, but (1) the ends of a `FunctionalExchange` are typed `Function` and a control node is not a `Function`, and (2) there is no obvious place for the condition of a Route or Select function when the node only routes data flows. Alternative: keep them as ordinary functions | [Function](mapping/08-Function.md#open-points) | SLA | — |
| <a id="op-inout"></a>[OP-INOUT](mapping/09-FunctionPort.md#open-points) | Should `inout` parameters be allowed on functions? | [Function Port](mapping/09-FunctionPort.md#open-points) | SLA | — |
| <a id="op-fc-junction"></a>[OP-FC-JUNCTION](mapping/10-FunctionalChain.md#open-points) | A link between two involvements of the same Function gives no succession: to be validated | [Functional Chain](mapping/10-FunctionalChain.md#open-points) | SLA, with TWE | — |
| <a id="op-fc-repeat"></a>[OP-FC-REPEAT](mapping/10-FunctionalChain.md#open-points) | A chain that references the same chain several times is not handled | [Functional Chain](mapping/10-FunctionalChain.md#open-points) | SLA | — |
| <a id="op-fc-trace"></a>[OP-FC-TRACE](mapping/10-FunctionalChain.md#open-points) | Capella trace objects of Functional Chains (control flow): is the solution based on successions sufficient? | [Functional Chain](mapping/10-FunctionalChain.md#open-points) | SLA | — |
| <a id="op-fc-context"></a>[OP-FC-CONTEXT](mapping/10-FunctionalChain.md#open-points) | "Exchange Context" property of the Functional Chain Involvement Link | [Functional Chain](mapping/10-FunctionalChain.md#open-points) | SLA | — |
| <a id="op-fc-kind"></a>[OP-FC-KIND](mapping/10-FunctionalChain.md#open-points) | Kind field of Functional Chains (SIMPLE, COMPOSITE, FRAGMENT): probably rarely used, to be confirmed | [Functional Chain](mapping/10-FunctionalChain.md#open-points) | SLA | — |
| <a id="op-fc-components"></a>[OP-FC-COMPONENTS](mapping/10-FunctionalChain.md#open-points) | Derived relationship giving the components involved in a Functional Chain | [Functional Chain](mapping/10-FunctionalChain.md#open-points) | SLA | — |
| <a id="op-transition-traces"></a>[OP-TRANSITION-TRACES](mapping/15-Realization.md#open-points) | Transition traces: the generic trace (`capellacommon::TransfoLink`) that a Capella transition keeps between a transitioned element and its source, for the elements that have no dedicated realization link (allocations, involvements in functional chains, exchange categories, constraints...). To be treated with the transitions between perspectives | [Realization](mapping/15-Realization.md#open-points), [Functional Exchange](mapping/11-FunctionalExchange.md#open-points) | SLA | — |
| <a id="op-ce-kind"></a>[OP-CE-KIND](mapping/12-ComponentExchange.md#open-points) | Kind of a Component Exchange (ASSEMBLY, DELEGATION, FLOW) and delegation | [Component Exchange](mapping/12-ComponentExchange.md#open-points) | SLA | [#34](https://github.com/eclipse-capella/arcadia-sysmlv2-lib/issues/34) |
| <a id="op-port-dir"></a>[OP-PORT-DIR](mapping/13-ComponentPort.md#open-points) | Direction of a Component Port: stored, computed or used as a check? | [Component Port](mapping/13-ComponentPort.md#open-points) | SLA | — |
| <a id="op-port-alloc-type"></a>[OP-PORT-ALLOC-TYPE](mapping/13-ComponentPort.md#open-points) | `allocatedFunctionPorts` of `ComponentPort` is typed by `ExchangeItem`: its name says function ports, its type says exchange items. Rename it, retype it, or keep it? | [Component Port](mapping/13-ComponentPort.md#open-points) | SLA | — |
| <a id="op-interfaces"></a>[OP-INTERFACES](mapping/13-ComponentPort.md#open-points) | Interfaces, provided and required interfaces, and their impact on Component Ports | [Component Port](mapping/13-ComponentPort.md#open-points) | SLA | — |
| <a id="op-data"></a>[OP-DATA](mapping/16-ExchangeItem.md#open-points) | Data modeling and the fields of Exchange Items (exchange mechanism, exchange item elements), and the "Predefined Types" package created by default in Data | [Exchange Item](mapping/16-ExchangeItem.md#open-points) | SLA | — |
| <a id="op-cap"></a>[OP-CAP](mapping/18-Capability.md#open-points) | Capabilities: pre and post conditions, inheritance, extends and includes | [Capability](mapping/18-Capability.md#open-points) | SLA | [#35](https://github.com/eclipse-capella/arcadia-sysmlv2-lib/issues/35) |
| <a id="op-mission"></a>[OP-MISSION](mapping/19-Mission.md#open-points) | Missions: only in System Analysis? | [Mission](mapping/19-Mission.md#open-points) | SLA | — |
| <a id="op-modes"></a>OP-MODES | Modes and States | (no section yet) | SLA | — |
