<!DOCTYPE html>
<%@page import="java.net.InetAddress"%>
<%-- <%@page import="com.amarsoft.app.als.image.ImageAuthManage"%> --%>
<%@ page contentType="text/html; charset=GBK"%>
<script type="text/javascript" src="<%=request.getContextPath()%>/ImageTrans/jquery-1.7.2.min.js"></script>
<%@ include file="/IncludeBeginMD.jsp"%>

<%
	//����������	,Ӱ�����ţ��ͻ��Ż�����ţ���Ӱ�����ͺ�  CurPage.getParameter("ObjectType");
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
	
	//��ȡȨ��
	String sAuthCode = "";
	/* if( sRightType.equals( "ReadOnly" ) ) sAuthCode = "100";	//���ҳ��ֻ������ֻ�в鿴Ȩ
	else sAuthCode = ImageAuthManage.getAuthCode( sObjectType, sObjectNo, CurUser.getUserID() ); */
	sAuthCode = "111";
	
	//���Ҷ�Ӧ��docId
	ASResultSet resultSet= Sqlca.getResultSet( "select  documentId  from  ECM_PAGE where objectType='"+sObjectType+"' and objectNo='"+sObjectNo+"' and typeNo='"+sTypeNo+"' and documentId is not null order by pageNum");
	StringBuffer sbuf = new StringBuffer();
	while(resultSet.next()){
		sbuf.append(resultSet.getString("documentId")+"|");
	}
	resultSet.close();
	//���ػ���
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

<title>Ӱ������</title>
</head>
<body>
<table>
<tr>
<td>
<input type="button" name="newPage" id="newPage" value="����" style="width: 50px" name="open" onclick="javascript:newPage();" >
</td>
</tr>
</table>
	<object id="amarsoftECMObject" classid="clsid:FED91F2B-DDF8-42E7-9CBF-6FA56B80EDF3" codebase="AmarECM_ActiveXSetup.CAB#version=1,0,0" width="100%" border="0" height="100%" style="margin:0px;border-width: 0;padding-top: 0px;"></object>
	
	<script type="text/javascript" >
		
	
		var obj = document.getElementById("amarsoftECMObject");
        function initActiveX() {
            obj.height = document.documentElement.clientHeight;
            	/* �������������ͣ������ţ�Ӱ�����ͣ�Ȩ�޿��ƴ��룬����ͼƬ�ļ���·��(����ͼƬʱ��|Ϊ�ָ�)�������ˣ���������������Ӱ���servlet��ַ */
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