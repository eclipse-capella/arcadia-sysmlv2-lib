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

	metadata def ExchangeCategory {
		private doc /* A named group of exchanges (functional exchanges, component exchanges or physical links), used to show them
		 * as a single link in synthetic views. A category is written as a named annotation that lists its exchanges:
		 * 'metadata <name> : ExchangeCategory about <exchange>, <exchange>;'. */
		:> annotatedElement : SysML::FlowUsage;
		:> annotatedElement : SysML::InterfaceUsage;
	}
```

## Mapping

| ID | Capella concept | Capella metamodel | Treatment | In SysML v2 | Meaning | Rationale |
| --- | --- | --- | --- | --- | --- | --- |
| <a id="fe-01"></a>FE-01 | Functional Exchange (Interaction in Operational Analysis) | `fa::FunctionalExchange` | Library | `flow def FunctionalExchange :> ArcadiaElement`, used as `flow x : FunctionalExchange from <output port> to <input port>;` | A possible interaction between a source function and a destination function, that transmits exchange items through their output and input ports | P1: a functional exchange is a flow |
| <a id="fe-02"></a>FE-02 | Exchanged items | `fa::FunctionalExchange.exchangedItems` | Library | `ref item :>> payload : ExchangeItem [*]`, set with `of :>> payload = (...)` | The exchange items carried by the exchange | P1: the standard `payload` of a flow, redefined so that it is typed by `ExchangeItem` |
| <a id="fe-03"></a>FE-03 | Source | derived `fa::FunctionalExchange.sourceFunctionOutputPort` | Library | `end source : Function`; the usage starts from an `out` parameter ([FPORT-02](09-FunctionPort.md#fport-02)) | The function, and its output port, from which the exchange starts | P1 |
| <a id="fe-04"></a>FE-04 | Target | derived `fa::FunctionalExchange.targetFunctionInputPort` | Library | `end target : Function`; the usage ends on an `in` parameter ([FPORT-01](09-FunctionPort.md#fport-01)) | The function, and its input port, where the exchange ends | P1 |
| <a id="fe-05"></a>FE-05 | Exchange categories | `fa::ExchangeCategory` (derived: `fa::FunctionalExchange.categories`) | Library | `metadata def ExchangeCategory`, used as a named annotation that lists its exchanges: `metadata x : ExchangeCategory about <exchange>, <exchange>;`. The categories of an exchange are derived | A named group of exchanges, shown as a single link in synthetic views | P1: a category is an information about the model, used to build views, and not an element of the system; metadata is the standard SysML v2 mechanism for this. P3: a category only stores what cannot be computed, its name and its exchanges |

The allocation of a functional exchange to a component exchange is described in the EA section, its involvement in a functional chain in [FC-03](10-FunctionalChain.md#fc-03), and realizations in the REAL section.

## Example

From [`examples/concepts/exchanges.sysml`](../../examples/concepts/exchanges.sysml), validated with the SysML v2 pilot implementation.

```
			// FE-01: a functional exchange between two function ports (FE-03, FE-04)
			// FE-02: the exchange items it carries
			flow 'Optical Data' : FunctionalExchange of :>> payload = (rawOpticalDataX, rawOpticalDataY)
				from 'Capture Movement'.FOP1 to 'Transform Raw Optical Data'.FIP2;
		}
		// FE-05: an exchange category is a named annotation that lists the functional exchanges it groups
		metadata 'Optical Data Flows' : ExchangeCategory about 'Root Function'::'Optical Data';
```

## Decisions

- The flow usage connects the `out` and `in` parameters of the functions, which correspond to the function ports of Capella. The flow definition connects the functions, as in standard SysML v2.
- The payload is the set of exchange items allocated to the functional exchange in Capella. It is set with `of :>> payload = (...)` after the name of the flow, or in its body with `:>> payload = (...);`.
- `payload` is redefined (`:>>`), not subset: with a plain subsetting it would stay typed by `Anything`.
- **Exchange categories** ([FE-05](#fe-05)). In Arcadia, exchanges are meant to connect leaf functions only, and synthetic views are computed: functions are grouped in parent functions, and exchanges in categories. A category is what stands for several exchanges in such a view. It is a name and a list of exchanges, and nothing else: the synthetic links are not model elements.
- A category is written as a metadata annotation, because it tells something about elements of the model and not about the system. It is one named element, owned by a package, that lists its exchanges after `about`, as the Capella category does: creating or deleting a category does not change the exchanges. An exchange can belong to several categories, and a category can group exchanges between different pairs of functions.
- A category of functional exchanges is owned by the `Functions` package of its engineering perspective. A category of component exchanges or of physical links is owned by the `Structure` package of its engineering perspective. Capella also allows these two kinds of categories in a component; this is not reproduced, so that each kind of category has a single place.
- One definition, `ExchangeCategory`, is used for the categories of functional exchanges, of component exchanges ([CE-07](12-ComponentExchange.md#ce-07)) and of physical links. It can only annotate flows and interfaces.
- A category can have a description (`doc`) and a progress status, like the other elements.
- Categories are flat, as in Capella. The Arcadia method allows sub-categories, without saying what a parent category contains; they are not reproduced. Synthesis by levels is given by the hierarchy of functions and components.
- Not retained: a definition that specializes `ArcadiaElement` (`occurrence def`, `item def`), because a category is not something of the system that exists over time; an `attribute def`, which is a data of the system; one metadata definition for each category, applied to its exchanges (it allows a standard view to filter one category, an empty category and property values, at the cost of a second element and of definitions created in the model); the exchange listing its categories; a category written as a definition that types its exchanges.

## Tooling requirements

- An exchange is displayed as an edge between two function ports; its exchange items are shown in its properties.
- [FE-05](#fe-05): the categories of an exchange are computed from the categories that list it.
- [FE-05](#fe-05): a diagram can show the exchanges of the selected categories as category links: the exchanges of a category that have the same source and the same target among the displayed functions (a function that is not displayed is represented by its closest displayed ancestor) are replaced by a single link, named after the category. No link is shown between a function and one of its ancestors. Which categories are shown is a setting of the diagram.
- [FE-05](#fe-05): a category only groups exchanges of the same kind (functional exchanges, component exchanges or physical links); this is checked by tooling.
- [FE-05](#fe-05): a migration moves a category that a Capella component owns to the `Structure` package.
- [FE-05](#fe-05): a category lists at least one exchange. A migration does not keep the Capella categories that have no exchange, nor the property values of a category.
- [FE-05](#fe-05): the trace that a Capella transition keeps between a category and the category it comes from in the previous perspective is not translated yet ([OP-TRANSITION-TRACES](../ArcadiaLibraryMapping.md#op-transition-traces)).

## SysML v2 limitations

- A binding connector cannot set the payload: `bind` relates one feature to one feature, and `bind 'Optical Data'.payload = (a, b);` is rejected by the pilot implementation.
- [FE-05](#fe-05): `about` takes qualified names (`'Root Function'::'Optical Data'`), not feature chains: `about 'Root Function'.'Optical Data'` is rejected by the pilot implementation. An inherited exchange has to be redefined before it can be listed for one context only.
- [FE-05](#fe-05): a named annotation without `about` annotates its owner; a category without exchange cannot be written.
- [FE-05](#fe-05): an annotation cannot own a new attribute; a property value cannot be added to a category.

## Open points

[OP-TRANSITION-TRACES](../ArcadiaLibraryMapping.md#op-transition-traces) (see the [open points register](../ArcadiaLibraryMapping.md#open-points-register)).
