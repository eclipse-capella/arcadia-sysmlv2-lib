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
occurrence def <SE> OpticalMouseModel {
	metadata ArcadiaPackage {engineeringPerspective = ArcadiaEngineeringPerspective::SystemEngineering;}
    private import Arcadia::*;
    private import ScalarValues::Boolean;
	private import ModelingMetadata::*;
	private import KerML::FeatureDirectionKind;

	package <OA> 'Operational Analysis' {
		metadata ArcadiaPackage {engineeringPerspective = ArcadiaEngineeringPerspective::OperationalAnalysis;}
		doc /* Defines the operational view of the system context and stakeholder needs.
		Captures missions, actors, and activities without technical constraints.
		Serves as the foundation for deriving system-level requirements. */
		package Functions {
			private import Data::*;
			action 'Root Function' : Function;
		}
		package Capabilities;
		package Interfaces;
		package Data;
		package Structure {
			private import Data::*;
			private import Functions::*;
			part system : Component;
		}
		package Requirements;
	}

	package <SA> 'System Analysis' {
		metadata ArcadiaPackage {engineeringPerspective = ArcadiaEngineeringPerspective::SystemAnalysis;}
		doc /* Defines the system’s intended behavior and responsibilities in response to stakeholder needs.
		Describes system functions, interfaces, and interactions, independently from implementation choices.
		Serves as a basis for the logical architecture. */
		package Functions {
			private import Data::*;
			action 'Root Function' : Function;
		}
		package Capabilities;
		package Interfaces;
		package Data;
		package Structure {
			private import Data::*;
			private import Functions::*;
			part system : Component;
		}
		package Requirements;
	}

	package <LA> 'Logical Architecture' {
		metadata ArcadiaPackage {engineeringPerspective = ArcadiaEngineeringPerspective::LogicalArchitecture;}
		doc /* Defines the logical architecture of the system.
		Contains logical components, functions, and their interactions, abstracted from implementation details.
		Serves as a bridge between system needs and physical design. */
		package Functions {
			private import Data::*;

			action 'Root Function' : Function {
	   	    	action 'Capture Movement' : Function {
	            	@StatusInfo {status = StatusKind::tbd;}
	   	    		//Corresponds to the description field in Capella
	        		doc description /*Interpret raw optical data into motion vectors.*/
	            	//Correspond to a Capella Function Output Port and the allocated Exchange Item(s) (binding rawOpticalData)
	            	out FOP1 [0..*] : ExchangeItem = (rawOpticalDataX, rawOpticalDataY);
	        	}

	   	    	action 'Transform Raw Optical Data' : Function {
	   	    		in FIP2 [0..*] : ExchangeItem = (rawOpticalDataX, rawOpticalDataY);
	   	    	}

	   	    	// A Functional Exchange
	   	    	flow 'Optical Data' : FunctionalExchange
	   	    		from 'Capture Movement'.FOP1 to 'Transform Raw Optical Data'.FIP2;

	   	    	// Binding the Exchange Item(s) to the flow
	   	    	//bind 'Optical Data'.payload = (rawOpticalDataX, rawOpticalDataY);


	   	    	// A Functional Chain
	   	    	action 'read movement' : FunctionalChain {
	   	    		ref flow :>> involvedFunctionalExchanges = ('Optical Data');
	   	    		perform 'Root Function'.'Capture Movement';
	   	    		perform 'Root Function'.'Transform Raw Optical Data';

	   	    		succession first start then 'Root Function'.'Capture Movement';
	   	    		succession first 'Root Function'.'Capture Movement' then 'Root Function'.'Transform Raw Optical Data';
	   	    		succession first 'Root Function'.'Transform Raw Optical Data' then done;
	   	    	}
	   	    }
    	}

		package Capabilities {
			private import Functions::*;
			private import Structure::*;
			occurrence 'Move Cursor on Screen' : Capability  {
				ref action :>> involvedFunctions = ('Root Function'.'Capture Movement', 'Root Function'.'Transform Raw Optical Data');
				ref action :>> involvedFunctionalChains = ('Root Function'.'read movement');
				ref part :>> involvedComponents = (system.'Optical Sensor Unit', system.'Mouse Controller');
			}

			occurrence 'Provide Interface to User' : Mission  {
				ref occurrence :>> exploitedCapabilities = ('Move Cursor on Screen');
				ref part :>> involvedComponents = (system.'Optical Sensor Unit', system.'Mouse Controller');
			}

		}
		package Interfaces;
		package Data {
   	    	item rawOpticalDataX: ExchangeItem;
   	    	item rawOpticalDataY: ExchangeItem;
		}
		package Structure {
			private import Functions::*;
			private import Data::*;
			part computerUser : Component {
				:>> isActor = true;
			}

			part system : Component{
				part 'Optical Sensor Unit' : Component {
				    doc description /*Captures surface movement using optical detection.*/
	                :>> isActor = false;
	                :>> isHuman = false;
	                perform 'Root Function'.'Capture Movement';
	                port 'Cable Connector' : ComponentPort  {
		               	out [0..*] : ExchangeItem = (rawOpticalDataX, rawOpticalDataY);
		               	:>> portDirection = FeatureDirectionKind::'out';
		               	ref item :>> allocatedFunctionPorts = ('Root Function'.'Capture Movement'.FOP1);
	                }
			 	}

				part 'Mouse Controller' : Component {
	                doc description /*Manages mouse peripherals*/
	                :>> isActor = false;
	                :>> isHuman = false;
	                perform 'Root Function'.'Transform Raw Optical Data';
	                port 'Cable Connector' : ComponentPort {
		               	in [0..*] : ExchangeItem = (rawOpticalDataX, rawOpticalDataY);
		               	:>> portDirection = FeatureDirectionKind::'in';
		               	ref item :>> allocatedFunctionPorts = ('Root Function'.'Transform Raw Optical Data'.FIP2);
	                }
			 	}

				// An interface between 2 compoenents Ports
				interface cable : ComponentExchange
					connect 'Optical Sensor Unit'.'Cable Connector' to 'Mouse Controller'.'Cable Connector' {
					flow system.'Optical Sensor Unit'.'Cable Connector' to system.'Mouse Controller'.'Cable Connector';
			        ref item :>> allocatedExchangeItems = (rawOpticalDataX, rawOpticalDataY);
	        		ref action:>> allocatedFunctionalExchanges = ('Root Function'.'Optical Data');
					}

				// A Fonctional Exchange allocated to a Component Exchange
				allocation : ExchangeAllocation
					allocate 'Root Function'.'Optical Data' to cable;
			}
		}

		package Requirements {
			//R1.1 is the ID of the requirement
			requirement <'R1.1'> Optical : ArcadiaRequirement {
				doc /*
				 * The mouse should capture movement using optical detection
				 */
			}
		}
	}

	package <PA> 'Physical Architecture' {
		metadata ArcadiaPackage {engineeringPerspective = ArcadiaEngineeringPerspective::PhysicalArchitecture;}
		doc /* Defines the physical components and their interactions that realize the logical architecture.
		Includes hardware, software, and communication elements, with consideration for implementation constraints.
		Supports integration, validation, and preparation for deployment. */
		package Functions {
			private import Data::*;
			action 'Root Function' : Function;
		}
		package Capabilities;
		package Interfaces;
		package Data;
		package Structure {
			private import Data::*;
			private import Functions::*;
			part system : Component{

				part 'Optical Sensor Module' : Component {
				    doc description /*Captures surface movement using optical detection.*/
	                :>> isActor = false;
	                :>> isHuman = false;
	            }
	        }
		}
		package Requirements;
	}

	package <EPBS> 'EPBS Architecture' {
		metadata ArcadiaPackage {engineeringPerspective = ArcadiaEngineeringPerspective::EPBS;}
		doc /* Defines the configuration of the system as delivered to the customer.
		Describes the breakdown of end products, including deliverable items, versions, and traceability to physical components and requirements.
		Supports verification, acceptance, and product management. */
		package Functions {
			private import Data::*;
			action 'Root Function' : Function;
		}
		package Capabilities;
		package Interfaces;
		package Data;
		package Structure {
			private import Data::*;
			private import Functions::*;
			part system : Component;
		}
		package Requirements;
	}
}
