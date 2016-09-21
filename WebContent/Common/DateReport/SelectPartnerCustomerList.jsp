<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	ASObjectModel doTemp = new ASObjectModel("SelectPartnerCustomerList");
	doTemp.getCustomProperties().setProperty("JboWhereWhenNoFilter"," and 1=2 ");
	doTemp.setDataQueryClass("com.amarsoft.app.als.awe.ow.processor.impl.html.ALSListHtmlGenerator");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);

	dwTemp.Style="1";      	     //--设置为Grid风格--
	dwTemp.setParameter("InputOrgID", CurOrg.getOrgID());
	dwTemp.setPageSize(20);
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
			//0、是否展示 1、	权限控制  2、 展示类型 3、按钮显示名称 4、按钮解释文字 5、按钮触发事件代码	6、	7、	8、	9、图标，CSS层叠样式 10、风格
			{"true","All","Button","合作方详情","合作方详情","viewAndEdit()","","","","btn_icon_detail",""},
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
			alert("请选择一条信息！");
			return;
		}
		 CustomerManage.viewCustomerPartner(sCustomerID, listType);
	}

</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
