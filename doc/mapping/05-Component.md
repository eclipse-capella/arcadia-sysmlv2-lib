# Component

[Contents](../ArcadiaLibraryMapping.md#contents) | Previous: [Packages](04-Packages.md) | Next: [Node and Behavior Components](06-NodeAndBehaviorComponents.md)

## Library definition

```
	part def Component :> ArcadiaElement {
		private doc /* A generic Arcadia component, used across all Arcadia engineering perspectives. */
    	attribute isActor : Boolean default false;
    	attribute isHuman : Boolean default false;
    	alias allocatedFunctions for performedActions;
		alias subComponents for subparts;
	}
```

## Mapping

| ID | Capella concept | Capella metamodel | Treatment | In SysML v2 | Meaning | Rationale |
| --- | --- | --- | --- | --- | --- | --- |
| COMP-01 | Operational Entity / Actor, System Component, Logical Component, Physical Component | `oa::Entity`, `ctx::SystemComponent`, `la::LogicalComponent`, `pa::PhysicalComponent` (all `cs::Component`) | Library | `part def Component :> ArcadiaElement`, used as `part x : Component` | A constituent of the system or an external entity | P1: a component is a part. P6: one type for all perspectives; the perspective is given by the enclosing `ArcadiaPackage` |
| COMP-02 | Is Actor | `cs::Component.actor` | Library | `attribute isActor : Boolean default false` | The component is external to the system of interest | P3: property needed by Arcadia, no native equivalent |
| COMP-03 | Is Human | `cs::Component.human` | Library | `attribute isHuman : Boolean default false` | The component is a human | P3 |
| COMP-04 | Nature (Node / Behavior) | `pa::PhysicalComponent.nature` | Typing | type `NodeComponent` or `BehaviorComponent` (see NODE-01, NODE-02) | Distinguishes a Physical Node from a Physical Behavior | P1: expressed by the type, not by an attribute |
| COMP-05 | Kind (hardware, software, person…) | `pa::PhysicalComponent.kind` (enum `PhysicalComponentKind`, 14 literals) | Deferred – OP-KIND | none | Category of a Physical Component, from a fixed list | Not decided yet |
| COMP-06 | Abstract | `capellacore::GeneralizableElement.abstract` | Deferred – OP-REC | none | Abstract actor meant to be specialized (used with Generalizations) | Depends on how reuse (REC/RPL, definitions and usages) is handled |
| COMP-07 | Generalized Components | `capellacore::GeneralizableElement.ownedGeneralizations` (derived: `super`, `sub`) | Deferred – OP-REC | none | A component specializes another one (mostly actors) | Same as COMP-06 |
| COMP-08 | Allocated Functions | `fa::AbstractFunctionalBlock.ownedFunctionalAllocation` (derived: `allocatedFunctions`, and per perspective `allocatedOperationalActivities`, `allocatedSystemFunctions`, `allocatedLogicalFunctions`, `allocatedPhysicalFunctions`) | Library | `perform <function>`; `alias allocatedFunctions for performedActions` | The functions allocated to the component: its behavior | P1: native `perform`; alias kept because it is a key Arcadia relationship |
| COMP-09 | Sub-components | `cs::Part` typed by a component owned through `ownedEntities`, `ownedSystemComponents`, `ownedLogicalComponents`, `ownedPhysicalComponents` (derived: `subEntities`, `subLogicalComponents`, `subPhysicalComponents`) | Library | nested `part`; `alias subComponents for subparts` | Components directly contained (one level) | P1: native part nesting |
| COMP-10 | Allocated Roles (OA) | `oa::Entity.ownedRoleAllocations` (derived: `allocatedRoles`) | Not translated – replaced by definition/usage | none | Roles avoid duplicating activities performed by several entities | P4: rarely used; reuse is expressed with definitions and usages |

## Example

From `examples/concepts/component.sysml`, validated with the SysML v2 pilot implementation.

```
	// COMP-01, COMP-02, COMP-03: a human actor
	part computerUser : Component {
		:>> isActor = true;
		:>> isHuman = true;
		// COMP-08: allocated function
		perform 'Root Function'.'Use Mouse';
	}

	part system : Component {
		// COMP-09: sub-component (one level)
		part 'Optical Sensor Unit' : Component {
			perform 'Root Function'.'Capture Movement';
		}
	}
```

## Decisions

- One single type represents the components of all engineering perspectives (P6). Whether a component is Operational, System, Logical or Physical follows from the closest enclosing package annotated with `ArcadiaPackage`.
- The sub-components of a component are the parts it owns directly plus those owned by its nested packages (see the PKG section). The alias `subComponents` (the native `subparts`) only gives the parts owned directly: the parts of a nested package are not features of the component, so the complete list is computed by tooling.

## Tooling requirements

- COMP-02, COMP-03: editable as booleans; they drive the icon and the color of the component.
- COMP-08: allocated functions are shown inside the component in architecture diagrams, and listed in its properties.
- COMP-09: the list of sub-components is computed, not entered by the user.

## SysML v2 limitations

None.

## Open points

OP-KIND, OP-REC, OP-SUBPARTS (see the open points register).
