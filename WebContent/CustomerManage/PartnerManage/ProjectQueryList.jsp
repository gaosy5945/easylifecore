<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	ASObjectModel doTemp = new ASObjectModel("ProjectListForQuery");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //设置为Grid风格
	//dwTemp.ReadOnly = "1";	 //编辑模式
	dwTemp.setPageSize(20);
	dwTemp.genHTMLObjectWindow(CurUser.getOrgID());
	
	String sButtons[][] = {
			{"true","","Button","详情","详情","viewTab()","","","","btn_icon_detail",""},
		};
%> 
<script type="text/javascript">

	/*~[Describe=使用OpenComp打开详情;InputParam=无;OutPutParam=无;]~*/
	function viewTab(){
		var serialNo = getItemValue(0,getRow(0),"SerialNo");
		var customerID = getItemValue(0,getRow(0),"CustomerID");
		 if (typeof(serialNo)=="undefined" || serialNo.length==0){
	         alert(getHtmlMessage('1'));//请选择一条信息！
	         return;
	     }
		//打开详情页面
		popComp("","/CustomerManage/PartnerManage/ProjectTab.jsp","SerialNo="+serialNo+"&CustomerID="+customerID,"");
		reloadSelf();
	}
</script>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%><%@
 include file="/Frame/resources/include/include_end.jspf"%>
