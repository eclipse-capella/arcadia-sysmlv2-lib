# Exchange Item

[Contents](../ArcadiaLibraryMapping.md#contents) | Previous: [Realization](15-Realization.md) | Next: [Requirements](17-Requirements.md)

## Library definition

```
	item def ExchangeItem :> ArcadiaElement{
		private doc /* A generic Arcadia ExchangeItem, used across all Arcadia engineering perspectives. */
	}
```

## Mapping

| ID | Capella concept | Capella metamodel | Treatment | In SysML v2 | Meaning | Rationale |
| --- | --- | --- | --- | --- | --- | --- |
| <a id="ei-01"></a>EI-01 | Exchange Item | `information::ExchangeItem` | Library | `item def ExchangeItem :> ArcadiaElement`, used as `item x : ExchangeItem` | An ordered set of references to elements routed together during an exchange between functions, components and actors | P1: an exchange item is an item |
| <a id="ei-02"></a>EI-02 | Exchange mechanism (Flow, Operation, Event, Shared Data) | `information::ExchangeItem.exchangeMechanism` | Deferred – [OP-DATA](../ArcadiaLibraryMapping.md#op-data) | none | The communication mechanism of the exchange item | Not decided yet |
| <a id="ei-03"></a>EI-03 | Exchange item elements | `information::ExchangeItem.ownedElements` (`information::ExchangeItemElement`) | Deferred – [OP-DATA](../ArcadiaLibraryMapping.md#op-data) | none | The data carried by the exchange item, with reference to the data model | Not decided yet |
| <a id="ei-04"></a>EI-04 | Abstract, final | `capellacore::GeneralizableElement.abstract`, `modellingcore::FinalizableElement.final` | Not translated – rarely used | none | Inheritance settings of the exchange item | P4 |

## Example

From [`examples/concepts/exchange-item.sysml`](../../examples/concepts/exchange-item.sysml), validated with the SysML v2 pilot implementation.

```
	package Data {
		// EI-01: an exchange item
		item rawOpticalData : ExchangeItem;
	}
```

## Decisions

- Exchange items are defined in the `Data` package of each engineering perspective. They are referenced by function ports ([FPORT-03](09-FunctionPort.md#fport-03)), functional exchanges ([FE-02](11-FunctionalExchange.md#fe-02)), component ports ([CP-03](13-ComponentPort.md#cp-03)) and component exchanges ([CE-04](12-ComponentExchange.md#ce-04)).

## Tooling requirements

- An exchange item is shown in data diagrams, and in the properties of the elements that reference it.

## SysML v2 limitations

None.

## Open points

[OP-DATA](../ArcadiaLibraryMapping.md#op-data) (see the [open points register](../ArcadiaLibraryMapping.md#open-points-register)).
