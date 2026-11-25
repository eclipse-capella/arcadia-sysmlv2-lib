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
    private doc /* Version 0.1.0 */
    private import ScalarValues::Boolean;
    private import ScalarValues::String;
	private import KerML::FeatureDirectionKind;
	private import StandardViewDefinitions::*;

	abstract occurrence def ArcadiaElement {
    	private doc /* Reusable structure shared by all Arcadia elements.*/
    }

    metadata def ArcadiaPackage {
		private doc /* Used to annotate the top-level element of an Arcadia model and its engineering perspective packages (OA, SA, LA, PA, EPBS) */
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
       	enum EPBS = "EPBS Architecture";
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

	part def NodeComponent :> Component {
		private doc /* A Physical Architecture component of Node nature: a physical platform that hosts deployed components,
		 * Behavior Components or Node Components (see Deployment). An actor of the Physical Architecture is a Node Component or a Behavior Component. */
	}

	part def BehaviorComponent :> Component {
		private doc /* A Physical Architecture component of Behavior nature: it carries allocated functions and component exchanges,
		 * and is deployed on a Node Component, not contained in it (see Deployment). This also applies to the actors of the Physical Architecture that are Behavior Components. */
	}

	allocation def Deployment :> ArcadiaElement {
		private doc /* A generic Arcadia Deployment, used in the Physical Architecture: a component (deployedElement) is deployed on
		 * another component (location), instead of being contained in it. Typically a Behavior Component or a Node Component
		 * is deployed on a Node Component.
		 * A Deployment is stored in the location component, and is written
		 * 'allocation : Deployment allocate <deployed component> to self;'. */
		end deployedElement : Component;
		end location : Component;
	}

    port def ComponentPort :> ArcadiaElement {
		private doc /* A generic Arcadia Component Port, used across all Arcadia engineering perspectives. */
        attribute portDirection : FeatureDirectionKind;
		ref item allocatedFunctionPorts: ExchangeItem [*];
    }

    interface def ComponentExchange :> ArcadiaElement {
    	private doc /* A generic Component Exchange, used across all Arcadia engineering perspectives.
    	 * Functional Exchanges are allocated to a Component Exchange with ExchangeAllocation usages
    	 * (see ExchangeAllocation); the list of allocated Functional Exchanges is derived by tooling. */
        end cp1 : ComponentPort;
        end cp2 : ComponentPort;
        ref item allocatedExchangeItems: ExchangeItem[*];
    }

	action def Function :> ArcadiaElement {
	    private doc /* A  generic Arcadia Function, used across all Arcadia engineering perspectives. */
    }

    action def FunctionalChain :> ArcadiaElement  {
        private doc /*  A  generic Arcadia Functional Chain, used across all Arcadia engineering perspectives. */
        ref involvedFunctionalExchanges: FunctionalExchange[*];
        perform action involvedFunctions: Function[*];
        perform action referencedFunctionalChains: FunctionalChain[*];
    }

	flow def FunctionalExchange :> ArcadiaElement{
	    private doc /* A generic Arcadia Functional Exchange, used across all Arcadia engineering perspectives. */
		ref item :>> payload : ExchangeItem [*];
		end source : Function;
		end target : Function;
	}

    allocation def ExchangeAllocation :> ArcadiaElement {
	    private doc /* A generic Arcadia Exchange Allocation, used across all Arcadia engineering perspectives.
	     * An Exchange Allocation is owned by the Component Exchange it allocates to, and is written
	     * 'allocation : ExchangeAllocation allocate <functional exchange> to self;'. */
        end functionalExchange : FunctionalExchange;
        end componentExchange : ComponentExchange;
    }

    allocation def Realization :> ArcadiaElement {
	    private doc /* A generic Arcadia Realization, used across all Arcadia engineering perspectives and for all kinds of
	     * Arcadia elements: an element (realizing) realizes an element of the previous engineering perspective (realized).
	     * A Realization is owned by the realizing element, and is written
	     * 'allocation : Realization allocate <realized element> to self;'.
	     * The 'realizes' and 'is realized by' navigations are derived by tooling and are not stored. */
        end realized : ArcadiaElement;
        end realizing : ArcadiaElement;
    }

	item def ExchangeItem :> ArcadiaElement{
		private doc /* A generic Arcadia ExchangeItem, used across all Arcadia engineering perspectives. */
	}

	occurrence def Capability :> ArcadiaElement {
	    private doc /* A generic Arcadia Capability, used across all Arcadia engineering perspectives. */
		ref action involvedFunctions: Function[*];
		ref action involvedFunctionalChains: FunctionalChain[*];
		ref part involvedComponents: Component[*];
	}

 	occurrence def Mission :> ArcadiaElement {
	    private doc /* A generic Arcadia Mission, used across all Arcadia engineering perspectives. */
		ref part involvedComponents: Component[*];
		ref occurrence exploitedCapabilities: Capability[*];
	}

	// Arcadia view definitions: one view definition per Capella diagram kind. The name is the diagram name displayed
	// in Capella, the short name is the Capella acronym. Each one specializes the closest standard view definition,
	// so that a tool which does not know Arcadia still sees a standard view. An Arcadia diagram is represented by a view
	// usage typed by one of them: view 'My diagram name' : LAB { expose ...; }
	// Not included: "Modes and States" (deprecated in Capella).
	// Operational Analysis
	view def <OEBD> 'Operational Entity Breakdown' :> GeneralView;
	view def <OAIB> 'Operational Activity Interaction Blank' :> ActionFlowView;
	view def <OAB> 'Operational Architecture Blank' :> InterconnectionView;
	view def <OABD> 'Operational Activity Breakdown' :> GeneralView;
	view def <ORB> 'Operational Role Blank' :> GeneralView;
	view def <OES> 'Entity Scenario' :> SequenceView;
	view def <OAS> 'Activity Scenario' :> SequenceView;
	view def <OPD> 'Operational Process Description' :> ActionFlowView;
	view def <OCB> 'Operational Capabilities Blank' :> GeneralView;
	view def <COC> 'Contextual Operational Capability' :> GeneralView;

	// System Analysis
	view def <CM> 'Contextual Mission' :> GeneralView;
	view def <MB> 'Missions Blank' :> GeneralView;
	view def <CC> 'Contextual Capability' :> GeneralView;
	view def <MCB> 'Missions Capabilities Blank' :> GeneralView;
	view def <SFBD> 'System Function Breakdown' :> GeneralView;
	view def <SDFB> 'System Data Flow Blank' :> ActionFlowView;
	view def <SAB> 'System Architecture Blank' :> InterconnectionView;
	view def <CSA> 'Contextual System Actors' :> GeneralView;

	// Logical Architecture
	view def <LCBD> 'Logical Component Breakdown' :> GeneralView;
	view def <LFBD> 'Logical Function Breakdown' :> GeneralView;
	view def <LDFB> 'Logical Data Flow Blank' :> ActionFlowView;
	view def <LAB> 'Logical Architecture Blank' :> InterconnectionView;
	view def <CRR> 'Capability Realization Refinement' :> GeneralView;

	// Physical Architecture
	view def <PFBD> 'Physical Function Breakdown' :> GeneralView;
	view def <PDFB> 'Physical Data Flow Blank' :> ActionFlowView;
	view def <PCBD> 'Physical Component Breakdown' :> GeneralView;
	view def <PAB> 'Physical Architecture Blank' :> InterconnectionView;
	view def <PPD> 'Physical Path Description' :> InterconnectionView;

	// EPBS
	view def <EAB> 'EPBS Architecture Blank' :> InterconnectionView;
	view def <CIBD> 'Configuration Items Breakdown' :> GeneralView;

	// Common to several perspectives
	view def <MSM> 'Mode State Machine' :> StateTransitionView;
	view def <CDB> 'Class Diagram Blank' :> GeneralView;
	view def <CA> 'Capella Architecture' :> GeneralView;
	view def <IDB> 'Interfaces Diagram Blank' :> GeneralView;
	view def <ID> 'Interface Diagram' :> GeneralView;
	view def <CDI> 'Contextual Component Detailed Interfaces' :> GeneralView;
	view def <CEI> 'Contextual Component External Interfaces' :> GeneralView;
	view def <CII> 'Contextual Component Internal Interfaces' :> GeneralView;
	view def <CRB> 'Capability Realization Blank' :> GeneralView;
	view def <CRI> 'Contextual Capability Realization Involvement' :> GeneralView;
	view def <PD> 'Package Dependencies' :> GeneralView;
	view def <IS> 'Interface Scenario' :> SequenceView;
	view def <ES> 'Exchange Scenario' :> SequenceView;
	view def <FS> 'Function Scenario' :> SequenceView;
	view def <FCD> 'Functional Chain Description' :> ActionFlowView;

	// Matrices (the Capella cross tables): a single view definition for all of them, without short name (Capella gives none)
	view def 'Matrix' :> GridView;

}
