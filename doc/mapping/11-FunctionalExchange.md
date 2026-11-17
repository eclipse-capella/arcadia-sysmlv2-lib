# Functional Exchange

[Contents](../ArcadiaLibraryMapping.md#contents) | Previous: [Functional Chain](10-FunctionalChain.md) | Next: [Component Exchange](12-ComponentExchange.md)

## Library definition

```
	flow def FunctionalExchange :> ArcadiaElement{
	    private doc /* A generic Arcadia Functional Exchange, used across all Arcadia engineering perspectives. */
		ref item :>> payload : ExchangeItem [*];
		end source : Function;
		end target : Function;
	}
```

## Mapping

| ID | Capella concept | Capella metamodel | Treatment | In SysML v2 | Meaning | Rationale |
| --- | --- | --- | --- | --- | --- | --- |
| FE-01 | Functional Exchange (Interaction in Operational Analysis) | `fa::FunctionalExchange` | Library | `flow def FunctionalExchange :> ArcadiaElement`, used as `flow x : FunctionalExchange from <output port> to <input port>;` | A possible interaction between a source function and a destination function, that transmits exchange items through their output and input ports | P1: a functional exchange is a flow |
| FE-02 | Exchanged items | `fa::FunctionalExchange.exchangedItems` | Library | `ref item :>> payload : ExchangeItem [*]`, set with `of :>> payload = (...)` | The exchange items carried by the exchange | P1: the standard `payload` of a flow, redefined so that it is typed by `ExchangeItem` |
| FE-03 | Source | derived `fa::FunctionalExchange.sourceFunctionOutputPort` | Library | `end source : Function`; the usage starts from an `out` parameter (FPORT-02) | The function, and its output port, from which the exchange starts | P1 |
| FE-04 | Target | derived `fa::FunctionalExchange.targetFunctionInputPort` | Library | `end target : Function`; the usage ends on an `in` parameter (FPORT-01) | The function, and its input port, where the exchange ends | P1 |
| FE-05 | Exchange categories | `fa::ExchangeCategory` (derived: `fa::FunctionalExchange.categories`) | Deferred – OP-CATEGORIES | none | A named group of functional exchanges, used to simplify diagrams | Not decided yet |

The allocation of a functional exchange to a component exchange is described in the EA section, its involvement in a functional chain in FC-03, and realizations in the REAL section.

## Example

From `examples/concepts/exchanges.sysml`, validated with the SysML v2 pilot implementation.

```
			// FE-01: a functional exchange between two function ports (FE-03, FE-04)
			// FE-02: the exchange items it carries
			flow 'Optical Data' : FunctionalExchange of :>> payload = (rawOpticalDataX, rawOpticalDataY)
				from 'Capture Movement'.FOP1 to 'Transform Raw Optical Data'.FIP2;
```

## Decisions

- The flow usage connects the `out` and `in` parameters of the functions, which correspond to the function ports of Capella. The flow definition connects the functions, as in standard SysML v2.
- The payload is the set of exchange items allocated to the functional exchange in Capella. It is set with `of :>> payload = (...)` after the name of the flow, or in its body with `:>> payload = (...);`.
- `payload` is redefined (`:>>`), not subset: with a plain subsetting it would stay typed by `Anything`.

## Tooling requirements

- An exchange is displayed as an edge between two function ports; its exchange items are shown in its properties.

## SysML v2 limitations

- A binding connector cannot set the payload: `bind` relates one feature to one feature, and `bind 'Optical Data'.payload = (a, b);` is rejected by the pilot implementation.

## Open points

OP-CATEGORIES (see the open points register).
