<%@ page contentType="text/html; charset=GBK"%>
<%@ page import="com.amarsoft.app.base.util.BUSINESSOBJECT_CONSTANTS" %>
<%@ page import="com.amarsoft.app.base.businessobject.BusinessObjectManager" %>
<%@ page import="com.amarsoft.app.base.businessobject.BusinessObject" %>
<%@ page import="com.amarsoft.app.base.util.DateHelper" %>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%><%	
	ASObjectModel doTemp = new ASObjectModel("InvoiceLoan");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--����ΪGrid���--
	
	
	String orgID = CurOrg.getOrgID();
	
	String businessDate = DateHelper.getBusinessDate();
	String endDate = DateHelper.getRelativeDate(businessDate, DateHelper.TERM_UNIT_MONTH, 1);//���һ��������δ����Ʊ�ݵĻ���ƻ�
	
	//dwTemp.ShowSummary="1";	 	 //����
	dwTemp.ReadOnly = "1";	 //ֻ��ģʽ
	dwTemp.setPageSize(10);
	dwTemp.setParameter("ORGID", orgID);
	dwTemp.setParameter("ENDDATE", endDate);
	dwTemp.MultiSelect = true;	 //��ѡ
	dwTemp.genHTMLObjectWindow("");

	//0���Ƿ�չʾ 1��	Ȩ�޿���  2�� չʾ���� 3����ť��ʾ���� 4����ť�������� 5����ť�����¼�����	6��	7��	8��	9��ͼ�꣬CSS�����ʽ 10�����
	String sButtons[][] = {
		{"true","","Button","��Ʊ","��Ʊ","toInvoice()","","","","",""},
	};
%><%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function toInvoice(){
		var rows = getCheckedRows(0);
		if(typeof(rows)=="undefined" || rows.length==0) {
			alert("�빴ѡ��¼��");
			return;
		}
		var record = "";
		var productID = "";
		for(var i=0;i<rows.length;i++){
			record += "@"+getItemValue(0,rows[i],"SERIALNO");
			productID += "@" + getItemValue(0,rows[i],"PRODUCTID");
		}
		var products = productID.split("@");
		for(var i=1;i<products.length;i++){
			if(products[i] != products[1]){
				alert("ѡ���Ӧ�Ĳ�Ʒ��ͬ����ͬʱ��Ʊ");
				return;
			}
		}
		if(record.length>0)record=record.substring(1);
		
		var result = AsControl.PopPage("/InvoiceManage/CreatInvoiceInfo.jsp","record="+record+"&productID="+products[1],"resizable=yes;dialogWidth=450px;dialogHeight=300px;center:yes;status:no;statusbar:no");
		reloadSelf();
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>