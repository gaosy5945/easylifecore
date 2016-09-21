<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String agencyType = CurPage.getParameter("AgencType");
	if(agencyType == null) agencyType = "";


	ASObjectModel doTemp = new ASObjectModel("AgencyList");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //设置为Grid风格
	//dwTemp.ReadOnly = "1";	 //编辑模式
	dwTemp.setPageSize(10);
	dwTemp.genHTMLObjectWindow(agencyType);
	
	String sButtons[][] = {
			{"true","","Button","新增","新增","newRecord()","","","","btn_icon_add",""},
			{"true","","Button","详情","查看","viewAndEdit()","","","","btn_icon_detail",""},
			{"true","","Button","删除","删除","deleteRecord()","","","","btn_icon_delete",""},
		};
%> 
<script type="text/javascript">
/*~[Describe=新增记录;InputParam=无;OutPutParam=无;]~*/
	function newRecord(){
		OpenPage("/CustomerManage/PartnerManage/AgencyInfo.jsp","_self","");
	}
	
	/*~[Describe=删除记录;InputParam=无;OutPutParam=无;]~*/
	function deleteRecord(){
		var serialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(serialNo)=="undefined" || serialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		
		if(confirm(getHtmlMessage('2')))//您真的想删除该信息吗？
		{
			as_delete(0);
			//as_del(0);
		}
	}

	/*~[Describe=查看及修改详情;InputParam=无;OutPutParam=无;]~*/
	function viewAndEdit()
	{
		var serialNo = getItemValue(0,getRow(),"SerialNo");
		
		if (typeof(serialNo)=="undefined" || serialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		
		OpenPage("/CustomerManage/PartnerManage/AgencyInfo.jsp?SerialNo="+serialNo, "_self","");
	}

</script>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%><%@
 include file="/Frame/resources/include/include_end.jspf"%>
