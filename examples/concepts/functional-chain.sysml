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
package FunctionalChainConceptExample {
	private import Arcadia::*;
	private import ScalarValues::Boolean;

	package Functions {
		action 'Root Function' : Function {
			action 'Capture Movement' : Function { out FOP1 [0..*] : ExchangeItem; }
			action 'Transform Raw Optical Data' : Function { in FIP2 [0..*] : ExchangeItem; out FOP3 [0..*] : ExchangeItem; }
			action 'Update Pointer Position' : Function { in FIP4 [0..*] : ExchangeItem; }

			flow 'Optical Data' : FunctionalExchange from 'Capture Movement'.FOP1 to 'Transform Raw Optical Data'.FIP2;
			flow 'Motion Data' : FunctionalExchange from 'Transform Raw Optical Data'.FOP3 to 'Update Pointer Position'.FIP4;

			// FC-01: a functional chain, owned by a function
			action 'read movement' : FunctionalChain {
				// FC-03: involved functional exchanges
				ref :>> involvedFunctionalExchanges = ('Optical Data');
				// FC-02: involved functions
				perform 'Root Function'.'Capture Movement' :> involvedFunctions;
				perform 'Root Function'.'Transform Raw Optical Data' :> involvedFunctions;
				// FC-05: sequence of the chain
				succession first start then 'Root Function'.'Capture Movement';
				succession first 'Root Function'.'Capture Movement' then 'Root Function'.'Transform Raw Optical Data';
				succession first 'Root Function'.'Transform Raw Optical Data' then done;
			}

			// FC-04: a composite chain references another chain
			action 'move pointer' : FunctionalChain {
				ref :>> involvedFunctionalExchanges = ('Motion Data');
				perform 'Root Function'.'read movement' :> referencedFunctionalChains;
				perform 'Root Function'.'Update Pointer Position' :> involvedFunctions;
				succession first start then 'Root Function'.'read movement';
				// a link that ends on a function inside the referenced chain
				succession first 'Root Function'.'read movement'.'Transform Raw Optical Data' then 'Root Function'.'Update Pointer Position';
				succession first 'Root Function'.'Update Pointer Position' then done;
			}

			// FC-05: a control node OR, with a condition on each branch
			action 'handle movement' : FunctionalChain {
				attribute isMoving : Boolean;
				perform 'Root Function'.'Capture Movement' :> involvedFunctions;
				perform action transform references 'Root Function'.'Transform Raw Optical Data' :> involvedFunctions;
				succession first start then 'Root Function'.'Capture Movement';
				succession first 'Root Function'.'Capture Movement' then moving;
				decide moving;
					if isMoving then transform;
					if not isMoving then done;
				succession first transform then done;
			}

			// FC-01: an empty chain
			action 'stop movement' : FunctionalChain;
		}
	}
}
