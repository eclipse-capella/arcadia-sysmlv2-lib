# Property values

[Contents](../ArcadiaLibraryMapping.md#contents) | Previous: [Mission](19-Mission.md) | Next: [Views](21-Views.md)

## Library definition

None. Property values are not part of the library: they are native SysML v2 attributes owned by the element. This section documents the convention, so that all tools handle them in the same way.

## Mapping

| ID | Capella concept | Capella metamodel | Treatment | In SysML v2 | Meaning | Rationale |
| --- | --- | --- | --- | --- | --- | --- |
| <a id="pv-01"></a>PV-01 | Property Value (String, Integer, Float, Boolean) | `capellacore::StringPropertyValue`, `IntegerPropertyValue`, `FloatPropertyValue`, `BooleanPropertyValue`, owned by the element (`capellacore::CapellaElement.ownedPropertyValues`) | Native | attribute usage owned by the element, with its value: `attribute 'Safety Class' : Integer = 2;` | A user-defined value attached to an element, inside a group or not | P1: no Arcadia-specific concept is needed |
| <a id="pv-02"></a>PV-02 | (no Capella counterpart: Capella property values have no unit) | none | Native | a unit in the value of the attribute: `attribute 'Mass' = 0.4 [kg];` | A physical quantity | P1: units are expected in SysML v2 models and come from the standard SI library |
| <a id="pv-03"></a>PV-03 | Property Value Group | `capellacore::PropertyValueGroup` (`capellacore::CapellaElement.ownedPropertyValueGroups`) | Native | attribute usage without type, that contains attribute usages: `attribute 'Budget' { attribute 'Power' = 2.5 [W]; }` | A named set of property values | P1: a Capella group is only a container of values, not a definition, so no attribute definition is needed |
| <a id="pv-04"></a>PV-04 | Description of a property value | `capellacore::CapellaElement.description` | Native | `doc description /* ... */` inside the attribute | Free text that describes the property value | P1: same as for the description of other elements ([ELEM-03](01-ArcadiaElement.md#elem-03)) |
| <a id="pv-05"></a>PV-05 | Enumeration property values | `capellacore::EnumerationPropertyValue`, `EnumerationPropertyType`, `EnumerationPropertyLiteral` | Deferred – [OP-PV-ENUM](../ArcadiaLibraryMapping.md#op-pv-enum) | none | A property value whose value is a literal of a user-defined list | Not decided yet |
| <a id="pv-06"></a>PV-06 | Shared property values, applied to elements | `capellacore::CapellaElement.appliedPropertyValues`, `appliedPropertyValueGroups`, `capellacore::PropertyValuePkg` | Deferred – [OP-PV-SHARED](../ArcadiaLibraryMapping.md#op-pv-shared) | none | Property values defined in a package and applied to several elements by reference | Not decided yet (see [PKG-11](04-Packages.md#pkg-11)) |
| <a id="pv-07"></a>PV-07 | Property values defined with the PVMT add-on | none in the Capella core metamodel | Not translated – out of library scope | none | Domains, groups and scopes defined with an add-on | An add-on, not native Capella |

## Example

From [`examples/concepts/property-values.sysml`](../../examples/concepts/property-values.sysml), validated with the SysML v2 pilot implementation.

```
	part 'Optical Sensor Unit' : Component {
		// PV-01: a property value
		attribute 'Safety Class' : Integer = 2;
		// PV-02: a physical quantity, with its unit; PV-04: its description
		attribute 'Mass' = 0.4 [kg] {
			doc description /*Mass of the module without cable.*/
		}
		// PV-03: a property value group
		attribute 'Budget' {
			attribute 'Power' = 2.5 [W];
		}
	}
```

## Decisions

- **Models created in SysML v2.** Every property value is an attribute. A physical quantity carries a unit in its value (`[kg]`, `[W]`). A quantity type of the ISQ library (for example `MassValue`) can be used but is optional. Values without dimension use `Real`, `Integer`, `String` or `Boolean`.
- **Migration from Capella.** Capella property values have no unit: each one becomes an attribute without a unit, and no unit is inferred. A group becomes an attribute without type that contains the attributes of the group. A property value owned outside any group becomes a flat attribute of the element. The description becomes a `doc description`. Names are kept, between quotes when needed.
- SysML v2 attributes can express more than Capella property values (computed values, conversions, multiple values, constraints). This section only describes the conversion from Capella.
- Property values on packages are not covered (see [PKG-06](04-Packages.md#pkg-06) and [OP-PKG-FIELDS](../ArcadiaLibraryMapping.md#op-pkg-fields)).

## Tooling requirements

- Property values are shown in a dedicated part of the properties of the element; the unit is part of the value.

## SysML v2 limitations

- With the pilot implementation, an ISQ quantity type is not checked against the unit: `attribute m : MassValue = 3.0 [s];` raises no warning.
- Two attributes with the same name in the same element give a warning.
- Unit symbols come from the SI library: `kg`, `W`, `mm` and `g` exist, but not all prefixed symbols are predefined (`ms` is written `milli*s`, and the degree Celsius is `'°C'`). Units outside SI need an import, for example `USCustomaryUnits`.

## Open points

[OP-PV-ENUM](../ArcadiaLibraryMapping.md#op-pv-enum), [OP-PV-SHARED](../ArcadiaLibraryMapping.md#op-pv-shared), [OP-PKG-FIELDS](../ArcadiaLibraryMapping.md#op-pkg-fields) (see the [open points register](../ArcadiaLibraryMapping.md#open-points-register)).
