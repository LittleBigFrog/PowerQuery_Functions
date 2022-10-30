let
  output = (t as table, keys as list) =>
    let
      schema                = Table.Buffer(Table.Schema(t)), 
      UnpivotSchema         = Table.SelectRows(schema, each not (List.Contains(keys, [Name]))), 
      TextColumns           = Table.SelectRows(schema, each ([Kind] = "text"))[Name], 
      CleanEmptyTextColumns = Table.ReplaceValue(t, "", null, Replacer.ReplaceValue, TextColumns), 
      TypeToUnpivot         = List.Distinct(UnpivotSchema[Kind]), 
      UnpivotFunction       = (t, ty) =>
        let
          output = Table.UnpivotOtherColumns(
            Table.SelectColumns(t, List.Combine({keys, Table.SelectRows(UnpivotSchema, each ([Kind] = ty))[Name]})), 
            keys, 
            "Attribute", 
            "Value" & Text.Proper(ty)
          )
        in
          output, 
      LoopTypes             = Table.Combine(List.Transform(TypeToUnpivot, each UnpivotFunction(CleanEmptyTextColumns, _)))
    in
      LoopTypes
in
  output
