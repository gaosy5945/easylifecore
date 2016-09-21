<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String projectSerialNo = CurPage.getParameter("SerialNo");
	if(projectSerialNo == null) projectSerialNo = "";

	ASObjectModel doTemp = new ASObjectModel("PrjAlterHistory");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--����ΪGrid���--
	dwTemp.ReadOnly = "1";	 //ֻ��ģʽ
	dwTemp.setPageSize(10);
	dwTemp.setParameter("ObjectNo", projectSerialNo);
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
			//0���Ƿ�չʾ 1��	Ȩ�޿���  2�� չʾ���� 3����ť��ʾ���� 4����ť�������� 5����ť�����¼�����	6��	7��	8��	9��ͼ�꣬CSS�����ʽ 10�����
			{"true","All","Button","�������","�������","view()","","","","",""},
		};
%>
<HEAD>
<title>��Ŀ�����ʷ</title>
</HEAD>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function view(){
		var SerialNo = getItemValue(0,getRow(),"SERIALNO");
		var ProjectSerialNo = getItemValue(0,getRow(),"PROJECTSERIALNO");
		var ObjectNo = getItemValue(0,getRow(),"OBJECTNO");
		var RelativeType = getItemValue(0,getRow(),"RELATIVETYPE");
		if(typeof(SerialNo) == "undefined" || SerialNo.length == 0){
			alert("��ѡ��һ����Ϣ��");
			return;
		}
		var CustomerID = getItemValue(0,getRow(0),"CUSTOMERID");
		var functionID = "ProjectAlterInfo";
		var readFlag = "ReadOnly";
		var flowSerialNo = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.project.SelectFlowSerialNo", "selectFlowSerialNo", "ObjectNo="+ProjectSerialNo);
		AsCredit.openFunction(functionID,"SerialNo="+ProjectSerialNo+"&CustomerID="+CustomerID+"&RightType="+readFlag+"&flowSerialNo="+flowSerialNo,"");
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
