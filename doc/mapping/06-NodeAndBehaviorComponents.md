# Node and Behavior Components

[Contents](../ArcadiaLibraryMapping.md#contents) | Previous: [Component](05-Component.md) | Next: [Deployment](07-Deployment.md)

## Library definition

```
	part def NodeComponent :> Component {
		private doc /* A Physical Architecture component of Node nature: a physical platform that hosts deployed components,
		 * Behavior Components or Node Components (see Deployment). An actor of the Physical Architecture is a Node Component or a Behavior Component. */
	}

	part def BehaviorComponent :> Component {
		private doc /* A Physical Architecture component of Behavior nature: it carries allocated functions and component exchanges,
		 * and is deployed on a Node Component, not contained in it (see Deployment). This also applies to the actors of the Physical Architecture that are Behavior Components. */
	}
```

## Mapping

| ID | Capella concept | Capella metamodel | Treatment | In SysML v2 | Meaning | Rationale |
| --- | --- | --- | --- | --- | --- | --- |
| <a id="node-01"></a>NODE-01 | Physical Component of nature Node, including the Node actors of the Physical Architecture | `pa::PhysicalComponent` with `nature = NODE` | Library | `part def NodeComponent :> Component`, used as `part x : NodeComponent` | A physical platform that hosts deployed components and is connected to other nodes by physical links | P3: the Node / Behavior distinction is essential in the Physical Architecture. P1: a specialization of the part definition is the standard way to distinguish kinds of parts, and any tool can read it without knowing a library attribute |
| <a id="node-02"></a>NODE-02 | Physical Component of nature Behavior, including the Behavior actors of the Physical Architecture | `pa::PhysicalComponent` with `nature = BEHAVIOR` | Library | `part def BehaviorComponent :> Component`, used as `part x : BehaviorComponent` | A component that carries allocated functions and component exchanges, and that is deployed on a Node Component, not contained in it | Same as [NODE-01](#node-01) |
| <a id="node-03"></a>NODE-03 | Root component of the Physical Architecture | `pa::PhysicalComponent` with `nature = UNSET` | Library | `part system : Component` | The only Physical Component whose nature is not specified | It stays a plain `Component` |

## Example

From [`examples/concepts/node-behavior.sysml`](../../examples/concepts/node-behavior.sysml), validated with the SysML v2 pilot implementation.

```
	// The root component of the Physical Architecture stays a plain Component
	part system : Component {
		// NODE-02: a Behavior Component, with an allocated function
		part 'Mouse Firmware' : BehaviorComponent {
			perform 'Root Function'.'Filter Noise';
			// NODE-02: an actor created in a Behavior Component is a Behavior Component
			part 'Firmware Updater' : BehaviorComponent {
				:>> isActor = true;
			}
		}
		// NODE-01: a Node Component
		part 'Mouse PCB' : NodeComponent {
			// DEPL-01 to DEPL-03: the firmware is deployed on the PCB, not contained in it
			allocation : Deployment allocate system.'Mouse Firmware' to self;
		}
	}

	// NODE-01: an actor created at the root level is a Node Component
	part computer : NodeComponent {
		:>> isActor = true;
	}
```

## Decisions

- The two specializations are used only in the Physical Architecture, where every component is either a Node Component or a Behavior Component, except the root component ([NODE-03](#node-03)). The other engineering perspectives keep using `Component`.
- Migration from Capella is direct: nature NODE gives `NodeComponent`, nature BEHAVIOR gives `BehaviorComponent`, and the root component (nature UNSET) stays a `Component`. An actor of the Physical Architecture is a `NodeComponent` or a `BehaviorComponent` with `isActor = true`, according to its nature in Capella. A Capella model in which an actor is contained in a component of the other nature is migrated as it is, and validation reports it.
- Hierarchies of Node Components and hierarchies of Behavior Components are both supported. It is a good practice in Arcadia to keep separate hierarchies for nodes and for behaviors.
- Containment and deployment are two different relations, as in Capella. A component created inside another one is contained in it. A deployed component is related to the component that hosts it by a `Deployment` allocation (see the DEPL section). A Node Component can be contained in a Node Component or deployed on it. A Behavior Component can be contained in a Behavior Component, but not in a Node Component: it is deployed on it. A Node Component is not contained in a Behavior Component. These rules are the same for the actors of the Physical Architecture and for the other components.

## Tooling requirements

The following rules are not enforced by the library. They are validation rules for tooling:

- In the Physical Architecture, a component other than the root component is a Node Component or a Behavior Component.
- A Node Component may have allocated functions (this is the case of the Node actors of the Physical Architecture).
- The nature of an actor of the Physical Architecture is set when the actor is created, from its container: it is the nature of the component that contains it, and Node when the actor is created at the root level or in the root component. It does not change when the actor is moved.
- Node Components have no realization relationship in Arcadia: tooling has to prevent it.
- A Behavior Component is not contained in a Node Component: it is deployed on it. A Node Component is not contained in a Behavior Component. Both rules apply to actors: tooling deploys a Behavior actor that is moved onto a Node Component, and does not move a Node actor into a Behavior Component.
- A human component can deploy sub-components but cannot contain them.

## SysML v2 limitations

- `Component` is not abstract (see the ELEM section), so the language does not prevent a plain `Component` in the Physical Architecture: this is left to tooling.

## Open points

[OP-PHYS](../ArcadiaLibraryMapping.md#op-phys) (see the [open points register](../ArcadiaLibraryMapping.md#open-points-register)).
