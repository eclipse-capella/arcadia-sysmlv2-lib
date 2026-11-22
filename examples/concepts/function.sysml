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
package FunctionConceptExample {
	private import Arcadia::*;

	package Data {
		item rawOpticalData : ExchangeItem;
	}

	package Functions {
		private import Data::*;
		// FUNC-01: a function
		action 'Root Function' : Function {
			// FUNC-02: sub-functions are nested action usages typed by Function
			action 'Capture Movement' : Function {
				// FPORT-02: an output port named FOP1; FPORT-03: it carries rawOpticalData
				out FOP1 [0..*] : ExchangeItem = (rawOpticalData);
			}
			action 'Transform Raw Optical Data' : Function {
				// FPORT-01: an input port named FIP1
				in FIP1 [0..*] : ExchangeItem = (rawOpticalData);
			}
			// FUNC-03: a routing function is a function typed by one of the five routing definitions
			action 'Duplicate Raw Optical Data' : DuplicateFunction {
				in FIP1 [0..*] : ExchangeItem = (rawOpticalData);
				out FOP1 [0..*] : ExchangeItem = (rawOpticalData);
				out FOP2 [0..*] : ExchangeItem = (rawOpticalData);
			}
		}
	}
}
