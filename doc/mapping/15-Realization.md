# Realization

[Contents](../ArcadiaLibraryMapping.md#contents) | Previous: [Exchange Allocation](14-ExchangeAllocation.md) | Next: [Exchange Item](16-ExchangeItem.md)

## Library definition

```
    allocation def Realization :> ArcadiaElement {
	    private doc /* A generic Arcadia Realization, used across all Arcadia engineering perspectives and for all kinds of
	     * Arcadia elements: an element (realizing) realizes an element of the previous engineering perspective (realized).
	     * A Realization is owned by the realizing element, and is written
	     * 'allocation : Realization allocate <realized element> to self;'.
	     * The 'realizes' and 'is realized by' navigations are derived by tooling and are not stored. */
        end realized : ArcadiaElement;
        end realizing : ArcadiaElement;
    }
```

## Mapping

| ID | Capella concept | Capella metamodel | Treatment | In SysML v2 | Meaning | Rationale |
| --- | --- | --- | --- | --- | --- | --- |
| REAL-01 | Realization of an element by an element of the next engineering perspective | the realization classes, one per kind of element: `fa::FunctionRealization`, `cs::ComponentRealization`, `fa::FunctionalExchangeRealization`, `fa::ComponentExchangeRealization`, `fa::FunctionalChainRealization`, `information::PortRealization`, `interaction::AbstractCapabilityRealization`…; owned by the realizing element | Library | `allocation def Realization :> ArcadiaElement`, used as `allocation : Realization allocate <realized element> to self;` in the realizing element | Traceability between engineering perspectives: an element realizes one or several elements of the previous perspective (SA realizes OA, LA realizes SA, PA realizes LA) | P1: allocation is the standard way to relate an abstract architecture to a more concrete one. P3: one single definition for all kinds of elements |
| REAL-02 | Realized element | `modellingcore::AbstractTrace.targetElement` | Library | `end realized : ArcadiaElement` (source of the allocation) | The element of the previous perspective | P1 |
| REAL-03 | Realizing element | `modellingcore::AbstractTrace.sourceElement` | Library | `end realizing : ArcadiaElement` (target of the allocation) | The element of this perspective | P1 |
| REAL-04 | Realized and realizing elements of an element | derived references of each class (`realizedXxx`, `realizingXxx`) | Derived | computed from the `Realization` allocations | Navigation in both directions | The link is stored once, as in Capella |

## Example

From `examples/concepts/realization.sysml`, validated with the SysML v2 pilot implementation.

```
				// REAL-01 to REAL-03: a logical function realizes a system function
				action 'Capture Movement' : Function {
					allocation : Realization allocate SA::Functions::'Root Function'.'Move Cursor' to self;
				}
				// A system function can be realized by several logical functions
				action 'Transform Raw Optical Data' : Function {
					allocation : Realization allocate SA::Functions::'Root Function'.'Move Cursor' to self;
				}
```

```
			// REAL-01: the same allocation for a component
			part system : Component {
				allocation : Realization allocate SA::Structure::system to self;
			}
```

## Decisions

- **Why an allocation.** The SysML v2 reference models use allocation to link an abstract architecture to a more concrete one. An allocation is a first-class element: it can be named, documented, carry a status and be navigated by tools, which a plain reference cannot. It migrates one-to-one from a Capella realization object. The other candidate, a `dependency` with the standard `#refinement` metadata, was not retained: a refinement is not exactly a realization.
- **One single `Realization`.** Capella has more than twenty realization classes, one per kind of element. They are not reproduced: the library stays light; each specialization would have to be known, created, displayed and migrated by tooling; and the information they carry is redundant with the types of the two ends. The Capella class is deduced from the types of the ends.
- **Ownership (general rule for all Arcadia allocations).** An allocation is owned by the element that owns the corresponding trace in Capella: the realizing element for a `Realization`, the component exchange for an `ExchangeAllocation`, the hosting component for a `Deployment`. The owner is designated by `self`.
- **Use of `self`.** `self` is a feature of the SysML v2 system libraries and always means the element itself, whether the owner is a usage or a definition; nothing in the language forbids the owner of an allocation from being one of its ends. This convention has been confirmed valid by a SysML v2 expert review; it has no precedent in the official examples. Alternative not retained: owning the allocation in the parent element and designating both elements by name or feature chain, at the cost of no longer storing the allocation in the element that owns it in Capella.
- **Direction.** Arcadia says "the logical function realizes the system function". SysML v2 writes `allocate <system function> to <logical function>`: the abstract element is allocated to the concrete one. This is the opposite of the Capella trace, whose source is the realizing element: a migration swaps the ends.
- **Many-to-many.** A realizing element can have several `Realization` allocations, one per realized element, and an element can be realized by several elements.
- **Status and property values.** A Capella realization has no name, but it has a status and property values: they are kept, as the allocation is an `ArcadiaElement`.
- **Realization between architectures.** Capella also creates realization links between the architectures themselves (`ctx::OperationalAnalysisRealization`, `la::SystemAnalysisRealization`, `pa::LogicalArchitectureRealization`, `epbs::PhysicalArchitectureRealization`). They are not translated: a `Realization` links Arcadia elements, not packages, and the order of the engineering perspectives already gives this information.
- The allocation of function ports to component ports is not a `Realization`: it stays a reference (see CP-04).
- Nested allocations (the allocation of a parent function containing the allocations of its children) are accepted by the pilot implementation but are not used: their semantics has not been verified.

## Tooling requirements

- REAL-04: the realized and realizing elements of an element are computed from the allocations, for its properties and for traceability views. Labels keep the Arcadia vocabulary (Realized, Realizing).
- The consistency of the ends (a function realizes a function, a component a component…) is a validation rule.
- A migration from Capella swaps the ends (see Direction).

## SysML v2 limitations

- An element cannot be designated by its simple name from inside itself (the pilot implementation answers "Must be an accessible feature"), and a feature chain from the enclosing element breaks when the element is renamed, moved or copied. `that` designates the featuring instance (the parent), not the element itself. This is why `self` is used.
- The pilot implementation does not check the types of the ends of an allocation.

## Open points

None.
