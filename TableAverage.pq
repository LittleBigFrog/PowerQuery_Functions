let
  averageTable = (TableToAverage as table, keys as list, optional suffix as text) as table =>
    let
      t           = TableToAverage, 
      Schema      = Table.AddColumn(Table.Schema(t), "Type", each Expression.Evaluate("type " & [Kind]), type type), 
      RecordTypes = Record.FromList(Schema[Type], Schema[Name]), 
      Columns     = Schema[Name], 
      keys        = {"Inbred", "Year"}, 
      Suffix      = null, 
      Average     = Table.Group(
        t, 
        keys, 
        List.Transform(
          List.RemoveItems(Columns, keys), 
          (C) => {
            if suffix = null then C else C & " " & suffix, 
            each 
              if Type.Is(Record.Field(RecordTypes, C), type text) then
                List.Mode(List.RemoveNulls(Table.Column(_, C)))
              else
                List.Average(List.RemoveNulls(Table.Column(_, C))), 
            Record.Field(RecordTypes, C)
          }
        )
      )
    in
      Average
in
  averageTable
