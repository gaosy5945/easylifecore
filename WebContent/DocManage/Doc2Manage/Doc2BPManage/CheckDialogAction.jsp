<%
/* Copyright 2001-2003 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author: 		
 * Tester:
 * Content: 	
 * Input Param:
 *              
 *
 * Output param:    
 */
%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>
<%
	String sSuccess="false";
	String sPassword   = DataConvert.toRealString(iPostChange,(String)request.getParameter("Password"));
	//MD5 md5 = new MD5();
	//String EnPassword = md5.getMD5ofStr(sPassword);
	String EnPassword = MessageDigest.getDigestAsUpperHexString("MD5", sPassword);
	if (EnPassword.equals(CurUser.getPassword())) {
		sSuccess="true";
	}

%>
<script language=javascript>
	self.returnValue = "<%=sSuccess%>";
	self.close();
</script>
<%@ include file="/IncludeEnd.jsp"%>