# SysML v2 Arcadia Library mappings

## Introduction

Arcadia is a model-based systems engineering (MBSE) method that guides engineers in the analysis, design, and validation of complex systems through a structured, viewpoint-driven approach. Capella is the open-source modeling desktop workbench that implements Arcadia, providing dedicated diagrams, automation, and methodological guidance to help teams collaboratively build consistent and high-quality system architectures. Together, Arcadia and Capella accelerate engineering processes, reduce risks, and improve communication across all stakeholders.

The Arcadia SysML v2 library provides an implementation of the Arcadia methodology in SysML v2. It captures core Arcadia concepts such as components, functions, exchanges, and requirements in a way that aligns with the SysML v2 metamodel and reuse mechanisms. It is envisioned that this library, in conjunction with appropriate tooling, will bring an abstraction and simplification layer to SysML v2, along with methodological guidelines, thereby streamlining SysML v2 usage for a broader audience.

## Objectives of this file

- introduce the rationale and main choices driving the development of this library
- provide a list of Arcadia concepts, their meanings, and how they are implemented in the library
- provide equivalences between the Arcadia implementation in Capella Desktop and the SysML v2 library
- provide approximate indications on how elements are intended to be graphically represented

## Rationale used for the development of Arcadia SysML v2 library

- Our main driver for designing this library is to ensure that models produced using it are as close as possible to models that would be produced without the library. The rationale is to keep these models as interoperable as possible with other tools (simulation, analysis, verification, etc.). In other words, when considering Arcadia concepts, we aim to identify their most natural equivalents in SysML v2, rather than developing an extensive Arcadia-specific library that maps one-to-one to the Capella implementation and results in overly “Arcadia-colored” SysML v2 models.
- Nevertheless, we aim to strike a balance so that users and tool providers can easily understand and manipulate these models. For this reason, the Arcadia library will include a minimal but essential set of core Arcadia concepts such as Functions, Components, and Exchanges. Another way to say this is that we want this Arcadia library to act as a minimal and essential semantic layer for Arcadia on top of the SysML v2 language
- We acknowledge that this approach may make migration from Capella (Desktop) models to SysML v2 models more challenging. However, enabling such automated migration remains within our scope.
- We do not aim to support the full detailed and technical Capella Desktop metamodel. Based on more than 15 years of Capella usage worldwide, we focus on the concepts that are actually used by the community.
- We choose to rely on generic concepts (Functions, Components, Ports) rather than engineering-perspective–specific concepts (e.g., Logical Functions, Physical Functions) in order to facilitate tooling implementation and reuse, such as moving or copying functions from one engineering perspective to another.
- the EPBS engineering perspective has not been worked on yet: only its place in the default model structure exists, and it is expected to be covered later.

## Key Concepts & Mappings

The `Library extract` blocks are copies of `lib/arcadia.sysml`. The code snippets of the `Example` column and of the `Additional Information` paragraphs are abbreviated: names are given without their full path (for instance `'Capture Movement'` stands for `'Root Function'.'Capture Movement'`) and the lists of Exchange Items are shortened. The complete, validated reference is `examples/optical-mouse.sysml`.

### `ArcadiaElement` OccurrenceDefinition

#### Library extract

```
    abstract occurrence def ArcadiaElement {
    	private doc /* Reusable structure shared by all Arcadia elements.*/
    }
```

#### Mappings

| Concept in v2 library                  | Concept in SysML v2                                             | Capella desktop implementation            | Concept meaning                                                                         | Rationale                                                                                                                                                                                                                               | Example                                                                | Representation                                                                             |
| -------------------------------------- | --------------------------------------------------------------- | ----------------------------------------- | --------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------- | ------------------------------------------------------------------------------------------ |
| abstract occurrence def ArcadiaElement | N/A                                                             | Complex inheritance hierarchy             | N/A                                                                                     | Top level abstract element for reuse among all elements                                                                                                                                                                                 | part def Component :> ArcadiaElement                                   | N/A                                                                                        |
| (not translated)                       | (not translated)                                                | (Attribute) summary                       | short description of an element                                                         | Field rarely used, hence not reproduced in v2                                                                                                                                                                                           | N/A                                                                    | N/A                                                                                        |
| (not translated)                       | (not translated)                                                | (Attribute) Visible in Documentation      | self explanatory                                                                        | Legacy field, hence not reproduced in v2                                                                                                                                                                                                | N/A                                                                    | N/A                                                                                        |
| (not translated)                       | (not translated)                                                | (Attribute) Visible for Traceability      | self explanatory                                                                        | Legacy field, hence not reproduced in v2                                                                                                                                                                                                | N/A                                                                    | N/A                                                                                        |
| None                                   | name                                                            | name                                      | name of an element                                                                      | Reusing SysML v2 concept                                                                                                                                                                                                                | N/A                                                                    | Label typically displayed on nodes and edges on diagrams, name field in the property views |
| None                                   | doc description /\* \*/                                         | description                               | Full richtext description of an element (HTML)                                          | Reusing SysML v2 concept, more information below                                                                                                                                                                                        | doc description /_Captures surface movement using optical detection._/ | Richtext description in property views                                                     |
| None                                   | (Metadata Annotation) @StatusInfo                               | Progress Status                           | Used to manage the review status of model elements                                      | Reusing SysML v2 concept - see below                                                                                                                                                                                                    | @StatusInfo {status = StatusKind::tbd;}                                | Displayed as a dropdown box in the property view of any element                            |
| None                                   | attribute usages                                                | Property Values and Property Value Groups | User-defined values attached to any element                                             | Reusing SysML v2 concept - see "Property values" below                                                                                                                                                                                  | attribute 'Mass' = 0.4 [kg];                                           | Property values section of the property view                                               |
| (not translated)                       | (not translated)                                                | (Attribute) Review Text                   | Used to provide information related to reviews                                          | Field rarely used and not sufficient for review mgmt, hence not reproduced in v2                                                                                                                                                        | N/A                                                                    | N/A                                                                                        |
| None (derived by tooling)              | `Realization` allocations whose `realizing` end is this element | realizedXxx (derived references)          | Elements of the previous engineering perspective realized by this element               | Realization is a key concept in Arcadia. In Capella these references are derived from the owned realization objects, the same approach is used here: the link is stored once, as a `Realization` allocation (see `Realization` section) | see `Realization` section                                              | property view ("Realized ..."), Related Elements                                           |
| None (derived by tooling)              | `Realization` allocations whose `realized` end is this element  | realizingXxx (derived references)         | inverse navigation: elements of the next engineering perspective realizing this element | see above                                                                                                                                                                                                                               | see `Realization` section                                              | property view ("Realizing ...")                                                            |

#### Additional Information:

- The richtext description field used in Capella is mapped to the doc feature by naming it 'doc description /\* \*/' - there may be multiple doc strings attached to a given model element, the one used to store the richtext description should be named accordingly. Note: when migrating from Capella to v2, actual images needs to be taken into account
- Default progress status values in Capella are DRAFT, TO BE REVIEWED, TO BE DISCUSSED, REWORK NECESSARY, UNDER REWORK, REVIEWED, we propose the following mapping by default DRAFT = tbd, TO BE REVIEWED = tbr, TO BE DISCUSSED = tbc, REWORK NECESSARY = open, UNDER REWORK = open, REVIEWED = done - Please note that projects may have defined their own progress Status values, requiring a specific management when doing a transformation from Capella (see next point)
- At this stage, enums in SysML v2 libraries cannot be redefined. This may be addressed in a future version of the SysML v2 standard. So this means that if a project wants to define its own progress statuses, it would have to redefine its own enum of statuses
- We use the abstract keyword here as this is a high level element. We won't use the abstract keyword on other elements (Component, Function) as this would prevent from using the semantic metadata for these elements. Note: for the moment, we do not have defined semantic metadata for all these elements, by choice. The notation would allow to write "#component part myComponent" instead of "part myComponent : Component". We consider that it does not bring a lot of value for the end user, and are not sure how tool will handle semantic metadata and when

- The former `realizes` / `isRealizedBy` references have been replaced by `Realization` allocations (see the `Realization` section). The question of typing these relationships is answered there: one single generic allocation, typed by tooling rules rather than by library specializations. Physical Nodes in Arcadia do not have realization relationships: this is to be managed by tooling.

### `ArcadiaPackage` metadata

#### Library extract

```
    metadata def ArcadiaPackage {
		private doc /* Used to annotate the top-level element of an Arcadia model and its engineering perspective packages (OA, SA, LA, PA, EPBS) */
		:> annotatedElement : SysML::Package;
		:> annotatedElement : SysML::OccurrenceDefinition;
		enum engineeringPerspective : ArcadiaEngineeringPerspective;
     }

	enum def ArcadiaEngineeringPerspective :> String {
    	private doc /* flag to indicate which engineering perspective you're in.*/
       	enum OperationalAnalysis = "Operational Analysis";
       	enum SystemAnalysis = "System Analysis";
       	enum LogicalArchitecture = "Logical Architecture";
       	enum PhysicalArchitecture = "Physical Architecture";
       	enum EPBS = "EPBS Physical Architecture";
      	enum Generic = "Generic";
       	enum SystemEngineering = "System Engineering";
  	}
```

