# Component Port

[Contents](../ArcadiaLibraryMapping.md#contents) | Previous: [Component Exchange](12-ComponentExchange.md) | Next: [Exchange Allocation](14-ExchangeAllocation.md)

## Library definition

```
    port def ComponentPort :> ArcadiaElement {
		private doc /* A generic Arcadia Component Port, used across all Arcadia engineering perspectives.
		 * The direction of the port is given by its directed features: 'out [0..*] : ExchangeItem;' for an output port,
		 * 'in [0..*] : ExchangeItem;' for an input port, both for a bidirectional port. */
		ref item allocatedFunctionPorts: ExchangeItem [*];
		ref item providedInterfaces: Interface [*];
		ref item requiredInterfaces: Interface [*];
    }
```

## Mapping

| ID | Capella concept | Capella metamodel | Treatment | In SysML v2 | Meaning | Rationale |
| --- | --- | --- | --- | --- | --- | --- |
| <a id="cp-01"></a>CP-01 | Component Port | `fa::ComponentPort` | Library | `port def ComponentPort :> ArcadiaElement`, used as `port x : ComponentPort` | A place of interaction between a component and the other components or actors of its environment. Called "behavioral port" in Arcadia | P1: a component port is a port |
| <a id="cp-02"></a>CP-02 | Orientation (In, Out, InOut) | `fa::ComponentPort.orientation` | Native | directed features of the port: `out [0..*] : ExchangeItem;` for an output port, `in [0..*] : ExchangeItem;` for an input port, both for a bidirectional port | Direction of the port | P1, P2: a SysML v2 port has no direction, its features have one, and any tool can read them. P3: no attribute is added to the library |
| <a id="cp-03"></a>CP-03 | Exchange items that go through the port | no dedicated feature on the port: the exchange items come from its component exchanges and allocated function ports | Native | value of the directed features of [CP-02](#cp-02): `out [0..*] : ExchangeItem = (...)` | What the port receives or sends | P1 |
| <a id="cp-04"></a>CP-04 | Allocated function ports | `information::PortAllocation`, owned by the component port (`information::Port.ownedPortAllocations`; derived: `fa::ComponentPort.allocatedFunctionPorts`) | Library | `ref item allocatedFunctionPorts: ExchangeItem [*]`, set with `ref item :>> allocatedFunctionPorts = (<function port>, ...)` | The function ports allocated to the component port | P3: needed by Arcadia; an allocation element is not possible here (see Decisions) |
| <a id="cp-05"></a>CP-05 | Kind (Standard, Flow) | `fa::ComponentPort.kind` | Not translated – legacy | none | Standard ports provide and require interfaces; flow ports carry flows | The distinction comes from SysML v1. Any component port can have directed features and provided or required interfaces |
| <a id="cp-06"></a>CP-06 | Provided and required interfaces | `information::Port.providedInterfaces`, `requiredInterfaces` | Library | `ref item providedInterfaces: Interface [*]` and `ref item requiredInterfaces: Interface [*]`, set with `ref item :>> providedInterfaces = (...)` | The interfaces that the port provides or requires (see the [IF section](22-Interface.md)) | P3: needed by Arcadia (see the decisions of the IF section) |

## Example

From [`examples/concepts/exchanges.sysml`](../../examples/concepts/exchanges.sysml), validated with the SysML v2 pilot implementation.

```
				// CP-01: a component port
				port 'Cable Connector' : ComponentPort {
					// CP-02: an output port; CP-03: the exchange items that go through the port
					out [0..*] : ExchangeItem = (rawOpticalDataX, rawOpticalDataY);
				}
				part 'Image Sensor' : Component {
					perform 'Root Function'.'Capture Movement';
					port 'Sensor Output' : ComponentPort {
						out [0..*] : ExchangeItem = (rawOpticalDataX, rawOpticalDataY);
						// CP-04: function ports allocated to the component port
						ref item :>> allocatedFunctionPorts = ('Root Function'.'Capture Movement'.FOP1);
					}
				}
				// CE-08: the port of the component is delegated to a port of its sub-component
				bind 'Cable Connector' = 'Image Sensor'.'Sensor Output';
```

```
				// CP-02: an input port
				port 'Cable Connector' : ComponentPort {
					in [0..*] : ExchangeItem = (rawOpticalDataX, rawOpticalDataY);
					ref item :>> allocatedFunctionPorts = ('Root Function'.'Transform Raw Optical Data'.FIP2);
				}
				// CP-02: an output port that carries no exchange item yet
				port 'Status Output' : ComponentPort {
					out [0..*] : ExchangeItem;
				}
				// CP-02: a bidirectional port
				port 'Debug Link' : ComponentPort {
					in [0..*] : ExchangeItem;
					out [0..*] : ExchangeItem;
				}
```

## Decisions

- **Direction.** A component port has no direction attribute: its direction is read on its directed features ([CP-02](#cp-02)). An output port has one `out` feature, an input port one `in` feature, a bidirectional port one of each. A port whose orientation is not set has none. A port has at most one `in` feature and one `out` feature.
- A port can be oriented before any exchange item is allocated to it: the directed feature has no value (`out [0..*] : ExchangeItem;`). The exchange items are added later as the value of the same feature ([CP-03](#cp-03)). On a bidirectional port, each exchange item is placed on the feature of its direction.
- Not retained for [CP-02](#cp-02): a direction attribute in the library (it repeats what the directed features already say, nothing keeps the two consistent, other tools do not read it, and it cannot represent a Capella port whose orientation is not set).
- Migration from Capella: orientation OUT gives an `out` feature, IN an `in` feature, INOUT both, UNSET none.
- `allocatedFunctionPorts` is a reference declared in the library, not an allocation element. Its name is the one of Capella: a component port references the function ports allocated to it. It is typed by `ExchangeItem` because a function port is a parameter typed by `ExchangeItem` ([FPORT-01](09-FunctionPort.md#fport-01)): a reference to function ports has the type of these parameters. It cannot be derived from the allocations of functional exchanges to component exchanges, because a port can be allocated before any exchange exists.
- Not retained for [CP-04](#cp-04): an allocation element owned by the port, as for exchanges and realizations (a port usage cannot own an allocation, see limitations; it would have to be owned by the component, there is no official precedent for allocating an action parameter to a port, and the description and status of these allocations are assumed to be rarely used); and a `bind` between the parameter and an item of the port (it equates values, it is not an allocation).
- The provided and required interfaces of a port ([CP-06](#cp-06)) are described in the [IF section](22-Interface.md), with an example.
- A component port of a hosted component is made accessible through a physical port of its hosting component: see [PHYS-02](23-PhysicalLinksAndPaths.md#phys-02).
- There are no component ports in Operational Analysis.
- Node Components have physical ports, not component ports (see the [PHYS section](23-PhysicalLinksAndPaths.md)).

## Tooling requirements

- [CP-02](#cp-02): the direction of a port is computed from its directed features and changes its icon. Tooling creates, changes or removes the directed features when the user sets the direction of the port, and reports a port that has more than one `in` feature or more than one `out` feature.
- [CP-04](#cp-04): the allocation is displayed as a link between the function port and the component port. A migration creates the reference from the Capella port allocations.

## SysML v2 limitations

- A port has no direction: only its features have one.
- A port usage cannot own an allocation: the pilot implementation answers "Nested usages in a port usage (other than ports) must be referential".

## Open points

None.
