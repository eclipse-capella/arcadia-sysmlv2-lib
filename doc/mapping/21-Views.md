# Views (Capella diagrams)

[Contents](../ArcadiaLibraryMapping.md#contents) | Previous: [Property values](20-PropertyValues.md)

## Library definition

```
	private import StandardViewDefinitions::*;

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
```

## Mapping

| ID | Capella concept | Capella metamodel | Treatment | In SysML v2 | Meaning | Rationale |
| --- | --- | --- | --- | --- | --- | --- |
| <a id="view-01"></a>VIEW-01 | Diagram | `viewpoint::DRepresentationDescriptor` (Sirius), whose `representation` is a `diagram::DDiagram` | Library | a `view` usage typed by an Arcadia view definition ([VIEW-02](#view-02)) | A diagram displays elements of the model | P1: the native SysML v2 construct for a diagram is the view. P3: the Arcadia view definitions are the only addition |
| <a id="view-02"></a>VIEW-02 | Diagram kind (for example Logical Architecture Blank) | `description::DiagramDescription` (Capella `.odesign` files) | Typing | the type of the view usage: one Arcadia view definition per diagram kind, 45 in the library (the matrices have their own, [VIEW-09](#view-09)) | The kind tells which palette and which rules apply to the diagram | P3: tools need to know the kind. A view usage has only one type, so the kind is the type itself, not an attribute |
| <a id="view-03"></a>VIEW-03 | (no Capella counterpart: standard parent of a kind) | none | Library | each Arcadia view definition specializes the closest standard view definition (table below) | A tool that does not know Arcadia still sees a standard view | P1, P2 |
| <a id="view-04"></a>VIEW-04 | Name of the diagram | `viewpoint::DRepresentationDescriptor.name` | Native | the name of the view usage | Label of the diagram | P1 |
| <a id="view-05"></a>VIEW-05 | Target of the diagram: the element it is attached to | `viewpoint::DRepresentationDescriptor.target` | Native | the view usage is owned by the same element as in Capella: a package, a component, a function... | Where the diagram lives in the model | P1: SysML v2 allows views in parts and actions (see Decisions). P5: the owner is the same in Capella and in SysML v2 |
| <a id="view-06"></a>VIEW-06 | Elements displayed by the diagram | `diagram::DDiagram.ownedDiagramElements` | Native | `expose` statements of the view usage | The model elements that the diagram shows | P1 |
| <a id="view-07"></a>VIEW-07 | Layout and graphical style (size, position, style, visibility) | `diagram::DNode.width`, `DNode.height`, `DNode.ownedStyle`, `DEdge.ownedStyle`, `DDiagramElement.visible` | Not translated – out of library scope | none | How the diagram looks | The textual notation does not carry the layout: it is up to the tools |
| <a id="view-08"></a>VIEW-08 | "Modes and States" diagram | `description::DiagramDescription` | Not translated – legacy | none | Older diagram on modes and states, marked deprecated in Capella and replaced by the Mode State Machine diagram (`MSM`), which is translated | P4 |
| <a id="view-09"></a>VIEW-09 | Matrices (cross tables) | `description::CrossTableDescription` (20 in the Capella `.odesign` files) | Library | a `view` usage typed by the view definition `Matrix`, which specializes `GridView` | A relationship matrix between two sets of elements, for example components and functions | P1: `GridView` is the standard view for a rectangular grid, including relationship matrices. P3: one view definition for all the matrices |

Standard view definition chosen for each Arcadia view definition (short names are the Capella acronyms):

| Standard view definition | Arcadia view definitions |
| --- | --- |
| `InterconnectionView` | architecture blank diagrams and Physical Path Description: `OAB`, `SAB`, `LAB`, `PAB`, `PPD`, `EAB` |
| `ActionFlowView` | data flow blank, activity interaction, process and functional chain descriptions: `OAIB`, `OPD`, `SDFB`, `LDFB`, `PDFB`, `FCD` |
| `SequenceView` | scenarios: `OES`, `OAS`, `IS`, `ES`, `FS` |
| `StateTransitionView` | `MSM` |
| `GridView` | all the matrices (no short name): `Matrix` |
| `GeneralView` | everything else (breakdowns, capabilities, missions, class and interface diagrams, package dependencies...): `OEBD`, `OABD`, `ORB`, `OCB`, `COC`, `CM`, `MB`, `CC`, `MCB`, `SFBD`, `CSA`, `LCBD`, `LFBD`, `CRR`, `PFBD`, `PCBD`, `CIBD`, `CDB`, `CA`, `IDB`, `ID`, `CDI`, `CEI`, `CII`, `CRB`, `CRI`, `PD` |

## Example

From [`examples/concepts/views.sysml`](../../examples/concepts/views.sysml), validated with the SysML v2 pilot implementation.

The same constructs appear in `examples/optical-mouse.sysml` (`'Optical Data Flow'`, `'Mouse Logical Architecture'`).

```
	action 'Root Function' : Function {
		action 'Capture Movement' : Function;
		action 'Transform Raw Optical Data' : Function;
		// VIEW-01 to VIEW-06: a Logical Data Flow Blank diagram (kind LDFB), attached to a function and owned by it
		view 'Optical Data Flow' : LDFB {
			expose 'Capture Movement';
			expose 'Transform Raw Optical Data';
		}
	}

	part system : Component {
		part 'Optical Sensor Unit' : Component;
		part 'Mouse Controller' : Component;
		// A Logical Architecture Blank diagram (kind LAB), attached to a component and owned by it
		view 'Mouse Logical Architecture' : LAB {
			expose 'Optical Sensor Unit';
			expose 'Mouse Controller';
		}
	}

	// A Logical Function Breakdown diagram (kind LFBD), attached to a package and owned by it
	view 'Logical Functions' : LFBD {
		expose 'Root Function';
	}

	// VIEW-09: a Capella matrix (for example the allocation of functions to components), attached to a package and owned by it
	view 'Components and Functions' : Matrix {
		expose system;
		expose 'Root Function';
	}
```

## Decisions

- A Capella diagram is a view usage typed by one Arcadia view definition. A view usage can only be typed by one view definition, so the kind cannot be added to a standard view as a second type or as an enumeration: each kind is a view definition that specializes a standard one.
- The view definitions are in the library, not generated in each model: a generated copy would have its own identity in every model, tools would have to recognize it by its name, and two imported models would bring two competing definitions.
- `expose` is valid in a view usage, not in a view definition: the view definitions are empty and the exposed elements are in the usage.
- The view usage is owned by the same element as the diagram in Capella (package, component, function...). Views in packages are the common practice, but they are package-level usages: they become features of anything, with a default multiplicity of `[0..*]`. SysML v2 allows views in parts and actions; the element knows best how it wants to be represented (advice from a SysML v2 expert review).
- The order of the `expose` statements has no semantic meaning. An order used to create a diagram (ports after functions, nested functions after their parent) is a convention of the tools.
- A single view definition, `Matrix`, covers the 20 Capella matrices. They differ by the elements in rows and columns and by the relationship shown; the type does not record this, a tool decides it from the exposed elements. One view definition per matrix, as for the diagrams, can be added later if needed. Capella gives no acronym to the matrices, so `Matrix` has no short name.
- The standard view definition chosen for each kind is the best compromise with the current SysML v2 specification and its planned evolution for the graphical part.

## Tooling requirements

- [VIEW-02](#view-02): the Arcadia kind of a view usage is found by following the specializations of its type: a view typed by `LAB` is an Interconnection view. A tool that only compares the type with the standard view definitions does not recognize the Arcadia kinds.
- [VIEW-05](#view-05): a view is formally a subpart of the part that owns it (a `view` specializes `part`), and `subComponents` is an alias of `subparts`. Tools filter the views out of the sub-components, for any analysis (no issue known so far, according to a SysML v2 expert review).
- [VIEW-06](#view-06), [VIEW-07](#view-07): the layout of a diagram created from a view is computed by the tool.
- [VIEW-09](#view-09): the cells of a matrix show the relationships between the exposed elements (for example allocations): they are computed by the tool.

## SysML v2 limitations

- A tool that does not know Arcadia should show an architecture blank diagram typed this way with its nested components, ports and connections, but without the layout, without the deployment as nesting (a deployment is an allocation), and probably without the functions as nodes inside the components. These limits do not depend on the standard view definition chosen.
- The official examples found (training, Annex A) only have views in packages. Nesting views in parts and actions is allowed and compiles with the SysML v2 pilot implementation.

## Open points

None.