#### Mappings

| Concept in v2 library                            | Concept in SysML v2 | Capella desktop implementation | Concept meaning                                                                                                                                                                  | Rationale                     | Example                                                                                                | Representation |
| ------------------------------------------------ | ------------------- | ------------------------------ | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------------- | ------------------------------------------------------------------------------------------------------ | -------------- |
| metadata def ArcadiaPackage                      | None                | N/A                            | annotate the top-level element of the model and the packages of the engineering perspectives (OA, SA, LA, PA, EPBS) with the Arcadia perspective; not used on the other packages | see overall library rationale | metadata ArcadiaPackage {engineeringPerspective = ArcadiaEngineeringPerspective::LogicalArchitecture;} | N/A            |
| enum def ArcadiaEngineeringPerspective :> String | N/A                 | N/A                            | List of Arcadia engineering perspectives, see below.                                                                                                                             | see overall library rationale | see above                                                                                              | N/A            |

#### Additional Information:

- "Generic" may be used as a non-specified engineering perspective. "System Engineering" corresponds to the top level element of the model.

### `Arcadia default model structure`

#### Library extract

```
Not Applicable
```

#### Mappings

| Concept in v2 library | Concept in SysML v2     | Capella desktop implementation | Concept meaning                                         | Rationale                      | Example   | Representation                           |
| --------------------- | ----------------------- | ------------------------------ | ------------------------------------------------------- | ------------------------------ | --------- | ---------------------------------------- |
| None                  | default model structure | default model structure        | default model structure of all Arcadia/Capella projects | See below for more information | See below | Mostly represented in the tree structure |

#### Additional Information:

- In SysML v2, Packages are not based on the KerML concepts Classifier and Feature. Hence there are no Package Definition that we could define in the library and reuse in Capella models. As a consequence, it is up to the tooling to create the default package structure for a given Capella project. This structure is given in the file ArcadiaDefaultStructure.SysML
- Usages (Parts, Actions...) are contained in packages, as in the SysML v2 reference models (OMG training, Annex A, OOSEM v2, Apollo 11). In SysML v2, a usage that is contained only by a package is implicitly featured by `Anything` (with 0..\* cardinality by default): a value for it is available within any instance of any type. The library first tried to avoid this by making the top level model element an Occurrence Definition containing the packages, but this does not work: a package nested in a definition does not make its usages features of that definition (checked with the pilot implementation 0.63.1: the usages of the `Functions`, `Structure`... packages have the package as owner and no featuring type). Avoiding it completely would mean giving up the Arcadia packages (Functions, Structure...) and the nested Capella packages, so it is accepted as a known limitation of SysML v2 rather than a modeling choice of this library. It may be revisited if the specification evolves. The top level Occurrence Definition is kept: it gives a name, a short name and a namespace to the model, and carries the `ArcadiaPackage` annotation. We keep the Arcadia Engineering perspectives as packages.
- **Default realizations**: a new Capella project already contains the realization links between the root elements of consecutive perspectives (checked on a project created with Capella Desktop: Root System Function realizes Root Operational Activity, Root Logical Function realizes Root System Function, Root Physical Function realizes Root Logical Function, Logical System realizes System, Physical System realizes Logical System, and the EPBS System configuration item realizes Physical System). The default structure creates the same links as `Realization` allocations (see the `Realization` section): `'Root Function'` SA→OA, LA→SA, PA→LA, and `system` LA→SA, PA→LA, EPBS→PA. There is no `system` allocation in SA because there is no root component in OA in Capella. The EPBS `'Root Function'` of the file has no Capella counterpart and has no allocation. Consequence for tooling: the creation of a project must generate these allocations, so that the initial model is the same as in Capella Desktop.
- Capella also creates realization links between the architectures themselves (for example System Analysis realizes Operational Analysis). They cannot be expressed with `Realization`, whose ends are features and not packages: not covered, to be discussed separately.
- In line with our general rationale, all second level sub-packages have been standardized across all engineering perspectives (this may evolve in the future):

```
 		package Functions;
		package Capabilities;
		package Interfaces;
		package Data;
		package Structure;
		package Requirements;
```

- The meta-data elements defined in the previous section annotates the Arcadia engineering perspectives. Example:

```
	package <OA> 'Operational Analysis' {
		metadata ArcadiaPackage {engineeringPerspective = ArcadiaEngineeringPerspective::OperationalAnalysis;}
	}
```

- the Functions and Structure packages have by default a root action and part (except the Structure package of OA: Capella has no root component in OA). It is up to the tooling to prevent creating actions at the same level, or parts (unless they are Actors).
- The Top level element of the model "occurrence def <My_Model_Short_Name> 'My Model Name' {" has a shortname, as this may be useful for referencing elements with their namespaces across models. Nevertheless, while the short names of Arcadia engineering perspectives are hardcoded (OA/SA/LA...), it is not the case for the top level element: this would lead to duplicate short names, ie namespaces conflict resolutions. The name and short name of the top level model element has to be given by the user when creating a Capella project

### Capella Packages (`*Pkg`) (no library concept)

#### Library extract

```
None: a Capella package is a plain SysML v2 package, wherever it sits in Capella: nested in the second-level package that matches its content (Functions, Capabilities, Interfaces, Data, Structure, Requirements), in another package, in a function or in a component.
```

#### Mappings

| Concept in v2 library | Concept in SysML v2 | Capella desktop implementation                                                                              | Concept meaning                                                              | Rationale | Example                                                                           | Representation                           |
| --------------------- | ------------------- | ----------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------- | --------- | --------------------------------------------------------------------------------- | ---------------------------------------- |
| None                  | package             | Operational Activity Pkg / System Function Pkg / Logical Function Pkg / Physical Function Pkg (FunctionPkg) | Organizes functions; can be owned by a package or by a function              | See below | package 'Power Management' { action 'Manage Power' : Function; }                  | A folder node in the model explorer tree |
| None                  | package             | Operational Capability Pkg / Capability Pkg / Capability Realization Pkg / Mission Pkg                      | Organizes capabilities and missions                                          | See below | package 'Maintenance';                                                            | Same as above                            |
| None                  | package             | Interface Pkg                                                                                               | Organizes interfaces and exchange items                                      | See below | package 'User Interfaces';                                                        | Same as above                            |
| None                  | package             | Data Pkg                                                                                                    | Organizes classes, data types, collections, units, signals and messages      | See below | package 'Status Data' { item batteryLevel : ExchangeItem; }                       | Same as above                            |
| None                  | package             | Entity Pkg / System Component Pkg / Logical Component Pkg / Physical Component Pkg                          | Organizes components and actors; can be owned by a package or by a component | See below | package 'External Actors' { part technician : Component { :>> isActor = true; } } | Same as above                            |

#### Additional Information:

- In the Capella metamodel, all these packages are Structures mapped to UML Packages: pure organizational elements, which can contain sub-packages of the same kind. The native SysML v2 equivalent is the package, so no library concept is needed.
- The kind of a Capella package is not stored in the SysML v2 model. Tooling may display all packages identically (one folder representation), which is simpler and faster. What a package can contain follows from where it is: the second-level package in which it is nested, or the function or component that owns it. Tooling can restrict its content accordingly, as already done for `Functions` and `Structure`.
- In Capella, functions own function packages and components own component packages (`OperationalActivity`, `SystemFunction`, `LogicalFunction`, `PhysicalFunction`, `SystemComponent`, `LogicalComponent`, `PhysicalComponent`; see the Capella metamodel). The same native package is used: it is nested in the body of the action or of the part (checked with the SysML v2 pilot implementation 0.63.1). See `'Motion Filtering'` and `'Mechanical Parts'` in the example.
- The Capella rule that Data, Interface and Mission packages can only be created under other packages is not enforced in Capella for SysON: for simplicity and homogeneity, any package can be created where a package is allowed.
- Description, status and the other fields of a Capella element are rarely used on these packages. A SysML v2 package cannot be specialized, so no dedicated element can be defined in the library (the same limitation applies to the packages of the engineering perspectives). If these fields are needed, a model can carry a `doc description /* ... */` and the standard `@StatusInfo` metadata on any package, and the tooling can cover them.
- Choosing the plain package limits what is put in the library and keeps the models as close as possible to a classical use of SysML v2. This choice can be revisited later, but it is not expected to be.
- A package is not annotated with `ArcadiaPackage`: its engineering perspective is given by the closest enclosing package annotated with `ArcadiaPackage` (same principle as for components).
- Capella packages that are not mapped: Role Pkg (roles are not mapped, see "Allocated Roles" below), Concept Pkg (operational concepts are not in the library), Configuration Item Pkg (EPBS), Generic Pkg and Property Value Pkg.
- Elements contained in a package are, for functions, components and capabilities, usages directly owned by a package, which is the situation the default structure tries to avoid (see "default model structure" above). This is accepted here, as it is the usual SysML v2 practice (OMG training, Annex A, Apollo 11); it is a limitation of the SysML v2 specification rather than a modeling choice of this library.
- A package nested in an action or a part does not make its elements features of that action or part: checked with the pilot, `'Filter Noise'` in `'Root Function'::'Motion Filtering'` has no featuring type, unlike a sub-action declared directly in `'Root Function'`. The nesting is a namespace (`'Root Function'::'Motion Filtering'::'Filter Noise'`). In Capella the functions of a function package of a function are its sub-functions (derived `subFunctions` of the metamodel: functions owned directly, plus those owned by its packages and sub-packages), so the tooling derives the sub-functions the same way: direct sub-actions, plus the actions of its nested packages. The same applies to the components of a component package: the sub-components of a component are the usages it owns directly plus those owned by its packages and sub-packages. In Capella, the derived `subLogicalComponents` and `subPhysicalComponents` only consider the parts owned directly by the component, whereas the component breakdown of the Semantic Browser also goes through component packages; this library follows the latter.
- TODO: ask Thales whether the description and status fields of Capella packages are really used (owner: Obeo, with Thales).

