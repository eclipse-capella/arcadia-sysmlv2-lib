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
| <a id="ce-06"></a>CE-06 | Kind (Assembly, Delegation, Flow) | `fa::ComponentExchange.kind` | Deferred – [OP-CE-KIND](../ArcadiaLibraryMapping.md#op-ce-kind) | none | Kind of the component exchange | Not decided yet |
| <a id="ce-07"></a>CE-07 | Component exchange categories | `fa::ComponentExchangeCategory` (derived: `fa::ComponentExchange.categories`) | Library | `ExchangeCategory`, the definition used for functional exchanges ([FE-05](11-FunctionalExchange.md#fe-05)): `metadata x : ExchangeCategory about <exchange>, <exchange>;`, owned by the `Structure` package of the engineering perspective | A named group of component exchanges, shown as a single link in synthetic views | P3: one definition for all the categories |

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
		}
		// CE-07: the same definition groups component exchanges
		metadata 'Cables' : ExchangeCategory about system::cable;
```

## Decisions

- `allocatedExchangeItems` is a stored list, independent of the functional exchanges allocated to the component exchange, as in Capella: the Capella reference has no constraint, and the consistency with the exchange items of the allocated functional exchanges is only checked by validation rules that raise warnings. It is not constrained in the library either.
- Not retained for [CE-04](#ce-04): a SysML v2 constraint in the library (stricter than Capella and heavy to write); and replacing the list by the payload of a flow of the interface (native, but the payload is untyped and a flow is directed, whereas a component exchange can convey exchange items in both directions).
- The list of allocated functional exchanges is not stored on the component exchange ([CE-05](#ce-05)): see the EA section.
- Node Components have physical links, not component exchanges (see [OP-PHYS](../ArcadiaLibraryMapping.md#op-phys)).

## Tooling requirements

- [CE-04](#ce-04): tooling can propose the exchange items of the allocated functional exchanges, and report the differences.
- [CE-05](#ce-05): the allocated functional exchanges of a component exchange are computed from the allocations.
- [CE-07](#ce-07): category links between components follow the rules given for functions ([FE-05](11-FunctionalExchange.md#fe-05)).

## SysML v2 limitations

- A stored reference to flows (`ref flow`) on the interface is rejected by the pilot implementation (see the FC section).

## Open points

[OP-CE-KIND](../ArcadiaLibraryMapping.md#op-ce-kind), [OP-PHYS](../ArcadiaLibraryMapping.md#op-phys) (see the [open points register](../ArcadiaLibraryMapping.md#open-points-register)).
