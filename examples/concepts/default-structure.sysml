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
// STRUCT-01: the top-level element of the model, with a name and a short name
occurrence def <MOUSE> 'Optical Mouse' {
	private import Arcadia::*;
	metadata ArcadiaPackage { engineeringPerspective = ArcadiaEngineeringPerspective::SystemEngineering; }

	// STRUCT-02: one package per engineering perspective (here two of the five)
	package <SA> 'System Analysis' {
		metadata ArcadiaPackage { engineeringPerspective = ArcadiaEngineeringPerspective::SystemAnalysis; }
		// STRUCT-03 to STRUCT-09: the same six packages in every perspective
		package Functions {
			// STRUCT-11: root function
			action 'Root Function' : Function;
		}
		package Capabilities;
		package Interfaces;
		package Data;
		package Structure {
			// STRUCT-12: root component
			part system : Component;
		}
		package Requirements;
	}

	package <LA> 'Logical Architecture' {
		metadata ArcadiaPackage { engineeringPerspective = ArcadiaEngineeringPerspective::LogicalArchitecture; }
		package Functions {
			action 'Root Function' : Function {
				// STRUCT-13: default realization of the root function of the previous perspective
				allocation : Realization allocate SA::Functions::'Root Function' to self;
			}
		}
		package Capabilities;
		package Interfaces;
		package Data;
		package Structure {
			part system : Component {
				// STRUCT-13: default realization of the root component of the previous perspective
				allocation : Realization allocate SA::Structure::system to self;
			}
		}
		package Requirements;
	}
}