### `Component` PartDefinition

#### Library extract

```
	part def Component :> ArcadiaElement {
		private doc /* A generic Arcadia component, used across all Arcadia engineering perspectives. */
    	attribute isActor : Boolean default false;
    	attribute isHuman : Boolean default false;
    	alias allocatedFunctions for performedActions;
		alias subComponents for subparts;
	}
```

#### Mappings

| Concept in v2 library                         | Concept in SysML v2             | Capella desktop implementation                                                           | Concept meaning                                                                                                                | Rationale                                                                                                                                                                                                                                        | Example                                       | Representation                                                                                                                 |
| --------------------------------------------- | ------------------------------- | ---------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | --------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------ |
| part def Component :> ArcadiaElement          | None                            | Operational Entity and Actor / System Component / Logical Component / Physical Component | a constituent of the system or an external entity                                                                              | Reusing SysML v2 concept, Components are Parts Definitions by essence.                                                                                                                                                                           | part 'Optical Sensor Unit' : Component        | Generally represented as blue or yellow nodes                                                                                  |
| attribute isActor : Boolean default false     | None                            | (Attribute) isActor                                                                      | Indicates whether the component is internal or external to the SOI                                                             | Additional attribute needed for Arcadia support                                                                                                                                                                                                  | :>> isActor = true                            | A checkbox in the property view that changes the component icon and its background color                                       |
| attribute isHuman : Boolean default false     | None                            | (Attribute) isHuman                                                                      | Indicates whether the component is a human                                                                                     | Additional attribute needed for Arcadia support                                                                                                                                                                                                  | :>> isHuman = true                            | A checkbox in the property view that changes the component icon                                                                |
| None (expressed by typing)                    | None                            | (Attribute) physicalComponentNature                                                      | Differentiate a Physical Node from a Physical Behavior (applies only to Physical Components)                                   | Not an attribute: in the Physical Architecture a component is either a Node or a Behavior (except the root component of the architecture), and this is expressed by the type of the component, see `NodeComponent` and `BehaviorComponent` below | part 'Mouse PCB' : NodeComponent              | N/A                                                                                                                            |
| None                                          | None                            | (Enum) physicalComponentKind                                                             | Indicates the type of Component the component (applies only to Physical Components)                                            | In Capella, this is a hardcoded list. Projects tend to create their own with Property values. To be migrated to specific attributes depending on project usages, not reconducted in the library                                                  | N/A                                           | N/A                                                                                                                            |
| None                                          | None                            | isAbstract                                                                               | Used for Actors. Kind of a "REC/RPL' thing to create abstract actors and reuse among actors - linked to Generalized Components | Rarely used. See how REC/RPL are managed in v2                                                                                                                                                                                                   | N/A                                           | N/A                                                                                                                            |
| None                                          | None                            | Generalized Components                                                                   | Used for Actors. Kind of a "REC/RPL' thing to create abstract actors and reuse among actors - isAbstract                       | Rarely used. See how REC/RPL are managed in v2                                                                                                                                                                                                   | N/A                                           | N/A                                                                                                                            |
| alias allocatedFunctions for performedActions | (relationship) performedActions | Allocated Functions                                                                      | Functions allocated to Components represents its behavior                                                                      | Reusing SysML v2 concept while renaming it as it is a key relationship in Arcadia                                                                                                                                                                | perform 'Capture Movement'                    | Function Nodes represented within its allocated Component Node, also visible in the Component property view (selection widget) |
| alias subComponents for subparts              | (relationship) subparts         | None/ variant of subComponents                                                           | list of components contained directly (1 level)                                                                                | Reusing SysML v2 concept while renaming it for coherency with Arcadia concepts                                                                                                                                                                   | to be automatically calculated by the tooling | Sub-Components are displayed as Nodes in Nodes in a PAB and as a read-only list in the property view of a component            |
| none                                          | none                            | Allocated Roles                                                                          | see below                                                                                                                      | see below                                                                                                                                                                                                                                        | N/A                                           | N/A                                                                                                                            |

#### Additional Information:

- see overall library rationale: we have one single type to represent components for all engineering perspectives. This enables much easier management of operations like copy and paste across layers, and tooling reuse. As an example, finding if a component is a Logical one requires checking if it is contained in the package related to the Logical Architecture (corresponding metadata annotation set on the package)
- In Capella in the OA perspective, Operational Entities have "Allocated Roles" relationships in the property view. This refers to the Role concept. Roles have been created to avoid duplicating the same activities that are achieved by multiple stakeholders. We consider that these roles concepts have been rarely used in Capella models, that the REC/RPL mechanism could be used instead, and that the Definition/Usage mechanism should be used instead in v2.

### `NodeComponent` and `BehaviorComponent` PartDefinitions

#### Library extract

```
	part def NodeComponent :> Component {
		private doc /* A Physical Architecture component of Node nature: a physical platform that hosts deployed components,
		 * Behavior Components or Node Components (see Deployment). The actors of the Physical Architecture are Node Components. */
	}

	part def BehaviorComponent :> Component {
		private doc /* A Physical Architecture component of Behavior nature: it carries allocated functions and component exchanges,
		 * and is deployed on a Node Component, not contained in it (see Deployment). */
	}
```

#### Mappings

| Concept in v2 library                   | Concept in SysML v2 | Capella desktop implementation                                                          | Concept meaning                                                                                                                               | Rationale                                                                                                                                                                                                                                                                                                                                                | Example                                   | Representation                                              |
| --------------------------------------- | ------------------- | --------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------- | ----------------------------------------------------------- |
| part def NodeComponent :> Component     | None                | Physical Component with nature NODE (including the Actors of the Physical Architecture) | A physical platform that hosts deployed components (Behavior Components or Node Components) and is connected to other Nodes by physical links | The Node / Behavior distinction is essential in the Physical Architecture and is taught as such. A specialization of the part definition is the natural SysML v2 way to distinguish kinds of parts (Apollo 11 distinguishes `HardwareComponent` and `SoftwareComponent` this way), and any tool can read it without knowing a library-specific attribute | part 'Mouse PCB' : NodeComponent          | Node components in a PAB                                    |
| part def BehaviorComponent :> Component | None                | Physical Component with nature BEHAVIOR                                                 | A component which carries allocated functions and component exchanges, and which is deployed on a Node Component, not contained in it         | see above                                                                                                                                                                                                                                                                                                                                                | part 'Mouse Firmware' : BehaviorComponent | Behavior components are drawn with rounded borders in a PAB |

#### Additional Information:

