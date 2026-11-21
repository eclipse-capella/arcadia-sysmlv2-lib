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
package ExchangesConceptExample {
	private import Arcadia::*;

	package Data {
		item rawOpticalDataX : ExchangeItem;
		item rawOpticalDataY : ExchangeItem;
	}

	package Functions {
		private import Data::*;
		action 'Root Function' : Function {
			action 'Capture Movement' : Function {
				out FOP1 [0..*] : ExchangeItem = (rawOpticalDataX, rawOpticalDataY);
			}
			action 'Transform Raw Optical Data' : Function {
				in FIP2 [0..*] : ExchangeItem = (rawOpticalDataX, rawOpticalDataY);
			}
			// FE-01: a functional exchange between two function ports (FE-03, FE-04)
			// FE-02: the exchange items it carries
			flow 'Optical Data' : FunctionalExchange of :>> payload = (rawOpticalDataX, rawOpticalDataY)
				from 'Capture Movement'.FOP1 to 'Transform Raw Optical Data'.FIP2;
		}
	}

	package Structure {
		private import Functions::*;
		private import Data::*;
		part system : Component {
			part 'Optical Sensor Unit' : Component {
				// CP-01: a component port
				port 'Cable Connector' : ComponentPort {
					// CP-02: an output port; CP-03: the exchange items that go through the port
					out [0..*] : ExchangeItem = (rawOpticalDataX, rawOpticalDataY);
				}
				part 'Image Sensor' : Component {
					perform 'Root Function'.'Capture Movement';
					port 'Sensor Output' : ComponentPort {
						out [0..*] : ExchangeItem = (rawOpticalDataX, rawOpticalDataY);
						// CP-04: function ports allocated to the component port
						ref item :>> allocatedFunctionPorts = ('Root Function'.'Capture Movement'.FOP1);
					}
				}
				// CE-08: the port of the component is delegated to a port of its sub-component
				bind 'Cable Connector' = 'Image Sensor'.'Sensor Output';
			}
			part 'Mouse Controller' : Component {
				perform 'Root Function'.'Transform Raw Optical Data';
				// CP-02: an input port
				port 'Cable Connector' : ComponentPort {
					in [0..*] : ExchangeItem = (rawOpticalDataX, rawOpticalDataY);
					ref item :>> allocatedFunctionPorts = ('Root Function'.'Transform Raw Optical Data'.FIP2);
				}
				// CP-02: an output port that carries no exchange item yet
				port 'Status Output' : ComponentPort {
					out [0..*] : ExchangeItem;
				}
				// CP-02: a bidirectional port
				port 'Debug Link' : ComponentPort {
					in [0..*] : ExchangeItem;
					out [0..*] : ExchangeItem;
				}
			}
			// CE-01: a component exchange between two component ports (CE-02, CE-03)
			interface cable : ComponentExchange
				connect 'Optical Sensor Unit'.'Cable Connector' to 'Mouse Controller'.'Cable Connector' {
				// CE-04: exchange items conveyed by the component exchange
				ref item :>> allocatedExchangeItems = (rawOpticalDataX, rawOpticalDataY);
				// EA-01: the functional exchange allocated to the component exchange
				allocation : ExchangeAllocation allocate 'Root Function'.'Optical Data' to self;
			}
		}
	}
}
