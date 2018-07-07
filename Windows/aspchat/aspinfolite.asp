<%@ Language="VBSCRIPT" %>
<%

    '**************************************
    ' Name: aspinfo()
    ' Description:aspinfo() is the equivalent of phpinfo(). It displays all kinds of
    '     information about the server, asp, cookies, sessions and several other things in
    '     a neat table, properly formatted.
    ' By: Dennis Pallett (from psc cd)
    '
    '
    ' Inputs:None
    '
    ' Returns:None
    '
    'Assumes:You can include my code in any of your pages and call aspinfo() to show
    '     the information of your server and asp. 
    '
    '**************************************

Sub aspinfo()
    Dim strVariable, strASPVersion
    Dim strCookie, strKey, strSession
    'Retrieve the version of ASP
    strASPVersion = ScriptEngine & " Version " & ScriptEngineMajorVersion & "." & ScriptEngineMinorVersion
%>
    <!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
    <html>
    <head>
    <style type="text/css"><!--
    a { text-decoration: none; }
    a:hover { text-decoration: underline; }
    h1 { font-family: arial, helvetica, sans-serif; font-size: 18pt; font-weight: bold;}
    h2 { font-family: arial, helvetica, sans-serif; font-size: 14pt; font-weight: bold;}
    body, td { font-family: arial, helvetica, sans-serif; font-size: 10pt; }
    th { font-family: arial, helvetica, sans-serif; font-size: 10pt; font-weight: bold; }
    //--></style>
    <title>aspinfo()</title></head>
    <body>
    <div align="center">
    <table width="80%" border="0" bgcolor="#000000" cellspacing="1" cellpadding="3">
    <tr>
        <td align="center" valign="top" bgcolor="#FFFFAE" align="left" colspan="2">
            <h3>ASP (<%= strASPVersion %>)</h3>
        </td>
    </tr>
    </table>
    <br>
    <hr>
    <br>
    <h3>Server Variables</h3>
    <table width="80%" border="0" bgcolor="#000000" cellspacing="1" cellpadding="3">
<%
    For Each strVariable In Request.ServerVariables
      Response.write("<tr>")
      Response.write("<th width=""30%"" bgcolor=""#FFFFAE"" align=""left"">" & strVariable & "</th>")
      Response.write("<td bgcolor=""#FFFFD9"" align=""left"">" & Request.ServerVariables(strVariable) & "&nbsp;</td>")
      Response.write("</tr>")
    Next 'strVariable
%>
    </table>
    <br>
    <hr>
    <br>
    <h3>Cookies</h3>
    <table width="80%" border="0" bgcolor="#000000" cellspacing="1" cellpadding="3">
<%
    For Each strCookie In Request.Cookies
        If Not Request.Cookies(strCookie).HasKeys Then
            Response.write("<tr>")
            Response.write("<th width=""30%"" bgcolor=""#FFFFAE"" align=""left"">" & strCookie & "</th>")
            Response.write("<td bgcolor=""#FFFFD9"" align=""left"">" & Request.Cookies(strCookie) & "&nbsp;</td>")
            Response.write("</tr>")
        Else
            For Each strKey In Request.Cookies(strCookie)
                Response.write("<tr>")
                Response.write("<th width=""30%"" bgcolor=""#FFFFAE"" align=""left"">" & strCookie & "(" & strKey & ")</th>")
                Response.write("<td bgcolor=""#FFFFD9"" align=""left"">" & Request.Cookies(strCookie)(strKey) & "&nbsp;</td>")
                Response.write("</tr>")
            Next
        End If
    Next
%>
    </table>
    <br>
    <hr>
    <br>
    <h3>Session Cookies</h3>
    <table width="80%" border="0" bgcolor="#000000" cellspacing="1" cellpadding="3">
<%
    For Each strSession In Session.Contents
            Response.write("<tr>")
            Response.write("<th width=""30%"" bgcolor=""#FFFFAE"" align=""left"">" & strSession & "</th>")
            Response.write("<td bgcolor=""#FFFFD9"" align=""left"">" & Session(strSession) & "&nbsp;</td>")
            Response.write("</tr>")
    Next
%>
    </table>
    <br>
    <hr>
    <br>
    <h3>Other variables</h3>
    <table width="80%" border="0" bgcolor="#000000" cellspacing="1" cellpadding="3">
    <tr><th width="30%" bgcolor="#FFFFAE" align="left">Session.sessionid</th><td bgcolor="#FFFFD9"><%= Session.sessionid %></td></tr>
    <tr><th width="30%" bgcolor="#FFFFAE" align="left">Server.MapPath</th><td bgcolor="#FFFFD9"><%= Server.MapPath ("/") %></td></tr>
    </table>
    </div>
    </body>
    </html>
<%
End Sub
aspinfo()
%>