- The two specializations are used only in the Physical Architecture, where every component is either a Node Component or a Behavior Component, except the root component of the architecture (`system`): it is the only Physical Component whose nature is not specified (nature UNSET in Capella), and it stays a plain `Component`. The other engineering perspectives keep using `Component`, in line with the overall library rationale. `Component` itself is not abstract (see the note on the `abstract` keyword in the `ArcadiaElement` section), so "a Physical Architecture component, other than the root component, is a Node or a Behavior" is a validation rule of the tooling.
- Migration from Capella is direct: nature NODE gives `NodeComponent`, nature BEHAVIOR gives `BehaviorComponent`, and the root component (nature UNSET) stays a `Component`. An Actor of the Physical Architecture is a `NodeComponent` with `isActor = true`.
- Hierarchies of Node Components and hierarchies of Behavior Components are both supported (`subComponents`). It is a good practice in Arcadia to keep separate hierarchies for Nodes and for Behaviors.
- Containment and deployment are two different relations, as in Capella: a component created inside another one is contained (`subComponents`), whereas a deployed component is related to the component which hosts it by a `Deployment` allocation (see the `Deployment` section). A Node Component can be contained in a Node Component or deployed on it. A Behavior Component can be contained in a Behavior Component, but it cannot be contained in a Node Component: it is deployed on it.
- Rules left to the tooling (validation), not enforced by the library: a Node Component may have allocated functions (this is the case of the Actors of the Physical Architecture); Node Components do not have realization relationships; a Behavior Component is not contained in a Node Component (it is deployed on it); a Human component can deploy sub-components but not contain them (Capella 1.4).
- TODO Open Point: Physical Links and Physical Ports of Node Components (a Node has Physical Links, not Component Exchanges, and Physical Ports, not Component Ports), and Physical Paths. To be handled separately, see the "TODO To Cover" section.

### `Deployment` Allocation Def

#### Library extract

```
	allocation def Deployment :> ArcadiaElement {
		private doc /* A generic Arcadia Deployment, used in the Physical Architecture: a component (deployedElement) is deployed on
		 * another component (location), instead of being contained in it. Typically a Behavior Component or a Node Component
		 * is deployed on a Node Component.
		 * A Deployment is stored in the location component, and is written
		 * 'allocation : Deployment allocate <deployed component> to self;'. */
		end deployedElement : Component;
		end location : Component;
	}
```

#### Mappings

| Concept in v2 library                       | Concept in SysML v2                                       | Capella desktop implementation                                                                            | Concept meaning                                                                                                                                                                                                  | Rationale                                                                                                                                                                                                                                                                                          | Example                                                                                                  | Representation                                                                                                               |
| ------------------------------------------- | --------------------------------------------------------- | --------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------- |
| allocation def Deployment :> ArcadiaElement | allocation def / allocation usage (`allocate ... to ...`) | `PartDeploymentLink`, an object contained by a Part, with the references `deployedElement` and `location` | A component is deployed on another component instead of being contained in it: typically a Behavior Component or a Node Component is deployed on a Node Component, which is the physical platform which hosts it | SysML v2 has no deployment concept; the natural way to relate a component to the component which implements or hosts it is the allocation (OOSEM v2: a logical component allocated to software must then be allocated to a hardware component to execute it; training example `LogicalToPhysical`) | `part 'Mouse PCB' : NodeComponent { allocation : Deployment allocate system.'Mouse Firmware' to self; }` | Deployed components are displayed inside the component on which they are deployed in a PAB; property view of both components |
| end deployedElement : Component             | end (source)                                              | deployedElement                                                                                           | the deployed component (a Behavior Component or a Node Component)                                                                                                                                                | Reusing SysML v2 concept                                                                                                                                                                                                                                                                           | see first line                                                                                           | see first line                                                                                                               |
| end location : Component                    | end (target)                                              | location                                                                                                  | the component on which it is deployed (typically a Node Component)                                                                                                                                               | Reusing SysML v2 concept                                                                                                                                                                                                                                                                           | see first line                                                                                           | see first line                                                                                                               |

#### Additional Information:

- **Permissive ends**: the ends are typed `Component`, not `BehaviorComponent` / `NodeComponent`. The SysML v2 pilot implementation does not check the types of the ends of an allocation anyway, so the rules on which components can be deployed on which (typically a Behavior Component or a Node Component on a Node Component; a Behavior Component is never contained in a Node Component, it is only deployed on it) are validation rules of the tooling.
- **Ownership**: the Deployment is stored in the component on which the deployment is made (the `location`, in practice a Node), so that the deployments follow it (copy/paste, deletion, diff/merge). In Capella, the `PartDeploymentLink` is also contained by the Part of the `location`. The Node is designated by `self`: `allocation : Deployment allocate <deployed component> to self;`.
- The ends are named as in Capella (`deployedElement`, `location`).
- The list of the components deployed on a component, and the component on which a given component is deployed, are derived by the tooling from the `Deployment` allocations, not stored.
- **Impact on tooling**: the creation of a deployment (Capella: "Deploy" tools) must create a `Deployment` allocation in the Node; the property views and the PAB must read the allocations.
- **Use of `self`**: `allocate <deployed> to self`, where `self` designates the owner of the allocation. The owner cannot be designated by its simple name from inside itself (the pilot implementation answers "Must be an accessible feature"); a feature chain from the enclosing element (`system.'Mouse PCB'`) is accepted, but it breaks when the Node is renamed, moved or copied elsewhere, whereas `self` follows the Node. `self` is a feature of the SysML v2 system libraries and always means the element itself, whether the owner is a usage or a definition. This convention has been confirmed valid by a SysML v2 expert review; it has no precedent in the official examples (Annex A, training, OOSEM v2, Apollo 11). Alternative not retained: put the allocation in the parent element and designate the elements by name or feature chain (the Annex A way), at the cost of no longer storing the allocation in the Node.

### `Function` ActionDefinition

#### Library extract

```
	action def Function :> ArcadiaElement {
	    private doc /* A generic Arcadia Function, used across all Arcadia engineering perspectives. */
        alias subFunctions for subactions;
    }
```

#### Mappings

| Concept in v2 library                 | Concept in SysML v2       | Capella desktop implementation                                                | Concept meaning                                                                                                                          | Rationale                                                                      | Example                                       | Representation                                                                                                      |
| ------------------------------------- | ------------------------- | ----------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------ | --------------------------------------------- | ------------------------------------------------------------------------------------------------------------------- |
| action def Function :> ArcadiaElement | None                      | Operational Activity / System Function / Logical Function / Physical Function | An action, an operation, or a service, performed by the system or one of its components, or also by an actor interacting with the system | Reusing SysML v2 concept, Functions are Actions Definitions by essence.        | action 'Capture Movement' : Function          | Represented as Green nodes                                                                                          |
| alias subFunctions for subactions     | (relationship) subactions | Contained Functions (specialized by layer)                                    | list of functions contained directly (1 level)                                                                                           | Reusing SysML v2 concept while renaming it for coherency with Arcadia concepts | to be automatically calculated by the tooling | Sub-Functions are displayed as Nodes in Nodes in a LDFB and as a read-only list in the property view of a component |

#### Additional Information:

- Capella Functional Ports are mapped to Action in and out parameters, see dedicated section
- Capella special functions like DUPLICATE, GATHER, ROUTE, SELECT, SPLIT are not to be reproduced in v2 but rather translated as, respectively, fork, join, decision, merge and fork. Note that ROUTE and SELECT may have a condition field (property view) that should be migrated as well to the corresponding node.

- TODO Open Point : To be discussed with the group of expert: Should we parallelize/merge/unify Scenarios and Functional Chains. One idea could be that a Functional Chain may have multiple scenarios (separating data flow from behavior). Or we could imagine things like Capabilities -> Use Case -> Activity/Sequence

### `Function Port` (Actions Parameters)

#### Library extract

```
	None
```

#### Mappings

| Concept in v2 library | Concept in SysML v2                  | Capella desktop implementation | Concept meaning                                                                                                                             | Rationale                           | Example                                           | Representation                                             |
| --------------------- | ------------------------------------ | ------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------- | ------------------------------------------------- | ---------------------------------------------------------- |
| None                  | in or out parameters (ExchangeItems) | Functional Ports               | A place where the function interacts with other functions of its environment. It can be either an input port or an output port, exclusively | Reusing SysML v2 concept, see below | out FOP1 [0..*] : ExchangeItem = (rawOpticalData) | Typically represented as oriented ports on Functions nodes |

#### Additional Information:

- While Functional Port objects exist in Capella model, we are not recreating them in the Arcadia library as it would be too far from the SysML v2 intent, see overall library rationale. SysML v2 actually represents graphically Action in and out parameters as ports.
- While SysML v2 allows in, out and inout ports directions, Arcadia only allows for in or out parameters
- Further explanation on the mapping through the example "out FOP1 [0..*] : ExchangeItem = (rawOpticalData)":
- FOP1 corresponds to the Function Port Name in Capella
- [0..*] means that there can be multiple exchange items
- "= (rawOpticalData)" is the binding of the actual exchanged item(s) defined in the data package to the Function Port (in Capella) / Action parameter
- TODO Open Point: should we authorize inout parameters as well for Arcadia? To be discussed, as operations may have a return on oriented ports...

### `Functional Chain` ActionDefinition

#### Library extract

```
    action def FunctionalChain :> ArcadiaElement  {
        private doc /* A generic Arcadia Functional Chain, used across all Arcadia engineering perspectives. */
        ref involvedFunctionalExchanges: FunctionalExchange[*];
        alias involvedFunctions for subactions;
    }
```

#### Mappings

