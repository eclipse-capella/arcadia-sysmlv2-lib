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
package ViewsConceptExample {
	private import Arcadia::*;

	action 'Root Function' : Function {
		action 'Capture Movement' : Function;
		action 'Transform Raw Optical Data' : Function;
		// VIEW-01 to VIEW-06: a Logical Data Flow Blank diagram (kind LDFB), attached to a function and owned by it
		view 'Optical Data Flow' : LDFB {
			expose 'Capture Movement';
			expose 'Transform Raw Optical Data';
		}
	}

	part system : Component {
		part 'Optical Sensor Unit' : Component;
		part 'Mouse Controller' : Component;
		// A Logical Architecture Blank diagram (kind LAB), attached to a component and owned by it
		view 'Mouse Logical Architecture' : LAB {
			expose 'Optical Sensor Unit';
			expose 'Mouse Controller';
		}
	}

	// A Logical Function Breakdown diagram (kind LFBD), attached to a package and owned by it
	view 'Logical Functions' : LFBD {
		expose 'Root Function';
	}

	// VIEW-09: a Capella matrix (for example the allocation of functions to components), attached to a package and owned by it
	view 'Components and Functions' : Matrix {
		expose system;
		expose 'Root Function';
	}
}
