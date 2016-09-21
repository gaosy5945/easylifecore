<%@page import="com.amarsoft.app.als.edoc.EdocConst"%>
<%@page import="com.amarsoft.app.als.common.util.JBOHelper"%>
<%@page import="com.amarsoft.are.jbo.BizObject"%>
<%@page import="com.amarsoft.app.als.edoc.EContractSevice"%>
<%@ page import="com.amarsoft.app.als.edoc.EDocument"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ page import="org.jdom.JDOMException"%>
<%@ include file="/IncludeBegin.jsp"%>
 

<%
	String edocNo = "AAA";
	String objectNo = CurPage.getParameter("ObjectNo");
	String objectType = CurPage.getParameter("ObjectType");
	if(objectNo == null) objectNo = "";
	if(objectType == null) objectType = "";

	String fullPath = "";
	String content = "";
	
	EContractSevice service = new EContractSevice(objectNo, objectType, edocNo, CurUser.getUserID());
	String printSerial = service.getPrintSerialNo(null);
	if(!StringX.isEmpty(printSerial)){
		BizObject print = JBOHelper.querySingle(EdocConst.JBO_EDOC_PRINT, "SerialNo=:SerialNo", printSerial);
		fullPath = JBOHelper.getAttribute(print, "FullPath").toString();
	
		File dFileDef = new File(fullPath);
		if(dFileDef.exists()){
			String rowContent = new String();
	
			BufferedReader in = new BufferedReader(new FileReader(fullPath));
			while ((rowContent = in.readLine()) != null) {
			   content = content + rowContent + "\n";
			}
		}
	} else {
		content = "电子合同未生成，需要生成电子合同!";
	}
	
	String sButtons[][] = {
			//0、是否展示 1、	权限控制  2、 展示类型 3、按钮显示名称 4、按钮解释文字 5、按钮触发事件代码	6、	7、	8、	9、图标，CSS层叠样式 10、风格
			{"true","","Button","打印电子合同","打印电子合同","printContract()","","","","",""}
		};
%>
<html>
<head>
<title>电子文档状态</title>
</head>

<body leftmargin="0" topmargin="0" style="{overflow:scroll;overflow-x:visible;overflow-y:visible}">
<table width="99%" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td valign="top">
    <table width="90%" align=center border="0" cellspacing="0" cellpadding="4">
	    <tr align="left">
    	<%@ include file="/Frame/resources/include/ui/include_buttonset_dw.jspf"%>
	    </tr>
        <tr>
          <td>	
          <TEXTAREA NAME="Content" ROWS="24" COLS="120"><%=content%></TEXTAREA>
          </td>
        </tr>
	</table>
	</td>
  </tr>
</table>
</body>
</html>
<script type="text/javascript">
function printContract(){
	var objectNo = "<%=objectNo%>";
	var objectType = "<%=objectType%>";
	var edocNo = "<%=edocNo%>";
	
	var param = "ObjectNo="+objectNo+",ObjectType="+objectType+",EdocNo="+edocNo+",UserID=<%=CurUser.getUserID()%>";
	var printSerialNo = RunJavaMethodTrans("com.amarsoft.app.als.edoc.EContractSevice", "getPrintSerialNo", param);
	if(printSerialNo == ""){
		printSerialNo = RunJavaMethodTrans("com.amarsoft.app.als.edoc.EContractSevice", "initEdocPrint", param);
	} else {
		if(confirm("是否重新生成电子合同？"))
			printSerialNo = RunJavaMethodTrans("com.amarsoft.app.als.edoc.EContractSevice", "updateEdocPrint", param);
	}
	OpenComp("ViewEDOC","/Common/EDOC/EDocView.jsp","SerialNo="+printSerialNo,"_blank","");
	top.close();
}

</script>
<%@ include file="/IncludeEnd.jsp"%>