| Concept in v2 library                                   | Concept in SysML v2           | Capella desktop implementation                                     | Concept meaning                                                                                                                      | Rationale                                                                                                                      | Example                                                         | Representation                                                                    |
| ------------------------------------------------------- | ----------------------------- | ------------------------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------ | --------------------------------------------------------------- | --------------------------------------------------------------------------------- |
| action def FunctionalChain :> ArcadiaElement            | None                          | Operational Process / Functional Chain                             | A usage of the system in a given context. It is a logical organization of functions and functional exchanges to fulfil a Capability. | Reusing SysML v2 action def while adapting it to represent Arcadia Functional Chains, see below.                               | see below                                                       | Paths (exchanges) are highlighted with rotating colors                            |
| ref involvedFunctionalExchanges: FunctionalExchange[*]; | None                          | involvedFunctionalExchanges                                        | Functional Exchanges involved in the chain                                                                                           | key relation for Functional chains                                                                                             | see previous line                                               | see previous line                                                                 |
| None                                                    | Successions and Control Nodes | Pre-condition/Post-condition + Sequencing within Functional chains | Control flow semantics within Functional chains                                                                                      | Reusing SysML v2 Control Flow concepts                                                                                         | succession first start then 'Root Function'.'Capture Movement'; | mostly edges for sequencing, Nodes for Control Nodes and property view for guards |
| alias involvedFunctions for subactions;                 | perform                       | involvedFunctions                                                  | Functions involved in the chain                                                                                                      | Reusing SysML v2 concept while renaming it for coherency with Arcadia concepts (subactions is returning all performed actions) | to be automatically calculated by the tooling                   | see previous line                                                                 |

#### Additional Information:

- The reference to Functional Exchanges is declared with a plain `ref` typed by the flow definition, not `ref flow`: a flow usage must have exactly two ends, and `ref flow` without `from ... to ...` is rejected by the SysML v2 pilot implementation ("Cannot have more than two ends").
- SysML v2 does not provide a native concept for Functional Chains. We represent them using action def to define scenario-level orchestrations of reusable functions and exchanges, preserving type-instance separation and traceability while aligning with Arcadia semantics. Behavior (KerML) concept may have been an option but it is unlikely this concept is well handled by other tools.
- See this example of a Functional Chain:

```
	action myChain : FunctionalChain {
		ref :>> involvedFunctionalExchanges = (fe1, fe2);
	   	perform f1;
	   	perform f2;
		perform f3;
		succession first start then f1;
	   	succession first f1 then f2;
	   	succession first f3 then done;
	}
```

- We do not migrate the "Pre/Post conditions" fields on Functional Chains. This is rarely used.

- TODO Open Point : in Capella, Functional Chains have trace objects that point to the actual Functions/Exchanges, and this is particularly useful to model control flow. Evaluate whether the current solution is satisfactory (using successions). In the same spirit, Allocation between Component and Functions are Trace. Do we need it? Especially in the context of doing difference/merge of models to make these more explicit to users.
- TODO Open Point : "Functional chain involvement Link" in Capella has an "Exchange Context" property. Similar to what is on Scenarios (Control Flow), used to specify values, for example. Evaluate how we should migrate that depending on our target with Functional Chains and Scenarios.
- TODO : Manage the fact that Function Chains can reference Function Chains
- TODO Open Point: Functional Chains in Capella have a field Kind (SIMPLE, COMPOSITE, FRAGMENT) - rarely used?
- TODO Open Point: Functional Chains in Capella have a field "EnactedFunctionalBlocks" (expert/semantic view). We should add in the library a derived relationship involvedComponents that calculate the components involved in a Functional chain (useful for the semantic browser for instance)

### `Functional Exchange` FlowDefinition

#### Library extract

```
	flow def FunctionalExchange :> ArcadiaElement{
	    private doc /* A generic Arcadia Functional Exchange, used across all Arcadia engineering perspectives. */
		ref item :>> payload : ExchangeItem [*];
		end source : Function;
		end target : Function;
	}
```

#### Mappings

| Concept in v2 library                         | Concept in SysML v2 | Capella desktop implementation | Concept meaning                                                                                                                                                   | Rationale                                                                                                                                                                                                                       | Example   | Representation                       |
| --------------------------------------------- | ------------------- | ------------------------------ | ----------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------- | ------------------------------------ |
| flow def FunctionalExchange :> ArcadiaElement | None                | Functional Exchange            | A possible interaction between a source function and a destination function, likely to transmit exchange items through their output and input ports, respectively | Reusing SysML v2 flow definition                                                                                                                                                                                                | see below | An edge between 2 Function Ports     |
| ref item :>> payload : ExchangeItem [*]       | None                | exchangedItems                 | see first line                                                                                                                                                    | Reusing SysML v2 concept (the standard `payload`), redefined to restrict it to Exchange Items: the payload of a Functional Exchange usage is typed `ExchangeItem` (with a plain `:>` subsetting it would stay typed `Anything`) | see below | in the property view of the exchange |
| end source : Function                         | None                | source                         | see first line                                                                                                                                                    | Reusing SysML v2 concept                                                                                                                                                                                                        | see below | N/A                                  |
| end target : Function                         | None                | target                         | see first line                                                                                                                                                    | Reusing SysML v2 concept                                                                                                                                                                                                        | see below | N/A                                  |

#### Additional Information:

- Usage Example:

```
	// A Functional Exchange, with the Exchange Item(s) it carries
	flow 'Optical Data' : FunctionalExchange of :>> payload = (rawOpticalDataX, rawOpticalDataY)
		from 'Capture Movement'.FOP1 to 'Transform Raw Optical Data'.FIP2;
```

- Note that the Flow Usage payload is a set of Exchange Item(s) as defined in the `Data` package of the model. They are set with `of :>> payload = (...)` after the flow name, or equivalently in the body of the flow with `:>> payload = (...);`; this corresponds to the exchange items allocated to the functional exchange in Capella (`exchangedItems`). A binding connector cannot be used for this: `bind` relates one feature to one feature, so the form `bind 'Optical Data'.payload = (rawOpticalDataX, rawOpticalDataY);` is rejected by the SysML v2 pilot implementation.
- Note that the Flow Usage connects the parameters (in and out) of the Function Usages, corresponding to the Function Ports in Capella (`from 'Capture Movement'.FOP1 to 'Transform Raw Optical Data'.FIP2`), while the Flow Definition connects the Functions (Actions) as per the SysML v2 standard.

- TODO : Categories

### `Component Exchange` InterfaceDefinition

#### Library extract

```
    interface def ComponentExchange :> ArcadiaElement {
    	private doc /* A generic Component Exchange, used across all Arcadia engineering perspectives.
    	 * Functional Exchanges are allocated to a Component Exchange with ExchangeAllocation usages
    	 * (see ExchangeAllocation); the list of allocated Functional Exchanges is derived by tooling. */
        end cp1 : ComponentPort;
        end cp2 : ComponentPort;
        ref item allocatedExchangeItems: ExchangeItem[*];
    }
```

#### Mappings

| Concept in v2 library                                          | Concept in SysML v2                                                             | Capella desktop implementation                                                                                | Concept meaning                                                                                                                                        | Rationale                                                                                                                                                                                         | Example                                                                                                                                                                              | Representation                       |
| -------------------------------------------------------------- | ------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | ------------------------------------ |
| interface def ComponentExchange :> ArcadiaElement              | None                                                                            | (OA) Communication Mean, Component Exchange (see below)                                                       | A possible interaction between a source behavioral component and a destination behavioral component, likely to transmit exchange items via their ports | Reusing SysML v2 Interface definition                                                                                                                                                             | interface cable : ComponentExchange                                                                                                                                                  | An edge between 2 Component Ports    |
| end cp1 : ComponentPort                                        | None                                                                            | sourcePort                                                                                                    | see first line                                                                                                                                         | Reusing SysML v2 concept                                                                                                                                                                          | connect 'Optical Sensor Unit'.'Cable Connector' to 'Mouse Controller'.'Cable Connector' AND/OR flow 'Optical Sensor Unit'.'Cable Connector' to 'Mouse Controller'.'Cable Connector'; | N/A                                  |
| end cp2 : ComponentPort                                        | None                                                                            | targetPort                                                                                                    | see first line                                                                                                                                         | Reusing SysML v2 concept                                                                                                                                                                          | see previous line                                                                                                                                                                    | N/A                                  |
| ref item allocatedExchangeItems: ExchangeItem[*]               | None                                                                            | conveyedInformations                                                                                          | see first line                                                                                                                                         | Arcadia needed information                                                                                                                                                                        | ref item :>> allocatedExchangeItems = (Data::rawOpticalData);                                                                                                                        | in the property view of the exchange |
| None (derived by tooling from the `ExchangeAllocation` usages) | the `ExchangeAllocation` usages whose `componentExchange` end is this interface | allocatedFunctionalExchanges (derived from the owned `ComponentExchangeFunctionalExchangeAllocation` objects) | Functional Exchanges allocated to this Component Exchange                                                                                              | Single source of truth: the allocation element (see `ExchangeAllocation`). In Capella this reference is also derived. A stored reference `ref flow` was also rejected by the pilot implementation | see `ExchangeAllocation`                                                                                                                                                             | in the property view of the exchange |

