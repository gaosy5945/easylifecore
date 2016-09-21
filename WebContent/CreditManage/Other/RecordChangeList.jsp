<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String customerID =  CurPage.getParameter("CustomerID");
	if (customerID == null)	customerID = "";
	String objectType =  CurPage.getParameter("ObjectType");
	String objectNo =  CurPage.getParameter("ObjectNo");
	
	ASObjectModel doTemp = new ASObjectModel("RecordChangeList");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //设置为Grid风格
	//dwTemp.ReadOnly = "1";	 //编辑模式
	dwTemp.setPageSize(10);
	dwTemp.genHTMLObjectWindow(objectNo+","+objectType);
	
	String sButtons[][] = {
			{"false","","Button","详情","详情","edit()","","","","btn_icon_detail",""},
		};
%> 
<script type="text/javascript">
	function edit(){
		 var sUrl = "/CreditManage/Other/RecordChangeInfo.jsp";
		 OpenPage(sUrl + "?SerialNo=" + getItemValue(0,getRow(0),"SerialNo"), '_self','');
	}

	function mySelectRow(){
		var sDisplayLogMap=getItemValue(0,getRow(),"DisplayLogMap");
	 	if(parent  &&　parent.window.frames[Layout.getRegionName("rightdown")]&& parent.window.frames[Layout.getRegionName("rightdown")].showDetail){
	 		parent.window.frames[Layout.getRegionName("rightdown")].showDetail(sDisplayLogMap);
		 }
	}
</script>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%><%@
 include file="/Frame/resources/include/include_end.jspf"%>