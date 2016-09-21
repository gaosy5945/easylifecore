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
		content = "���Ӻ�ͬδ���ɣ���Ҫ���ɵ��Ӻ�ͬ!";
	}
	
	String sButtons[][] = {
			//0���Ƿ�չʾ 1��	Ȩ�޿���  2�� չʾ���� 3����ť��ʾ���� 4����ť�������� 5����ť�����¼�����	6��	7��	8��	9��ͼ�꣬CSS�����ʽ 10�����
			{"true","","Button","��ӡ���Ӻ�ͬ","��ӡ���Ӻ�ͬ","printContract()","","","","",""}
		};
%>
<html>
<head>
<title>�����ĵ�״̬</title>
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
		if(confirm("�Ƿ��������ɵ��Ӻ�ͬ��"))
			printSerialNo = RunJavaMethodTrans("com.amarsoft.app.als.edoc.EContractSevice", "updateEdocPrint", param);
	}
	OpenComp("ViewEDOC","/Common/EDOC/EDocView.jsp","SerialNo="+printSerialNo,"_blank","");
	top.close();
}

</script>
<%@ include file="/IncludeEnd.jsp"%>