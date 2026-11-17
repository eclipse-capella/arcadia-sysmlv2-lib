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
package ComponentConceptExample {
	private import Arcadia::*;

	action 'Root Function' : Function {
		action 'Capture Movement' : Function;
		action 'Use Mouse' : Function;
	}

	// COMP-01, COMP-02, COMP-03: a human actor
	part computerUser : Component {
		:>> isActor = true;
		:>> isHuman = true;
		// COMP-08: allocated function
		perform 'Root Function'.'Use Mouse';
	}

	part system : Component {
		// COMP-09: sub-component (one level)
		part 'Optical Sensor Unit' : Component {
			perform 'Root Function'.'Capture Movement';
		}
	}
}
