# Functional Chain

[Contents](../ArcadiaLibraryMapping.md#contents) | Previous: [Function Port](09-FunctionPort.md) | Next: [Functional Exchange](11-FunctionalExchange.md)

## Library definition

```
    action def FunctionalChain :> ArcadiaElement  {
        private doc /*  A  generic Arcadia Functional Chain, used across all Arcadia engineering perspectives. */
        ref involvedFunctionalExchanges: FunctionalExchange[*];
        perform action involvedFunctions: Function[*];
        perform action referencedFunctionalChains: FunctionalChain[*];
    }
```

## Mapping

| ID | Capella concept | Capella metamodel | Treatment | In SysML v2 | Meaning | Rationale |
| --- | --- | --- | --- | --- | --- | --- |
| <a id="fc-01"></a>FC-01 | Functional Chain, Operational Process | `fa::FunctionalChain`, `oa::OperationalProcess`; owned by a function or a capability (`fa::AbstractFunctionalChainContainer.ownedFunctionalChains`) | Library | `action def FunctionalChain :> ArcadiaElement`, used as `action x : FunctionalChain` | A usage of the system in a given context: an organization of functions and functional exchanges that contributes to a capability | P3: SysML v2 has no native concept for functional chains. An action definition orchestrates existing functions and exchanges |
| <a id="fc-02"></a>FC-02 | Involved functions | `fa::FunctionalChainInvolvementFunction` (derived: `fa::FunctionalChain.involvedFunctions`) | Library | `perform action involvedFunctions: Function[*]`, stated by each `perform <function> :> involvedFunctions;` | The functions involved in the chain | P1: native `perform`, a reference to an existing function. The role makes the list of involved functions available in the model |
| <a id="fc-03"></a>FC-03 | Involved functional exchanges | `fa::FunctionalChainInvolvementLink` (derived: `fa::FunctionalChain.involvedFunctionalExchanges`) | Library | `ref involvedFunctionalExchanges: FunctionalExchange[*]`, set by `ref :>> involvedFunctionalExchanges = (...)` | The functional exchanges involved in the chain | P3: key relation of a functional chain |
| <a id="fc-04"></a>FC-04 | Functional Chain Reference | `fa::FunctionalChainReference` (derived: `referencedFunctionalChain`) | Library | `perform action referencedFunctionalChains: FunctionalChain[*]`, stated by each `perform <chain> :> referencedFunctionalChains;` | The chains referenced by the chain, each one being a step of its sequence | P1: same mechanism as for the functions ([FC-02](#fc-02)) |
| <a id="fc-05"></a>FC-05 | Sequence of the chain: involvement links, sequence links and control nodes | `fa::FunctionalChainInvolvementLink.source` and `target`, `fa::SequenceLink`, `fa::ControlNode` (kinds OR, AND, ITERATE) | Native | successions (`succession first a then b;`) and control nodes: AND gives a `fork` and a `join`, OR a `decide` and a `merge`, ITERATE a loop. The condition of a sequence link is the guard that follows the `decide` (`if condition then step;`) | The order of the steps of the chain | P1: SysML v2 control flow |
| <a id="fc-06"></a>FC-06 | Pre-condition and post-condition | `fa::FunctionalChain.preCondition`, `postCondition` | Not translated – rarely used | none | Conditions before and after the chain | P4 |
| <a id="fc-07"></a>FC-07 | Kind (Simple, Composite, Fragment) | `fa::FunctionalChain.kind` | Deferred – [OP-FC-KIND](../ArcadiaLibraryMapping.md#op-fc-kind) | none | Kind of the chain, entered by the user | Not decided yet |
| <a id="fc-08"></a>FC-08 | Exchange Context of an involvement link | `fa::FunctionalChainInvolvementLink.exchangeContext` | Deferred – [OP-FC-CONTEXT](../ArcadiaLibraryMapping.md#op-fc-context) | none | A constraint on the exchange in the context of the chain | Not decided yet |
| <a id="fc-09"></a>FC-09 | Enacted functional blocks | derived `fa::FunctionalChain.enactedFunctionalBlocks` | Deferred – [OP-FC-COMPONENTS](../ArcadiaLibraryMapping.md#op-fc-components) | none | The components that perform the functions of the chain | Not decided yet |
| <a id="fc-10"></a>FC-10 | Available in modes and states | `fa::FunctionalChain.availableInStates` | Deferred – [OP-MODES](../ArcadiaLibraryMapping.md#op-modes) | none | The modes and states in which the chain is available | Modes and states are not covered yet |

## Example

From [`examples/concepts/functional-chain.sysml`](../../examples/concepts/functional-chain.sysml), validated with the SysML v2 pilot implementation.

```
			// FC-01: a functional chain, owned by a function
			action 'read movement' : FunctionalChain {
				// FC-03: involved functional exchanges
				ref :>> involvedFunctionalExchanges = ('Optical Data');
				// FC-02: involved functions
				perform 'Root Function'.'Capture Movement' :> involvedFunctions;
				perform 'Root Function'.'Transform Raw Optical Data' :> involvedFunctions;
				// FC-05: sequence of the chain
				succession first start then 'Root Function'.'Capture Movement';
				succession first 'Root Function'.'Capture Movement' then 'Root Function'.'Transform Raw Optical Data';
				succession first 'Root Function'.'Transform Raw Optical Data' then done;
			}

			// FC-04: a composite chain references another chain
			action 'move pointer' : FunctionalChain {
				ref :>> involvedFunctionalExchanges = ('Motion Data');
				perform 'Root Function'.'read movement' :> referencedFunctionalChains;
				perform 'Root Function'.'Update Pointer Position' :> involvedFunctions;
				succession first start then 'Root Function'.'read movement';
				// a link that ends on a function inside the referenced chain
				succession first 'Root Function'.'read movement'.'Transform Raw Optical Data' then 'Root Function'.'Update Pointer Position';
				succession first 'Root Function'.'Update Pointer Position' then done;
			}

			// FC-05: a control node OR, with a condition on each branch
			action 'handle movement' : FunctionalChain {
				attribute isMoving : Boolean;
				perform 'Root Function'.'Capture Movement' :> involvedFunctions;
				perform action transform references 'Root Function'.'Transform Raw Optical Data' :> involvedFunctions;
				succession first start then 'Root Function'.'Capture Movement';
				succession first 'Root Function'.'Capture Movement' then moving;
				decide moving;
					if isMoving then transform;
					if not isMoving then done;
				succession first transform then done;
			}

			// FC-01: an empty chain
			action 'stop movement' : FunctionalChain;
```

## Decisions

- **Action definition.** Functional chains are action definitions that orchestrate existing functions and exchanges. The KerML Behavior concept could have been an option, but it is unlikely to be well handled by other tools.
- **Involved functions and referenced chains.** A chain does not own the functions it involves: it performs them. A `perform` is a reference to the performed action, not a composite sub-action, so it is not in `subactions`. The library therefore declares two roles, `involvedFunctions` and `referencedFunctionalChains`, that each `perform` states with `:>`. A `perform` without role is valid SysML v2 but is not listed.
- **Local content.** `involvedFunctions` and `involvedFunctionalExchanges` are local to the chain, as in Capella. The flattened content of a composite chain is computed by following the references.
- **Composite chains.** The reference to a chain is a `perform` of that chain (the same performance, not a copy), ordered with successions like a function. An involvement link that ends on a function inside the referenced chain is a succession whose end is a feature chain through the referenced chain. The exchange carried by such a link is listed in `involvedFunctionalExchanges` of the composite chain.
- **Shared function.** A link between two involvements of the same function (two chains assembled through a function that belongs to both) gives no succession: the two chains perform the same function, so the junction is already expressed (see [OP-FC-JUNCTION](../ArcadiaLibraryMapping.md#op-fc-junction)).
- **Naming a performed function.** A `perform` can be given a name, which shortens the successions: `perform action transform references 'Root Function'.'Transform Raw Optical Data' :> involvedFunctions;`.
- **Empty chains.** A chain can have no involvement at all. It is represented like any other chain, with no `perform` and no succession, and it is migrated, not skipped.
- **Migration.** A Functional Chain Reference becomes a `perform` of the referenced chain with the role `referencedFunctionalChains`. An involvement link whose source or target is a reference, or a function inside a referenced chain, becomes a succession. The exchange of the link is added to `involvedFunctionalExchanges`.

## Tooling requirements

- Tooling checks that the role matches the type of the performed action: a function for `involvedFunctions`, a functional chain for `referencedFunctionalChains`.
- A chain must not reference itself, directly or through other chains. SysML v2 tools do not check it: tooling has to prevent it, as Capella does.
- The flattened content of a composite chain (all its functions and exchanges, its first and last functions) is computed.
- An empty chain may be reported as a warning, as Capella does.

## SysML v2 limitations

- A guarded succession has to be named, or written as `if condition then step;` right after the `decide`: `succession first a if condition then b;` without a name is rejected by the pilot implementation.
- The reference to functional exchanges is a plain `ref` typed by the flow definition, not a `ref flow`: a flow usage must have exactly two ends, and `ref flow` without `from ... to ...` is rejected by the pilot implementation ("Cannot have more than two ends").

## Open points

[OP-FC-JUNCTION](../ArcadiaLibraryMapping.md#op-fc-junction), [OP-FC-REPEAT](../ArcadiaLibraryMapping.md#op-fc-repeat), [OP-FC-TRACE](../ArcadiaLibraryMapping.md#op-fc-trace), [OP-FC-CONTEXT](../ArcadiaLibraryMapping.md#op-fc-context), [OP-FC-KIND](../ArcadiaLibraryMapping.md#op-fc-kind), [OP-FC-COMPONENTS](../ArcadiaLibraryMapping.md#op-fc-components), [OP-SCENARIOS](../ArcadiaLibraryMapping.md#op-scenarios), [OP-MODES](../ArcadiaLibraryMapping.md#op-modes) (see the [open points register](../ArcadiaLibraryMapping.md#open-points-register)).
