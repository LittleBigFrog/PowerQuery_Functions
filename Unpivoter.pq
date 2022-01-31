let
  output = (t as table ,keys as list)=>
let
  schema          = Table.Schema(t),
  UnpivotSchema   = Table.SelectRows(schema, each not (List.Contains(keys, [Name]))),
  TypeToUnpivot   = List.Distinct(UnpivotSchema[Kind]),
  UnpivotFunction = (t, ty) => 
    let
      output = Table.UnpivotOtherColumns(Table.SelectColumns(t, List.Combine({keys, Table.SelectRows(UnpivotSchema, each ([Kind] = ty))[Name]})), keys, "Attribute", if ty = "number" then "Value" else "Value" & Text.Proper(ty))
    in
      output,
  LoopTypes       = Table.Combine(List.Transform(TypeToUnpivot, each UnpivotFunction(t, _)))
in
  LoopTypes
in
  output
