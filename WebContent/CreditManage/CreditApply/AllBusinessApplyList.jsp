<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%
	String approveStatus = CurPage.getParameter("ApproveStatus");
	ASObjectModel doTemp = new ASObjectModel("AllBusinessApplyList");
	doTemp.getCustomProperties().setProperty("JboWhereWhenNoFilter"," and 1=2 ");//	
	doTemp.setDataQueryClass("com.amarsoft.app.als.awe.ow.processor.impl.html.ALSListHtmlGenerator");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--����ΪGrid���--
	dwTemp.ReadOnly = "1";	 //ֻ��ģʽ
	dwTemp.setPageSize(15);
	dwTemp.setParameter("OrgID", CurUser.getOrgID());
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
		//0���Ƿ�չʾ 1��	Ȩ�޿���  2�� չʾ���� 3����ť��ʾ���� 4����ť�������� 5����ť�����¼�����	6��	7��	8��	9��ͼ�꣬CSS�����ʽ 10�����
		//{"true","","Button","��ת��Ϣ","��ת��Ϣ","taskQry()","","","","",""},
		{"true","","Button","����","�鿴/�޸�����","edit()",""},
		//{"true","","Button","��ʷǩ�����","��ʷǩ�����","opinionLast()","","","","",""},
		{"true","","Button","����","����Excel","Export()","","","",""},
	};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function taskQry(){
		var flowSerialNo = getItemValue(0,getRow(),"FlowSerialNo");
		var isShowOpinion = "Y";
		if(typeof(flowSerialNo) == "undefined" || flowSerialNo.length == 0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		AsControl.PopView("/Common/WorkFlow/QueryFlowTaskList.jsp", "FlowSerialNo="+flowSerialNo+"&IsShowOpinion="+isShowOpinion,"dialogWidth:1300px;dialogHeight:590px;");
	}
	function opinionLast(){
		var serialNo = getItemValue(0,getRow(0),'SerialNo');
		if(typeof(serialNo) == "undefined" || serialNo.length == 0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		} 
		var flowSerialNo = getItemValue(0,getRow(0),'FlowSerialNo');
		AsControl.PopView("/CreditManage/CreditApprove/CreditApproveList.jsp", "FlowSerialNo="+flowSerialNo);
	}
	function edit(){
		var serialNo = getItemValue(0, getRow(0), "SerialNo");
		if(typeof(serialNo) == "undefined" || serialNo.length == 0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		//��ҳ��
		AsCredit.openFunction("ApplyMessageInfo","ObjectNo="+serialNo+"&ObjectType=jbo.app.BUSINESS_APPLY&RightType=ReadOnly","");
	}
	
	function Export(){
		if(s_r_c[0] > 1000){
			alert("���������������������1000���ڡ�");
			return;
		}
		as_defaultExport();
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
