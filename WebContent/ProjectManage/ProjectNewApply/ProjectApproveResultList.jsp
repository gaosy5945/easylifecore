<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String StatusTemp = CurPage.getParameter("Status");
	if(StatusTemp == null) StatusTemp= "";
	String Status = StatusTemp.replace(",", "','");
	ASObjectModel doTemp = new ASObjectModel("ProjectApproveResultList");
	doTemp.setJboWhere(doTemp.getJboWhere()+" and O.Status in ('"+Status+"')");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);

	dwTemp.Style="1";      	     //--����ΪGrid���--
	dwTemp.ReadOnly = "1";	 //ֻ��ģʽ
	dwTemp.setPageSize(10);
	dwTemp.setParameter("Status", Status);
	dwTemp.setParameter("InputUserID", CurUser.getUserID());
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
			//0���Ƿ�չʾ 1��	Ȩ�޿���  2�� չʾ���� 3����ť��ʾ���� 4����ť�������� 5����ť�����¼�����	6��	7��	8��	9��ͼ�꣬CSS�����ʽ 10�����
			{"true","All","Button","������Ŀ����","������Ŀ����","projectView()","","","","",""},
			};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function projectView(){
		var projectSerialNo = getItemValue(0,getRow(0),"SERIALNO");
		if(typeof(projectSerialNo) == "undefined" || projectSerialNo.length == 0){
			alert("��ѡ��һ����Ϣ��");
			return;
		}
		var CustomerID = getItemValue(0,getRow(0),"CUSTOMERID");
		var functionID = "ProjectAlterApproveInfo";
		var readFlag = "ReadOnly";
		var flowSerialNo = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.project.SelectFlowSerialNo", "selectFlowSerialNo", "ObjectNo="+projectSerialNo);
		AsCredit.openFunction(functionID,"SerialNo="+projectSerialNo+"&CustomerID="+CustomerID+"&FlowSerialNo="+flowSerialNo+"&readFlag="+readFlag,"");
		reloadSelf();
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
