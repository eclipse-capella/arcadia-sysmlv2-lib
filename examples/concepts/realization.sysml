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
				action 'Move Cursor' : Function;
			}
		}
		package Structure {
			part system : Component;
		}
	}

	package <LA> 'Logical Architecture' {
		package Functions {
			action 'Root Function' : Function {
				// REAL-01 to REAL-03: a logical function realizes a system function
				action 'Capture Movement' : Function {
					allocation : Realization allocate SA::Functions::'Root Function'.'Move Cursor' to self;
				}
				// A system function can be realized by several logical functions
				action 'Transform Raw Optical Data' : Function {
					allocation : Realization allocate SA::Functions::'Root Function'.'Move Cursor' to self;
				}
			}
		}
		package Structure {
			// REAL-01: the same allocation for a component
			part system : Component {
				allocation : Realization allocate SA::Structure::system to self;
			}
		}
	}
}
