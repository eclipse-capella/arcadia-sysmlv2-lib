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
// PKGM-01, PKGM-07: the top-level element of the model
occurrence def <MOUSE> 'Optical Mouse' {
	private import Arcadia::*;
	metadata ArcadiaPackage {
		engineeringPerspective = ArcadiaEngineeringPerspective::SystemEngineering;
	}

	// PKGM-01, PKGM-04: the package of an engineering perspective
	package <LA> 'Logical Architecture' {
		metadata ArcadiaPackage {
			engineeringPerspective = ArcadiaEngineeringPerspective::LogicalArchitecture;
		}
		// Not annotated: the perspective is given by the closest annotated package
		package Structure;
	}
}
