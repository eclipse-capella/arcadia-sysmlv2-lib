# Function

[Contents](../ArcadiaLibraryMapping.md#contents) | Previous: [Deployment](07-Deployment.md) | Next: [Function Port](09-FunctionPort.md)

## Library definition

```
	action def Function :> ArcadiaElement {
	    private doc /* A  generic Arcadia Function, used across all Arcadia engineering perspectives. */
    }

	// Dataflow control functions: functions whose only role is to govern how exchange items are routed between
	// source functions and destination functions. A function that processes or modifies exchange items is a plain Function.

	action def DuplicateFunction :> Function {
		private doc /* Sends the exchange items received from one source to all its destinations, at the same time. */
	}

	action def SplitFunction :> Function {
		private doc /* Sends a different part of the exchange items received from one source to each of its destinations, at the same time. */
	}

	action def RouteFunction :> Function {
		private doc /* Sends the exchange items received from one source, or a part of them, to one destination chosen among several, usually according to a condition. */
	}

	action def GatherFunction :> Function {
		private doc /* Combines the exchange items received from several sources into a single exchange item, sent to its destination. */
	}

	action def SelectFunction :> Function {
		private doc /* Forwards to its destination the exchange items of one source chosen among several, usually according to a condition. */
	}
```

## Mapping

| ID | Capella concept | Capella metamodel | Treatment | In SysML v2 | Meaning | Rationale |
| --- | --- | --- | --- | --- | --- | --- |
| <a id="func-01"></a>FUNC-01 | Operational Activity, System Function, Logical Function, Physical Function | `oa::OperationalActivity`, `ctx::SystemFunction`, `la::LogicalFunction`, `pa::PhysicalFunction` (all `fa::AbstractFunction`) | Library | `action def Function :> ArcadiaElement`, used as `action x : Function` | An action, an operation or a service performed by the system, by one of its components or by an actor that interacts with the system | P1: a function is an action. P6: one type for all perspectives |
| <a id="func-02"></a>FUNC-02 | Sub-functions | `fa::AbstractFunction.ownedFunctions` (derived: `subFunctions`) | Native | action usages typed by `Function`, nested in the function | The functions directly contained in a function (one level) | P1: native containment. No alias is defined (see Decisions) |
| <a id="func-03"></a>FUNC-03 | Kind: Duplicate, Gather, Route, Select, Split | `fa::AbstractFunction.kind` (enum `FunctionKind`) | Library | `action def DuplicateFunction :> Function`, and likewise `SplitFunction`, `RouteFunction`, `GatherFunction` and `SelectFunction`; used as `action x : DuplicateFunction` | A function whose only role is to govern how exchange items are routed between source functions and destination functions | P1: a routing function is a function, connected by functional exchanges like any other function. Its kind is given by its type, as the nature of a Physical Component is ([COMP-04](05-Component.md#comp-04)). Control nodes are kept for control flow |
| <a id="func-04"></a>FUNC-04 | Condition of a Route or Select function | `fa::AbstractFunction.condition` | Deferred – [OP-CONSTRAINTS](../ArcadiaLibraryMapping.md#op-constraints) | none | The condition that selects the path followed through the function | Free text in Capella, to be decided with the other constraints. A function has no native place for it; a candidate is a constraint feature defined on `RouteFunction` and `SelectFunction`, redefined in the function |
| <a id="func-05"></a>FUNC-05 | Available in modes and states | `fa::AbstractFunction.availableInStates` | Deferred – [OP-MODES](../ArcadiaLibraryMapping.md#op-modes) | none | The modes and states in which the function is available | Modes and states are not covered yet |

Function ports are described in the FPORT section, the allocation of a function to a component in [COMP-08](05-Component.md#comp-08), and realizations in the REAL section.

## Example

From [`examples/concepts/function.sysml`](../../examples/concepts/function.sysml), validated with the SysML v2 pilot implementation.

```
		// FUNC-01: a function
		action 'Root Function' : Function {
			// FUNC-02: sub-functions are nested action usages typed by Function
			action 'Capture Movement' : Function {
				out FOP1 [0..*] : ExchangeItem = (rawOpticalData);
			}
			action 'Transform Raw Optical Data' : Function {
				in FIP1 [0..*] : ExchangeItem = (rawOpticalData);
			}
			// FUNC-03: a routing function is a function typed by one of the five routing definitions
			action 'Duplicate Raw Optical Data' : DuplicateFunction {
				in FIP1 [0..*] : ExchangeItem = (rawOpticalData);
				out FOP1 [0..*] : ExchangeItem = (rawOpticalData);
				out FOP2 [0..*] : ExchangeItem = (rawOpticalData);
			}
		}
```

## Decisions

- No alias is defined for the sub-functions. The native `subactions` is the list of all the composite actions of an action: it also contains the Functional Chains and the Functional Exchanges owned by the function (a flow usage is an action usage), so it is not the list of sub-functions.
- The sub-functions of a function are its direct sub-actions typed by `Function`, plus those of its nested packages (see the PKG section).
- A routing function stays a function ([FUNC-03](#func-03)): it has ports, it is connected by functional exchanges and it can be involved in a Functional Chain like any other function. Control nodes are not used for it: they are kept for the control flow of the Functional Chains.
- The five definitions:
  - Duplicate: sends the exchange items received from one source to all its destinations, at the same time.
  - Split: sends a different part of the exchange items received from one source to each of its destinations, at the same time.
  - Route: sends the exchange items received from one source, or a part of them, to one destination chosen among several, usually according to a condition.
  - Gather: combines the exchange items received from several sources into a single exchange item, sent to its destination.
  - Select: forwards to its destination the exchange items of one source chosen among several, usually according to a condition.
- A function that processes or modifies the exchange items, or that has other outputs, is a plain `Function`.
- The rules that apply to routing functions are not written as constraints in the library: they are left to tooling (see Tooling requirements).

## Tooling requirements

- [FUNC-02](#func-02): the list of the sub-functions of a function is computed (action usages typed by `Function` owned by the function, directly or through its nested packages).
- [FUNC-03](#func-03): a migration types the function by the definition that matches its kind; a function of kind Function stays typed by `Function`. The condition of Route and Select functions is not migrated yet ([FUNC-04](#func-04)).
- [FUNC-03](#func-03): the rules on routing functions are checked by tooling: a routing function has no sub-function; a Duplicate, a Split or a Route function has only one incoming functional exchange; a Gather or a Select function has only one outgoing functional exchange.

## SysML v2 limitations

None.

## Open points

[OP-CONSTRAINTS](../ArcadiaLibraryMapping.md#op-constraints), [OP-SCENARIOS](../ArcadiaLibraryMapping.md#op-scenarios), [OP-MODES](../ArcadiaLibraryMapping.md#op-modes) (see the [open points register](../ArcadiaLibraryMapping.md#open-points-register)).
