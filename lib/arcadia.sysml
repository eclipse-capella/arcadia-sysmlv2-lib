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

library package Arcadia {
    private import ScalarValues::Boolean;
    private import ScalarValues::String;
    private import Flows::MessageAction;
	private import KerML::FeatureDirectionKind;
	private import KerML::Feature;
	private import ModelingMetadata::*;

	abstract occurrence def ArcadiaElement {
    	private doc /* Reusable structure shared by all Arcadia elements.*/
		ref occurrence realizes : ArcadiaElement[*];
		ref occurrence isRealizedBy : ArcadiaElement[*];
    }

    metadata def ArcadiaPackage {
		private doc /* Used to annotate Packages elements in an Arcadia model */
		:> annotatedElement : SysML::Package;
		:> annotatedElement : SysML::OccurrenceDefinition;
		enum engineeringPerspective : ArcadiaEngineeringPerspective;
     }

	enum def ArcadiaEngineeringPerspective :> String {
    	private doc /* flag to indicate which engineering perspective you're in.*/
       	enum OperationalAnalysis = "Operational Analysis";
       	enum SystemAnalysis = "System Analysis";
       	enum LogicalArchitecture = "Logical Architecture";
       	enum PhysicalArchitecture = "Physical Architecture";
       	enum EPBS = "EPBS Physical Architecture";
      	enum Generic = "Generic";
       	enum SystemEngineering = "System Engineering";
  	}

	part def Component :> ArcadiaElement {
		private doc /* A generic Arcadia component, used across all Arcadia engineering perspectives. */
    	attribute isActor : Boolean default false;
    	attribute isHuman : Boolean default false;
    	alias allocatedFunctions for performedActions;
		alias subComponents for subparts;
	}

    port def ComponentPort :> ArcadiaElement {
		private doc /* A  generic Arcadia Component Port, used across all Arcadia engineering perspectives. */
        attribute portDirection : FeatureDirectionKind;
		ref item allocatedFunctionPorts: ExchangeItem [*];
    }

    interface def ComponentExchange :> ArcadiaElement {
    	private doc /* A  generic Component Exchange, used across all Arcadia engineering perspectives.*/
        end cp1 : ComponentPort;
        end cp2 : ComponentPort;
        ref item allocatedExchangeItems: ExchangeItem[*];
        ref flow allocatedFunctionalExchanges: FunctionalExchange[*];
    }

	action def Function :> ArcadiaElement {
	    private doc /* A  generic Arcadia Function, used across all Arcadia engineering perspectives. */
        alias subFunctions for subactions;
    }

    action def FunctionalChain :> ArcadiaElement  {
        private doc /*  A  generic Arcadia Functional Chain, used across all Arcadia engineering perspectives. */
        ref flow involvedFunctionalExchanges: FunctionalExchange[*];
        alias involvedFunctions for subactions;
    }

	flow def FunctionalExchange :> ArcadiaElement{
	    private doc /* A  generic Arcadia Functional Exchange, used across all Arcadia engineering perspectives. */
		ref item :> payload : ExchangeItem [*];
		end source : Function;
		end target : Function;
	}

    allocation def ExchangeAllocation :> ArcadiaElement {
	    private doc /* A  generic Arcadia Exchange Allocation, used across all Arcadia engineering perspectives. */
        end functionalExchange : FunctionalExchange;
        end componentExchange : ComponentExchange;
    }

	item def ExchangeItem :> ArcadiaElement{
		private doc /* A  generic Arcadia ExchangeItem, used across all Arcadia engineering perspectives. */
	}

	requirement def ArcadiaRequirement :> ArcadiaElement{
    	private doc /* A  generic Requirement, used across all Arcadia engineering perspectives.*/
	}

	occurrence def Capability :> ArcadiaElement {
	    private doc /* A  generic Arcadia Capability, used across all Arcadia engineering perspectives. */
		ref action involvedFunctions: Function[*];
		ref action involvedFunctionalChains: FunctionalChain[*];
		ref part involvedComponents: Component[*];
	}

 	occurrence def Mission :> ArcadiaElement {
	    private doc /* A  generic Arcadia Mission, used across all Arcadia engineering perspectives. */
		ref part involvedComponents: Component[*];
		ref occurrence exploitedCapabilities: Capability[*];
	}

}
