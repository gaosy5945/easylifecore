<!DOCTYPE html>
<%@page import="java.net.InetAddress"%>
<%-- <%@page import="com.amarsoft.app.als.image.ImageAuthManage"%> --%>
<%@ page contentType="text/html; charset=GBK"%>
<script type="text/javascript" src="<%=request.getContextPath()%>/ImageTrans/jquery-1.7.2.min.js"></script>
<%@ include file="/IncludeBeginMD.jsp"%>

<%
	//获得组件参数	,影像对象号（客户号或申请号）、影像类型号  CurPage.getParameter("ObjectType");
	String sObjectType = "contract";
	String sObjectNo = CurPage.getParameter("ContractArtificialNo");
	String sTypeNo = CurPage.getParameter("ListType");
	String sRightType =  CurPage.getParameter("RightType");
	String sFlag =  CurPage.getParameter("Flag");
	if( sObjectType == null ) sObjectType = "";
	if( sObjectNo == null ) sObjectNo = "";
	if( sTypeNo == null ) sTypeNo = "";
	if( sRightType == null ) sRightType = "";
	if( sFlag == null ) sFlag = "1";
	System.out.println("****************"+sObjectType +"  " + sObjectNo+" "+sTypeNo+"   "+sRightType);
	
	//获取权限
	String sAuthCode = "";
	/* if( sRightType.equals( "ReadOnly" ) ) sAuthCode = "100";	//如果页面只读，则只有查看权
	else sAuthCode = ImageAuthManage.getAuthCode( sObjectType, sObjectNo, CurUser.getUserID() ); */
	sAuthCode = "111";
	
	//查找对应的docId
	ASResultSet resultSet= Sqlca.getResultSet( "select  documentId  from  ECM_PAGE where objectType='"+sObjectType+"' and objectNo='"+sObjectNo+"' and typeNo='"+sTypeNo+"' and documentId is not null order by pageNum");
	StringBuffer sbuf = new StringBuffer();
	while(resultSet.next()){
		sbuf.append(resultSet.getString("documentId")+"|");
	}
	resultSet.close();
	//本地环境
	String servletPath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+application.getContextPath()+"/servlet/view/image";
	System.out.println("----servletPath---"+servletPath);
		
	
%>


<html>
<head>

<script type="text/javascript" >
	function newPage(){
		AsControl.OpenPage("/ImageManage/NewImagePage.jsp","","");
		/* AsControl.OpenPage("/ImageManage/ImagePage.jsp","","");  */   <%-- "ContractArtificialNo="+<%=sObjectNo%>+"&ListType="+<%=sTypeNo%>+"&RightType="+<%=sRightType%> --%>
	} 
</script>

<title>影像资料</title>
</head>
<body>
<table>
<tr>
<td>
<input type="button" name="newPage" id="newPage" value="弹出" style="width: 50px" name="open" onclick="javascript:newPage();" >
</td>
</tr>
</table>
	<object id="amarsoftECMObject" classid="clsid:FED91F2B-DDF8-42E7-9CBF-6FA56B80EDF3" codebase="AmarECM_ActiveXSetup.CAB#version=1,0,0" width="100%" border="0" height="100%" style="margin:0px;border-width: 0;padding-top: 0px;"></object>
	
	<script type="text/javascript" >
		
	
		var obj = document.getElementById("amarsoftECMObject");
        function initActiveX() {
            obj.height = document.documentElement.clientHeight;
            	/* 参数：对象类型，对象编号，影像类型，权限控制代码，各个图片文件的路径(多张图片时以|为分割)，操作人，操作机构，处理影像的servlet地址 */
            obj.InitECM( "<%=sObjectType%>", "<%=sObjectNo%>",  "<%=sTypeNo%>", "<%=sAuthCode%>", "<%=sbuf.length()>0?sbuf.substring(0, sbuf.length()-1):""%>", "<%=CurUser.getUserID()%>", "<%=CurUser.getOrgID()%>",
            	"<%=servletPath%>" );
        }
           
       	$(document).ready(function(){
       		if(<%=sFlag%>=='2'){
       		 	$("#newPage").hide();
       		}
       		initActiveX();
    	});
       	
        function quitActiveX(){
       	   obj.UnloadECM();
          }
            
       	$(window).unload( function () { 
       		quitActiveX();
       	});
      </script>
</body>
</html>
<script type="text/javascript"> 

	
</script>

<%@ include file="/IncludeEnd.jsp"%>