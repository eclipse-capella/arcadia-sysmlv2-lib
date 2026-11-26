# Packages

[Contents](../ArcadiaLibraryMapping.md#contents) | Previous: [Default model structure](03-DefaultModelStructure.md) | Next: [Component](05-Component.md)

## Library definition

None. A Capella package is a plain SysML v2 package, wherever it sits in Capella: nested in the second-level package that matches its content (`Functions`, `Capabilities`, `Interfaces`, `Data`, `Structure`, `Requirements`), in another package, in a function or in a component.

## Mapping

| ID | Capella concept | Capella metamodel | Treatment | In SysML v2 | Meaning | Rationale |
| --- | --- | --- | --- | --- | --- | --- |
| <a id="pkg-01"></a>PKG-01 | Function packages (Operational Activity Pkg, System Function Pkg, Logical Function Pkg, Physical Function Pkg) | `oa::OperationalActivityPkg`, `ctx::SystemFunctionPkg`, `la::LogicalFunctionPkg`, `pa::PhysicalFunctionPkg` (all `fa::FunctionPkg`); owned by a package or by a function (`ownedOperationalActivityPkgs`, `ownedSystemFunctionPkgs`, `ownedLogicalFunctionPkgs`, `ownedPhysicalFunctionPkgs`) | Native | `package`, nested in a package or in the body of an action | Organizes functions | P1: a Capella package is a pure organizational element, like a SysML v2 package |
| <a id="pkg-02"></a>PKG-02 | Capability and mission packages (Operational Capability Pkg, Capability Pkg, Capability Realization Pkg, Mission Pkg) | `oa::OperationalCapabilityPkg`, `ctx::CapabilityPkg`, `la::CapabilityRealizationPkg`, `ctx::MissionPkg` | Native | `package` | Organizes capabilities and missions | P1 |
| <a id="pkg-03"></a>PKG-03 | Interface Pkg | `cs::InterfacePkg` | Native | `package` | Organizes interfaces and exchange items | P1 |
| <a id="pkg-04"></a>PKG-04 | Data Pkg | `information::DataPkg` | Native | `package` | Organizes classes, data types, collections, units, signals and messages | P1 |
| <a id="pkg-05"></a>PKG-05 | Component packages (Entity Pkg, System Component Pkg, Logical Component Pkg, Physical Component Pkg) | `oa::EntityPkg`, `ctx::SystemComponentPkg`, `la::LogicalComponentPkg`, `pa::PhysicalComponentPkg` (all `cs::ComponentPkg`); owned by a package or by a component (`ownedSystemComponentPkgs`, `ownedLogicalComponentPkgs`, `ownedPhysicalComponentPkgs`) | Native | `package`, nested in a package or in the body of a part | Organizes components and actors | P1 |
| <a id="pkg-06"></a>PKG-06 | Description, status and other fields of a package | features inherited from `capellacore::CapellaElement` (see the ELEM section) | Native | `doc description /* ... */` and `@StatusInfo` on the package, when needed | Same as for any element | P1: the same writing as for any other element. Rarely used on packages |
| <a id="pkg-07"></a>PKG-07 | Role Pkg | `oa::RolePkg` | Not translated – replaced by definition/usage | none | Organizes roles | Roles are not translated (see [COMP-10](05-Component.md#comp-10)) |
| <a id="pkg-08"></a>PKG-08 | Concept Pkg | `oa::ConceptPkg` | Not translated – rarely used | none | Organizes operational concepts | See [STRUCT-14](03-DefaultModelStructure.md#struct-14) |
| <a id="pkg-09"></a>PKG-09 | Configuration Item Pkg | `epbs::ConfigurationItemPkg` | Deferred – [OP-EPBS](../ArcadiaLibraryMapping.md#op-epbs) | none | Organizes the configuration items of the EPBS | EPBS is not covered yet |
| <a id="pkg-10"></a>PKG-10 | Generic Pkg | `sharedmodel::GenericPkg` | Not translated – legacy | none | Generic container of the "shared model" mechanism, meant to share elements between projects | P4: remainder of an earlier tool generation, according to the Capella metamodel itself |
| <a id="pkg-11"></a>PKG-11 | Property Value Pkg | `capellacore::PropertyValuePkg`, owned by a package or an architecture (`capellacore::Structure.ownedPropertyValuePkgs`) | Deferred – [OP-PV-SHARED](../ArcadiaLibraryMapping.md#op-pv-shared) | none | Contains property values, groups and enumeration types that are shared: they are applied to elements by reference | Shared (applied) property values are not covered yet (see the PV section) |
| <a id="pkg-12"></a>PKG-12 | Interface, data and capability packages owned by a component | `cs::Block.ownedInterfacePkg`, `ownedDataPkg`, `ownedAbstractCapabilityPkg` (one of each per component) | Not translated – rarely used | none | Interfaces, exchange items, data or capability realizations local to a component: in Capella, they are offered only to the elements of this component and of its sub-components | P4: found neither in the Capella sample models nor in the Capella documentation, only in the automated test models of Capella. Reproducing them would need a dedicated package per component, with a restricted content and a visibility rule. Packages that organize the sub-components of a component remain covered ([PKG-05](#pkg-05)) |

## Example

From [`examples/concepts/packages.sysml`](../../examples/concepts/packages.sysml), validated with the SysML v2 pilot implementation.

```
	package Functions {
		action 'Root Function' : Function {
			// PKG-01: a function package owned by a function
			package 'Motion Filtering' {
				action 'Filter Noise' : Function;
			}
		}
		// PKG-01: a function package owned by a package
		package 'Power Management' {
			action 'Manage Power' : Function;
		}
	}

	package Data {
		// PKG-04: a data package
		package 'Status Data' {
			item batteryLevel : ExchangeItem;
		}
	}

	package Structure {
		// PKG-05: a component package owned by a package
		package 'External Actors' {
			part technician : Component { :>> isActor = true; }
		}
		part system : Component {
			part 'Mouse Controller' : Component {
				// PKG-05: a component package owned by a component
				package 'Mechanical Parts' {
					part 'Mouse Casing' : Component;
				}
			}
		}
	}
```

## Decisions

- No library concept: the plain SysML v2 package is used. It limits what is put in the library and keeps the models close to a standard use of SysML v2.
- The kind of a Capella package is not stored in the model. What a package can contain follows from where it is: the second-level package in which it is nested, or the function or component that owns it.
- A package is not annotated with `ArcadiaPackage`: its engineering perspective is given by the closest enclosing element annotated with `ArcadiaPackage` (see the PKGM section).
- A package nested in an action or in a part is only a namespace: its elements are not features of that action or part (checked with the pilot implementation). The sub-functions of a function are therefore defined as its direct sub-actions plus the actions of its nested packages and sub-packages, as Capella does with its derived `subFunctions`. In the same way, the sub-components of a component are the parts it owns directly plus those owned by its nested packages and sub-packages. For components, Capella is not uniform: its derived `subLogicalComponents` and `subPhysicalComponents` only consider the parts owned directly by the component, whereas the component breakdown of its Semantic Browser also goes through component packages; this library follows the latter.
- Capella restricts where each kind of package can be created. These restrictions are not reproduced: for simplicity and homogeneity, any package can be created where a package is allowed.
- The interface, data and capability packages that Capella allows inside a component are not reproduced ([PKG-12](#pkg-12)). A migration moves their content to the `Interfaces`, `Data` or `Capabilities` package of the engineering perspective; the restriction of visibility to the component is lost.

## Tooling requirements

- All packages can be displayed in the same way (one folder representation).
- Tooling can restrict the content of a package according to where it is, as for `Functions` and `Structure`.
- [PKG-01](#pkg-01), [PKG-05](#pkg-05): tooling computes the sub-functions of a function and the sub-components of a component by going through their nested packages.
- [PKG-06](#pkg-06): tooling can give access to the description and to the status of a package.
- [PKG-12](#pkg-12): tooling does not offer to create interface, data or capability packages inside a component.

## SysML v2 limitations

- A package cannot be specialized: no dedicated element can be defined in the library for Capella packages, nor for the packages of the engineering perspectives.
- The functions, components and capabilities contained in a package are usages owned by a package (see the STRUCT section).

## Open points

[OP-EPBS](../ArcadiaLibraryMapping.md#op-epbs), [OP-PV-SHARED](../ArcadiaLibraryMapping.md#op-pv-shared) (see the [open points register](../ArcadiaLibraryMapping.md#open-points-register)).
