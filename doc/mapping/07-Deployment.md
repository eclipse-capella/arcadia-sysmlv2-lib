# Deployment

[Contents](../ArcadiaLibraryMapping.md#contents) | Previous: [Node and Behavior Components](06-NodeAndBehaviorComponents.md) | Next: [Function](08-Function.md)

## Library definition

```
	allocation def Deployment :> ArcadiaElement {
		private doc /* A generic Arcadia Deployment, used in the Physical Architecture: a component (deployedElement) is deployed on
		 * another component (location), instead of being contained in it. Typically a Behavior Component or a Node Component
		 * is deployed on a Node Component.
		 * A Deployment is stored in the location component, and is written
		 * 'allocation : Deployment allocate <deployed component> to self;'. */
		end deployedElement : Component;
		end location : Component;
	}
```

## Mapping

| ID | Capella concept | Capella metamodel | Treatment | In SysML v2 | Meaning | Rationale |
| --- | --- | --- | --- | --- | --- | --- |
| DEPL-01 | Deployment of a component on another one | `pa::deployment::PartDeploymentLink`, owned by the part of the hosting component (`cs::Part.ownedDeploymentLinks`) | Library | `allocation def Deployment :> ArcadiaElement`, used as `allocation : Deployment allocate <deployed component> to self;` in the hosting component | A component is deployed on another component instead of being contained in it: typically a Behavior Component or a Node Component on a Node Component, which is the platform that hosts it | P1: SysML v2 has no deployment concept; the allocation is the standard way to relate a component to the one that implements or hosts it. P3: deployment is essential in the Physical Architecture |
| DEPL-02 | Deployed element | `cs::AbstractDeploymentLink.deployedElement` | Library | `end deployedElement : Component` (source of the allocation) | The deployed component | Named as in Capella |
| DEPL-03 | Location | `cs::AbstractDeploymentLink.location` | Library | `end location : Component` (target of the allocation) | The component on which it is deployed | Named as in Capella |
| DEPL-04 | Deployed components / deploying components | derived `pa::PhysicalComponent.deployedPhysicalComponents`, `deployingPhysicalComponents` (and `cs::Part.deployedParts`, `deployingParts`) | Derived | computed from the `Deployment` allocations | The components deployed on a component, and the component on which a component is deployed | The link is stored once, as in Capella |

## Example

From `examples/concepts/node-behavior.sysml`, validated with the SysML v2 pilot implementation.

```
	part system : Component {
		part 'Mouse Firmware' : BehaviorComponent {
			perform 'Root Function'.'Filter Noise';
		}
		part 'Mouse PCB' : NodeComponent {
			// DEPL-01 to DEPL-03: the firmware is deployed on the PCB, not contained in it
			allocation : Deployment allocate system.'Mouse Firmware' to self;
		}
	}
```

## Decisions

- **Ownership.** The `Deployment` is owned by the component on which the deployment is made (the `location`, in practice a node), so that the deployments follow it when it is copied, deleted or compared. In Capella, the deployment link is also owned by the part of the `location`.
- **Use of `self`.** The allocation is written `allocate <deployed component> to self`, where `self` designates the owner of the allocation. `self` is a feature of the SysML v2 system libraries and always means the element itself, whether the owner is a usage or a definition. This convention has been confirmed valid by a SysML v2 expert review; it has no precedent in the official examples.
- **Alternative not retained:** owning the allocation in the parent element and designating both components by name or feature chain, at the cost of no longer storing the deployment in the node.
- **Permissive ends.** The ends are typed `Component`, not `NodeComponent` or `BehaviorComponent`. Which components can be deployed on which is left to tooling.

## Tooling requirements

- The creation of a deployment creates a `Deployment` allocation in the hosting component.
- DEPL-04: the deployed components of a component and the component on which a component is deployed are computed from the allocations, for the properties of both components and for the architecture diagrams, where deployed components are shown inside the component that hosts them.
- Validation rules: typically a Behavior Component or a Node Component is deployed on a Node Component.

## SysML v2 limitations

- An element cannot be designated by its simple name from inside itself (the pilot implementation answers "Must be an accessible feature"). A feature chain from the enclosing element (`system.'Mouse PCB'`) is accepted, but it breaks when the component is renamed, moved or copied, whereas `self` follows it.
- The pilot implementation does not check the types of the ends of an allocation.

## Open points

OP-DEPLOY-OTHER (see the open points register).
