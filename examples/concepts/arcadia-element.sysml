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
package ArcadiaElementConceptExample {
	private import Arcadia::*;
	private import SI::kg;
	private import ModelingMetadata::*;

	// ELEM-01: every Arcadia element specializes ArcadiaElement (here through Component)
	// ELEM-02: name
	part 'Optical Sensor Unit' : Component {
		// ELEM-03: description
		doc description /*Captures surface movement using optical detection.*/
		// ELEM-07: progress status
		@StatusInfo {status = StatusKind::tbd;}
		// ELEM-09: property value
		attribute 'Mass' = 0.4 [kg];
	}
}
