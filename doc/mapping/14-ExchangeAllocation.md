# Exchange Allocation

[Contents](../ArcadiaLibraryMapping.md#contents) | Previous: [Component Port](13-ComponentPort.md) | Next: [Realization](15-Realization.md)

## Library definition

```
    allocation def ExchangeAllocation :> ArcadiaElement {
	    private doc /* A generic Arcadia Exchange Allocation, used across all Arcadia engineering perspectives.
	     * An Exchange Allocation is owned by the Component Exchange it allocates to, and is written
	     * 'allocation : ExchangeAllocation allocate <functional exchange> to self;'. */
        end functionalExchange : FunctionalExchange;
        end componentExchange : ComponentExchange;
    }
```

## Mapping

| ID | Capella concept | Capella metamodel | Treatment | In SysML v2 | Meaning | Rationale |
| --- | --- | --- | --- | --- | --- | --- |
| EA-01 | Allocation of a functional exchange to a component exchange | `fa::ComponentExchangeFunctionalExchangeAllocation`, owned by the component exchange (`fa::ComponentExchange.ownedComponentExchangeFunctionalExchangeAllocations`) | Library | `allocation def ExchangeAllocation :> ArcadiaElement`, used as `allocation : ExchangeAllocation allocate <functional exchange> to self;` in the component exchange | The content of the interfaces between components is based on the functional content, through these allocations | P1: native allocation. P3: a thin typing that lets tools recognize an Arcadia exchange allocation |
| EA-02 | Allocated functional exchange | derived `allocatedFunctionalExchange` | Library | `end functionalExchange : FunctionalExchange` (source of the allocation) | The functional exchange that is allocated | P1 |
| EA-03 | Allocating component exchange | derived `allocatingComponentExchange` | Library | `end componentExchange : ComponentExchange` (target of the allocation) | The component exchange it is allocated to | P1 |

## Example

From `examples/concepts/exchanges.sysml`, validated with the SysML v2 pilot implementation.

```
			interface cable : ComponentExchange
				connect 'Optical Sensor Unit'.'Cable Connector' to 'Mouse Controller'.'Cable Connector' {
				ref item :>> allocatedExchangeItems = (rawOpticalDataX, rawOpticalDataY);
				// EA-01: the functional exchange allocated to the component exchange
				allocation : ExchangeAllocation allocate 'Root Function'.'Optical Data' to self;
			}
```

## Decisions

- **Ownership.** An exchange allocation is owned by the component exchange it allocates to, and designates it with `self`. This mirrors Capella, where the allocation object is owned by the component exchange, and it keeps the allocation next to the element it describes when the exchange is copied, deleted or compared. See the general ownership rule in the REAL section.
- **Alternative not retained:** owning the allocation in the part that owns the interface, as the Annex A model of the specification does. The component exchange is preferred so that the owner is the same in all Arcadia allocations.
- **Why a dedicated allocation definition.** SysML v2 has a generic allocation, whose two ends are typed by `Anything`: a functional exchange can be allocated to a component exchange with a plain `allocate`. `ExchangeAllocation` only types the ends, makes the allocation an `ArcadiaElement`, and lets tools recognize it among other allocations. Nothing is defined for the allocation of functions to components, because SysML v2 has a dedicated relation for it (`perform`).
- **Allocation element rather than a reference.** The library has no reference to the allocated functional exchanges on `ComponentExchange`: the list is computed from the allocations. Reasons: one single source of truth; it is the SysML v2 idiom (the Annex A model allocates a flow usage to an interface usage); in Capella the link is an object and the reference is derived, so a migration is one object to one allocation, which can carry a description and a status; one identifiable element per allocation when models are compared; same policy as for realizations.

## Tooling requirements

- The allocated functional exchanges of a component exchange are computed from the allocations (CE-05).

## SysML v2 limitations

- Not verified: whether a derived list can be expressed natively in SysML v2. It is computed by tooling here.

## Open points

None.
