<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String endDays = CurPage.getParameter("EndDays");
	String MaturityDate = com.amarsoft.app.base.util.DateHelper.getRelativeDate(com.amarsoft.app.base.util.DateHelper.getBusinessDate(), com.amarsoft.app.base.util.DateHelper.TERM_UNIT_DAY, Integer.parseInt(endDays));
	ASObjectModel doTemp = new ASObjectModel("CLToDate");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--����ΪGrid���--
	dwTemp.ReadOnly = "1";	 //ֻ��ģʽ
	dwTemp.setPageSize(15);
	dwTemp.setParameter("MaturityDate", MaturityDate);
	dwTemp.setParameter("OrgID", CurUser.getOrgID());
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
			//0���Ƿ�չʾ 1��	Ȩ�޿���  2�� չʾ���� 3����ť��ʾ���� 4����ť�������� 5����ť�����¼�����	6��	7��	8��	9��ͼ�꣬CSS�����ʽ 10�����
			{"true","","Button","����","����","view()","","","","btn_icon_detail",""},
		};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
function view(){
	 var serialNo = getItemValue(0,getRow(0),"SERIALNO");
	 if(typeof(serialNo) == "undefined" || serialNo.length == 0){
		 alert("��ѡ��һ�����룡");
		 return;
	 }
	 AsControl.PopComp("/CreditLineManage/CreditLineLimit/CreditLine/CLInfo.jsp","SerialNo="+serialNo,"resizable=yes;dialogWidth=900px;dialogHeight=420px;center:yes;status:no;statusbar:no");
}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