#### Additional Information:

- In Arcadia, they are called "Behavioral Exchange"
- Physical Nodes have Physical Links, not Component Exchanges (Behavioral Nodes do have Component Exchanges)
- `allocatedExchangeItems` is a stored list, independent of the Functional Exchanges allocated to the Component Exchange, as `convoyedInformations` is in Capella: that reference has no constraint in the Capella metamodel, and the consistency with the exchange items of the allocated Functional Exchanges is not enforced there, validation rules raise warnings (for example DCOM_13 for Functional Exchanges and TC_DF_04 for Component Exchanges of the previous level). It is not constrained in the library either. The tooling can propose the exchange items of the allocated Functional Exchanges and report the differences. Not retained: a SysML v2 constraint in the library (stricter than Capella and heavy to write), and replacing the list by the `payload` of the flow of the interface (native, as in Annex A `flow of Fuel from ... to ...`, and accepted by the pilot, but the payload is untyped and a flow is directed, whereas a Component Exchange can convey exchange items in both directions at the same time in Capella).

- TODO Open Point: discuss other component exchanges type (with delegation...) and the property "Kind (UNSET/ASSEMBLY/DELEGATION/FLOW)" - 90% of cases are flows. Sometimes delegation is used to delegate ports to parent component, may be equivalent to binding in v2
- TODO Categories

### `ComponentPort` PortDefinition

#### Library extract

```
	port def ComponentPort :> ArcadiaElement {
		private doc /* A generic Arcadia Component Port, used across all Arcadia engineering perspectives. */
        attribute portDirection : FeatureDirectionKind;
		ref item allocatedFunctionPorts: ExchangeItem [*];
    }
```

#### Mappings

| Concept in v2 library                             | Concept in SysML v2         | Capella desktop implementation | Concept meaning                                                                                                   | Rationale                        | Example                                                          | Representation                    |
| ------------------------------------------------- | --------------------------- | ------------------------------ | ----------------------------------------------------------------------------------------------------------------- | -------------------------------- | ---------------------------------------------------------------- | --------------------------------- |
| port def ComponentPort :> ArcadiaElement          | None                        | Component Port (see below)     | A place of interaction for the component to which it is attached to other components or actors in its environment | Reusing SysML v2 Port definition | port 'Cable Connector' : ComponentPort                           | A port on a Node                  |
| attribute portDirection : FeatureDirectionKind    | None                        | direction                      | see first line                                                                                                    | Reusing SysML v2 concept         | :>> portDirection = FeatureDirectionKind::'in';                  | Change of icon (arrow)            |
| None                                              | Reusing in and out features | conveyedInformations           | see first line                                                                                                    | Reusing SysML v2 concept         | see below                                                        | property view                     |
| ref item allocatedFunctionPorts: ExchangeItem [*] | None                        | allocatedPort                  | In Capella, we allocate function ports to components ports                                                        | Arcadia needed information       | ref item :>> allocatedFunctionPorts = ('Capture Movement'.FOP1); | a dashed edge between the 2 ports |

#### Additional Information:

- In Arcadia, they are called Behavioral Ports
- Component Ports do not exist at the OA level
- Physical Nodes have Physical Ports, not Component Ports (Behavioral Nodes do have Component Ports)
- More explanation for mapping in and out features of Ports. See this example : "in [0..*] : ExchangeItem = (rawOpticalDataX, rawOpticalDataY);"
- We use the name "portDirection" as in SysML v2, Port does not have a direction, but its features have. We don't want to conflict names

- TODO Open Point: Port in SysML v2 do not have a direction. Its features (payload) have. We may define the port direction as a calculated attribute. Or we may use it as a verification mechanism. To be decided. However, when migrating back and forth from v2 to Capella, this may present a challenge as Exchange Items don't have a direction on Component Ports
- TODO Open Point: Kind attribute? Provided Interface? Required Interface?
- `allocatedFunctionPorts` is a reference declared in the library (`ref item allocatedFunctionPorts: ExchangeItem [*]`), not a native SysML v2 relation. It is the view of the Capella `ComponentPortAllocation` objects (in Capella, `ComponentPort.allocatedFunctionPorts` is derived from them), and the tooling creates those objects from it. It cannot be derived from the allocations of Functional Exchanges to Component Exchanges, because a port can be allocated before any exchange exists. An allocation element, as for exchanges and realizations, was considered and not retained: a port usage cannot own an allocation (pilot 0.63.1: "Nested usages in a port usage (other than ports) must be referential"), so it would have to be owned by the component, there is no official precedent for allocating an action parameter to a port, and the benefit is small as we assume the description and status of these allocations are rarely used. A `bind` between the parameter and an item of the port was also not retained: it equates values, it is not an allocation.

### `ExchangeAllocation` Allocation Def

#### Library extract

```
    allocation def ExchangeAllocation :> ArcadiaElement {
	    private doc /* A generic Arcadia Exchange Allocation, used across all Arcadia engineering perspectives.
	     * An Exchange Allocation is owned by the Component Exchange it allocates to, and is written
	     * 'allocation : ExchangeAllocation allocate <functional exchange> to self;'. */
        end functionalExchange : FunctionalExchange;
        end componentExchange : ComponentExchange;
    }
```

#### Mappings

| Concept in v2 library                               | Concept in SysML v2                                       | Capella desktop implementation                                                                                                                                   | Concept meaning                                                                                                                       | Rationale                                                                                                                                                                                                                     | Example                                                                                                                      | Representation                               |
| --------------------------------------------------- | --------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------- |
| allocation def ExchangeAllocation :> ArcadiaElement | allocation def / allocation usage (`allocate ... to ...`) | `ComponentExchangeFunctionalExchangeAllocation`, an object contained by the Component Exchange (the `allocatedFunctionalExchanges` reference is derived from it) | Part of how Arcadia/Capella manage Interface Engineering (Interface content is based on Functional content through these allocations) | Reusing SysML v2 allocation as it maps naturally to the allocation. The allocation is owned by the Component Exchange, as in Capella where the allocation object is contained by the Component Exchange (see ownership below) | interface cable : ComponentExchange { ... allocation : ExchangeAllocation allocate 'Root Function'.'Optical Data' to self; } | in the property view of a component exchange |
| end functionalExchange : FunctionalExchange         | None                                                      | None                                                                                                                                                             | see first line                                                                                                                        | Reusing SysML v2 concept                                                                                                                                                                                                      | see first line                                                                                                               | see first line                               |
| end componentExchange : ComponentExchange           | None                                                      | None                                                                                                                                                             | see first line                                                                                                                        | Reusing SysML v2 concept                                                                                                                                                                                                      | see first line                                                                                                               | see first line                               |

#### Additional Information:

- **Ownership** (resolves the former open point on where to store the allocation elements): an Exchange Allocation is owned by the Component Exchange (the interface usage) it allocates to, and designates it with `self`: `allocation : ExchangeAllocation allocate <functional exchange> to self;`. This mirrors Capella, where the allocation object is contained by the Component Exchange, and it keeps the allocation next to the element it describes (diff/merge, copy/paste, deletion of the exchange). See the general ownership rule in the `Realization` section.
- Note: the SysML v2 Specification (Annex A, SimpleVehicleModel) writes the same allocation in the part that owns the interface, which is a possible alternative location. We prefer the Component Exchange as owner so that the owner is the same in all Arcadia allocations (the element that owns the trace in Capella).
- **Why a dedicated allocation def**: SysML v2 does have a native, generic allocation (`Allocations::Allocation`, whose two ends are typed `Anything`), so a Functional Exchange (a flow usage) can be allocated to a Component Exchange (an interface usage) with a plain `allocate`, as in Annex A. What SysML v2 does not have is a dedicated relation for this case, like `perform` (`Part::performedActions`) for the allocation of functions to components, which is why the library does not define anything for that one. `ExchangeAllocation` is a thin typing on top of the generic allocation: it types the ends (FunctionalExchange, ComponentExchange), makes it an `ArcadiaElement` and lets tools recognize an Arcadia Exchange Allocation among other allocations.
- **Allocation element rather than a reference** (resolves the former open point): Functional Exchanges are allocated to a Component Exchange with `ExchangeAllocation` usages only; the library no longer has an `allocatedFunctionalExchanges` reference on `ComponentExchange`, the list is derived by tooling from the allocations. Reasons: (1) single source of truth, the former example stored the same link twice (reference and allocation), which can become inconsistent; (2) it is the SysML v2 idiom, Annex A allocates a flow usage to an interface usage (`allocate ActionTree::providePower.generateToAmplify to engineToTransmissionInterface;`); (3) in Capella the link is an object contained by the Component Exchange and the reference is derived, so migration is one object to one allocation, and the allocation can carry a description and a status; (4) diff/merge: one identifiable element per allocation instead of a modified list; (5) same policy as for `Realization`. Impact on tooling: the "Allocated Functional Exchanges" of a Component Exchange must be computed from the allocations. Not verified: whether a derived list can be expressed natively in SysML v2 (it is computed by tooling here).
- **`self`**: the ownership convention uses `self` to designate the owner (see the `Realization` section).

