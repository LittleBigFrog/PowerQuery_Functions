P�  �  h                                                                                 ��5  -  HTML Format                                                                    ���  b-  Microsoft Mashup Format                                                         �%  \B                                                                                 // SharePoint_File
let
  Source = 
    let TenantName    = "WayneCorp", // update it with your tenant name, usually your company name (your sharepoint url starts with TenantName.sharepoint.com)                                 
      BaseUrl         = "https://" & TenantName & ".sharepoint.com/", 
      // SharePoint root site url has to be hardcoded to avoid hand-authored queries that cannot be refreshed in the Power BI service
      // see https://docs.microsoft.com/en-us/power-bi/connect-data/refresh-data#refresh-and-dynamic-data-sources
      BaseUrl_Updated = BaseUrl <> "https://WayneCorp.sharepoint.com/", 
      fn              = (SharePoint_File_url as text) as binary =>
        let
          FileUrl_ValidTenant = Text.StartsWith(SharePoint_File_url, BaseUrl),
          FileUrl_IsSharePoint =  Text.Contains(SharePoint_File_url, ".sharepoint.com/",Comparer.OrdinalIgnoreCase) and Text.StartsWith(SharePoint_File_url, "https://",Comparer.OrdinalIgnoreCase), 
          FileUrl_ValidFormat = FileUrl_IsSharePoint and Text.Contains(SharePoint_File_url, "/Shared%20Documents/",Comparer.OrdinalIgnoreCase), 
          FileUrl_IsValid     = FileUrl_ValidTenant and FileUrl_ValidFormat, 
          Path                = Uri.Parts(SharePoint_File_url)[Path],
          FileUrl_Host        = Uri.Parts(SharePoint_File_url)[Host],
          FileUrl_Tenant      = Text.BeforeDelimiter(Uri.Parts(BaseUrl)[Host],".sharepoint.com"),
          PathList            = List.Buffer(List.Select(Text.Split(Path, "/"), each _ <> "")), 
          PathListEnd         = List.RemoveFirstN(PathList, List.PositionOf(PathList, "sites")), 
          RelativeUrl         = Text.Combine(List.FirstN(PathListEnd, 2), "/") & "/_api/web/getfilebyserverrelativeurl('/" & Text.Combine(PathListEnd, "/") & "')/$value", 
          FileBinary          = Web.Contents(BaseUrl, [RelativePath = RelativeUrl]), 
          LineBreak           = Character.FromNumber(10), 
          output              = 
            if FileUrl_IsValid and BaseUrl_Updated then
              FileBinary
            else if BaseUrl_Updated = false then
              error Error.Record(
                "TenantName not updated", null, 
                LineBreak & "TenantName not updated" & LineBreak & "Function will only work once you update TenantName variable in first row of function code" & LineBreak
                & (if FileUrl_IsSharePoint then "According to link provided, you should update the function code with TenantName=""" & FileUrl_Tenant &"""" else "")
              )
            else if FileUrl_ValidFormat and FileUrl_ValidTenant = false then
              error Error.Record("Url issue", null, LineBreak & "File link is for a file on  " & FileUrl_Host & LineBreak & "But function is setup for " & BaseUrl)
            else if FileUrl_IsValid = false then
              error Error.Record(
                "Url issue", 
                null, 
                 "Wrong SharePoint link" & LineBreak
                  & "The Sharepoint direct link should look like:"& LineBreak
                  & BaseUrl & "sites/SITENAME/Shared%20Documents/FOLDERS/FILENAME"
                  & LineBreak & LineBreak
                  & "Find the correct link:" & LineBreak
                  & "Click File �> Copy path from Excel or Office application" & LineBreak
                  & "Or use ""People With Existing Access"" on SharePoint online sharing menu " & LineBreak 
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
                  & "<b>Please update TenantName variable in the first row of the function code (in Formula Bar or Advanced Editor).</b><br>"
                  & "Your tenant name is usually your company name (your sharepoint url starts with TenantName.sharepoint.com).<br>"
            )
            & "<br>Refresh in Power Bi service requires to check ""Skip test connection"" in Data source credentials.<br>"
            & "Explanations and updates on https://littlebigfrog.xyz"
        ]
    in
      Value.ReplaceType(fn, fnType)
in
  Source Format:HTML Format
Version: 1.0
StartHTML: 0
EndHTML: 0
StartFragment: 0
EndFragment: 0
<!DOCTYPE html>
<html>
<body><!--StartFragment--><div class="microsoft-mashup-format">&lt;?xml version=&quot;1.0&quot; encoding=&quot;utf-8&quot;?&gt;&lt;Mashup xmlns:xsd=&quot;http://www.w3.org/2001/XMLSchema&quot; xmlns:xsi=&quot;http://www.w3.org/2001/XMLSchema-instance&quot; xmlns=&quot;http://schemas.microsoft.com/DataMashup&quot;&gt;&lt;Client&gt;PBIDesktop&lt;/Client&gt;&lt;Version&gt;2.100.785.0&lt;/Version&gt;&lt;MinVersion&gt;1.5.3296.0&lt;/MinVersion&gt;&lt;Culture&gt;en-GB&lt;/Culture&gt;&lt;SafeCombine&gt;true&lt;/SafeCombine&gt;&lt;Items&gt;&lt;Query Name=&quot;SharePoint_File&quot;&gt;&lt;Formula&gt;&lt;![CDATA[let
  Source = 
    let TenantName    = &quot;WayneCorp&quot;, // update it with your tenant name, usually your company name (your sharepoint url starts with TenantName.sharepoint.com)                                 
      BaseUrl         = &quot;https://&quot; &amp; TenantName &amp; &quot;.sharepoint.com/&quot;, 
      // SharePoint root site url has to be hardcoded to avoid hand-authored queries that cannot be refreshed in the Power BI service
      // see https://docs.microsoft.com/en-us/power-bi/connect-data/refresh-data#refresh-and-dynamic-data-sources
      BaseUrl_Updated = BaseUrl &lt;&gt; &quot;https://WayneCorp.sharepoint.com/&quot;, 
      fn              = (SharePoint_File_url as text) as binary =&gt;
        let
          FileUrl_ValidTenant = Text.StartsWith(SharePoint_File_url, BaseUrl),
          FileUrl_IsSharePoint =  Text.Contains(SharePoint_File_url, &quot;.sharepoint.com/&quot;,Comparer.OrdinalIgnoreCase) and Text.StartsWith(SharePoint_File_url, &quot;https://&quot;,Comparer.OrdinalIgnoreCase), 
          FileUrl_ValidFormat = FileUrl_IsSharePoint and Text.Contains(SharePoint_File_url, &quot;/Shared%20Documents/&quot;,Comparer.OrdinalIgnoreCase), 
          FileUrl_IsValid     = FileUrl_ValidTenant and FileUrl_ValidFormat, 
          Path                = Uri.Parts(SharePoint_File_url)[Path],
          FileUrl_Host        = Uri.Parts(SharePoint_File_url)[Host],
          FileUrl_Tenant      = Text.BeforeDelimiter(Uri.Parts(BaseUrl)[Host],&quot;.sharepoint.com&quot;),
          PathList            = List.Buffer(List.Select(Text.Split(Path, &quot;/&quot;), each _ &lt;&gt; &quot;&quot;)), 
          PathListEnd         = List.RemoveFirstN(PathList, List.PositionOf(PathList, &quot;sites&quot;)), 
          RelativeUrl         = Text.Combine(List.FirstN(PathListEnd, 2), &quot;/&quot;) &amp; &quot;/_api/web/getfilebyserverrelativeurl(&#39;/&quot; &amp; Text.Combine(PathListEnd, &quot;/&quot;) &amp; &quot;&#39;)/$value&quot;, 
          FileBinary          = Web.Contents(BaseUrl, [RelativePath = RelativeUrl]), 
          LineBreak           = Character.FromNumber(10), 
          output              = 
            if FileUrl_IsValid and BaseUrl_Updated then
              FileBinary
            else if BaseUrl_Updated = false then
              error Error.Record(
                &quot;TenantName not updated&quot;, null, 
                LineBreak &amp; &quot;TenantName not updated&quot; &amp; LineBreak &amp; &quot;Function will only work once you update TenantName variable in first row of function code&quot; &amp; LineBreak
                &amp; (if FileUrl_IsSharePoint then &quot;According to link provided, you should update the function code with TenantName=&quot;&quot;&quot; &amp; FileUrl_Tenant &amp;&quot;&quot;&quot;&quot; else &quot;&quot;)
              )
            else if FileUrl_ValidFormat and FileUrl_ValidTenant = false then
              error Error.Record(&quot;Url issue&quot;, null, LineBreak &amp; &quot;File link is for a file on  &quot; &amp; FileUrl_Host &amp; LineBreak &amp; &quot;But function is setup for &quot; &amp; BaseUrl)
            else if FileUrl_IsValid = false then
              error Error.Record(
                &quot;Url issue&quot;, 
                null, 
                 &quot;Wrong SharePoint link&quot; &amp; LineBreak
                  &amp; &quot;The Sharepoint direct link should look like:&quot;&amp; LineBreak
                  &amp; BaseUrl &amp; &quot;sites/SITENAME/Shared%20Documents/FOLDERS/FILENAME&quot;
                  &amp; LineBreak &amp; LineBreak
                  &amp; &quot;Find the correct link:&quot; &amp; LineBreak
                  &amp; &quot;Click File –&gt; Copy path from Excel or Office application&quot; &amp; LineBreak
                  &amp; &quot;Or use &quot;&quot;People With Existing Access&quot;&quot; on SharePoint online sharing menu &quot; &amp; LineBreak 
                  &amp; &quot;(and ask your IT to set it as default SharePoint option: https://docs.microsoft.com/en-us/sharepoint/change-default-sharing-link)&quot;
              )
            else
              null
        in
          output, 
      fnType          = type function (SharePoint_File_url as text) as list
        meta [
          Documentation.Name            = &quot;SharePoint_File&quot;, 
          Documentation.LongDescription = &quot;Returns the SharePoint file (binary) when given its direct SharePoint link &lt;br&gt;&quot;
            &amp; (
              if BaseUrl_Updated then
                &quot;&quot;
              else
                &quot;&lt;br&gt;SharePoint root site url has to be hardcoded to avoid hand-authored queries that cannot be refreshed in the Power BI service.&lt;br&gt;&quot;
                  &amp; &quot;&lt;b&gt;Please update TenantName variable in the first row of the function code (in Formula Bar or Advanced Editor).&lt;/b&gt;&lt;br&gt;&quot;
                  &amp; &quot;Your tenant name is usually your company name (your sharepoint url starts with TenantName.sharepoint.com).&lt;br&gt;&quot;
            )
            &amp; &quot;&lt;br&gt;Refresh in Power Bi service requires to check &quot;&quot;Skip test connection&quot;&quot; in Data source credentials.&lt;br&gt;&quot;
            &amp; &quot;Explanations and updates on https://littlebigfrog.xyz&quot;
        ]
    in
      Value.ReplaceType(fn, fnType)
in
  Source]]&gt;&lt;/Formula&gt;&lt;LoadToReport&gt;true&lt;/LoadToReport&gt;&lt;IsParameterQuery&gt;false&lt;/IsParameterQuery&gt;&lt;IsDirectQuery xsi:nil=&quot;true&quot; /&gt;&lt;/Query&gt;&lt;/Items&gt;&lt;/Mashup&gt;</div><!--EndFragment--></body>
</html> ����;pC�yVk���    ����          �  <?xml version="1.0" encoding="utf-8"?><Mashup xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns="http://schemas.microsoft.com/DataMashup"><Client>PBIDesktop</Client><Version>2.100.785.0</Version><MinVersion>1.5.3296.0</MinVersion><Culture>en-GB</Culture><SafeCombine>true</SafeCombine><Items><Query Name="SharePoint_File"><Formula><![CDATA[let
  Source = 
    let TenantName    = "WayneCorp", // update it with your tenant name, usually your company name (your sharepoint url starts with TenantName.sharepoint.com)                                 
      BaseUrl         = "https://" & TenantName & ".sharepoint.com/", 
      // SharePoint root site url has to be hardcoded to avoid hand-authored queries that cannot be refreshed in the Power BI service
      // see https://docs.microsoft.com/en-us/power-bi/connect-data/refresh-data#refresh-and-dynamic-data-sources
      BaseUrl_Updated = BaseUrl <> "https://WayneCorp.sharepoint.com/", 
      fn              = (SharePoint_File_url as text) as binary =>
        let
          FileUrl_ValidTenant = Text.StartsWith(SharePoint_File_url, BaseUrl),
          FileUrl_IsSharePoint =  Text.Contains(SharePoint_File_url, ".sharepoint.com/",Comparer.OrdinalIgnoreCase) and Text.StartsWith(SharePoint_File_url, "https://",Comparer.OrdinalIgnoreCase), 
          FileUrl_ValidFormat = FileUrl_IsSharePoint and Text.Contains(SharePoint_File_url, "/Shared%20Documents/",Comparer.OrdinalIgnoreCase), 
          FileUrl_IsValid     = FileUrl_ValidTenant and FileUrl_ValidFormat, 
          Path                = Uri.Parts(SharePoint_File_url)[Path],
          FileUrl_Host        = Uri.Parts(SharePoint_File_url)[Host],
          FileUrl_Tenant      = Text.BeforeDelimiter(Uri.Parts(BaseUrl)[Host],".sharepoint.com"),
          PathList            = List.Buffer(List.Select(Text.Split(Path, "/"), each _ <> "")), 
          PathListEnd         = List.RemoveFirstN(PathList, List.PositionOf(PathList, "sites")), 
          RelativeUrl         = Text.Combine(List.FirstN(PathListEnd, 2), "/") & "/_api/web/getfilebyserverrelativeurl('/" & Text.Combine(PathListEnd, "/") & "')/$value", 
          FileBinary          = Web.Contents(BaseUrl, [RelativePath = RelativeUrl]), 
          LineBreak           = Character.FromNumber(10), 
          output              = 
            if FileUrl_IsValid and BaseUrl_Updated then
              FileBinary
            else if BaseUrl_Updated = false then
              error Error.Record(
                "TenantName not updated", null, 
                LineBreak & "TenantName not updated" & LineBreak & "Function will only work once you update TenantName variable in first row of function code" & LineBreak
                & (if FileUrl_IsSharePoint then "According to link provided, you should update the function code with TenantName=""" & FileUrl_Tenant &"""" else "")
              )
            else if FileUrl_ValidFormat and FileUrl_ValidTenant = false then
              error Error.Record("Url issue", null, LineBreak & "File link is for a file on  " & FileUrl_Host & LineBreak & "But function is setup for " & BaseUrl)
            else if FileUrl_IsValid = false then
              error Error.Record(
                "Url issue", 
                null, 
                 "Wrong SharePoint link" & LineBreak
                  & "The Sharepoint direct link should look like:"& LineBreak
                  & BaseUrl & "sites/SITENAME/Shared%20Documents/FOLDERS/FILENAME"
                  & LineBreak & LineBreak
                  & "Find the correct link:" & LineBreak
                  & "Click File –> Copy path from Excel or Office application" & LineBreak
                  & "Or use ""People With Existing Access"" on SharePoint online sharing menu " & LineBreak 
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
                  & "<b>Please update TenantName variable in the first row of the function code (in Formula Bar or Advanced Editor).</b><br>"
                  & "Your tenant name is usually your company name (your sharepoint url starts with TenantName.sharepoint.com).<br>"
            )
            & "<br>Refresh in Power Bi service requires to check ""Skip test connection"" in Data source credentials.<br>"
            & "Explanations and updates on https://littlebigfrog.xyz"
        ]
    in
      Value.ReplaceType(fn, fnType)
in
  Source]]></Formula><LoadToReport>true</LoadToReport><IsParameterQuery>false</IsParameterQuery><IsDirectQuery xsi:nil="true" /></Query></Items></Mashup>/ /   S h a r e P o i n t _ F i l e  
 l e t  
     S o u r c e   =    
         l e t   T e n a n t N a m e         =   " W a y n e C o r p " ,   / /   u p d a t e   i t   w i t h   y o u r   t e n a n t   n a m e ,   u s u a l l y   y o u r   c o m p a n y   n a m e   ( y o u r   s h a r e p o i n t   u r l   s t a r t s   w i t h   T e n a n t N a m e . s h a r e p o i n t . c o m )                                                                    
             B a s e U r l                   =   " h t t p s : / / "   &   T e n a n t N a m e   &   " . s h a r e p o i n t . c o m / " ,    
             / /   S h a r e P o i n t   r o o t   s i t e   u r l   h a s   t o   b e   h a r d c o d e d   t o   a v o i d   h a n d - a u t h o r e d   q u e r i e s   t h a t   c a n n o t   b e   r e f r e s h e d   i n   t h e   P o w e r   B I   s e r v i c e  
             / /   s e e   h t t p s : / / d o c s . m i c r o s o f t . c o m / e n - u s / p o w e r - b i / c o n n e c t - d a t a / r e f r e s h - d a t a # r e f r e s h - a n d - d y n a m i c - d a t a - s o u r c e s  
             B a s e U r l _ U p d a t e d   =   B a s e U r l   < >   " h t t p s : / / W a y n e C o r p . s h a r e p o i n t . c o m / " ,    
             f n                             =   ( S h a r e P o i n t _ F i l e _ u r l   a s   t e x t )   a s   b i n a r y   = >  
                 l e t  
                     F i l e U r l _ V a l i d T e n a n t   =   T e x t . S t a r t s W i t h ( S h a r e P o i n t _ F i l e _ u r l ,   B a s e U r l ) ,  
                     F i l e U r l _ I s S h a r e P o i n t   =     T e x t . C o n t a i n s ( S h a r e P o i n t _ F i l e _ u r l ,   " . s h a r e p o i n t . c o m / " , C o m p a r e r . O r d i n a l I g n o r e C a s e )   a n d   T e x t . S t a r t s W i t h ( S h a r e P o i n t _ F i l e _ u r l ,   " h t t p s : / / " , C o m p a r e r . O r d i n a l I g n o r e C a s e ) ,    
                     F i l e U r l _ V a l i d F o r m a t   =   F i l e U r l _ I s S h a r e P o i n t   a n d   T e x t . C o n t a i n s ( S h a r e P o i n t _ F i l e _ u r l ,   " / S h a r e d % 2 0 D o c u m e n t s / " , C o m p a r e r . O r d i n a l I g n o r e C a s e ) ,    
                     F i l e U r l _ I s V a l i d           =   F i l e U r l _ V a l i d T e n a n t   a n d   F i l e U r l _ V a l i d F o r m a t ,    
                     P a t h                                 =   U r i . P a r t s ( S h a r e P o i n t _ F i l e _ u r l ) [ P a t h ] ,  
                     F i l e U r l _ H o s t                 =   U r i . P a r t s ( S h a r e P o i n t _ F i l e _ u r l ) [ H o s t ] ,  
                     F i l e U r l _ T e n a n t             =   T e x t . B e f o r e D e l i m i t e r ( U r i . P a r t s ( B a s e U r l ) [ H o s t ] , " . s h a r e p o i n t . c o m " ) ,  
                     P a t h L i s t                         =   L i s t . B u f f e r ( L i s t . S e l e c t ( T e x t . S p l i t ( P a t h ,   " / " ) ,   e a c h   _   < >   " " ) ) ,    
                     P a t h L i s t E n d                   =   L i s t . R e m o v e F i r s t N ( P a t h L i s t ,   L i s t . P o s i t i o n O f ( P a t h L i s t ,   " s i t e s " ) ) ,    
                     R e l a t i v e U r l                   =   T e x t . C o m b i n e ( L i s t . F i r s t N ( P a t h L i s t E n d ,   2 ) ,   " / " )   &   " / _ a p i / w e b / g e t f i l e b y s e r v e r r e l a t i v e u r l ( ' / "   &   T e x t . C o m b i n e ( P a t h L i s t E n d ,   " / " )   &   " ' ) / $ v a l u e " ,    
                     F i l e B i n a r y                     =   W e b . C o n t e n t s ( B a s e U r l ,   [ R e l a t i v e P a t h   =   R e l a t i v e U r l ] ) ,    
                     L i n e B r e a k                       =   C h a r a c t e r . F r o m N u m b e r ( 1 0 ) ,    
                     o u t p u t                             =    
                         i f   F i l e U r l _ I s V a l i d   a n d   B a s e U r l _ U p d a t e d   t h e n  
                             F i l e B i n a r y  
                         e l s e   i f   B a s e U r l _ U p d a t e d   =   f a l s e   t h e n  
                             e r r o r   E r r o r . R e c o r d (  
                                 " T e n a n t N a m e   n o t   u p d a t e d " ,   n u l l ,    
                                 L i n e B r e a k   &   " T e n a n t N a m e   n o t   u p d a t e d "   &   L i n e B r e a k   &   " F u n c t i o n   w i l l   o n l y   w o r k   o n c e   y o u   u p d a t e   T e n a n t N a m e   v a r i a b l e   i n   f i r s t   r o w   o f   f u n c t i o n   c o d e "   &   L i n e B r e a k  
                                 &   ( i f   F i l e U r l _ I s S h a r e P o i n t   t h e n   " A c c o r d i n g   t o   l i n k   p r o v i d e d ,   y o u   s h o u l d   u p d a t e   t h e   f u n c t i o n   c o d e   w i t h   T e n a n t N a m e = " " "   &   F i l e U r l _ T e n a n t   & " " " "   e l s e   " " )  
                             )  
                         e l s e   i f   F i l e U r l _ V a l i d F o r m a t   a n d   F i l e U r l _ V a l i d T e n a n t   =   f a l s e   t h e n  
                             e r r o r   E r r o r . R e c o r d ( " U r l   i s s u e " ,   n u l l ,   L i n e B r e a k   &   " F i l e   l i n k   i s   f o r   a   f i l e   o n     "   &   F i l e U r l _ H o s t   &   L i n e B r e a k   &   " B u t   f u n c t i o n   i s   s e t u p   f o r   "   &   B a s e U r l )  
                         e l s e   i f   F i l e U r l _ I s V a l i d   =   f a l s e   t h e n  
                             e r r o r   E r r o r . R e c o r d (  
                                 " U r l   i s s u e " ,    
                                 n u l l ,    
                                   " W r o n g   S h a r e P o i n t   l i n k "   &   L i n e B r e a k  
                                     &   " T h e   S h a r e p o i n t   d i r e c t   l i n k   s h o u l d   l o o k   l i k e : " &   L i n e B r e a k  
                                     &   B a s e U r l   &   " s i t e s / S I T E N A M E / S h a r e d % 2 0 D o c u m e n t s / F O L D E R S / F I L E N A M E "  
                                     &   L i n e B r e a k   &   L i n e B r e a k  
                                     &   " F i n d   t h e   c o r r e c t   l i n k : "   &   L i n e B r e a k  
                                     &   " C l i c k   F i l e    >   C o p y   p a t h   f r o m   E x c e l   o r   O f f i c e   a p p l i c a t i o n "   &   L i n e B r e a k  
                                     &   " O r   u s e   " " P e o p l e   W i t h   E x i s t i n g   A c c e s s " "   o n   S h a r e P o i n t   o n l i n e   s h a r i n g   m e n u   "   &   L i n e B r e a k    
                                     &   " ( a n d   a s k   y o u r   I T   t o   s e t   i t   a s   d e f a u l t   S h a r e P o i n t   o p t i o n :   h t t p s : / / d o c s . m i c r o s o f t . c o m / e n - u s / s h a r e p o i n t / c h a n g e - d e f a u l t - s h a r i n g - l i n k ) "  
                             )  
                         e l s e  
                             n u l l  
                 i n  
                     o u t p u t ,    
             f n T y p e                     =   t y p e   f u n c t i o n   ( S h a r e P o i n t _ F i l e _ u r l   a s   t e x t )   a s   l i s t  
                 m e t a   [  
                     D o c u m e n t a t i o n . N a m e                         =   " S h a r e P o i n t _ F i l e " ,    
                     D o c u m e n t a t i o n . L o n g D e s c r i p t i o n   =   " R e t u r n s   t h e   S h a r e P o i n t   f i l e   ( b i n a r y )   w h e n   g i v e n   i t s   d i r e c t   S h a r e P o i n t   l i n k   < b r > "  
                         &   (  
                             i f   B a s e U r l _ U p d a t e d   t h e n  
                                 " "  
                             e l s e  
                                 " < b r > S h a r e P o i n t   r o o t   s i t e   u r l   h a s   t o   b e   h a r d c o d e d   t o   a v o i d   h a n d - a u t h o r e d   q u e r i e s   t h a t   c a n n o t   b e   r e f r e s h e d   i n   t h e   P o w e r   B I   s e r v i c e . < b r > "  
                                     &   " < b > P l e a s e   u p d a t e   T e n a n t N a m e   v a r i a b l e   i n   t h e   f i r s t   r o w   o f   t h e   f u n c t i o n   c o d e   ( i n   F o r m u l a   B a r   o r   A d v a n c e d   E d i t o r ) . < / b > < b r > "  
                                     &   " Y o u r   t e n a n t   n a m e   i s   u s u a l l y   y o u r   c o m p a n y   n a m e   ( y o u r   s h a r e p o i n t   u r l   s t a r t s   w i t h   T e n a n t N a m e . s h a r e p o i n t . c o m ) . < b r > "  
                         )  
                         &   " < b r > R e f r e s h   i n   P o w e r   B i   s e r v i c e   r e q u i r e s   t o   c h e c k   " " S k i p   t e s t   c o n n e c t i o n " "   i n   D a t a   s o u r c e   c r e d e n t i a l s . < b r > "  
                         &   " E x p l a n a t i o n s   a n d   u p d a t e s   o n   h t t p s : / / l i t t l e b i g f r o g . x y z "  
                 ]  
         i n  
             V a l u e . R e p l a c e T y p e ( f n ,   f n T y p e )  
 i n  
     S o u r c e   