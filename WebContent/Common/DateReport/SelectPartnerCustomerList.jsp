<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	ASObjectModel doTemp = new ASObjectModel("SelectPartnerCustomerList");
	doTemp.getCustomProperties().setProperty("JboWhereWhenNoFilter"," and 1=2 ");
	doTemp.setDataQueryClass("com.amarsoft.app.als.awe.ow.processor.impl.html.ALSListHtmlGenerator");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);

	dwTemp.Style="1";      	     //--����ΪGrid���--
	dwTemp.setParameter("InputOrgID", CurOrg.getOrgID());
	dwTemp.setPageSize(20);
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
			//0���Ƿ�չʾ 1��	Ȩ�޿���  2�� չʾ���� 3����ť��ʾ���� 4����ť�������� 5����ť�����¼�����	6��	7��	8��	9��ͼ�꣬CSS�����ʽ 10�����
			{"true","All","Button","����������","����������","viewAndEdit()","","","","btn_icon_detail",""},
		};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript" src="<%=sWebRootPath%>/CustomerManage/js/CustomerManage.js"></script>
<script type="text/javascript">

	function viewAndEdit(){
		var sSerialNo = getItemValue(0,getRow(0),"SerialNo");
		var sCustomerID = getItemValue(0,getRow(0),"CustomerID");
		var listType = getItemValue(0,getRow(0),"LISTTYPE");
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("��ѡ��һ����Ϣ��");
			return;
		}
		 CustomerManage.viewCustomerPartner(sCustomerID, listType);
	}

</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
