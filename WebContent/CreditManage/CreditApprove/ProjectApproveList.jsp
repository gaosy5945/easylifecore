<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	

	String projectSerialNo = CurPage.getParameter("ProjectSerialNo");
    if(projectSerialNo == null) projectSerialNo = "";
    String tempno = "ProjectApproveList";
    ASObjectModel doTemp = new ASObjectModel(tempno);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--����ΪGrid���--
	dwTemp.ReadOnly = "1";	 //ֻ��ģʽ
	dwTemp.setPageSize(10);
	dwTemp.setParameter("PROJECTSERIALNO", projectSerialNo);
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
		var flowNo = getItemValue(0,getRow(),"FLOWNO");
		var flowVersion = getItemValue(0,getRow(),"FLOWVERSION");
		if(typeof(taskSerialNo)=="undefined" || taskSerialNo.length==0)  {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return ;
		}
		AsControl.PopView("/CreditManage/CreditApprove/ProjectApproveInfo.jsp", "FlowSerialNo="+flowSerialNo+"&TaskSerialNo="+taskSerialNo+"&RightType=ReadOnly");
		//AsCredit.openFunction("SignTApproveInfo","FlowNo="+flowNo+"&FlowVersion="+flowVersion+"&TaskSerialNo="+taskSerialNo+"&FlowSerialNo="+flowSerialNo+"&PhaseNo="+phaseNo+"&RightType=ReadOnly");
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
