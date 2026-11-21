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
occurrence def <MOUSE> 'Optical Mouse' {
	private import Arcadia::*;
	package <SA> 'System Analysis' {
		package Functions {
			action 'Root Function' : Function {
				action 'Capture Movement' : Function { out FOP1 [0..*] : ExchangeItem; }
				action 'Transform Raw Optical Data' : Function { in FIP2 [0..*] : ExchangeItem; }
				flow 'Optical Data' : FunctionalExchange from 'Capture Movement'.FOP1 to 'Transform Raw Optical Data'.FIP2;
				// a chain owned by a function
				action 'diagnostic chain' : FunctionalChain;
			}
		}
		package Structure {
			part system : Component {
				part 'Optical Sensor Unit' : Component;
				part 'Mouse Controller' : Component;
			}
			part computerUser : Component { :>> isActor = true; }
		}
		package Capabilities {
			private import Functions::*;
			private import Structure::*;
			occurrence 'Detect Movement' : Capability;
			// CAP-01: a capability
			occurrence 'Move Cursor on Screen' : Capability {
				// CAP-02: involved functions
				ref action :>> involvedFunctions = ('Root Function'.'Capture Movement', 'Root Function'.'Transform Raw Optical Data');
				// CAP-04: involved components
				ref part :>> involvedComponents = (system.'Optical Sensor Unit', system.'Mouse Controller');
				// CAP-03: a chain owned by the capability is involved by construction
				action 'read movement' : FunctionalChain {
					ref :>> involvedFunctionalExchanges = ('Root Function'.'Optical Data');
					perform 'Root Function'.'Capture Movement' :> involvedFunctions;
					perform 'Root Function'.'Transform Raw Optical Data' :> involvedFunctions;
				}
				// CAP-03: a chain owned elsewhere is referenced
				ref action :>> involvedFunctionalChains = ('Root Function'.'diagnostic chain');
				// CAP-07: included capabilities
				ref occurrence :>> includedCapabilities = ('Detect Movement');
			}
			// MIS-01: a mission
			occurrence 'Provide Interface to User' : Mission {
				// MIS-02: exploited capabilities
				ref occurrence :>> exploitedCapabilities = ('Move Cursor on Screen');
				// MIS-03: involved components
				ref part :>> involvedComponents = (computerUser);
				// MIS-04: a sub-mission
				occurrence 'Provide Pointing Interface' : Mission;
			}
		}
	}
}
