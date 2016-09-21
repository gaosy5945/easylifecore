<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String sObjectType = DataConvert.toString(CurPage.getParameter("ObjectType"));

	String sTempletNo = "";
	if("01".equals(sObjectType)){
	    sTempletNo = "RiskWarningConfigList01";
	}else if("02".equals(sObjectType)){
		sTempletNo = "RiskWarningConfigList02";
	}
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--设置为Grid风格--
	dwTemp.ReadOnly = "1";	 //只读模式
	dwTemp.setPageSize(20);
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
		
		var sTableName = "RISK_WARNING_CONFIG";//表名
		var sColumnName = "SIGNALID";//字段名
		var sPrefix = "";//前缀
		//获取流水号
		var serialNo = getSerialNo(sTableName,sColumnName,sPrefix);
		
		AsControl.OpenView("/BusinessManage/RiskWarningManage/RiskWarningConfigInfo.jsp","SerialNo="+serialNo+"&ObjectType=<%=sObjectType%>","_self","");
	}
	
	function viewAndEdit(){
		var sSIGNALID = getItemValue(0,getRow(),"SIGNALID");
		if(typeof(sSIGNALID)=="undefined" || sSIGNALID.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
			return ;
		}
		AsControl.OpenView("/BusinessManage/RiskWarningManage/RiskWarningConfigInfo.jsp","SIGNALID="+sSIGNALID+"&ObjectType=<%=sObjectType%>","_self","");
	}
	
	function deleteRecord(){
		var signalID = getItemValue(0,getRow(),"SIGNALID");
		if(typeof(signalID)=="undefined" || signalID.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		if(confirm(getHtmlMessage('2'))){
			AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.afterloan.action.RiskWarningConfig","setConfigStatus","SignalID="+signalID);
			
			reloadSelf();
		}
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
