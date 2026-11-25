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
package NodeBehaviorConceptExample {
	private import Arcadia::*;

	action 'Root Function' : Function {
		action 'Filter Noise' : Function;
	}

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
}
