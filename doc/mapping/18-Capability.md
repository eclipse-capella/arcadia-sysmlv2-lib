# Capability

[Contents](../ArcadiaLibraryMapping.md#contents) | Previous: [Requirements](17-Requirements.md) | Next: [Mission](19-Mission.md)

## Library definition

```
	occurrence def Capability :> ArcadiaElement {
	    private doc /* A generic Arcadia Capability, used across all Arcadia engineering perspectives. */
		ref action involvedFunctions: Function[*];
		ref action involvedFunctionalChains: FunctionalChain[*];
		ref part involvedComponents: Component[*];
	}
```

## Mapping

| ID | Capella concept | Capella metamodel | Treatment | In SysML v2 | Meaning | Rationale |
| --- | --- | --- | --- | --- | --- | --- |
| <a id="cap-01"></a>CAP-01 | Operational Capability, Capability, Capability Realization | `oa::OperationalCapability`, `ctx::Capability`, `la::CapabilityRealization` (all `interaction::AbstractCapability`) | Library | `occurrence def Capability :> ArcadiaElement`, used as `occurrence x : Capability` | An ability required from the system, to provide a service that supports the achievement of a mission | P3: capabilities are essential to Arcadia and no native concept keeps their role of abstract abilities, independent of specific behaviors or structures. P6: one type for all perspectives |
| <a id="cap-02"></a>CAP-02 | Involved functions | `interaction::AbstractCapability.ownedAbstractFunctionAbstractCapabilityInvolvements` (derived: `involvedAbstractFunctions`) | Library | `ref action involvedFunctions: Function[*]`, set with `ref action :>> involvedFunctions = (...)` | The functions involved in the capability | P3: needed by Arcadia |
| <a id="cap-03"></a>CAP-03 | Involved functional chains (or operational processes) | `interaction::AbstractCapability.ownedFunctionalChainAbstractCapabilityInvolvements` (derived: `involvedFunctionalChains`); chains owned by the capability: `fa::AbstractFunctionalChainContainer.ownedFunctionalChains` | Library | a chain owned by the capability is an action usage nested in it; a chain owned elsewhere is listed in `ref action involvedFunctionalChains: FunctionalChain[*]` | The functional chains involved in the capability | P3. The information is stored once (see Decisions) |
| <a id="cap-04"></a>CAP-04 | Involved components (entities in Operational Analysis) | `oa::OperationalCapability.ownedEntityOperationalCapabilityInvolvements`, `ctx::Capability.ownedCapabilityInvolvements`, `la::CapabilityRealization.ownedCapabilityRealizationInvolvements` (derived: `involvedEntities`, `involvedSystemComponents`, `involvedComponents`) | Library | `ref part involvedComponents: Component[*]`, set with `ref part :>> involvedComponents = (...)` | The components and actors involved in the capability | P6: one reference for all perspectives, whereas Capella has one per perspective |
| <a id="cap-05"></a>CAP-05 | Missions that exploit the capability | derived `ctx::Capability.purposeMissions` | Derived | computed from the missions that list the capability in `exploitedCapabilities` ([MIS-02](19-Mission.md#mis-02)) | The missions that the capability contributes to | The link is stored once, on the mission, as in Capella |
| <a id="cap-06"></a>CAP-06 | Pre-condition and post-condition | `interaction::AbstractCapability.preCondition`, `postCondition` | Deferred – [OP-CAP](../ArcadiaLibraryMapping.md#op-cap) | none | Conditions before and after the capability | Not decided yet |
| <a id="cap-07"></a>CAP-07 | Extends, includes, generalization between capabilities | `interaction::AbstractCapability.extends`, `includes`, `superGeneralizations` | Deferred – [OP-CAP](../ArcadiaLibraryMapping.md#op-cap) | none | Relationships between capabilities | Not decided yet |
| <a id="cap-08"></a>CAP-08 | Scenarios of a capability | `interaction::AbstractCapability.ownedScenarios` | Deferred – [OP-SCENARIOS](../ArcadiaLibraryMapping.md#op-scenarios) | none | The scenarios that describe the capability | Scenarios are not covered yet |
| <a id="cap-09"></a>CAP-09 | Available in modes and states | `interaction::AbstractCapability.availableInStates` | Deferred – [OP-MODES](../ArcadiaLibraryMapping.md#op-modes) | none | The modes and states in which the capability is available | Modes and states are not covered yet |

## Example

From [`examples/concepts/capability.sysml`](../../examples/concepts/capability.sysml), validated with the SysML v2 pilot implementation.

```
			// CAP-01: a capability
			occurrence 'Move Cursor on Screen' : Capability {
				// CAP-02: involved functions
				ref action :>> involvedFunctions = ('Root Function'.'Capture Movement', 'Root Function'.'Transform Raw Optical Data');
				// CAP-04: involved components
				ref part :>> involvedComponents = (system.'Optical Sensor Unit', system.'Mouse Controller');
				// CAP-03: a chain owned by the capability is involved by construction
				action 'read movement' : FunctionalChain {
					perform action 'Capture Movement' references 'Root Function'.'Capture Movement' :> involvedFunctions;
					perform action 'Transform Raw Optical Data' references 'Root Function'.'Transform Raw Optical Data' :> involvedFunctions;
					flow :> 'Root Function'.'Optical Data', involvedFunctionalExchanges from 'Capture Movement'.FOP1 to 'Transform Raw Optical Data'.FIP2;
				}
				// CAP-03: a chain owned elsewhere is referenced
				ref action :>> involvedFunctionalChains = ('Root Function'.'diagnostic chain');
			}
```

## Decisions

- **Functional chains owned by a capability.** In Capella a functional chain (or an operational process) is owned either by a function or by a capability. The same structure is kept: a `FunctionalChain` action usage can be owned by a `Function` or by a `Capability` occurrence usage (an occurrence usage can own action usages). Nothing is added to the library for this.
- **Stored once.** A chain owned by the capability is involved by construction. `involvedFunctionalChains` only references the chains owned elsewhere, in a function or in another capability.
- **Migration.** A functional chain owned by a capability becomes an action usage owned by the capability. The Capella involvement from that capability to its own chain is not migrated: it is implied by the ownership. An involvement to a chain owned elsewhere becomes an entry of `involvedFunctionalChains`.
- Capabilities of the Logical and Physical Architectures are generally the same as those of the System Analysis. They are supported, because a model does not always have an Operational Analysis and a System Analysis.

## Tooling requirements

- The full list of the functional chains involved in a capability (owned and referenced) is computed.
- [CAP-05](#cap-05): the missions that exploit a capability are computed from the missions.
- Involved functions and chains are shown in the properties of the capability; involved components are shown as links in capability diagrams.

## SysML v2 limitations

None.

## Open points

[OP-CAP](../ArcadiaLibraryMapping.md#op-cap), [OP-SCENARIOS](../ArcadiaLibraryMapping.md#op-scenarios), [OP-MODES](../ArcadiaLibraryMapping.md#op-modes) (see the [open points register](../ArcadiaLibraryMapping.md#open-points-register)).
