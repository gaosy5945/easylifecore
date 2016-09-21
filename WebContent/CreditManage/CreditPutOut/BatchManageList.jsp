<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String functionID = CurPage.getParameter("FunctionID");
	
	ASObjectModel doTemp = new ASObjectModel("BatchManageList");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--设置为Grid风格--
	dwTemp.ReadOnly = "1";	 //只读模式
	dwTemp.setPageSize(10);
	dwTemp.setParameter("UserID", CurUser.getUserID());
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
			//0、是否展示 1、	权限控制  2、 展示类型 3、按钮显示名称 4、按钮解释文字 5、按钮触发事件代码	6、	7、	8、	9、图标，CSS层叠样式 10、风格
			{"true","","Button","新增","新增一条记录","newRecord()","","","",""},
			{"true","","Button","详情","查看/修改详情","viewAndEdit()","","","",""},
			{"true","","Button","删除","删除所选中的记录","deleteRecord()","","","",""},
		};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function newRecord(){
		var returnValue = AsControl.RunJavaMethodTrans("com.amarsoft.acct.accounting.web.AddBatchApply","add","UserID=<%=CurUser.getUserID()%>,OrgID=<%=CurUser.getOrgID()%>,BatchType=<%=CurPage.getParameter("BatchType")%>");
		if(typeof(returnValue) == "undefined" || returnValue == null || returnValue.length ==0) return;
		else(returnValue.split("@")[0] =="true")
		{
			var batchSerialNo = returnValue.split("@")[1];
			AsCredit.openFunction("<%=functionID%>","SerialNo="+batchSerialNo);
		}
		reloadSelf();
	}
	
	function viewAndEdit(){
		var serialNo = getItemValue(0,getRow(),"SerialNo");
		if(typeof(serialNo)=="undefined" || serialNo.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
            return ;
		}else{
			AsCredit.openFunction("<%=functionID%>","SerialNo="+serialNo);
		}
	}
	
	function deleteRecord(){
		var serialNo = getItemValue(0,getRow(),"SerialNo");
        if(typeof(serialNo) == "undefined" || serialNo.length == 0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
            return ;
		}
		
		if(confirm(getHtmlMessage('2'))){ //您真的想删除该信息吗？
			as_del("myiframe0");
			as_save("myiframe0");  //如果单个删除，则要调用此语句
		}
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
