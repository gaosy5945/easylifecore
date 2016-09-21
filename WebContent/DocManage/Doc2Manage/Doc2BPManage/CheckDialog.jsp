<%
/* Copyright 2001-2003 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author: bliu 2004.12.19 * Tester:
 * sUserID = PopPage("/SystemManage/GeneralSetup/AddUserConfirmDialog.jsp","","dialogWidth:350px;dialogHeight:150px;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no;");
 *
 * Content: 根据输入校验号码
 * Input Param:
 *
 * Output param:
 *
 * History Log: 
 *
 *
 */
%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<html>
<head> 
<title>输入密码</title>

<script language=javascript>

	function newUser()
	{
		var sUserID;
		sUserID = document.all("UserID").value;
       	if(typeof(sUserID)=="undefined" ||sUserID.length==0)
       	{
			alert("请输入密码！");
       	}else
       	{		
			self.returnValue = sUserID;
			self.close();
		}
	}	   


</script>
<style>
.black9pt {  font-size: 9pt; color: #000000; text-decoration: none}
</style>
</head>

<body bgcolor="#DEDFCE">
<br>
  <table align="center" width="329" border='1' cellspacing='0' bordercolor='#999999' bordercolordark='#FFFFFF'>
    
    <tr> 
      <td nowarp align="right" class="black9pt" bgcolor="#D8D8AF" >密码：</td>
      <td nowarp bgcolor="#F0F1DE"> 
        <input  type="password" name="UserID" value="">
      </td>
    </tr>
    <tr>
      <td nowarp align="right" class="black9pt" bgcolor="#D8D8AF" height="25" >&nbsp;</td>
      <td nowarp bgcolor="#F0F1DE" height="25"> 
        <input type="button" name="next" value="确认" onClick="javascript:newUser()" style="font-size:9pt;padding-top:3;padding-left:5;padding-right:5;background-image:url(<%=sWebRootPath%>/Resources/functionbg.gif); border: #DEDFCE;  border-style: outset; border-top-width: 1px; border-right-width: 1px;  border-bottom-width: 1px; border-left-width: 1px" border='1'>
        
        <input type="button" name="Cancel" value="取消" onClick="javascript:self.returnValue='_none_null_';self.close()" style="font-size:9pt;padding-top:3;padding-left:5;padding-right:5;background-image:url(<%=sWebRootPath%>/Resources/functionbg.gif); border: #DEDFCE;  border-style: outset; border-top-width: 1px; border-right-width: 1px;  border-bottom-width: 1px; border-left-width: 1px" border='1'>
      </td>
    </tr>
  </table>
</body>
</html>
<%@ include file="/IncludeEnd.jsp"%>