### `Realization` Allocation Def

#### Library extract

```
    allocation def Realization :> ArcadiaElement {
	    private doc /* A generic Arcadia Realization, used across all Arcadia engineering perspectives and for all kinds of
	     * Arcadia elements: an element (realizing) realizes an element of the previous engineering perspective (realized).
	     * A Realization is owned by the realizing element, and is written
	     * 'allocation : Realization allocate <realized element> to self;'.
	     * The 'realizes' and 'is realized by' navigations are derived by tooling and are not stored. */
        end realized : ArcadiaElement;
        end realizing : ArcadiaElement;
    }
```

#### Mappings

| Concept in v2 library                        | Concept in SysML v2                                       | Capella desktop implementation                                                                                                                                                                    | Concept meaning                                                                                                                                                                          | Rationale                                                                                                                                                                                  | Example                                                                                                                                | Representation                                                                              |
| -------------------------------------------- | --------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | -------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------- |
| allocation def Realization :> ArcadiaElement | allocation def / allocation usage (`allocate ... to ...`) | The realization objects (`FunctionRealization`, `ComponentRealization`, `FunctionalExchangeRealization`, `ComponentExchangeRealization`, `PortRealization`, ... ), owned by the realizing element | Traceability between engineering perspectives: an element of a perspective realizes one or several elements of the previous perspective (SA realizes OA, LA realizes SA, PA realizes LA) | SysML v2 allocation is the natural way to relate an abstract architecture to a more concrete one (`LogicalToPhysical` pattern of the SysML v2 training and Annex A). See the reasons below | `action 'Capture Movement' : Function { ... allocation : Realization allocate SA::Functions::'Root Function'.'Move Cursor' to self; }` | property view of both elements (derived navigations), Related Elements, traceability matrix |
| end realized : ArcadiaElement                | end (source)                                              | targetElement of the Capella realization object                                                                                                                                                   | the realized element (previous perspective)                                                                                                                                              | Reusing SysML v2 concept                                                                                                                                                                   | see first line                                                                                                                         | see first line                                                                              |
| end realizing : ArcadiaElement               | end (target)                                              | sourceElement of the Capella realization object                                                                                                                                                   | the realizing element (this perspective)                                                                                                                                                 | Reusing SysML v2 concept                                                                                                                                                                   | see first line                                                                                                                         | see first line                                                                              |

#### Additional Information:

- **Why allocation**: the references of the SysML v2 standard library and of the official examples converge on allocation for linking an abstract (e.g. logical) architecture to a more concrete one (training example `LogicalToPhysical`, Annex A SimpleVehicleModel, OOSEM v2 allocation of logical to physical components). An allocation is a first-class element: it can be named, documented, carry a status (it is an `ArcadiaElement`) and be navigated by tools, which a plain reference cannot. It migrates one-to-one from a Capella realization object. The other candidate, `dependency` with the standard `#refinement` metadata (used by the Airbus Apollo 11 model), was not retained: Apollo 11 models functions as definitions, between which an allocation is not possible, and a refinement is not exactly a realization.
- **Why one single `Realization` (and not one per kind of element, as in Capella)**: Capella has more than twenty realization classes (one per kind of element) because its metamodel is typed by class. We do not reproduce this: (1) the library must stay light and contain only the concepts really needed; (2) each specialization would have to be known, created, displayed and migrated by the tooling (creation tools, property views, derived navigations, import/export), whereas a single concept is handled by a single code path; (3) the information carried by the specializations is redundant with the types of the two ends, so the consistency of the ends (a Function realizes a Function, a Component a Component, ...) is a rule checked by tooling (validation) rather than a library type. Note that the SysML v2 pilot implementation does not check the type conformance of allocation ends, so the validation rule is needed in any case. The mapping back to a Capella class is deduced from the type of the ends.
- **Ownership** (general rule for all Arcadia allocations): the allocation is owned by the element that owns the corresponding trace in Capella: the realizing element for a Realization, the Component Exchange for an Exchange Allocation. The owner is designated by `self`. A usage cannot be targeted by name from inside itself, and `that` designates the featuring instance (the parent), not the element itself. Allocations are not placed directly in a package, in line with the library principle of not having usages directly in a package.
- **Direction**: Arcadia says "the Logical Function _realizes_ the System Function". SysML v2 writes `allocate <System Function> to <Logical Function>` (the abstract element is allocated to the concrete one), as in `LogicalToPhysical`. This is the opposite of the Capella trace (source = realizing element, target = realized element): migration tooling must swap the ends. Tool labels should keep the Arcadia vocabulary (Realized / Realizing).
- **Derived navigations**: `realizes` / `isRealizedBy` are no longer stored (they were untyped references to any element). They are computed by tooling from the `Realization` allocations, as the `realizedXxx` / `realizingXxx` references are in Capella. A Capella realization has no name but it has a status and property values, which are kept as the allocation is an `ArcadiaElement`.
- **Many-to-many**: a realizing element may have several `Realization` allocations (one per realized element) and an element may be realized by several elements (several allocations from different owners). See `Capture Movement` and `Transform Raw Optical Data` in the optical mouse example, both realizing the System Function `Move Cursor`.
- **Impact on tooling (breaking change)**: models using `realizes` / `isRealizedBy` are no longer valid and must be migrated to `Realization` allocations. Tooling relying on the references (property views "Realized ..." / "Realizing ...", Related Elements, creation of realization links) must be reworked to read and create the allocations.
- **Use of `self`**: `allocate <realized> to self`, where `self` designates the owner of the allocation. An element cannot be designated by its simple name from inside itself (the pilot implementation answers "Must be an accessible feature"), and a feature chain from the enclosing element breaks when the element is renamed, moved or copied, whereas `self` follows the element. `self` is a feature of the SysML v2 system libraries and always means the element itself, whether the owner is a usage or a definition; nothing in the language forbids the owner of an allocation from also being one of its ends. This convention has been confirmed valid by a SysML v2 expert review. It has no precedent in the official examples (Annex A, training, OOSEM v2, Apollo 11). As a consequence, the element designated by `self` explicitly references the allocated element, which matches Capella, where the trace is owned by the element that carries it. Alternative not retained: put the allocation in the parent element and designate the elements by name or feature chain (the Annex A way), at the cost of no longer storing the allocation in the element that owns it in Capella.
- **Validation**: lib and example validate without error or warning with the SysML v2 pilot implementation 0.63.1.
- Nested allocations (one allocation of a parent function containing the allocations of its children) are accepted by the pilot but are not used here: their semantics has not been verified.
- Not covered here: the allocation of function ports to component ports, which stays a reference (`allocatedFunctionPorts`, see Component Port).

### `ExchangeItem` ItemDefinition

#### Library extract

```
	item def ExchangeItem :> ArcadiaElement{
		private doc /* A generic Arcadia ExchangeItem, used across all Arcadia engineering perspectives. */
	}
```

#### Mappings

| Concept in v2 library                   | Concept in SysML v2 | Capella desktop implementation | Concept meaning                                                                                                                      | Rationale                        | Example                           | Representation                                                      |
| --------------------------------------- | ------------------- | ------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------ | -------------------------------- | --------------------------------- | ------------------------------------------------------------------- |
| item def ExchangeItem :> ArcadiaElement | None                | ExchangeItem                   | An ordered set of references to elements routed together, during an interaction or exchange between functions, components and actors | Reusing SysML v2 natural concept | item rawOpticalData: ExchangeItem | a Node on a data diagram, generally in the property views elsewhere |

#### Additional Information:

- TODO Open Point: discuss which fields/relations needs to be brought in Capella. Discuss data modeling in v2

### `ArcadiaRequirement` RequirementDefinition

#### Library extract

```
	requirement def ArcadiaRequirement :> ArcadiaElement{
    	private doc /* A generic Requirement, used across all Arcadia engineering perspectives.*/
	}
```

#### Mappings

