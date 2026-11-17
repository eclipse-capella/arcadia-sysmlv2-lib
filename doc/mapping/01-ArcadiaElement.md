# ArcadiaElement

[Contents](../ArcadiaLibraryMapping.md#contents) | Previous: [Introduction](../ArcadiaLibraryMapping.md) | Next: [ArcadiaPackage](02-ArcadiaPackage.md)

## Library definition

```
    abstract occurrence def ArcadiaElement {
    	private doc /* Reusable structure shared by all Arcadia elements.*/
    }
```

## Mapping

| ID | Capella concept | Capella metamodel | Treatment | In SysML v2 | Meaning | Rationale |
| --- | --- | --- | --- | --- | --- | --- |
| <a id="elem-01"></a>ELEM-01 | Common ancestor of all model elements | `capellacore::CapellaElement` and its inheritance hierarchy | Library | `abstract occurrence def ArcadiaElement`, specialized by every definition of the library | What all Arcadia elements have in common | P3: one top-level definition shared by all the concepts of the library |
| <a id="elem-02"></a>ELEM-02 | Name | `modellingcore::AbstractNamedElement.name` | Native | declared name of the element | Name of the element | P1 |
| <a id="elem-03"></a>ELEM-03 | Description | `capellacore::CapellaElement.description` | Native | `doc description /* ... */` | Rich text description of the element (HTML in Capella) | P1: a documentation named `description`, so that it is told apart from other `doc` of the element |
| <a id="elem-04"></a>ELEM-04 | Summary | `capellacore::CapellaElement.summary` | Not translated – rarely used | none | Short description of the element | P4 |
| <a id="elem-05"></a>ELEM-05 | Visible in Documentation | `modellingcore::PublishableElement.visibleInDoc` | Not translated – out of library scope | none | The element appears in the generated documentation | A setting for document generation, not an Arcadia concept |
| <a id="elem-06"></a>ELEM-06 | Visible for Traceability | `modellingcore::PublishableElement.visibleInLM` | Not translated – legacy | none | The element is visible for traceability tools | P4 |
| <a id="elem-07"></a>ELEM-07 | Progress Status | `capellacore::CapellaElement.status` | Native | metadata annotation `@StatusInfo { status = StatusKind::... ; }` | Review status of the element | P1: standard SysML v2 metadata |
| <a id="elem-08"></a>ELEM-08 | Review | `capellacore::CapellaElement.review` | Not translated – rarely used | none | Free text about the review of the element | P4: rarely used, and not sufficient to manage reviews |
| <a id="elem-09"></a>ELEM-09 | Property Values and Property Value Groups | `capellacore::CapellaElement.ownedPropertyValues`, `appliedPropertyValues`, `ownedPropertyValueGroups`, `appliedPropertyValueGroups` | Native | attribute usages (see the PV section) | User-defined values attached to an element | P1 |
| <a id="elem-10"></a>ELEM-10 | Identifier | `modellingcore::ModelElement.id` | Deferred – [OP-ID](../ArcadiaLibraryMapping.md#op-id) | none | Technical identifier of the element, set on every element | Not decided yet |
| <a id="elem-11"></a>ELEM-11 | Shared identifier | `modellingcore::ModelElement.sid` | Deferred – [OP-ID](../ArcadiaLibraryMapping.md#op-id) | none | Identifier shared by an element and its replicas | Not decided yet |
| <a id="elem-12"></a>ELEM-12 | Constraints | `modellingcore::ModelElement.ownedConstraints` | Deferred – [OP-CONSTRAINTS](../ArcadiaLibraryMapping.md#op-constraints) | none | Constraints attached to an element, often as free text | Not decided yet |
| <a id="elem-13"></a>ELEM-13 | Features | `capellacore::CapellaElement.features` | Not translated – rarely used | none | Enumeration literals attached to an element | P4 |

## Example

From [`examples/concepts/arcadia-element.sysml`](../../examples/concepts/arcadia-element.sysml), validated with the SysML v2 pilot implementation.

```
	// ELEM-01: every Arcadia element specializes ArcadiaElement (here through Component)
	// ELEM-02: name
	part 'Optical Sensor Unit' : Component {
		// ELEM-03: description
		doc description /*Captures surface movement using optical detection.*/
		// ELEM-07: progress status
		@StatusInfo {status = StatusKind::tbd;}
		// ELEM-09: property value
		attribute 'Mass' = 0.4 [kg];
	}
```

## Decisions

- `ArcadiaElement` is abstract. The other definitions of the library (Component, Function…) are not, so that semantic metadata can be defined on them later. No semantic metadata is defined for now: writing `#component part x` instead of `part x : Component` brings little to the user, and tool support is uncertain.
- An element can have several `doc`. The one that holds the Capella description is named `description`.
- Default mapping of the Capella progress status to `StatusKind`: DRAFT = `tbd`, TO BE REVIEWED = `tbr`, TO BE DISCUSSED = `tbc`, REWORK NECESSARY = `open`, UNDER REWORK = `open`, REVIEWED = `done`.
- The elements realized by an element, and those that realize it, are not properties of the element: they are `Realization` allocations (see the REAL section).

## Tooling requirements

- [ELEM-02](#elem-02): the name is the label shown on diagrams and in the properties of the element.
- [ELEM-03](#elem-03): rich text editing of the description. When migrating from Capella, the images embedded in descriptions have to be taken into account.
- [ELEM-07](#elem-07): the status is selected in a list.
- [ELEM-07](#elem-07): Capella projects can define their own status values; a migration has to handle them specifically (see limitations).

## SysML v2 limitations

- An enumeration of a library cannot be redefined. A project that wants its own status values has to define its own enumeration.

## Open points

[OP-ID](../ArcadiaLibraryMapping.md#op-id), [OP-CONSTRAINTS](../ArcadiaLibraryMapping.md#op-constraints) (see the [open points register](../ArcadiaLibraryMapping.md#open-points-register)).
