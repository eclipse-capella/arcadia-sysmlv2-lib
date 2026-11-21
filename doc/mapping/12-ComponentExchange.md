# Component Exchange

[Contents](../ArcadiaLibraryMapping.md#contents) | Previous: [Functional Exchange](11-FunctionalExchange.md) | Next: [Component Port](13-ComponentPort.md)

## Library definition

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

## Mapping

| ID | Capella concept | Capella metamodel | Treatment | In SysML v2 | Meaning | Rationale |
| --- | --- | --- | --- | --- | --- | --- |
| <a id="ce-01"></a>CE-01 | Component Exchange; Communication Mean in Operational Analysis | `fa::ComponentExchange`, `oa::CommunicationMean` | Library | `interface def ComponentExchange :> ArcadiaElement`, used as `interface x : ComponentExchange connect <port> to <port>` | A possible interaction between two behavioral components, that transmits exchange items through their ports. Called "behavioral exchange" in Arcadia | P1: a component exchange is an interface between two ports |
| <a id="ce-02"></a>CE-02 | Source port | derived `fa::ComponentExchange.sourcePort` | Library | `end cp1 : ComponentPort` | The port from which the exchange starts | P1 |
| <a id="ce-03"></a>CE-03 | Target port | derived `fa::ComponentExchange.targetPort` | Library | `end cp2 : ComponentPort` | The port where the exchange ends | P1 |
| <a id="ce-04"></a>CE-04 | Conveyed exchange items | `modellingcore::AbstractInformationFlow.convoyedInformations` | Library | `ref item allocatedExchangeItems: ExchangeItem[*]`, set with `ref item :>> allocatedExchangeItems = (...)` | The exchange items conveyed by the component exchange | P3: needed by Arcadia, no native equivalent that fits (see Decisions) |
| <a id="ce-05"></a>CE-05 | Allocated functional exchanges | derived `fa::ComponentExchange.allocatedFunctionalExchanges` | Derived | the `ExchangeAllocation` usages owned by the component exchange (see the EA section) | The functional exchanges allocated to the component exchange | The link is stored once, as an allocation, as in Capella |
| <a id="ce-06"></a>CE-06 | Kind (Assembly, Delegation, Flow) | `fa::ComponentExchange.kind` | Not translated – legacy | none | Kind of the component exchange, inherited from the UML connector kinds | Arcadia has behavioral exchanges and delegation links, not kinds of exchanges. A delegation is expressed by [CE-08](#ce-08); the distinction between Assembly and Flow is not reproduced (see Decisions) |
| <a id="ce-07"></a>CE-07 | Component exchange categories | `fa::ComponentExchangeCategory` (derived: `fa::ComponentExchange.categories`) | Deferred – [OP-CATEGORIES](../ArcadiaLibraryMapping.md#op-categories) | none | A named group of component exchanges, used to simplify diagrams | Not decided yet |
| <a id="ce-08"></a>CE-08 | Delegation | `fa::ComponentExchange` with `kind = DELEGATION` (derived: `fa::ComponentPort.delegatedComponentPorts`, `delegatingComponentPorts`) | Native | `bind <port of the component> = <sub-component>.<port>;`, owned by the component | A port of a component is delegated to a port of one of its sub-components | P1: a binding connector is the standard way to delegate a port, as in the Annex A model of the specification. Nothing is added to the library |

## Example

From [`examples/concepts/exchanges.sysml`](../../examples/concepts/exchanges.sysml), validated with the SysML v2 pilot implementation.

```
			// CE-01: a component exchange between two component ports (CE-02, CE-03)
			interface cable : ComponentExchange
				connect 'Optical Sensor Unit'.'Cable Connector' to 'Mouse Controller'.'Cable Connector' {
				// CE-04: exchange items conveyed by the component exchange
				ref item :>> allocatedExchangeItems = (rawOpticalDataX, rawOpticalDataY);
				// EA-01: the functional exchange allocated to the component exchange
				allocation : ExchangeAllocation allocate 'Root Function'.'Optical Data' to self;
			}
```

```
			part 'Optical Sensor Unit' : Component {
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
			}
```

## Decisions

- `allocatedExchangeItems` is a stored list, independent of the functional exchanges allocated to the component exchange, as in Capella: the Capella reference has no constraint, and the consistency with the exchange items of the allocated functional exchanges is only checked by validation rules that raise warnings. It is not constrained in the library either.
- Not retained for [CE-04](#ce-04): a SysML v2 constraint in the library (stricter than Capella and heavy to write); and replacing the list by the payload of a flow of the interface (native, but the payload is untyped and a flow is directed, whereas a component exchange can convey exchange items in both directions).
- The list of allocated functional exchanges is not stored on the component exchange ([CE-05](#ce-05)): see the EA section.
- **Delegation.** A port of a component is delegated to a port of one of its sub-components with a binding connector, owned by the component ([CE-08](#ce-08)). The binding states that the two ports are the same interaction point, seen from outside and from inside the component: the two ports have the same direction. It is recommended to connect a decomposed component through its own ports, not through the ports of its sub-components. A binding can be named (`binding <name> bind ... = ...;`).
- A delegation is not a `ComponentExchange`: it conveys no exchange items and no functional exchange is allocated to it. A migration creates a binding from a Capella component exchange of kind Delegation; its description, status and property values are not kept.
- Not retained for [CE-08](#ce-08): a `kind` attribute on `ComponentExchange`, or a specialization of `ComponentExchange` for delegations (a connection between the two ports tells other tools that two different ports are linked, not that the port of the component is the port of its sub-component, and it adds to the library).
- **Assembly and Flow.** These kinds come from UML and SysML v1, where they go with standard ports and flow ports ([CP-05](13-ComponentPort.md#cp-05)). They are not reproduced: a component exchange that is not a delegation is a `ComponentExchange`.
- A component exchange is carried by a physical link or by a physical path: see [PHYS-04](23-PhysicalLinksAndPaths.md#phys-04).
- Node Components have physical links, not component exchanges (see the [PHYS section](23-PhysicalLinksAndPaths.md)).

## Tooling requirements

- [CE-04](#ce-04): tooling can propose the exchange items of the allocated functional exchanges, and report the differences.
- [CE-05](#ce-05): the allocated functional exchanges of a component exchange are computed from the allocations.
- [CE-08](#ce-08): a binding between a port of a component and a port of one of its sub-components is displayed as a delegation link. Tooling reports a delegation between two ports that do not have the same direction, and a port delegated to several ports.

## SysML v2 limitations

- A stored reference to flows (`ref flow`) on the interface is rejected by the pilot implementation (see the FC section).

## Open points

[OP-CATEGORIES](../ArcadiaLibraryMapping.md#op-categories) (see the [open points register](../ArcadiaLibraryMapping.md#open-points-register)).
