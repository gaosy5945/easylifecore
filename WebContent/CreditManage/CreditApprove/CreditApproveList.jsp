<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	

    String flowSerialNo = CurPage.getParameter("FlowSerialNo");
	String taskSerialNo = CurPage.getParameter("TaskSerialNo");
	String flowNo = Sqlca.getString(new SqlObject("select FlowNo from FLOW_OBJECT where FlowSerialNo = :FlowSerialNo").setParameter("FlowSerialNo", flowSerialNo));
	String flowVersion = Sqlca.getString(new SqlObject("select FlowVersion from FLOW_OBJECT where FlowSerialNo = :FlowSerialNo").setParameter("FlowSerialNo", flowSerialNo));
	String phaseNo = CurPage.getParameter("PhaseNo");
    if(flowSerialNo == null) flowSerialNo = "";
    if(taskSerialNo == null) taskSerialNo = "";
    if(flowNo == null) flowNo = "";
    if(phaseNo == null) phaseNo = "";
    String tempno = "";
	if("".equals(taskSerialNo)){
		tempno = "CreditApproveList1";
	}else{
		tempno = "CreditApproveList";
	}
    ASObjectModel doTemp = new ASObjectModel(tempno);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--����ΪGrid���--
	dwTemp.ReadOnly = "1";	 //ֻ��ģʽ
	dwTemp.setPageSize(10);
	dwTemp.setParameter("FlowSerialNo", flowSerialNo);
	dwTemp.setParameter("TaskSerialNo", taskSerialNo);
	dwTemp.setParameter("PhaseNo", phaseNo);
	dwTemp.setParameter("UserID", CurUser.getUserID());
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
			//0���Ƿ�չʾ 1��	Ȩ�޿���  2�� չʾ���� 3����ť��ʾ���� 4����ť�������� 5����ť�����¼�����	6��	7��	8��	9��ͼ�꣬CSS�����ʽ 10�����
			{"true","","Button","����","����","edit()","","","","",""},
		};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function edit(){
		var taskSerialNo = getItemValue(0,getRow(),"TASKSERIALNO");
		var flowSerialNo = getItemValue(0,getRow(),"FLOWSERIALNO");
		var phaseNo = getItemValue(0,getRow(),"PHASENO");
		var flowNo = "<%=flowNo%>";
		var flowVersion = "<%=flowVersion%>";
		if(typeof(taskSerialNo)=="undefined" || taskSerialNo.length==0)  {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return ;
		}
		var returnValue = AsControl.RunASMethod("BusinessManage","QueryIsCanReadOpinion","<%=CurUser.getUserID()%>,"+flowSerialNo);
		//ֻ����ͳ�Ʋ�ѯʱ��������
		if(returnValue == "false" && "<%=tempno%>" == "CreditApproveList1"){
			alert("�Բ�����û��Ȩ�޲鿴���顣");
			return;
		}else{
			AsCredit.openFunction("SignTApproveInfo","FlowNo="+flowNo+"&FlowVersion="+flowVersion+"&TaskSerialNo="+taskSerialNo+"&FlowSerialNo="+flowSerialNo+"&PhaseNo="+phaseNo+"&RightType=ReadOnly");
		}
	}
/* function mySelectRow(){
		var taskSerialNo = getItemValue(0,getRow(),"TASKSERIALNO");
		var flowSerialNo = getItemValue(0,getRow(),"FLOWSERIALNO");
		var phaseNo = getItemValue(0,getRow(),"PHASENO");
		var flowNo = getItemValue(0,getRow(),"FLOWNO");
		var flowVersion = getItemValue(0,getRow(),"FLOWVERSION");
		 
		if(typeof(taskSerialNo)=="undefined" || taskSerialNo.length==0) {
			AsControl.OpenView("/Blank.jsp","TextToShow=����ѡ����Ӧ����Ϣ!","rightdown","");
		}else{
			AsControl.OpenView("/CreditManage/CreditApprove/CreditApproveInfo01.jsp","RightType=ReadOnly&TaskSerialNo="+taskSerialNo+"&FlowSerialNo="+flowSerialNo+"&PhaseNo="+phaseNo+"&FlowNo="+flowNo+"&FlowVersion="+flowVersion,"rightdown","");
		}
	}
	mySelectRow();  */
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
