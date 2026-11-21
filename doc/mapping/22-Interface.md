# Interface

[Contents](../ArcadiaLibraryMapping.md#contents) | Previous: [Views](21-Views.md)

## Library definition

```
	item def Interface :> ArcadiaElement {
		private doc /* A generic Arcadia Interface, used across all Arcadia engineering perspectives: a set of Exchange Items
		 * that Component Ports provide or require (see providedInterfaces and requiredInterfaces of ComponentPort). */
		ref item exchangeItems: ExchangeItem [*];
	}
```

The provided and required interfaces of a port are declared on `ComponentPort` (see [CP-06](13-ComponentPort.md#cp-06)).

## Mapping

| ID | Capella concept | Capella metamodel | Treatment | In SysML v2 | Meaning | Rationale |
| --- | --- | --- | --- | --- | --- | --- |
| <a id="if-01"></a>IF-01 | Interface | `cs::Interface` | Library | `item def Interface :> ArcadiaElement`, used as `item x : Interface`, in the `Interfaces` package of an engineering perspective | A named group of exchange items that belong together, on which two components (or the system and its actors) agree in order to communicate: their communication contract | P3: needed by Arcadia. P6: one generic concept for all perspectives |
| <a id="if-02"></a>IF-02 | Exchange items of an interface | `cs::ExchangeItemAllocation`, owned by the interface (`cs::Interface.ownedExchangeItemAllocations`; derived: `exchangeItems`) | Library | `ref item exchangeItems: ExchangeItem [*]`, set with `ref item :>> exchangeItems = (...)` | The exchange items grouped by the interface | P3 |
| <a id="if-03"></a>IF-03 | Interface provided or required by a port | `information::Port.providedInterfaces`, `requiredInterfaces` | Library | see [CP-06](13-ComponentPort.md#cp-06) | The role of a component port for an interface: provider or consumer of its exchange items | P3 |
| <a id="if-04"></a>IF-04 | Realization of an interface | `cs::InterfaceAllocation` | Library | `Realization` (see [REAL-01](15-Realization.md#real-01)) | An interface realizes an interface of the previous engineering perspective | An interface is an `ArcadiaElement` usage: it is realized like any other element |
| <a id="if-05"></a>IF-05 | Interface implemented or used by a component, without port | `cs::InterfaceImplementation`, `cs::InterfaceUse` (`cs::Component.implementedInterfaces`, `usedInterfaces`) | Not translated – rarely used | none | A component implements or uses an interface directly | P4: in Arcadia an interface is allocated to a component port |
| <a id="if-06"></a>IF-06 | Send and receive protocols of an exchange item in an interface | `cs::ExchangeItemAllocation.sendProtocol`, `receiveProtocol` | Not translated – rarely used | none | Default protocol used by the sender and by the receiver of the exchange item (unicast, multicast, broadcast, synchronous, asynchronous, read, accept) | P4 |
| <a id="if-07"></a>IF-07 | Mechanism and structural flag of an interface | `cs::Interface.mechanism`, `structural` | Not translated – rarely used | none | Not documented in the Capella metamodel | P4 |

## Example

From [`examples/concepts/interface.sysml`](../../examples/concepts/interface.sysml), validated with the SysML v2 pilot implementation.

```
		// IF-01: an interface; IF-02: its exchange items
		item 'Optical Data' : Interface {
			ref item :>> exchangeItems = (rawOpticalDataX, rawOpticalDataY);
		}
		item 'Sensor Control' : Interface {
			ref item :>> exchangeItems = (sensorCommand);
		}
```

```
			part 'Optical Sensor Unit' : Component {
				port 'Cable Connector' : ComponentPort {
					out [0..*] : ExchangeItem = (rawOpticalDataX, rawOpticalDataY);
					in [0..*] : ExchangeItem = (sensorCommand);
					// CP-06: the port provides an interface and requires another one
					ref item :>> providedInterfaces = ('Optical Data');
					ref item :>> requiredInterfaces = ('Sensor Control');
				}
			}
			part 'Mouse Controller' : Component {
				port 'Cable Connector' : ComponentPort {
					in [0..*] : ExchangeItem = (rawOpticalDataX, rawOpticalDataY);
					out [0..*] : ExchangeItem = (sensorCommand);
					// CP-06: the same interfaces, with the opposite roles
					ref item :>> requiredInterfaces = ('Optical Data');
					ref item :>> providedInterfaces = ('Sensor Control');
				}
			}
```

## Decisions

- **Vocabulary.** In SysML v2, an `interface` is a connection between two ports: it corresponds to the Arcadia component exchange (see the CE section). The Arcadia interface is something else: a named set of exchange items. It is the `Interface` of this section.
- **An interface is a usage of a library definition**, like components, functions and exchange items. It has a name, a description, a status and property values, it can be realized ([IF-04](#if-04)) and it can be designated by other elements. It is a natural entry point to produce interface documents.
- **Roles.** A port provides or requires an interface ([IF-03](#if-03)). A port can have several interfaces, provided and required. The role is not deduced from the direction of the port: it is stated by the modeler. The direction of each exchange item on a port is given by the directed features of the port ([CP-02](13-ComponentPort.md#cp-02), [CP-03](13-ComponentPort.md#cp-03)).
- Not retained: an interface as a port definition, with the providing port typed by it and the requiring port typed by its conjugate (`~`). It is the usual SysML v2 pattern, but a port then has a single interface unless nested ports are used, modelers have to write definitions whereas the models built with the library are made of usages, and a definition cannot be realized with `Realization`, which links usages.
- Interfaces are placed in the `Interfaces` package of the engineering perspective (see [STRUCT-06](03-DefaultModelStructure.md#struct-06)).
- An interface is provided or required by a component port, as in Arcadia. Interfaces on physical ports, which would describe hardware interfaces, go beyond Arcadia: they are recorded with the open point on physical ports (see [OP-PHYS](../ArcadiaLibraryMapping.md#op-phys)).

## Tooling requirements

- Tooling displays the provided and required interfaces of a port, and the ports that provide or require an interface.
- Validation: the exchange items of the directed features of a port should belong to the interfaces of the port; the exchange items conveyed by a component exchange should belong to the interfaces of its two ports.
- Tooling can create or update interfaces from the exchange items of the functional exchanges allocated to the component exchanges, as Capella does.

## SysML v2 limitations

None.

## Open points

[OP-PHYS](../ArcadiaLibraryMapping.md#op-phys) (see the [open points register](../ArcadiaLibraryMapping.md#open-points-register)).
