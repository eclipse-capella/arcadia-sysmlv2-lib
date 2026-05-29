/* Copyright (c) 2026 OBEO
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

occurrence def <My_Model_Short_Name> 'My Model Name' {
	metadata ArcadiaPackage {
		engineeringPerspective = ArcadiaEngineeringPerspective::SystemEngineering;
	}
	private import Arcadia::*;
	private import ScalarValues::Boolean;
	private import ModelingMetadata::*;
	private import KerML::FeatureDirectionKind;
	
	package <OA> 'Operational Analysis' {
		metadata ArcadiaPackage {
			engineeringPerspective = ArcadiaEngineeringPerspective::OperationalAnalysis;
		}
		doc
		/* Defines the operational view of the system context and stakeholder needs.
		 * Captures missions, actors, and activities without technical constraints.
		 * Serves as the foundation for deriving system-level requirements.
		 */
		package Functions {
			private import Data::*;
			action 'Root Function' : Function;
		} // package Functions
		package Capabilities {
			private import Functions::*;
			private import Structure::*;
		} // package Capabilities
		package Interfaces;
		package Data;
		package Structure {
			private import Functions::*;
			private import Data::*;
		} // package Structure
		package Requirements;
	} // package <OA> 'Operational Analysis'
	
	package <SA> 'System Analysis' {
		metadata ArcadiaPackage {
			engineeringPerspective = ArcadiaEngineeringPerspective::SystemAnalysis;
		}
		doc
		/* Defines the system’s intended behavior and responsibilities in response to stakeholder needs.
		 * Describes system functions, interfaces, and interactions, independently from implementation choices.
		 * Serves as a basis for the logical architecture.
		 */
		package Functions {
			private import Data::*;
			action 'Root Function' : Function;
		} // package Functions
		package Capabilities {
			private import Functions::*;
			private import Structure::*;
		} // package Capabilities
		package Interfaces;
		package Data;
		package Structure {
			private import Data::*;
			private import Functions::*;
			part system : Component;
		} // package Structure
		package Requirements;
	} // package <SA> 'System Analysis'
	
	package <LA> 'Logical Architecture' {
		metadata ArcadiaPackage {
			engineeringPerspective = ArcadiaEngineeringPerspective::LogicalArchitecture;
		}
		doc
		/* Defines the logical architecture of the system.
		 * Contains logical components, functions, and their interactions, abstracted from implementation details.
		 * Serves as a bridge between system needs and physical design.
		 */
		package Functions {
			private import Data::*;
			action 'Root Function' : Function;
		} // package Functions
		package Capabilities {
			private import Functions::*;
			private import Structure::*;
		} // package Capabilities
		package Interfaces;
		package Data;
		package Structure {
			private import Data::*;
			private import Functions::*;
			part system : Component;
		} // package Structure
		package Requirements;
	} // package <LA> 'Logical Architecture'
	
	package <PA> 'Physical Architecture' {
		metadata ArcadiaPackage {
			engineeringPerspective = ArcadiaEngineeringPerspective::PhysicalArchitecture;
		}
		doc
		/* Defines the physical components and their interactions that realize the logical architecture.
		 * Includes hardware, software, and communication elements, with consideration for implementation constraints.
		 * Supports integration, validation, and preparation for deployment.
		 */
		package Functions {
			private import Data::*;
			action 'Root Function' : Function;
		} // package Functions
		package Capabilities {
			private import Functions::*;
			private import Structure::*;
		} // package Capabilities
		package Interfaces;
		package Data;
		package Structure {
			private import Data::*;
			private import Functions::*;
			part system : Component;
		} // package Structure
		package Requirements;
	} // package <PA> 'Physical Architecture'
	
	package <EPBS> 'EPBS Architecture' {
		metadata ArcadiaPackage { engineeringPerspective = ArcadiaEngineeringPerspective::EPBS; }
		doc
		/* Defines the configuration of the system as delivered to the customer.
		 * Describes the breakdown of end products, including deliverable items, versions, and traceability to physical components and requirements.
		 * Supports verification, acceptance, and product management.
		 */
		package Functions {
			private import Data::*;
			action 'Root Function' : Function;
		} // package Functions
		package Capabilities {
			private import Functions::*;
			private import Structure::*;
		} // package Capabilities
		package Interfaces;
		package Data;
		package Structure {
			private import Data::*;
			private import Functions::*;
			part system : Component;
		} // package Structure
		package Requirements;
	} // package <EPBS> 'EPBS Architecture'
}
