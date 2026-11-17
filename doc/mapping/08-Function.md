# Function

[Contents](../ArcadiaLibraryMapping.md#contents) | Previous: [Deployment](07-Deployment.md) | Next: [Function Port](09-FunctionPort.md)

## Library definition

```
	action def Function :> ArcadiaElement {
	    private doc /* A  generic Arcadia Function, used across all Arcadia engineering perspectives. */
    }
```

## Mapping

| ID | Capella concept | Capella metamodel | Treatment | In SysML v2 | Meaning | Rationale |
| --- | --- | --- | --- | --- | --- | --- |
| <a id="func-01"></a>FUNC-01 | Operational Activity, System Function, Logical Function, Physical Function | `oa::OperationalActivity`, `ctx::SystemFunction`, `la::LogicalFunction`, `pa::PhysicalFunction` (all `fa::AbstractFunction`) | Library | `action def Function :> ArcadiaElement`, used as `action x : Function` | An action, an operation or a service performed by the system, by one of its components or by an actor that interacts with the system | P1: a function is an action. P6: one type for all perspectives |
| <a id="func-02"></a>FUNC-02 | Sub-functions | `fa::AbstractFunction.ownedFunctions` (derived: `subFunctions`) | Native | action usages typed by `Function`, nested in the function | The functions directly contained in a function (one level) | P1: native containment. No alias is defined (see Decisions) |
| <a id="func-03"></a>FUNC-03 | Kind: Duplicate, Gather, Route, Select, Split | `fa::AbstractFunction.kind` (enum `FunctionKind`) | Native | control nodes: Duplicate and Split give a fork, Gather a join, Route a decision, Select a merge | Functions that only route flows | P1: SysML v2 has dedicated control nodes |
| <a id="func-04"></a>FUNC-04 | Condition of a Route or Select function | `fa::AbstractFunction.condition` | Deferred – [OP-ROUTING](../ArcadiaLibraryMapping.md#op-routing) | none | The condition that selects the flow | Not decided yet: the condition has no obvious place on a control node that only routes data flows |
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
		}
```

## Decisions

- No alias is defined for the sub-functions. The native `subactions` is the list of all the composite actions of an action: it also contains the Functional Chains and the Functional Exchanges owned by the function (a flow usage is an action usage), so it is not the list of sub-functions.
- The sub-functions of a function are its direct sub-actions typed by `Function`, plus those of its nested packages (see the PKG section).
- The Capella functions of kind Duplicate, Gather, Route, Select and Split are not reproduced as functions: they are translated to control nodes ([FUNC-03](#func-03)).

## Tooling requirements

- [FUNC-02](#func-02): the list of the sub-functions of a function is computed (action usages typed by `Function` owned by the function, directly or through its nested packages).
- [FUNC-03](#func-03): a migration replaces these functions by control nodes. What it does with the condition of Route and Select functions is not decided yet ([FUNC-04](#func-04), [OP-ROUTING](../ArcadiaLibraryMapping.md#op-routing)).

## SysML v2 limitations

- [FUNC-03](#func-03): control nodes are primarily meant for control flow. Used to route functional exchanges, they raise two questions that are not settled yet (see [OP-ROUTING](../ArcadiaLibraryMapping.md#op-routing)): the ends of a `FunctionalExchange` are typed `Function`, and the condition of a Route or Select function has no obvious place.

## Open points

[OP-ROUTING](../ArcadiaLibraryMapping.md#op-routing), [OP-SCENARIOS](../ArcadiaLibraryMapping.md#op-scenarios), [OP-MODES](../ArcadiaLibraryMapping.md#op-modes) (see the [open points register](../ArcadiaLibraryMapping.md#open-points-register)).
