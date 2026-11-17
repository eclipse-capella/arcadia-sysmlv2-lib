# Function Port

[Contents](../ArcadiaLibraryMapping.md#contents) | Previous: [Function](08-Function.md) | Next: [Functional Chain](10-FunctionalChain.md)

## Library definition

None. A function port is a native parameter of the action.

## Mapping

| ID | Capella concept | Capella metamodel | Treatment | In SysML v2 | Meaning | Rationale |
| --- | --- | --- | --- | --- | --- | --- |
| <a id="fport-01"></a>FPORT-01 | Function Input Port | `fa::FunctionInputPort`, owned by the function (`activity::AbstractAction.inputs`) | Native | `in` parameter of the action, typed by `ExchangeItem` | A place where the function receives something from other functions | P1: recreating port objects would be far from the SysML v2 intent; action parameters are displayed as ports |
| <a id="fport-02"></a>FPORT-02 | Function Output Port | `fa::FunctionOutputPort`, owned by the function (`activity::AbstractAction.outputs`) | Native | `out` parameter of the action, typed by `ExchangeItem` | A place where the function sends something to other functions | Same as [FPORT-01](#fport-01) |
| <a id="fport-03"></a>FPORT-03 | Exchange items of a port | `fa::FunctionInputPort.incomingExchangeItems`, `fa::FunctionOutputPort.outgoingExchangeItems` | Native | multiplicity `[0..*]` and value of the parameter: `= (item1, item2)` | The exchange items that the port receives or sends | P1 |

## Example

From [`examples/concepts/function.sysml`](../../examples/concepts/function.sysml), validated with the SysML v2 pilot implementation.

```
			action 'Capture Movement' : Function {
				// FPORT-02: an output port named FOP1; FPORT-03: it carries rawOpticalData
				out FOP1 [0..*] : ExchangeItem = (rawOpticalData);
			}
			action 'Transform Raw Optical Data' : Function {
				// FPORT-01: an input port named FIP1
				in FIP1 [0..*] : ExchangeItem = (rawOpticalData);
			}
```

`FOP1` is the name of the port in Capella. `[0..*]` means that the port can carry several exchange items. `= (rawOpticalData)` binds the exchange items, defined in the data package, to the port.

## Decisions

- Function ports are not recreated as objects of the library: they are the `in` and `out` parameters of the action.
- SysML v2 allows `in`, `out` and `inout` parameters. Arcadia only has input ports and output ports: only `in` and `out` are used (see [OP-INOUT](../ArcadiaLibraryMapping.md#op-inout)).

## Tooling requirements

- Parameters are displayed as oriented ports on the functions.
- Tooling only proposes `in` and `out` parameters.

## SysML v2 limitations

None.

## Open points

[OP-INOUT](../ArcadiaLibraryMapping.md#op-inout) (see the [open points register](../ArcadiaLibraryMapping.md#open-points-register)).
