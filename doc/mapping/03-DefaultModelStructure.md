# Default model structure

[Contents](../ArcadiaLibraryMapping.md#contents) | Previous: [ArcadiaPackage](02-ArcadiaPackage.md) | Next: [Packages](04-Packages.md)

## Library definition

None. The default structure is not a library element: it is a model template, given in `lib/ArcadiaDefaultStructure.sysml`, that tooling instantiates when a project is created.

## Mapping

| ID | Capella concept | Capella metamodel | Treatment | In SysML v2 | Meaning | Rationale |
| --- | --- | --- | --- | --- | --- | --- |
| <a id="struct-01"></a>STRUCT-01 | Project and its System Engineering root | `capellamodeller::Project`, `capellamodeller::SystemEngineering` | Native | `occurrence def <short name> 'name'`, annotated with `ArcadiaPackage` ([PKGM-07](02-ArcadiaPackage.md#pkgm-07)) | The root of the model | P1. An occurrence definition gives a name, a short name and a namespace to the model |
| <a id="struct-02"></a>STRUCT-02 | The five architectures | `capellacore::AbstractModellingStructure.ownedArchitectures` | Native | one package per perspective, with a fixed short name: `<OA>`, `<SA>`, `<LA>`, `<PA>`, `<EPBS>`, annotated with `ArcadiaPackage` ([PKGM-02](02-ArcadiaPackage.md#pkgm-02) to [PKGM-06](02-ArcadiaPackage.md#pkgm-06)) | The engineering perspectives | P1: perspectives are packages |
| <a id="struct-03"></a>STRUCT-03 | Operational Activities / System Functions / Logical Functions / Physical Functions | `fa::AbstractFunctionalArchitecture.ownedFunctionPkg` | Native | `package Functions` | Contains the functions of the perspective | P6: same package name in every perspective |
| <a id="struct-04"></a>STRUCT-04 | Operational Capabilities / Capabilities | `cs::BlockArchitecture.ownedAbstractCapabilityPkg` | Native | `package Capabilities` | Contains the capabilities of the perspective | P6 |
| <a id="struct-05"></a>STRUCT-05 | Missions (System Analysis) | `ctx::SystemAnalysis.ownedMissionPkg` | Native | `package Capabilities` (no dedicated package) | Contains the missions | P3: missions are kept with the capabilities they exploit |
| <a id="struct-06"></a>STRUCT-06 | Interfaces | `cs::BlockArchitecture.ownedInterfacePkg` | Native | `package Interfaces` | Contains the interfaces and exchange items | P6 |
| <a id="struct-07"></a>STRUCT-07 | Data | `cs::BlockArchitecture.ownedDataPkg` | Native | `package Data` | Contains the data model | P6 |
| <a id="struct-08"></a>STRUCT-08 | Operational Entities / Structure | `oa::OperationalAnalysis.ownedEntityPkg`, `ctx::SystemAnalysis.ownedSystemComponentPkg`, `la::LogicalArchitecture.ownedLogicalComponentPkg`, `pa::PhysicalArchitecture.ownedPhysicalComponentPkg`, `epbs::EPBSArchitecture.ownedConfigurationItemPkg` | Native | `package Structure` | Contains the components and actors of the perspective | P6 |
| <a id="struct-09"></a>STRUCT-09 | (no Capella counterpart: the Capella core metamodel has no requirement concept) | none | Native | `package Requirements` | Contains the requirements of the perspective (see the REQ section) | P6 |
| <a id="struct-10"></a>STRUCT-10 | Roles (Operational Analysis) | `oa::OperationalAnalysis.ownedRolePkg` | Not translated – replaced by definition/usage | none | Contains the roles | Roles are not translated (see [COMP-10](05-Component.md#comp-10)) |
| <a id="struct-11"></a>STRUCT-11 | Root Operational Activity / Root System Function / Root Logical Function / Root Physical Function | the root function of `ownedFunctionPkg` | Library | `action 'Root Activity' : Function` in OA, `action 'Root Function' : Function` in the other perspectives | The function that contains all the functions of the perspective | P6: same name in every perspective, except in OA where Capella speaks of activities |
| <a id="struct-12"></a>STRUCT-12 | System / Logical System / Physical System | the root component of the component package | Library | `part system : Component`; none in OA | The component that represents the system in the perspective | P6. Capella has no root component in Operational Analysis |
| <a id="struct-13"></a>STRUCT-13 | Default realizations between the root elements of consecutive perspectives | realization objects created with the project (see the REAL section) | Library | `allocation : Realization allocate <root of the previous perspective> to self;` | A new project already links each root function and each root component to the one of the previous perspective | P5: same initial model as in Capella |
| <a id="struct-14"></a>STRUCT-14 | Operational concepts (Concept, Capability Configuration, Location, Organisational Unit, Community of Interest) and their package | `oa::OperationalAnalysis.ownedConceptPkg`, `oa::ConceptPkg`, `oa::Concept` and related classes | Not translated – rarely used | none | Describes how capabilities are used in an operational context | P4: present in the Capella metamodel, with no known use in Capella models |

## Example

From [`examples/concepts/default-structure.sysml`](../../examples/concepts/default-structure.sysml), validated with the SysML v2 pilot implementation.

```
// STRUCT-01: the top-level element of the model, with a name and a short name
occurrence def <MOUSE> 'Optical Mouse' {
	private import Arcadia::*;
	metadata ArcadiaPackage { engineeringPerspective = ArcadiaEngineeringPerspective::SystemEngineering; }

	// STRUCT-02: one package per engineering perspective (here two of the five)
	package <SA> 'System Analysis' {
		metadata ArcadiaPackage { engineeringPerspective = ArcadiaEngineeringPerspective::SystemAnalysis; }
		// STRUCT-03 to STRUCT-09: the same six packages in every perspective
		package Functions {
			// STRUCT-11: root function
			action 'Root Function' : Function;
		}
		package Capabilities;
		package Interfaces;
		package Data;
		package Structure {
			// STRUCT-12: root component
			part system : Component;
		}
		package Requirements;
	}

	package <LA> 'Logical Architecture' {
		metadata ArcadiaPackage { engineeringPerspective = ArcadiaEngineeringPerspective::LogicalArchitecture; }
		package Functions {
			action 'Root Function' : Function {
				// STRUCT-13: default realization of the root function of the previous perspective
				allocation : Realization allocate SA::Functions::'Root Function' to self;
			}
		}
		package Capabilities;
		package Interfaces;
		package Data;
		package Structure {
			part system : Component {
				// STRUCT-13: default realization of the root component of the previous perspective
				allocation : Realization allocate SA::Structure::system to self;
			}
		}
		package Requirements;
	}
}
```

The complete template, with the five perspectives, is `lib/ArcadiaDefaultStructure.sysml`.

## Decisions

- The engineering perspectives are packages.
- The six second-level packages (`Functions`, `Capabilities`, `Interfaces`, `Data`, `Structure`, `Requirements`) are the same in every perspective, whereas their Capella names depend on the perspective.
- The short names of the perspectives are fixed (`OA`, `SA`, `LA`, `PA`, `EPBS`). The name and the short name of the top-level element are given by the user when the project is created: a fixed short name would be the same in all models and would create conflicts when a model references another one.
- Default realizations: the root functions are linked SA→OA, LA→SA and PA→LA; the `system` components are linked LA→SA, PA→LA and EPBS→PA. There is none for `system` in SA, because Capella has no root component in OA. The `'Root Function'` of EPBS has no Capella counterpart and no realization.
- Usages (parts, actions…) are owned by packages, as in the SysML v2 reference models. The top-level occurrence definition is kept for the name, the short name, the namespace and the `ArcadiaPackage` annotation it carries.

## Tooling requirements

- [STRUCT-01](#struct-01) to [STRUCT-13](#struct-13): the creation of a project generates this structure, including the `ArcadiaPackage` annotations and the default realizations, so that the initial model is the same as in Capella.
- [STRUCT-01](#struct-01): the user gives the name and the short name of the model.
- [STRUCT-11](#struct-11), [STRUCT-12](#struct-12): tooling prevents the creation of a second root function next to the root function, and of components next to the root component, except actors.

## SysML v2 limitations

- A package is not a classifier: there is no "package definition" that the library could define and that models would reuse. This is why the structure is a template instantiated by tooling.
- A usage that is owned only by a package is implicitly a feature of `Anything`: a value for it is available within any instance of any type. Nesting the packages in a definition does not change this: a package nested in a definition does not make its usages features of that definition (checked with the pilot implementation). It is a property of the language, also present in the reference models, and not a modeling choice of this library.

## Open points

[OP-EPBS](../ArcadiaLibraryMapping.md#op-epbs) (see the [open points register](../ArcadiaLibraryMapping.md#open-points-register)).
