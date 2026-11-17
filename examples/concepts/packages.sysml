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
package PackagesConceptExample {
	private import Arcadia::*;

	package Functions {
		action 'Root Function' : Function {
			// PKG-01: a function package owned by a function
			package 'Motion Filtering' {
				action 'Filter Noise' : Function;
			}
		}
		// PKG-01: a function package owned by a package
		package 'Power Management' {
			action 'Manage Power' : Function;
		}
	}

	package Data {
		// PKG-04: a data package
		package 'Status Data' {
			item batteryLevel : ExchangeItem;
		}
	}

	package Structure {
		// PKG-05: a component package owned by a package
		package 'External Actors' {
			part technician : Component { :>> isActor = true; }
		}
		part system : Component {
			part 'Mouse Controller' : Component {
				// PKG-05: a component package owned by a component
				package 'Mechanical Parts' {
					part 'Mouse Casing' : Component;
				}
			}
		}
	}
}
