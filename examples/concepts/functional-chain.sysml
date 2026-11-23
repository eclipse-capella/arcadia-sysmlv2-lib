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

	package Data {
		item rawOpticalDataX : ExchangeItem;
		item rawOpticalDataY : ExchangeItem;
	}

	package Functions {
		private import Data::*;
		action 'Root Function' : Function {
			action 'Capture Movement' : Function { out FOP1 [0..*] : ExchangeItem = (rawOpticalDataX, rawOpticalDataY); in FIP6 [0..*] : ExchangeItem; }
			action 'Transform Raw Optical Data' : Function { in FIP2 [0..*] : ExchangeItem = (rawOpticalDataX, rawOpticalDataY); out FOP3 [0..*] : ExchangeItem; }
			action 'Update Pointer Position' : Function { in FIP4 [0..*] : ExchangeItem; out FOP5 [0..*] : ExchangeItem; }
			action 'Log Movement' : Function;
			action 'Check Surface' : Function;

			flow 'Optical Data' : FunctionalExchange of :>> payload = (rawOpticalDataX, rawOpticalDataY)
				from 'Capture Movement'.FOP1 to 'Transform Raw Optical Data'.FIP2;
			flow 'Motion Data' : FunctionalExchange from 'Transform Raw Optical Data'.FOP3 to 'Update Pointer Position'.FIP4;
			flow 'Sensitivity Setting' : FunctionalExchange from 'Update Pointer Position'.FOP5 to 'Capture Movement'.FIP6;

			// FC-01: a functional chain, owned by a function
			action 'read movement' : FunctionalChain {
				// FC-02: involved functions, one named reference for each
				perform action 'Capture Movement' references 'Root Function'.'Capture Movement' :> involvedFunctions;
				perform action 'Transform Raw Optical Data' references 'Root Function'.'Transform Raw Optical Data' :> involvedFunctions;
				// FC-03: an involved functional exchange, between two references
				flow :> 'Optical Data', involvedFunctionalExchanges from 'Capture Movement'.FOP1 to 'Transform Raw Optical Data'.FIP2;
			}

			// FC-02: a function referenced twice (the chain starts from it and comes back to it)
			action 'adjust sensitivity' : FunctionalChain {
				perform action 'Capture Movement 1' references 'Root Function'.'Capture Movement' :> involvedFunctions;
				perform action 'Transform Raw Optical Data' references 'Root Function'.'Transform Raw Optical Data' :> involvedFunctions;
				perform action 'Update Pointer Position' references 'Root Function'.'Update Pointer Position' :> involvedFunctions;
				perform action 'Capture Movement 2' references 'Root Function'.'Capture Movement' :> involvedFunctions;
				flow :> 'Optical Data', involvedFunctionalExchanges from 'Capture Movement 1'.FOP1 to 'Transform Raw Optical Data'.FIP2;
				flow :> 'Motion Data', involvedFunctionalExchanges from 'Transform Raw Optical Data'.FOP3 to 'Update Pointer Position'.FIP4;
				flow :> 'Sensitivity Setting', involvedFunctionalExchanges from 'Update Pointer Position'.FOP5 to 'Capture Movement 2'.FIP6;
			}

			// FC-04: a composite chain references another chain
			action 'move pointer' : FunctionalChain {
				perform action 'read movement' references 'Root Function'.'read movement' :> referencedFunctionalChains;
				perform action 'Update Pointer Position' references 'Root Function'.'Update Pointer Position' :> involvedFunctions;
				// a link that starts from a function inside the referenced chain
				flow :> 'Motion Data', involvedFunctionalExchanges from 'read movement'.'Transform Raw Optical Data'.FOP3 to 'Update Pointer Position'.FIP4;
			}

			action 'compute pointer' : FunctionalChain {
				perform action 'Transform Raw Optical Data' references 'Root Function'.'Transform Raw Optical Data' :> involvedFunctions;
				perform action 'Update Pointer Position' references 'Root Function'.'Update Pointer Position' :> involvedFunctions;
				flow :> 'Motion Data', involvedFunctionalExchanges from 'Transform Raw Optical Data'.FOP3 to 'Update Pointer Position'.FIP4;
			}

			// FC-11: two referenced chains joined by a function that belongs to both
			action 'read and compute' : FunctionalChain {
				perform action 'read movement' references 'Root Function'.'read movement' :> referencedFunctionalChains;
				perform action 'compute pointer' references 'Root Function'.'compute pointer' :> referencedFunctionalChains;
				bind 'read movement'.'Transform Raw Optical Data' = 'compute pointer'.'Transform Raw Optical Data';
			}

			// FC-05: a sequence link, between two functions that no exchange links
			action 'move and log' : FunctionalChain {
				perform action 'Update Pointer Position' references 'Root Function'.'Update Pointer Position' :> involvedFunctions;
				perform action 'Log Movement' references 'Root Function'.'Log Movement' :> involvedFunctions;
				succession first 'Update Pointer Position' then 'Log Movement';
			}

			// FC-12: a control node OR, with a condition on each sequence link that leaves it
			action 'handle movement' : FunctionalChain {
				attribute isMoving : Boolean;
				perform action 'Capture Movement' references 'Root Function'.'Capture Movement' :> involvedFunctions;
				perform action 'Transform Raw Optical Data' references 'Root Function'.'Transform Raw Optical Data' :> involvedFunctions;
				perform action 'Log Movement' references 'Root Function'.'Log Movement' :> involvedFunctions;
				succession first 'Capture Movement' then moving;
				decide moving;
					if isMoving then 'Transform Raw Optical Data';
					if not isMoving then 'Log Movement';
			}

			// FC-12: a control node AND
			action 'check and capture' : FunctionalChain {
				perform action 'Check Surface' references 'Root Function'.'Check Surface' :> involvedFunctions;
				perform action 'Capture Movement' references 'Root Function'.'Capture Movement' :> involvedFunctions;
				perform action 'Log Movement' references 'Root Function'.'Log Movement' :> involvedFunctions;
				fork split;
					then 'Check Surface';
					then 'Capture Movement';
				succession first 'Check Surface' then gather;
				succession first 'Capture Movement' then gather;
				join gather;
				succession first gather then 'Log Movement';
			}

			// FC-12: a control node ITERATE
			action 'capture repeatedly' : FunctionalChain {
				perform action 'Check Surface' references 'Root Function'.'Check Surface' :> involvedFunctions;
				perform action 'Log Movement' references 'Root Function'.'Log Movement' :> involvedFunctions;
				action iteration loop {
					perform action 'Capture Movement' references 'Root Function'.'Capture Movement' :> involvedFunctions;
				}
				succession first 'Check Surface' then iteration;
				succession first iteration then 'Log Movement';
			}

			// FC-08, FC-13: what the chain expects from an exchange
			action 'read horizontal movement' : FunctionalChain {
				attribute isMoving : Boolean;
				perform action 'Capture Movement' references 'Root Function'.'Capture Movement' :> involvedFunctions;
				perform action 'Transform Raw Optical Data' references 'Root Function'.'Transform Raw Optical Data' :> involvedFunctions;
				flow :> 'Optical Data', involvedFunctionalExchanges from 'Capture Movement'.FOP1 to 'Transform Raw Optical Data'.FIP2 {
					// FC-13: among the exchange items of the exchange, the link only carries this one
					ref item exchangedItems :> payload = (rawOpticalDataX);
					// FC-08: exchange context
					assert constraint 'exchange context' { isMoving }
				}
			}

			// FC-01: an empty chain
			action 'stop movement' : FunctionalChain;
		}
	}
}
