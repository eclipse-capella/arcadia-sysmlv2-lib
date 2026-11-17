# Requirements

[Contents](../ArcadiaLibraryMapping.md#contents) | Previous: [Exchange Item](16-ExchangeItem.md) | Next: [Capability](18-Capability.md)

## Library definition

None. The library has no requirement concept: Arcadia models use the native SysML v2 `requirement` as is. The Capella core metamodel has no requirement concept either, so there is no Capella column in the table below.

## Mapping

| ID | Need | Treatment | In SysML v2 |
| --- | --- | --- | --- |
| REQ-01 | A requirement | Native | `requirement`, in the `Requirements` package of an engineering perspective |
| REQ-02 | Identifier of a requirement | Native | short name: `requirement <'R1.1'> Optical` |
| REQ-03 | Statement of a requirement (the "shall" statement) | Native | `doc` of the requirement |
| REQ-04 | Status of a requirement | Native | `@StatusInfo` metadata, optional |
| REQ-05 | Organization of the requirements | Native | requirements nested in requirements; sub-packages of `Requirements` |
| REQ-06 | Link between a requirement and a model element | Native | `satisfy <requirement>;` owned by the satisfying element |
| REQ-07 | Trace between requirements | Native | derivation connection of the `RequirementDerivation` library: `#derivation connection { end #original ::> ...; end #derive ::> ...; }` |

## Example

From `examples/concepts/requirements.sysml`, validated with the SysML v2 pilot implementation.

```
			requirement <'R1'> 'Movement Capture' {
				doc /* The mouse shall capture its movement */
				// REQ-05: nesting only organizes the requirements
				requirement <'R1.1'> Optical {
					doc /* The mouse shall capture movement using optical detection */
					// REQ-04: status
					@StatusInfo {status = StatusKind::tbd;}
				}
			}
			// REQ-07: a derived requirement and the original one
			#derivation connection {
				end #original ::> SA::Requirements::'Cursor Control';
				end #derive ::> 'Movement Capture';
			}
```

```
				part 'Optical Sensor Unit' : Component {
					// REQ-06: the component satisfies a requirement
					satisfy Requirements::'Movement Capture'.Optical;
				}
```

## Decisions

- Requirements have their own hierarchy, in the `Requirements` package of each engineering perspective (see STRUCT-09).
- Nesting is only a way to organize requirements: it is not a trace.
- A requirement can be linked to any element of an Arcadia model (function, component, exchange, capability…) with a `satisfy`, owned by the satisfying element.
- The `subject` of a requirement is not used for this link: a requirement has a single subject, whereas it can be satisfied by several elements.
- A derivation goes from the derived requirement to the original one, for instance from a logical requirement to the system requirement it derives from.
- The other requirement features of SysML v2 (typing of the `subject`, `concern`, `stakeholder`, `frame`, `actor`, constraints, `verify`) are valid but are not part of the Arcadia concepts: they are not described here.

## Tooling requirements

- Tooling creates requirements in the `Requirements` packages, and shows the requirements satisfied by an element and the elements that satisfy a requirement.

## SysML v2 limitations

- The satisfying element has to be a usage: a requirement cannot be satisfied by a package or by a definition.
- The pilot implementation reports a warning on `satisfy` when it is owned by a part ("Duplicate of inherited member name 'this'"). It is known and has no effect on the model.

## Open points

None.
