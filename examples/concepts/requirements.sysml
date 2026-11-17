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
	private import ModelingMetadata::*;
	private import RequirementDerivation::*;

	package <SA> 'System Analysis' {
		package Requirements {
			// REQ-01, REQ-02, REQ-03: a requirement with its identifier and its statement
			requirement <'SR1'> 'Cursor Control' {
				doc /* The system shall move the cursor according to the movement of the mouse */
			}
		}
	}

	package <LA> 'Logical Architecture' {
		package Requirements {
			requirement <'R1'> 'Movement Capture' {
				doc /* The mouse shall capture its movement */
				// REQ-05: nesting only organizes the requirements
				requirement <'R1.1'> Optical {
					doc /* The mouse shall capture movement using optical detection */
					// REQ-04: status
					@StatusInfo {status = StatusKind::tbd;}
				}
			}
			// REQ-07: a derived requirement and the original one
			#derivation connection {
				end #original ::> SA::Requirements::'Cursor Control';
				end #derive ::> 'Movement Capture';
			}
		}
		package Structure {
			part system : Component {
				part 'Optical Sensor Unit' : Component {
					// REQ-06: the component satisfies a requirement
					satisfy Requirements::'Movement Capture'.Optical;
				}
			}
		}
	}
}
