# ArcadiaPackage

[Contents](../ArcadiaLibraryMapping.md#contents) | Previous: [ArcadiaElement](01-ArcadiaElement.md) | Next: [Default model structure](03-DefaultModelStructure.md)

## Library definition

```
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
```

## Mapping

In Capella, the engineering perspective of an element is given by the class of the architecture that contains it. In SysML v2 a package has no type, so the perspective is carried by a metadata annotation.

| ID | Capella concept | Capella metamodel | Treatment | In SysML v2 | Meaning | Rationale |
| --- | --- | --- | --- | --- | --- | --- |
| <a id="pkgm-01"></a>PKGM-01 | Engineering perspective of a part of the model | class of the architecture (rows below) | Library | `metadata def ArcadiaPackage`, with `engineeringPerspective : ArcadiaEngineeringPerspective` | States which engineering perspective a package belongs to | P3: the perspectives are essential to Arcadia and a SysML v2 package cannot be typed. P6: this annotation is what allows generic concepts (one `Component`, one `Function`) |
| <a id="pkgm-02"></a>PKGM-02 | Operational Analysis | `oa::OperationalAnalysis` | Library | `ArcadiaEngineeringPerspective::OperationalAnalysis` | The Operational Analysis perspective | Same as [PKGM-01](#pkgm-01) |
| <a id="pkgm-03"></a>PKGM-03 | System Analysis | `ctx::SystemAnalysis` | Library | `ArcadiaEngineeringPerspective::SystemAnalysis` | The System Analysis perspective | Same as [PKGM-01](#pkgm-01) |
| <a id="pkgm-04"></a>PKGM-04 | Logical Architecture | `la::LogicalArchitecture` | Library | `ArcadiaEngineeringPerspective::LogicalArchitecture` | The Logical Architecture perspective | Same as [PKGM-01](#pkgm-01) |
| <a id="pkgm-05"></a>PKGM-05 | Physical Architecture | `pa::PhysicalArchitecture` | Library | `ArcadiaEngineeringPerspective::PhysicalArchitecture` | The Physical Architecture perspective | Same as [PKGM-01](#pkgm-01) |
| <a id="pkgm-06"></a>PKGM-06 | EPBS Architecture | `epbs::EPBSArchitecture` | Library | `ArcadiaEngineeringPerspective::EPBS` | The EPBS perspective (see [OP-EPBS](../ArcadiaLibraryMapping.md#op-epbs)) | Same as [PKGM-01](#pkgm-01) |
| <a id="pkgm-07"></a>PKGM-07 | System Engineering (root of the model) | `capellamodeller::SystemEngineering` | Library | `ArcadiaEngineeringPerspective::SystemEngineering`, on the top-level element of the model | The root that contains the engineering perspectives | Same as [PKGM-01](#pkgm-01) |
| <a id="pkgm-08"></a>PKGM-08 | (no Capella counterpart) | none | Library | `ArcadiaEngineeringPerspective::Generic` | A package whose perspective is not specified | Allows models or parts of models outside the five perspectives |

## Example

From [`examples/concepts/arcadia-package.sysml`](../../examples/concepts/arcadia-package.sysml), validated with the SysML v2 pilot implementation.

```
// PKGM-01, PKGM-07: the top-level element of the model
occurrence def <MOUSE> 'Optical Mouse' {
	private import Arcadia::*;
	metadata ArcadiaPackage {
		engineeringPerspective = ArcadiaEngineeringPerspective::SystemEngineering;
	}

	// PKGM-01, PKGM-04: the package of an engineering perspective
	package <LA> 'Logical Architecture' {
		metadata ArcadiaPackage {
			engineeringPerspective = ArcadiaEngineeringPerspective::LogicalArchitecture;
		}
		// Not annotated: the perspective is given by the closest annotated package
		package Structure;
	}
}
```

## Decisions

- The annotation is set on the top-level element of the model and on the package of each engineering perspective, and only there. The other packages are not annotated: the perspective of an element is given by the closest enclosing element annotated with `ArcadiaPackage`.
- The annotation applies to packages and to occurrence definitions, because the top-level element of a model is an occurrence definition (see the STRUCT section).

## Tooling requirements

- Tooling finds the engineering perspective of an element by looking for the closest enclosing element annotated with `ArcadiaPackage`.
- Tooling sets the annotations when it creates the default model structure.

## SysML v2 limitations

- A package cannot be specialized or typed: there is no "package definition" that the library could provide for the engineering perspectives. This is why a metadata annotation is used.

## Open points

[OP-EPBS](../ArcadiaLibraryMapping.md#op-epbs) (see the [open points register](../ArcadiaLibraryMapping.md#open-points-register)).
