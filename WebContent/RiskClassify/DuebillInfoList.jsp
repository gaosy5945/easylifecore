<%@ page contentType="text/html; charset=GBK"%>
<%@page import="com.amarsoft.app.base.util.ObjectWindowHelper"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String sSerialNo = CurPage.getParameter("SerialNo");
	String sFlowSerialNo = CurPage.getParameter("FlowSerialNo");
	String sTaskSerialNo = CurPage.getParameter("TaskSerialNo");
	String flag = CurPage.getParameter("Flag");
	if(sSerialNo == null) sSerialNo = "";
	if(sFlowSerialNo == null) sFlowSerialNo = "";
	if(sTaskSerialNo == null) sTaskSerialNo = "";
	
	ASObjectModel doTemp = new ASObjectModel("ClassifyDuebillList");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);

	dwTemp.Style="1";      	     //--����ΪGrid���--
	dwTemp.ReadOnly = "1";	 //ֻ��ģʽ
	dwTemp.setPageSize(10);
	dwTemp.setParameter("FlowSerialNo",sFlowSerialNo);
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
			//0���Ƿ�չʾ 1��	Ȩ�޿���  2�� չʾ���� 3����ť��ʾ���� 4����ť�������� 5����ť�����¼�����	6��	7��	8��	9��ͼ�꣬CSS�����ʽ 10�����
		};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function mySelectRow(){
		var duebillSerialNo = getItemValue(0,getRow(),"SerialNo");
		if(typeof(duebillSerialNo)=="undefined" || duebillSerialNo.length==0) return;
		if("<%=flag%>" =="RiskWarning"){
			AsControl.OpenComp("/BusinessManage/RiskWarningManage/RiskWarningManageInfo.jsp","SerialNo="+duebillSerialNo,"rightdown","");
		}else if("<%=flag%>" =="CLColl"){
			AsControl.OpenComp("/CreditManage/Collection/CLCollTaskInfo.jsp","ObjectNo="+duebillSerialNo+"&ObjectType=jbo.app.BUSINESS_DUEBILL","rightdown","");
		}else
			AsControl.OpenComp("/CreditManage/AfterBusiness/DuebillInfo.jsp","DuebillSerialNo="+duebillSerialNo,"rightdown","");
	}

</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
