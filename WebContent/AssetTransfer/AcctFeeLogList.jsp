<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	
	String objectNo = DataConvert.toString(CurPage.getParameter("ObjectNo"));
	String objectType = DataConvert.toString(CurPage.getParameter("ObjectType"));
	String isQuery = DataConvert.toString(CurPage.getParameter("isQuery"));//是否是查询页面

	ASObjectModel doTemp = new ASObjectModel("AcctFeeLogList");
	doTemp.setDDDWJbo("FEESERIALNO","jbo.acct.ACCT_FEE,SERIALNO,FEENAME,ObjectType='"+objectType+"' and ObjectNo='"+objectNo+"'");
	
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //设置为Grid风格
	//dwTemp.ReadOnly = "1";	 //编辑模式
	dwTemp.setPageSize(10);
	dwTemp.genHTMLObjectWindow(objectNo+","+objectType);
	
	String sButtons[][] = {
			{!"true".equals(isQuery)?"true":"false","","Button","新增","新增","add()","","","","btn_icon_add",""},
			{"true","","Button","详情","详情","edit()","","","","btn_icon_detail",""},
			{!"true".equals(isQuery)?"true":"false","","Button","删除","删除","del()","","","","btn_icon_delete",""},
			{"true".equals(isQuery)?"true":"false","","Button","导出","导出","asExport()","","","","",""},
		};
%> 
<script type="text/javascript">
	function add(){
		var sObjectNo = '<%=objectNo%>';
		var sObjectType = '<%=objectType%>';
		var serialNo = getItemValue(0,getRow(0),"SerialNo");
	 	var sUrl = "/AssetTransfer/AcctFeeLogInfo.jsp";
	 	OpenPage(sUrl+'?ObjectNo='+sObjectNo+'&ObjectType='+sObjectType+'&SerialNo='+serialNo,'_self','');
	}
	
	function edit(){
		var serialNo = getItemValue(0,getRow(0),"SerialNo");
		if(typeof(serialNo) == 'undefined' || serialNo.length == 0){
			alert("请先选择一条记录");
			return;
		}
		
	 	var sUrl = "/AssetTransfer/AcctFeeLogInfo.jsp";
	 	OpenPage(sUrl+'?SerialNo='+serialNo,'_self','');
	}
	
	function del(){
		var serialNo = getItemValue(0,getRow(0),"SerialNo");
		if(typeof(serialNo) == 'undefined' || serialNo.length == 0){
			alert("请先选择一条记录");
			return;
		}
		
		if(confirm('确实要删除吗?')){
			as_delete(0);
		}
	}
	
	function asExport(){
		
	}
</script>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%><%@
 include file="/Frame/resources/include/include_end.jspf"%>
