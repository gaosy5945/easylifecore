<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String customerID = CurPage.getParameter("CustomerID");
	String serialNo = CurPage.getParameter("SerialNo");

	ASObjectModel doTemp = new ASObjectModel("ProjectAssetdealList");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //设置为Grid风格
	//dwTemp.ReadOnly = "1";	 //编辑模式
	dwTemp.setPageSize(10);
	dwTemp.genHTMLObjectWindow(serialNo +"," + customerID);
	
	String sButtons[][] = {
			{"true","","Button","新增","新增","add()","","","","btn_icon_add",""},
			{"true","","Button","详情","详情","edit()","","","","btn_icon_detail",""},
			{"true","","Button","删除","删除","deleteRecord()","","","","btn_icon_delete",""},
		};
%> 
<script type="text/javascript">
	/*新增*/
	function add(){
		 var sUrl = "/CustomerManage/PartnerManage/ProjectAssetdealInfo.jsp";
		 OpenPage(sUrl,'_self','');
	}
	/*编辑信息*/
	function edit(){
		var customerID = getItemValue(0,getRow(),"CustomerID");
		if (typeof(customerID)=="undefined" || customerID.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		 var sUrl = "/CustomerManage/PartnerManage/ProjectAssetdealInfo.jsp";
		 OpenPage(sUrl+'?PSerialNo=' + getItemValue(0,getRow(0),'SerialNo'),'_self','');
	}
	/*删除记录*/
	function deleteRecord(){
		var customerID = getItemValue(0,getRow(),"CustomerID");
		if (typeof(customerID)=="undefined" || customerID.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		if(confirm('确实要删除吗?'))as_delete(0);
	}
</script>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%><%@
 include file="/Frame/resources/include/include_end.jspf"%>
