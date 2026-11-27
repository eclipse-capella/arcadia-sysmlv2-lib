# Mission

[Contents](../ArcadiaLibraryMapping.md#contents) | Previous: [Capability](18-Capability.md) | Next: [Property values](20-PropertyValues.md)

## Library definition

```
 	occurrence def Mission :> ArcadiaElement {
	    private doc /* A generic Arcadia Mission, used across all Arcadia engineering perspectives. */
		ref part involvedComponents: Component[*];
		ref occurrence exploitedCapabilities: Capability[*];
	}
```

## Mapping

| ID | Capella concept | Capella metamodel | Treatment | In SysML v2 | Meaning | Rationale |
| --- | --- | --- | --- | --- | --- | --- |
| <a id="mis-01"></a>MIS-01 | Mission | `ctx::Mission` | Library | `occurrence def Mission :> ArcadiaElement`, used as `occurrence x : Mission` | A major goal to which the system is expected to contribute | P3: no native SysML v2 behavioral or interaction concept captures a goal that is independent of the system of interest |
| <a id="mis-02"></a>MIS-02 | Exploited capabilities | `ctx::Mission.ownedCapabilityExploitations` (derived: `exploitedCapabilities`) | Library | `ref occurrence exploitedCapabilities: Capability[*]`, set with `ref occurrence :>> exploitedCapabilities = (...)` | The capabilities exploited to achieve the mission | P3: needed by Arcadia |
| <a id="mis-03"></a>MIS-03 | Involved components | `ctx::Mission.ownedMissionInvolvements` (derived: `involvedSystemComponents`) | Library | `ref part involvedComponents: Component[*]`, set with `ref part :>> involvedComponents = (...)` | The components and actors involved in the mission | P3: needed by Arcadia |

## Example

From [`examples/concepts/capability.sysml`](../../examples/concepts/capability.sysml), validated with the SysML v2 pilot implementation.

```
			// MIS-01: a mission
			occurrence 'Provide Interface to User' : Mission {
				// MIS-02: exploited capabilities
				ref occurrence :>> exploitedCapabilities = ('Move Cursor on Screen');
				// MIS-03: involved components
				ref part :>> involvedComponents = (computerUser);
			}
```

## Decisions

- Missions are placed in the `Capabilities` package of the engineering perspective (see [STRUCT-05](03-DefaultModelStructure.md#struct-05)).
- A `Mission` can be used in the Operational Analysis (operational missions), the System Analysis, the Logical Architecture and the Physical Architecture (system missions). The EPBS has no missions: it only describes Configuration Items. Capella only has missions in the System Analysis: a migration creates missions there only.

## Tooling requirements

- Exploited capabilities and involved components are shown as links in mission and capability diagrams.

## SysML v2 limitations

None.

## Open points

None.
