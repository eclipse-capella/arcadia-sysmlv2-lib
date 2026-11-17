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
package PropertyValuesConceptExample {
	private import Arcadia::*;
	private import ScalarValues::Integer;
	private import SI::kg;
	private import SI::W;
	part 'Optical Sensor Unit' : Component {
		// PV-01: a property value
		attribute 'Safety Class' : Integer = 2;
		// PV-02: a physical quantity, with its unit; PV-04: its description
		attribute 'Mass' = 0.4 [kg] {
			doc description /*Mass of the module without cable.*/
		}
		// PV-03: a property value group
		attribute 'Budget' {
			attribute 'Power' = 2.5 [W];
		}
	}
}
