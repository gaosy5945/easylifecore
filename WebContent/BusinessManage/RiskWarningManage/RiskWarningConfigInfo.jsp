<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
	String sSIGNALID = CurPage.getParameter("SIGNALID");
	if(sSIGNALID == null) sSIGNALID = "";
	String sObjectType = CurPage.getParameter("ObjectType");
	if(sObjectType == null) sObjectType = "";
	String serialNo = CurPage.getParameter("SerialNo");
	if(serialNo == null) serialNo = "";
	
	String sTempletNo = "";
	if("01".equals(sObjectType)){
		sTempletNo = "RiskWarningConfigInfo01";//--模板号--
    }
	if("02".equals(sObjectType)){
		sTempletNo = "RiskWarningConfigInfo02";//--模板号--
	}
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	//dwTemp.ReadOnly = "-2";//只读模式
	dwTemp.genHTMLObjectWindow(sSIGNALID);
	String sButtons[][] = {
			//{"true","","Button","保存并新增","保存本次修改后，显示新增页面","saveRecord(1)","","","",""},
			{"true","","Button","保存","保存修改信息","saveRecord(2)","","","",""},
			{"true","","Button","返回","返回参数配置列表","goBack()","","","",""},
	};
	//sButtonPosition = "south";
%>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">

/*~[Describe=保存;InputParam=后续事件;OutPutParam=无;]~*/
	function saveRecord(sPostEvents){
		
		if("1"==sPostEvents)
		{
			as_save("myiframe0","newRecord();");	
		}
		else{
			as_save("myiframe0");	
		}
	}

	/*~[Describe=返回列表页面;InputParam=无;OutPutParam=无;]~*/
	function goBack(){
		OpenPage("/BusinessManage/RiskWarningManage/RiskWarningConfigList.jsp","_self","");
	}
	
	function newRecord(){
		OpenPage("/BusinessManage/RiskWarningManage/RiskWarningConfigInfo.jsp","_self","");
	}
	//SIGNALID字段赋值；
	function inertSignalNo(){
		var serialNo = "<%=serialNo%>";
		if(typeof(serialNo) != "undefined" && serialNo != ""){
			
			setItemValue(0,getRow(),"SIGNALID","<%=serialNo%>");
		}
	}
	
 	$(document).ready(function(){

 		inertSignalNo();
 	});
	
	
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
