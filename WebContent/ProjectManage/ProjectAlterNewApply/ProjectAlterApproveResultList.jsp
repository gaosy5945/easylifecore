<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String Status = CurPage.getParameter("Status");
	if(Status == null) Status = "";

	ASObjectModel doTemp = new ASObjectModel("ProjectAlterApproveResultList");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--����ΪGrid���--
	dwTemp.ReadOnly = "1";	 //ֻ��ģʽ
	dwTemp.setPageSize(10);
	dwTemp.setParameter("Status", Status);
	dwTemp.setParameter("InputUserID", CurUser.getUserID());
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
			//0���Ƿ�չʾ 1��	Ȩ�޿���  2�� չʾ���� 3����ť��ʾ���� 4����ť�������� 5����ť�����¼�����	6��	7��	8��	9��ͼ�꣬CSS�����ʽ 10�����
			{"true","","Button","��Ŀ�������","��Ŀ�������","edit()","","","","",""},
		};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function edit(){
		var projectSerialNo = getItemValue(0,getRow(0),"PROJECTSERIALNO");
		if(typeof(projectSerialNo) == "undefined" || projectSerialNo.length == 0){
			alert("��ѡ��һ����Ϣ��");
			return;
		}
		var CustomerID = getItemValue(0,getRow(0),"CUSTOMERID");
		var functionID = "ProjectAlterInfo";
		var RightType = "ReadOnly";
		var flowSerialNo = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.project.SelectFlowSerialNo", "selectFlowSerialNo", "ObjectNo="+projectSerialNo);
		AsCredit.openFunction(functionID,"SerialNo="+projectSerialNo+"&CustomerID="+CustomerID+"&RightType="+RightType+"&FlowSerialNo="+flowSerialNo+"&OpinionFlag=1","");
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
