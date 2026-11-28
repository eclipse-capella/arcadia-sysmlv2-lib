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
package InterfaceConceptExample {
	private import Arcadia::*;

	package Data {
		item rawOpticalDataX : ExchangeItem;
		item rawOpticalDataY : ExchangeItem;
		item sensorCommand : ExchangeItem;
	}

	package Interfaces {
		private import Data::*;
		// IF-01: an interface; IF-02: its exchange items
		item 'Optical Data' : Interface {
			ref item :>> exchangeItems = (rawOpticalDataX, rawOpticalDataY);
		}
		item 'Sensor Control' : Interface {
			ref item :>> exchangeItems = (sensorCommand);
		}
	}

	package Structure {
		private import Data::*;
		private import Interfaces::*;
		part system : Component {
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
			interface cable : ComponentExchange
				connect 'Optical Sensor Unit'.'Cable Connector' to 'Mouse Controller'.'Cable Connector';
		}
	}
}
