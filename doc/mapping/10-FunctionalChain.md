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
| <a id="fc-01"></a>FC-01 | Functional Chain, Operational Process | `fa::FunctionalChain`, `oa::OperationalProcess`; owned by a function or a capability (`fa::AbstractFunctionalChainContainer.ownedFunctionalChains`) | Library | `action def FunctionalChain :> ArcadiaElement`, used as `action x : FunctionalChain` | One path among the paths of the dataflow, in the context of a capability: an ordered set of references to functions and to the functional exchanges that link them | P3: SysML v2 has no native concept for functional chains. An action definition references existing functions and exchanges |
| <a id="fc-02"></a>FC-02 | Involved functions | `fa::FunctionalChainInvolvementFunction` (derived: `fa::FunctionalChain.involvedFunctions`) | Library | `perform action involvedFunctions: Function[*]`, stated by one named reference for each involvement: `perform action <name> references <function> :> involvedFunctions;` | The references of the chain to functions. A function can be referenced several times | P1: native `perform`, a reference to an existing function. The role makes the list of involved functions available in the model |
| <a id="fc-03"></a>FC-03 | Involved functional exchanges | `fa::FunctionalChainInvolvementLink` (`involved`, `source`, `target`; derived: `fa::FunctionalChain.involvedFunctionalExchanges`) | Library | `ref involvedFunctionalExchanges: FunctionalExchange[*]`, stated by one link for each involvement: `flow :> <exchange>, involvedFunctionalExchanges from <source reference>.<port> to <target reference>.<port>;` | The references of the chain to functional exchanges, each one between two references to functions | P1: a flow usage that subsets the functional exchange and connects two references of the chain. No succession is written: a functional exchange does not order the two functions (see Decisions) |
| <a id="fc-04"></a>FC-04 | Functional Chain Reference | `fa::FunctionalChainReference` (derived: `referencedFunctionalChain`) | Library | `perform action referencedFunctionalChains: FunctionalChain[*]`, stated by one named reference for each involvement: `perform action <name> references <chain> :> referencedFunctionalChains;` | The chains referenced by the chain | P1: same mechanism as for the functions ([FC-02](#fc-02)) |
| <a id="fc-05"></a>FC-05 | Sequence link | `fa::SequenceLink.source` and `target` | Native | `succession first <a> then <b>;`, between two references of the chain | The source function has to operate before the target function, in the context of the chain | P1: SysML v2 control flow. The succession belongs to the chain, so it only holds in its context |
| <a id="fc-06"></a>FC-06 | Pre-condition and post-condition | `fa::FunctionalChain.preCondition`, `postCondition` | Deferred – [OP-CONSTRAINTS](../ArcadiaLibraryMapping.md#op-constraints) | none | Conditions before and after the chain | In Capella they are references to constraints, and constraints are not covered yet |
| <a id="fc-07"></a>FC-07 | Kind (Simple, Composite, Fragment) | `fa::FunctionalChain.kind` | Not translated – rarely used | none | Kind of the chain, entered by the user | P4. A composite chain is a chain that references other chains ([FC-04](#fc-04)) |
| <a id="fc-08"></a>FC-08 | Exchange Context of an involvement link | `fa::FunctionalChainInvolvementLink.exchangeContext` | Native | a constraint owned by the link: `flow :> <exchange>, involvedFunctionalExchanges from ... to ... { assert constraint <name> { <expression> } }` | What the chain expects from the exchange in its context | P1: a constraint, owned by the element it applies to |
| <a id="fc-09"></a>FC-09 | Enacted functional blocks | derived `fa::FunctionalChain.enactedFunctionalBlocks` | Derived | computed from the components that perform the functions of the chain | The components involved in the chain | Derived in Capella as well |
| <a id="fc-10"></a>FC-10 | Available in modes and states | `fa::FunctionalChain.availableInStates` | Deferred – [OP-MODES](../ArcadiaLibraryMapping.md#op-modes) | none | The modes and states in which the chain is available | Modes and states are not covered yet |
| <a id="fc-11"></a>FC-11 | Link between two involvements of the same function | `fa::FunctionalChainInvolvementLink` whose `involved` element is a function | Native | `bind <reference>.<function reference> = <reference>.<function reference>;` | Two referenced chains are joined by a function that belongs to both | P1: a binding states that the two references designate the same thing |
| <a id="fc-12"></a>FC-12 | Control nodes | `fa::ControlNode` (kinds OR, AND, ITERATE) | Native | control nodes between successions: AND gives a `fork` and a `join`, OR a `decide` and a `merge`, ITERATE a loop action (`action <name> loop { ... }`) | Parallelism, alternative or iteration between sequences of functions | P1: SysML v2 control flow |
| <a id="fc-13"></a>FC-13 | Exchanged items of an involvement link | `fa::FunctionalChainInvolvementLink.exchangedItems` | Native | a subset of the payload, owned by the link: `ref item exchangedItems :> payload = (...)` | Among the exchange items of the exchange, those that the chain is concerned with | P1: a subsetting can only restrict the exchange items of the exchange |
| <a id="fc-14"></a>FC-14 | Condition of a sequence link | `fa::SequenceLink.condition` | Native | the guard of the succession that leaves a `decide`: `if <expression> then <step>;` | The condition for the sequence to be realized | P1: SysML v2 guard |
| <a id="fc-15"></a>FC-15 | Involvement links associated with a sequence link | `fa::SequenceLink.links` | Not translated – rarely used | none | The involvement links that a sequence link refers to | P4 |

## Example

From [`examples/concepts/functional-chain.sysml`](../../examples/concepts/functional-chain.sysml), validated with the SysML v2 pilot implementation.

```
			// FC-01: a functional chain, owned by a function
			action 'read movement' : FunctionalChain {
				// FC-02: involved functions, one named reference for each
				perform action 'Capture Movement' references 'Root Function'.'Capture Movement' :> involvedFunctions;
				perform action 'Transform Raw Optical Data' references 'Root Function'.'Transform Raw Optical Data' :> involvedFunctions;
				// FC-03: an involved functional exchange, between two references
				flow :> 'Optical Data', involvedFunctionalExchanges from 'Capture Movement'.FOP1 to 'Transform Raw Optical Data'.FIP2;
			}

			// FC-02: a function referenced twice (the chain starts from it and comes back to it)
			action 'adjust sensitivity' : FunctionalChain {
				perform action 'Capture Movement 1' references 'Root Function'.'Capture Movement' :> involvedFunctions;
				perform action 'Transform Raw Optical Data' references 'Root Function'.'Transform Raw Optical Data' :> involvedFunctions;
				perform action 'Update Pointer Position' references 'Root Function'.'Update Pointer Position' :> involvedFunctions;
				perform action 'Capture Movement 2' references 'Root Function'.'Capture Movement' :> involvedFunctions;
				flow :> 'Optical Data', involvedFunctionalExchanges from 'Capture Movement 1'.FOP1 to 'Transform Raw Optical Data'.FIP2;
				flow :> 'Motion Data', involvedFunctionalExchanges from 'Transform Raw Optical Data'.FOP3 to 'Update Pointer Position'.FIP4;
				flow :> 'Sensitivity Setting', involvedFunctionalExchanges from 'Update Pointer Position'.FOP5 to 'Capture Movement 2'.FIP6;
			}

			// FC-04: a composite chain references another chain
			action 'move pointer' : FunctionalChain {
				perform action 'read movement' references 'Root Function'.'read movement' :> referencedFunctionalChains;
				perform action 'Update Pointer Position' references 'Root Function'.'Update Pointer Position' :> involvedFunctions;
				// a link that starts from a function inside the referenced chain
				flow :> 'Motion Data', involvedFunctionalExchanges from 'read movement'.'Transform Raw Optical Data'.FOP3 to 'Update Pointer Position'.FIP4;
			}

			// FC-11: two referenced chains joined by a function that belongs to both
			action 'read and compute' : FunctionalChain {
				perform action 'read movement' references 'Root Function'.'read movement' :> referencedFunctionalChains;
				perform action 'compute pointer' references 'Root Function'.'compute pointer' :> referencedFunctionalChains;
				bind 'read movement'.'Transform Raw Optical Data' = 'compute pointer'.'Transform Raw Optical Data';
			}

			// FC-05: a sequence link, between two functions that no exchange links
			action 'move and log' : FunctionalChain {
				perform action 'Update Pointer Position' references 'Root Function'.'Update Pointer Position' :> involvedFunctions;
				perform action 'Log Movement' references 'Root Function'.'Log Movement' :> involvedFunctions;
				succession first 'Update Pointer Position' then 'Log Movement';
			}

			// FC-12: a control node OR, with a condition on each sequence link that leaves it
			action 'handle movement' : FunctionalChain {
				attribute isMoving : Boolean;
				perform action 'Capture Movement' references 'Root Function'.'Capture Movement' :> involvedFunctions;
				perform action 'Transform Raw Optical Data' references 'Root Function'.'Transform Raw Optical Data' :> involvedFunctions;
				perform action 'Log Movement' references 'Root Function'.'Log Movement' :> involvedFunctions;
				succession first 'Capture Movement' then moving;
				decide moving;
					if isMoving then 'Transform Raw Optical Data';
					if not isMoving then 'Log Movement';
			}

			// FC-12: a control node AND
			action 'check and capture' : FunctionalChain {
				perform action 'Check Surface' references 'Root Function'.'Check Surface' :> involvedFunctions;
				perform action 'Capture Movement' references 'Root Function'.'Capture Movement' :> involvedFunctions;
				perform action 'Log Movement' references 'Root Function'.'Log Movement' :> involvedFunctions;
				fork split;
					then 'Check Surface';
					then 'Capture Movement';
				succession first 'Check Surface' then gather;
				succession first 'Capture Movement' then gather;
				join gather;
				succession first gather then 'Log Movement';
			}

			// FC-12: a control node ITERATE
			action 'capture repeatedly' : FunctionalChain {
				perform action 'Check Surface' references 'Root Function'.'Check Surface' :> involvedFunctions;
				perform action 'Log Movement' references 'Root Function'.'Log Movement' :> involvedFunctions;
				action iteration loop {
					perform action 'Capture Movement' references 'Root Function'.'Capture Movement' :> involvedFunctions;
				}
				succession first 'Check Surface' then iteration;
				succession first iteration then 'Log Movement';
			}

			// FC-08, FC-13: what the chain expects from an exchange
			action 'read horizontal movement' : FunctionalChain {
				attribute isMoving : Boolean;
				perform action 'Capture Movement' references 'Root Function'.'Capture Movement' :> involvedFunctions;
				perform action 'Transform Raw Optical Data' references 'Root Function'.'Transform Raw Optical Data' :> involvedFunctions;
				flow :> 'Optical Data', involvedFunctionalExchanges from 'Capture Movement'.FOP1 to 'Transform Raw Optical Data'.FIP2 {
					// FC-13: among the exchange items of the exchange, the link only carries this one
					ref item exchangedItems :> payload = (rawOpticalDataX);
					// FC-08: exchange context
					assert constraint 'exchange context' { isMoving }
				}
			}

			// FC-01: an empty chain
			action 'stop movement' : FunctionalChain;
```

## Decisions

- **Dataflow and control flow.** Arcadia separates the dataflow from the control flow. The functions and the functional exchanges describe dependencies, without any order of execution. A functional chain follows the dataflow: it references functions and the functional exchanges that link them. Sequencing information is added on top of it, when needed, by sequence links and control nodes (Arcadia Language - MetaModel, "Functional Chain", "Sequence Link" and "Control Node"; Arcadia Q&A, "How to use Functional Chains?").
- **No succession for a functional exchange.** By default a chain has no succession: it only has references to functions ([FC-02](#fc-02)) and links ([FC-03](#fc-03)). A succession states that an action ends before the next one starts, which a functional exchange does not state. Successions are only written for sequence links ([FC-05](#fc-05)).
- **Action definition.** Functional chains are action definitions that reference existing functions and exchanges. The KerML Behavior concept could have been an option, but it is unlikely to be well handled by other tools.
- **Named references.** A chain does not own the functions it involves: it performs them. A `perform` is a reference to the performed action, not a composite sub-action, so it is not in `subactions`. The library therefore declares the roles `involvedFunctions` and `referencedFunctionalChains`, that each `perform` states with `:>`. Each reference is named, so that a function that appears several times in a chain has one reference for each appearance, and so that the links and the successions designate the appearance they connect. Two references to the same function each denote performances of that function; nothing says whether they are the same performance or two different ones. A binding between two references states that they are the same performance ([FC-11](#fc-11)).
- **Links.** A link is a flow usage owned by the chain. It subsets the functional exchange: it is a flow usage of its own, but its transfers are transfers of the exchange, those that take place in the chain. It adds no other transfer. It connects the ports of two references of the chain. A functional exchange involved in several chains has one link in each of them. It states the role `involvedFunctionalExchanges`, as a reference states the role `involvedFunctions`.
- The functional exchanges are not declared `abstract`. It would mean that an exchange can only take place through the links of the chains, whereas in Arcadia an exchange exists whether or not a chain involves it.
- The writing of the links ([FC-03](#fc-03)) and of the binding between two referenced chains ([FC-11](#fc-11)) was reviewed by TWE.
- **Local content.** `involvedFunctions` and `involvedFunctionalExchanges` are local to the chain, as in Capella. The flattened content of a composite chain is computed by following the references.
- **Composite chains.** The reference to a chain is a `perform` of that chain. Two referenced chains, or a referenced chain and a function, are assembled in one of three ways: by a link, whose end can be a function inside a referenced chain (a feature chain through the reference); by a sequence link, which gives a succession; or by a function that belongs to both chains, which gives a binding ([FC-11](#fc-11)).
- **Control nodes.** They only exist between sequence links. The functions that an ITERATE node repeats are performed inside the loop action; they keep the role `involvedFunctions`.
- **Conditions and exchange contexts.** The condition of a sequence link ([FC-14](#fc-14)) and the exchange context of a link ([FC-08](#fc-08)) are constraints written as expressions. A Capella constraint written as free text has no translation yet (see [OP-CONSTRAINTS](../ArcadiaLibraryMapping.md#op-constraints)).
- **Empty chains.** A chain can have no involvement at all. It is represented like any other chain, with no reference and no link, and it is migrated, not skipped.
- **Migration.** An involvement of a function or of a chain becomes a named reference. An involvement link becomes a link between the references of its source and of its target. A sequence link becomes a succession. A link between two involvements of the same function becomes a binding.

## Tooling requirements

- A reference has no name in Capella. Tooling builds its name from the name of the referenced function or chain, with a number when the same element is referenced several times, and displays the name of the referenced element.
- Tooling checks that the role matches the type of the performed action: a function for `involvedFunctions`, a functional chain for `referencedFunctionalChains`.
- Tooling checks that a link connects a port of the source of the functional exchange to a port of its target, and that the exchanged items of a link ([FC-13](#fc-13)) are exchange items of the exchange.
- A chain must not reference itself, directly or through other chains. SysML v2 tools do not check it: tooling has to prevent it, as Capella does.
- The flattened content of a composite chain (all its functions and exchanges, its first and last functions) is computed. The first and last functions of a chain are computed from its links.
- [FC-09](#fc-09): the components involved in a chain are computed.
- The functions performed inside a loop action ([FC-12](#fc-12)) are part of the functions of the chain.
- An empty chain may be reported as a warning, as Capella does.

## SysML v2 limitations

- A guarded succession has to be named, or written as `if condition then step;` right after the `decide`: `succession first a if condition then b;` without a name is rejected by the pilot implementation.
- The feature `involvedFunctionalExchanges` of the library is a plain `ref` typed by the flow definition, not a `ref flow`: a flow usage must have exactly two ends, and `ref flow` without `from ... to ...` is rejected by the pilot implementation ("Cannot have more than two ends").
- A link cannot redefine the payload of the functional exchange it specializes ("Cannot override a binding feature value"): the exchanged items of a link are a subset of the payload ([FC-13](#fc-13)).

## Open points

[OP-CONSTRAINTS](../ArcadiaLibraryMapping.md#op-constraints), [OP-SCENARIOS](../ArcadiaLibraryMapping.md#op-scenarios), [OP-MODES](../ArcadiaLibraryMapping.md#op-modes) (see the [open points register](../ArcadiaLibraryMapping.md#open-points-register)).
