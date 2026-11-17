# Component Port

[Contents](../ArcadiaLibraryMapping.md#contents) | Previous: [Component Exchange](12-ComponentExchange.md) | Next: [Exchange Allocation](14-ExchangeAllocation.md)

## Library definition

```
	port def ComponentPort :> ArcadiaElement {
		private doc /* A generic Arcadia Component Port, used across all Arcadia engineering perspectives. */
        attribute portDirection : FeatureDirectionKind;
		ref item allocatedFunctionPorts: ExchangeItem [*];
    }
```

## Mapping

| ID | Capella concept | Capella metamodel | Treatment | In SysML v2 | Meaning | Rationale |
| --- | --- | --- | --- | --- | --- | --- |
| <a id="cp-01"></a>CP-01 | Component Port | `fa::ComponentPort` | Library | `port def ComponentPort :> ArcadiaElement`, used as `port x : ComponentPort` | A place of interaction between a component and the other components or actors of its environment. Called "behavioral port" in Arcadia | P1: a component port is a port |
| <a id="cp-02"></a>CP-02 | Orientation (In, Out, InOut) | `fa::ComponentPort.orientation` | Library | `attribute portDirection : FeatureDirectionKind` | Direction of the port | P3: a SysML v2 port has no direction, only its features have one (see [OP-PORT-DIR](../ArcadiaLibraryMapping.md#op-port-dir)) |
| <a id="cp-03"></a>CP-03 | Exchange items that go through the port | no dedicated feature on the port: the exchange items come from its component exchanges and allocated function ports | Native | `in` and `out` features of the port: `out [0..*] : ExchangeItem = (...)` | What the port receives or sends | P1 |
| <a id="cp-04"></a>CP-04 | Allocated function ports | `information::PortAllocation`, owned by the component port (`information::Port.ownedPortAllocations`; derived: `fa::ComponentPort.allocatedFunctionPorts`) | Library | `ref item allocatedFunctionPorts: ExchangeItem [*]`, set with `ref item :>> allocatedFunctionPorts = (<function port>, ...)` | The function ports allocated to the component port | P3: needed by Arcadia; an allocation element is not possible here (see Decisions) |
| <a id="cp-05"></a>CP-05 | Kind (Standard, Flow) | `fa::ComponentPort.kind` | Deferred – [OP-INTERFACES](../ArcadiaLibraryMapping.md#op-interfaces) | none | Standard ports provide and require interfaces; flow ports carry flows | Not decided yet |
| <a id="cp-06"></a>CP-06 | Provided and required interfaces | `information::Port.providedInterfaces`, `requiredInterfaces` | Deferred – [OP-INTERFACES](../ArcadiaLibraryMapping.md#op-interfaces) | none | The interfaces that the port provides or requires | Interfaces are not covered yet |

## Example

From [`examples/concepts/exchanges.sysml`](../../examples/concepts/exchanges.sysml), validated with the SysML v2 pilot implementation.

```
				// CP-01: a component port
				port 'Cable Connector' : ComponentPort {
					// CP-03: the exchange items that go through the port
					out [0..*] : ExchangeItem = (rawOpticalDataX, rawOpticalDataY);
					// CP-02: direction of the port
					:>> portDirection = FeatureDirectionKind::'out';
					// CP-04: function ports allocated to the component port
					ref item :>> allocatedFunctionPorts = ('Root Function'.'Capture Movement'.FOP1);
				}
```

## Decisions

- The attribute is named `portDirection`, not `direction`, to avoid a conflict with the direction of the features of the port.
- `allocatedFunctionPorts` is a reference declared in the library, not an allocation element. It is typed by `ExchangeItem`, because a function port is a parameter typed by `ExchangeItem`; its name and its type do not say the same thing (see [OP-PORT-ALLOC-TYPE](../ArcadiaLibraryMapping.md#op-port-alloc-type)). It cannot be derived from the allocations of functional exchanges to component exchanges, because a port can be allocated before any exchange exists.
- Not retained for [CP-04](#cp-04): an allocation element owned by the port, as for exchanges and realizations (a port usage cannot own an allocation, see limitations; it would have to be owned by the component, there is no official precedent for allocating an action parameter to a port, and the description and status of these allocations are assumed to be rarely used); and a `bind` between the parameter and an item of the port (it equates values, it is not an allocation).
- There are no component ports in Operational Analysis.
- Node Components have physical ports, not component ports (see [OP-PHYS](../ArcadiaLibraryMapping.md#op-phys)).

## Tooling requirements

- [CP-02](#cp-02): the direction changes the icon of the port.
- [CP-04](#cp-04): the allocation is displayed as a link between the function port and the component port. A migration creates the reference from the Capella port allocations.

## SysML v2 limitations

- A port has no direction: only its features have one.
- A port usage cannot own an allocation: the pilot implementation answers "Nested usages in a port usage (other than ports) must be referential".

## Open points

[OP-PORT-DIR](../ArcadiaLibraryMapping.md#op-port-dir), [OP-PORT-ALLOC-TYPE](../ArcadiaLibraryMapping.md#op-port-alloc-type), [OP-INTERFACES](../ArcadiaLibraryMapping.md#op-interfaces), [OP-PHYS](../ArcadiaLibraryMapping.md#op-phys) (see the [open points register](../ArcadiaLibraryMapping.md#open-points-register)).
