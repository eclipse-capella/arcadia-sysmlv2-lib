# Physical Ports, Links and Paths

[Contents](../ArcadiaLibraryMapping.md#contents) | Previous: [Interface](22-Interface.md)

## Library definition

```
	port def PhysicalPort :> ArcadiaElement {
		private doc /* A generic Arcadia Physical Port: a point of connection of a hosting component (a Node Component, or the system
		 * and the actors before the Physical Architecture) with its environment. A Physical Port is not oriented.
		 * It references the Component Ports of the hosted components that are accessible through it. */
		ref port allocatedComponentPorts: ComponentPort [*];
	}

	interface def PhysicalLink :> ArcadiaElement {
		private doc /* A generic Arcadia Physical Link: a means of communication, transport or routing between two hosting components,
		 * used as a support for Component Exchanges. It connects two Physical Ports.
		 * Component Exchanges are allocated to a Physical Link with ComponentExchangeAllocation usages. */
		end pp1 : PhysicalPort;
		end pp2 : PhysicalPort;
	}

	item def PhysicalPath :> ArcadiaElement {
		private doc /* A generic Arcadia Physical Path: an ordered set of references to Physical Links, defining a continuous path
		 * that routes Component Exchanges between components that are not linked by a single Physical Link.
		 * A Physical Path can reuse other Physical Paths: involvedLinksAndPaths references Physical Links and Physical
		 * Paths, in the order of the path.
		 * Component Exchanges are allocated to a Physical Path with ComponentExchangeAllocation usages. */
		ref involvedLinksAndPaths: ArcadiaElement [*] ordered;
	}

	allocation def ComponentExchangeAllocation :> ArcadiaElement {
		private doc /* A generic Arcadia Component Exchange Allocation: a Component Exchange is carried by a Physical Link or by a
		 * Physical Path (physicalSupport).
		 * It is owned by the Physical Link or the Physical Path, and is written
		 * 'allocation : ComponentExchangeAllocation allocate <component exchange> to self;'. */
		end componentExchange : ComponentExchange;
		end physicalSupport : ArcadiaElement;
	}
```

## Mapping

| ID | Capella concept | Capella metamodel | Treatment | In SysML v2 | Meaning | Rationale |
| --- | --- | --- | --- | --- | --- | --- |
| <a id="phys-01"></a>PHYS-01 | Physical Port | `cs::PhysicalPort` | Library | `port def PhysicalPort :> ArcadiaElement`, used as `port x : PhysicalPort`, without directed feature | A point of connection of a hosting component with its environment. A physical port is not oriented | P3: needed by Arcadia. P1: a SysML v2 port without directed feature |
| <a id="phys-02"></a>PHYS-02 | Component ports allocated to a physical port | `fa::ComponentPortAllocation`, owned by the physical port (`cs::PhysicalPort.ownedComponentPortAllocations`; derived: `allocatedComponentPorts`) | Library | `ref port allocatedComponentPorts: ComponentPort [*]`, set with `ref port :>> allocatedComponentPorts = (...)` | The component ports of the hosted components that are accessible through the physical port | P3. Same choice as for the function ports of a component port ([CP-04](13-ComponentPort.md#cp-04)) |
| <a id="phys-03"></a>PHYS-03 | Physical Link | `cs::PhysicalLink` (`linkEnds`) | Library | `interface def PhysicalLink :> ArcadiaElement`, used as `interface x : PhysicalLink connect <physical port> to <physical port>;` | A means of communication, transport or routing between two hosting components, used as a support for component exchanges | P3: needed by Arcadia. P1: an interface usage between two ports, as for a component exchange |
| <a id="phys-04"></a>PHYS-04 | Allocation of a component exchange to a physical link or to a physical path | `fa::ComponentExchangeAllocation`, owned by the physical link or the physical path (`fa::ComponentExchangeAllocator.ownedComponentExchangeAllocations`; derived: `allocatedComponentExchanges`) | Library | `allocation : ComponentExchangeAllocation allocate <component exchange> to self;`, owned by the physical link or the physical path | The component exchange is carried by the physical link or by the physical path | P1: a native allocation, typed by a library definition. Same choice as for functional exchanges ([EA-01](14-ExchangeAllocation.md#ea-01)) |
| <a id="phys-05"></a>PHYS-05 | Physical Path | `cs::PhysicalPath`, owned by a component (`cs::Component.ownedPhysicalPath`) | Library | `item def PhysicalPath :> ArcadiaElement`, used as `item x : PhysicalPath` | A continuous path made of physical links, that routes component exchanges between components that are not linked by a single physical link | P3: needed by Arcadia; SysML v2 has no native concept of path |
| <a id="phys-06"></a>PHYS-06 | Physical links of a physical path, and their order | `cs::PhysicalPathInvolvement` designating a physical link, chained with `nextInvolvements` (`cs::PhysicalPath.involvedLinks`) | Library | `ref involvedLinksAndPaths: ArcadiaElement [*] ordered`, set with `ref :>> involvedLinksAndPaths = (...)` | The ordered set of physical links of the path | P3 |
| <a id="phys-07"></a>PHYS-07 | Components crossed by a physical path | `cs::PhysicalPathInvolvement` designating a part (derived: `involvedComponent`) | Derived | none | The components that the path goes through | Computed from the ends of the physical links of the path: storing them would repeat it |
| <a id="phys-08"></a>PHYS-08 | Physical Path Reference | `cs::PhysicalPathReference` (derived: `referencedPhysicalPath`) | Library | an entry of `involvedLinksAndPaths` ([PHYS-06](#phys-06)), at its place in the order of the path | A physical path reuses another physical path | P3. Same possibility as for functional chains ([FC-04](10-FunctionalChain.md#fc-04)). One single list keeps the place of a reused path among the physical links |
| <a id="phys-09"></a>PHYS-09 | Physical Link End | `cs::PhysicalLinkEnd` | Deferred – [OP-REC](../ArcadiaLibraryMapping.md#op-rec) | none | End of a physical link that designates a port through a part, for reused components | Linked to the reuse of components |
| <a id="phys-10"></a>PHYS-10 | Physical Link Category | `cs::PhysicalLinkCategory` | Deferred – [OP-CATEGORIES](../ArcadiaLibraryMapping.md#op-categories) | none | Group of physical links | Treated with the other categories |
| <a id="phys-11"></a>PHYS-11 | Realization of a physical link or of a physical path | `cs::PhysicalLinkRealization`, `cs::PhysicalPathRealization` | Library | `Realization`, owned by the realizing physical link or physical path (see [REAL-01](15-Realization.md#real-01)) | A physical link or path realizes a physical link or path of the previous engineering perspective | A physical link and a physical path are `ArcadiaElement` usages: they are realized like any other element |
| <a id="phys-12"></a>PHYS-12 | Realization of a physical port | `cs::PhysicalPortRealization` | Deferred – [OP-PORT-REAL](../ArcadiaLibraryMapping.md#op-port-real) | none | A physical port realizes a physical port of the previous engineering perspective | A port usage cannot own an allocation (see SysML v2 limitations) |
| <a id="phys-13"></a>PHYS-13 | Function ports allocated to a physical port | `information::PortAllocation`, owned by the physical port | Not translated – legacy | none | Function ports allocated directly to a physical port | Capella advises against it: function ports are allocated to component ports ([CP-04](13-ComponentPort.md#cp-04)) |
| <a id="phys-14"></a>PHYS-14 | Interfaces provided or required by a physical port | `information::Port.providedInterfaces`, `requiredInterfaces`, inherited by `cs::PhysicalPort` | Deferred – [OP-HW-INTERFACE](../ArcadiaLibraryMapping.md#op-hw-interface) | none | Interfaces of a hosting component (hardware interfaces) | The Capella metamodel allows it but the Capella editors do not offer it |

## Example

From [`examples/concepts/physical.sysml`](../../examples/concepts/physical.sysml), validated with the SysML v2 pilot implementation.

```
		part 'Sensor Board' : NodeComponent {
			allocation : Deployment allocate system.'Sensor Firmware' to self;
			// PHYS-01: a physical port, not oriented
			port 'Flex Connector' : PhysicalPort {
				// PHYS-02: the component ports of the hosted components that are accessible through the physical port
				ref port :>> allocatedComponentPorts = (system.'Sensor Firmware'.'Data Out', system.'Sensor Firmware'.'Status Out');
			}
		}
		part 'Main Board' : NodeComponent {
			allocation : Deployment allocate system.'Board Monitor' to self;
			port 'Flex Socket' : PhysicalPort;
			port 'USB Connector' : PhysicalPort;
			// A Node Component contained in a Node Component
			part 'Microcontroller' : NodeComponent {
				allocation : Deployment allocate system.'Controller Software' to self;
				port 'Data Pins' : PhysicalPort;
				port 'USB Pins' : PhysicalPort;
			}
			// PHYS-03: the port of a node and the port of a node that it contains are connected by a physical link, not by a delegation
			interface 'Flex Traces' : PhysicalLink connect 'Flex Socket' to 'Microcontroller'.'Data Pins';
			interface 'USB Traces' : PhysicalLink connect 'USB Connector' to 'Microcontroller'.'USB Pins';
		}
		// PHYS-03: a physical link between two physical ports of two nodes
		interface 'Flex Cable' : PhysicalLink connect 'Sensor Board'.'Flex Connector' to 'Main Board'.'Flex Socket' {
			// PHYS-04: a component exchange carried by the physical link
			allocation : ComponentExchangeAllocation allocate system.'Sensor Status' to self;
		}
		// PHYS-05: a physical path; PHYS-06: its physical links, in order
		item 'Sensor to Microcontroller' : PhysicalPath {
			ref :>> involvedLinksAndPaths = ('Flex Cable', 'Main Board'.'Flex Traces');
			// PHYS-04: a component exchange carried by the physical path
			allocation : ComponentExchangeAllocation allocate system.'Optical Data' to self;
		}
```

```
	// PHYS-03: a physical link between the system and an actor
	interface 'USB Cable' : PhysicalLink connect system.'Main Board'.'USB Connector' to computer.'USB Port';

	item 'Microcontroller to Computer' : PhysicalPath {
		ref :>> involvedLinksAndPaths = (system.'Main Board'.'USB Traces', 'USB Cable');
		allocation : ComponentExchangeAllocation allocate 'Motion Report' to self;
	}
	// PHYS-08: a physical path that reuses other physical paths
	item 'Sensor to Computer' : PhysicalPath {
		ref :>> involvedLinksAndPaths = (system.'Sensor to Microcontroller', 'Microcontroller to Computer');
	}
	// PHYS-08: a physical link between two reused physical paths
	item 'Sensor to Main Board' : PhysicalPath {
		ref :>> involvedLinksAndPaths = (system.'Flex Cable');
	}
	item 'Sensor to Computer through the traces' : PhysicalPath {
		ref :>> involvedLinksAndPaths = ('Sensor to Main Board', system.'Main Board'.'Flex Traces', 'Microcontroller to Computer');
	}
```

## Decisions

- **Not oriented.** A physical port has no directed feature: unlike a component port ([CP-02](13-ComponentPort.md#cp-02)), it has no direction.
- **Allocated component ports.** `allocatedComponentPorts` is a reference declared in the library, not an allocation element, for the same reason as `allocatedFunctionPorts`: a port cannot own an allocation. A component port connected to a component exchange that leaves its hosting component is allocated to one physical port.
- **Physical link.** It has the same form as a component exchange: an interface usage between two ports. Its two ends are not ordered. It is declared in the component that contains its two ends, or in a package when it connects the system and an actor.
- **Between a node and a node that it contains.** The physical port of the containing node and the physical port of the contained node are connected by a physical link, not by a delegation. This differs from component ports, which are delegated with a binding connector ([CE-08](12-ComponentExchange.md#ce-08)).
- **Engineering perspectives.** In the Physical Architecture, physical ports belong to Node Components and physical links connect Node Components. Before the Physical Architecture, a physical link can only connect the system and an actor. There is no physical port or physical link in the Operational Analysis, where entities are connected by communication means ([CE-01](12-ComponentExchange.md#ce-01)).
- **Allocation of component exchanges.** A `ComponentExchangeAllocation` is owned by the physical link or the physical path that carries the component exchange, and designates it with `self`, like the other Arcadia allocations (see the EA and REAL sections). The list of the component exchanges of a physical link or path is computed from the allocations. A component exchange is allocated to one physical link only; when it is routed through several physical links, it is allocated to a physical path.
- **Permissive end.** The `physicalSupport` end is typed `ArcadiaElement`, because it is a physical link or a physical path. The check is left to tooling.
- **Physical path.** It is an item usage typed by `PhysicalPath`, declared in the component or the package that contains its physical links. It references its physical links in order. The components that it goes through are not stored ([PHYS-07](#phys-07)). When a path has a fork, for example a bus, the order is only partial: the continuity of the path is checked from the ends of its physical links.
- **Reuse of paths.** A physical path can reference other physical paths ([PHYS-08](#phys-08)). Physical links and reused paths are in one single ordered list, `involvedLinksAndPaths`, because a physical link can come between two reused paths, as in Capella, where a Physical Path Reference is chained with the other involvements: two separate lists would lose that order. The content of the path is its own physical links and the content of the paths that it reuses.
- **Permissive list.** `involvedLinksAndPaths` is typed `ArcadiaElement`, because its entries are physical links and physical paths, which have no other common type. The check is left to tooling, as for the `physicalSupport` end.
- Not retained for [PHYS-05](#phys-05): one object per element crossed by the path, each one chained to the next, as in Capella (it repeats what the physical links already say and it is heavier to write, read and compare); the form of a functional chain (a physical path is a structure, not a behavior).
- **Migration from Capella.** The involvements of a physical path that designate physical links and the Physical Path References give the entries of `involvedLinksAndPaths`, in the order of the chaining; the involvements that designate parts are not migrated.

## Tooling requirements

- A physical port is not placed on a Behavior Component. The root component of the Physical Architecture can own physical ports, but they are never the end of a physical link.
- In the Physical Architecture, a physical link connects the physical ports of two Node Components. In the System Analysis and the Logical Architecture, it connects the system and an actor. Tooling does not create physical ports or physical links in the Operational Analysis.
- Tooling reports a physical port that is not connected to any physical link, except on the root component of the Physical Architecture.
- Tooling reports a component exchange allocated to several physical links, and a `ComponentExchangeAllocation` whose owner is neither a physical link nor a physical path.
- [PHYS-07](#phys-07): the components crossed by a physical path are computed from the ends of its physical links, including those of the paths that it reuses. Tooling reports a physical path that is not continuous.
- [PHYS-06](#phys-06), [PHYS-08](#phys-08): tooling reports an entry of `involvedLinksAndPaths` that is neither a physical link nor a physical path, and a physical path that reuses itself, directly or through other paths.
- The component exchanges carried by a physical link or a physical path are computed from the allocations ([PHYS-04](#phys-04)).

## SysML v2 limitations

- There is no native concept of path: a physical path is a library definition.
- A port usage cannot own an allocation: the pilot implementation answers "Nested usages in a port usage (other than ports) must be referential". The realization of a physical port cannot be written like the other realizations ([PHYS-12](#phys-12)).
- A reference to interface usages is written with a plain `ref` (`ref involvedLinksAndPaths: ArcadiaElement [*]`). It cannot be written `ref interface ...`, which declares a connection and requires two ends.

## Open points

[OP-HW-INTERFACE](../ArcadiaLibraryMapping.md#op-hw-interface), [OP-PORT-REAL](../ArcadiaLibraryMapping.md#op-port-real), [OP-CATEGORIES](../ArcadiaLibraryMapping.md#op-categories), [OP-REC](../ArcadiaLibraryMapping.md#op-rec) (see the [open points register](../ArcadiaLibraryMapping.md#open-points-register)).
