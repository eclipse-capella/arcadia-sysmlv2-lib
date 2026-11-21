/*
 * Copyright (c) 2026 OBEO
 * This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v2.0
 * which accompanies this distribution, and is available at
 * https://www.eclipse.org/legal/epl-2.0/
 *
 * SPDX-License-Identifier: EPL-2.0
 *
 * Contributors:
 *     Obeo and Thales Global Services - initial implementation
 */
package PhysicalConceptExample {
	private import Arcadia::*;

	// The root component of the Physical Architecture
	part system : Component {
		// Behavior Components and their component exchanges
		part 'Sensor Firmware' : BehaviorComponent {
			port 'Data Out' : ComponentPort { out [0..*] : ExchangeItem; }
			port 'Status Out' : ComponentPort { out [0..*] : ExchangeItem; }
		}
		part 'Board Monitor' : BehaviorComponent {
			port 'Status In' : ComponentPort { in [0..*] : ExchangeItem; }
		}
		part 'Controller Software' : BehaviorComponent {
			port 'Data In' : ComponentPort { in [0..*] : ExchangeItem; }
			port 'Report Out' : ComponentPort { out [0..*] : ExchangeItem; }
		}
		interface 'Sensor Status' : ComponentExchange connect 'Sensor Firmware'.'Status Out' to 'Board Monitor'.'Status In';
		interface 'Optical Data' : ComponentExchange connect 'Sensor Firmware'.'Data Out' to 'Controller Software'.'Data In';

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
	}

	// An actor of the Physical Architecture is a Node Component; its Behavior Component is deployed on it
	part 'Mouse Driver' : BehaviorComponent {
		port 'Report In' : ComponentPort { in [0..*] : ExchangeItem; }
	}
	part computer : NodeComponent {
		:>> isActor = true;
		allocation : Deployment allocate 'Mouse Driver' to self;
		port 'USB Port' : PhysicalPort;
	}
	interface 'Motion Report' : ComponentExchange connect system.'Controller Software'.'Report Out' to 'Mouse Driver'.'Report In';
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
}