| Concept in v2 library                                | Concept in SysML v2 | Capella desktop implementation | Concept meaning                                                                                                  | Rationale                                    | Example                                                                                                                 | Representation |
| ---------------------------------------------------- | ------------------- | ------------------------------ | ---------------------------------------------------------------------------------------------------------------- | -------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------- | -------------- |
| requirement def ArcadiaRequirement :> ArcadiaElement | None                | None                           | A textual requirement is an unformalised description of an expectation on the system or solution to be delivered | Reusing SysML v2 natural concept (see below) | requirement <'R1.1'> Optical : ArcadiaRequirement {doc /_ The mouse should capture movement using optical detection _/} | a Node         |

#### Additional Information:

- Historically, Requirements were not in Capella (although there was a legacy concept removed in Capella 7.0) but made available through the Requirements Viewpoint. As Requirement is a first class citizen element in SysML v2, we are adding the concept in the library.
- In SysML v2, IDs are stored in the short name field

- TODO Open Point: Do we really want to have this ArcadiaRequirement Concept? Probably to be removed
- TODO Open Point: discuss how to manage the doc attribute generally shown as hosting the shall statement in v2 with the fact that we use the doc attribute for the description. Should we give it a specific name? or use an attribute? or use a constraint and then the doc ?
- TODO Open Point: discuss Requirements Allocation (currently reusing allocation) + what is the direction of the allocation
- TODO Open Point: Review data model in the Req viewpoint/add-on, integrate the ID in the table

### `Capability` OccurrenceDefinition

#### Library extract

```
	occurrence def Capability :> ArcadiaElement {
	    private doc /* A generic Arcadia Capability, used across all Arcadia engineering perspectives. */
		ref action involvedFunctions: Function[*];
		ref action involvedFunctionalChains: FunctionalChain[*];
		ref part involvedComponents: Component[*];
	}
```

#### Mappings

| Concept in v2 library                                   | Concept in SysML v2 | Capella desktop implementation | Concept meaning                                                                                    | Rationale                                                                                                                                                                                                             | Example                                                                               | Representation       |
| ------------------------------------------------------- | ------------------- | ------------------------------ | -------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------- | -------------------- |
| occurrence def Capability :> ArcadiaElement             | None                | Capability                     | Ability required from the system, to provide a service that supports the achievement of a mission. | Arcadia Capabilities are represented as a dedicated SysML v2 concept to preserve their role as abstract, reusable system abilities that are independent of specific behaviors, scenarios, or structural realizations. | occurrence 'Move Cursor on Screen' : Capability                                       | a rounded Node       |
| ref action involvedFunctions: Function[*]               | None                | involvedFunctions              | Functions involved for realizing the capability                                                    | Arcadia needed information                                                                                                                                                                                            | ref action :>> involvedFunctions = ('Capture Movement', 'Transform Raw Optical Data') | in the property view |
| ref action involvedFunctionalChains: FunctionalChain[*] | None                | involvedFunctionalChains       | Functional Chains involved for realizing the capability                                            | Arcadia needed information                                                                                                                                                                                            | ref action :>> involvedFunctionalChains = ('read movement')                           | in the property view |
| ref part involvedComponents: Component[*]               | None                | involvedComponents             | Components involved for realizing the capability                                                   | Arcadia needed information                                                                                                                                                                                            | ref part :>> involvedComponents = ('Optical Sensor Unit', 'Mouse Controller')         | edges                |

#### Additional Information:

- Capabilities at the LA/PA level are not widely used. Nevertheless, one may not have modeled SA and OA, so it is needed. Generally LA/PA Capabilities are identical to the ones defined at the SA layer
- TODO Open Point: Pre and Post Conditions? Inheritance? extends and includes relationships?

### `Mission` OccurrenceDefinition

#### Library extract

```
 	occurrence def Mission :> ArcadiaElement {
	    private doc /* A generic Arcadia Mission, used across all Arcadia engineering perspectives. */
		ref part involvedComponents: Component[*];
		ref occurrence exploitedCapabilities: Capability[*];
	}
```

#### Mappings

| Concept in v2 library                               | Concept in SysML v2 | Capella desktop implementation | Concept meaning                                            | Rationale                                                                                                                                                                                                        | Example                                                                        | Representation |
| --------------------------------------------------- | ------------------- | ------------------------------ | ---------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------ | -------------- |
| occurrence def Mission :> ArcadiaElement            | None                | Mission                        | A major goal to which the system is expected to contribute | Arcadia Missions are mapped to a dedicated SysML v2 concept because their system-of-interest–independent, goal-oriented nature is not fully captured by any native SysML v2 behavioral or interaction construct. | occurrence 'Provide Interface to User' : Mission                               | a rounded Node |
| ref occurrence exploitedCapabilities: Capability[*] | None                | exploitedCapabilities          | Capabilities exploited for realizing the Mission           | Arcadia needed information                                                                                                                                                                                       | ref occurrence :>> exploitedCapabilities = ('Move Cursor on Screen')           | edges          |
| ref part involvedComponents: Component[*]           | None                | involvedComponents             | Components involved for realizing the mission              | Arcadia needed information                                                                                                                                                                                       | ref part :>> involvedComponents = ('Optical Sensor Unit', 'Mouse Controller'); | edges          |

#### Additional Information:

- TODO Open Point: Only at the SA Level?

### Property values

Property values are not part of the library: they are modelled with native SysML v2 attributes owned by the element. This section documents the convention so that all the tools implementing the library handle them the same way.

#### Mappings

| Concept in v2 library | Concept in SysML v2                                       | Capella desktop implementation                                                | Concept meaning                                                    | Rationale                                                                                      | Example                                                                               | Representation                                                              |
| --------------------- | --------------------------------------------------------- | ----------------------------------------------------------------------------- | ------------------------------------------------------------------ | ---------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------- | --------------------------------------------------------------------------- |
| None                  | attribute usage owned by the element, value bound with =  | Property Value (String, Integer, Float, Boolean)                              | A user-defined value attached to an element, inside a group or not | Reusing SysML v2 concept, no Arcadia-specific concept needed                                   | attribute 'Safety Class' : Integer = 2;                                               | Property values section of the property view                                |
| None                  | attribute with a unit in its value expression             | Float or Integer Property Value (native Capella property values have no unit) | A physical quantity                                                | Units are expected in SysML v2 models and come from the standard SI library                    | attribute 'Mass' = 0.4 [kg];                                                          | Property values section of the property view, the unit is part of the value |
| None                  | attribute usage without type, containing attribute usages | Property Value Group                                                          | A named set of property values                                     | A Capella group is only a container of values, not a definition, so no attribute def is needed | attribute 'Budget' { attribute 'Power' = 2.5 [W]; }                                   | A group in the property values section                                      |
| None                  | doc description /\* \*/ inside the attribute              | Property Value description                                                    | Free text describing the property value                            | Reusing SysML v2 concept, same as for the description of other elements                        | attribute 'Mass' = 0.4 [kg] { doc description /_Mass of the module without cable._/ } | Description field of the property value                                     |

#### Additional Information:

- Not covered: property values on packages, enumeration property values, and the PVMT add-on.
- Models created in SysML v2: every property value is an attribute. A physical quantity carries a unit in its value (`[kg]`, `[W]`). A quantity type of the ISQ library (for example `MassValue`) can be used but is optional: with the SysML v2 pilot implementation 0.63.1, it is not checked against the unit (`attribute m : MassValue = 3.0 [s];` raises no warning). Values without dimension use `Real`, `Integer`, `String` or `Boolean`.
- Migrating Capella models: native Capella property values have no unit, so each one becomes an attribute without a unit, and no unit is inferred. A group becomes an attribute without type containing the attributes of the group. A property value owned outside any group becomes a flat attribute of the element. The description becomes a `doc description`. Names are kept, between quotes when needed. The value is bound with `=`.
- Two attributes with the same name in the same element give a validator warning.
- Unit symbols come from the SI library (`SI`): `kg`, `W`, `mm` and `g` exist, but not all prefixed symbols are predefined (`ms` must be written `milli*s`, and the degree Celsius is `'°C'`). Units outside SI need an import, for example `USCustomaryUnits`.
- SysML v2 attributes can express more than Capella property values (computed values such as `'Total Mass' = 'Mass' + 'Lens Mass'`, conversions such as `'Mass' [g]`, multiple values, constraints). This mapping only describes the conversion from Capella to SysML v2.

### TODO To Cover

- Interfaces (and how this impact our Component Ports, see Capella, at the moment we say that CP carry exchange items but they carry Interfaces in Capella) - The concept of Interface in Capella aggregates exchange items (an interface may offer more than just the sum of the exchange items, or multiple interfaces may be defined to represent the full set of EIs). Interfaces are also allocated to components and/or ports. We need to reflect on how to rationalize this with respect to SysML v2. For example, we may question why interfaces are not linked to physical components / physical paths, as this would allow the definition of hardware interfaces — something currently missing in Capella. Plan to work further on the interface concepts and review what exists in the simplified metamodel.
- Scenario / Action Def
- Physical Path
- Mode and State
- REC/RPL (Definitions and Usages, tooling)
