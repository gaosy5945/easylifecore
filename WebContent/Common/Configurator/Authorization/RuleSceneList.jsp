<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String authSerialNo = CurPage.getParameter("AuthSerialNo");
	if(authSerialNo == null || authSerialNo == "undefined") authSerialNo = "";
	ASObjectModel doTemp = new ASObjectModel("RuleSceneList");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--设置为Grid风格--
	dwTemp.ReadOnly = "1";	 //只读模式
	dwTemp.setParameter("AuthSerialNo", authSerialNo);
	dwTemp.setPageSize(10);
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
			{"true","","Button","新增授权模板","新增授权方案","newRecord()","","","",""},
			{"true","","Button","查看授权模板详情","编辑授权方案","editRecord()","","","",""},
			{"true","","Button","删除授权模板","删除授权方案","deleteRecord()","","","",""},
			};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	/*~[Describe=新增记录;InputParam=无;OutPutParam=无;]~*/
	function newRecord(){
		AsControl.PopView("/Common/Configurator/Authorization/RuleSceneInfo.jsp","AuthSerialNo=<%=authSerialNo%>","dialogWidth:750px;dialogHeight:700px;resizable:yes;scrollbars:no;status:no;help:no");
		reloadSelf();
	}
	
	/*~[Describe=编辑记录;InputParam=无;OutPutParam=无;]~*/
	function editRecord(){
		var serialNo = getItemValue(0,getRow(),"SerialNo");		//--流水号码
		if(typeof(serialNo)=="undefined" || serialNo.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息!
		}else{
			AsControl.PopView("/Common/Configurator/Authorization/RuleSceneInfo.jsp","AuthSerialNo=<%=authSerialNo%>&SerialNo="+serialNo,"dialogWidth:750px;dialogHeight:700px;resizable:yes;scrollbars:no;status:no;help:no");
			reloadSelf();
		}
	}
	/*~[Describe=删除记录;InputParam=无;OutPutParam=无;]~*/
	function deleteRecord(){
		var serialNo = getItemValue(0,getRow(),"SerialNo");		//--流水号码
		if(typeof(serialNo)=="undefined" || serialNo.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息!
		}else if(confirm(getHtmlMessage('2'))){//您真的想删除该信息吗？
			as_delete('myiframe0');
		}
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
