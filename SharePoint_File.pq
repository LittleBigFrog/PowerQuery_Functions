let
  Source = 
    let
      TenantName      = "WayneCorp", // update it with your tenant name (your sharepoint root url is TenantName.sharepoint.com)                                                                                          
      BaseUrl         = "https://" & TenantName & ".sharepoint.com/", 
      // SharePoint root site url has to be hardcoded to avoid hand-authored queries that cannot be refreshed in the Power BI service                                                                                                                               
      // see https://docs.microsoft.com/en-us/power-bi/connect-data/refresh-data#refresh-and-dynamic-data-sources                                                                                                           
      BaseUrl_Updated = BaseUrl <> "https://WayneCorp.sharepoint.com/", 
      fn              = (SharePoint_File_url as text) as binary =>
        let
          FileUrl_ValidTenant = Text.StartsWith(SharePoint_File_url, BaseUrl), 
          FileUrl_ValidFormat = Text.Contains(SharePoint_File_url, "/Shared%20Documents/"), 
          FileUrl_IsValid     = FileUrl_ValidTenant and FileUrl_ValidFormat, 
          Path                = Uri.Parts(SharePoint_File_url)[Path], 
          PathList            = List.Buffer(List.Select(Text.Split(Path, "/"), each _ <> "")), 
          PathListEnd         = List.RemoveFirstN(PathList, List.PositionOf(PathList, "sites")), 
          RelativeUrl         = Text.Combine(List.FirstN(PathListEnd, 2), "/") & "/_api/web/getfilebyserverrelativeurl('/" & Text.Combine(PathListEnd, "/") & "')/$value", 
          FileBinary          = Web.Contents(BaseUrl, [RelativePath = RelativeUrl]), 
          LineBreak           = Character.FromNumber(10), 
          output              = 
            if FileUrl_IsValid and BaseUrl_Updated then
              FileBinary
            else if BaseUrl_Updated = false then
              error Error.Record("Setup issue", "TenantName not updated", "Function will only work once you update TenantName variable in first row of code")
            else if FileUrl_ValidFormat and FileUrl_ValidTenant = false then
              error Error.Record("Url issue", "Tenant different", "file url is ...")
            else if FileUrl_IsValid = false then
              error Error.Record(
                "Url issue", 
                "Wrong SharePoint link", 
                LineBreak
                  & "Sharepoint direct link format expected:"& LineBreak
                  & BaseUrl & "sites/SITENAME/Shared%20Documents/FOLDERS/FILENAME"
                  & LineBreak & LineBreak
                  & "Click File –> Copy path from Excel or Office application"
                  & LineBreak
                  & "Or use People With Existing Access on SharePoint online sharing menu "
                  & LineBreak & LineBreak
                  & "(and ask your IT to set it as default SharePoint option: https://docs.microsoft.com/en-us/sharepoint/change-default-sharing-link)"
              )
            else
              null
        in
          output, 
      fnType          = type function (SharePoint_File_url as text) as list
        meta [
          Documentation.Name            = "SharePoint_File", 
          Documentation.LongDescription = "Returns the SharePoint file (binary) when given its direct SharePoint link <br>"
            & (
              if BaseUrl_Updated then
                ""
              else
                "<br>SharePoint root site url has to be hardcoded to avoid hand-authored queries that cannot be refreshed in the Power BI service.<br>"
                  & "<b>Please update TenantName variable in the first row of the function code (in Formula Bar or Advanced Editor)</b><br>"
            )
            & "Explanations and updates on https://littlebigfrog.xyz"
        ]
    in
      Value.ReplaceType(fn, fnType)
in
  Source