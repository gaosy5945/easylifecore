<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String batchSerialNo = CurPage.getParameter("BatchSerialNo");
	
	ASObjectModel doTemp = new ASObjectModel("BatchPutOutList");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--����ΪGrid���--
	dwTemp.ReadOnly = "1";	 //ֻ��ģʽ
	dwTemp.setPageSize(10);
	dwTemp.setParameter("BatchSerialNo", batchSerialNo);
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
			//0���Ƿ�չʾ 1��	Ȩ�޿���  2�� չʾ���� 3����ť��ʾ���� 4����ť�������� 5����ť�����¼�����	6��	7��	8��	9��ͼ�꣬CSS�����ʽ 10�����
		};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
function mySelectRow(){
	var serialNo = getItemValue(0,getRow(),"SerialNo");
	if(typeof(serialNo)=="undefined" || serialNo.length==0) {
		return;
	}else{
		AsControl.PopView("/CreditManage/CreditPutOut/CreditPutOutInfo.jsp","ObjectType=jbo.app.BUSINESS_PUTOUT&ObjectNo="+serialNo,"");
	}
}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
