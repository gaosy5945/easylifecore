<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
	/*
		Content:    流程模型信息详情
	 */
	String PG_TITLE = "流程模型信息"; // 浏览器窗口标题 <title> PG_TITLE </title>
	
	//获得组件参数	FlowNo：流程编号
	String sFlowNo =  CurComp.getParameter("FlowNo"));
	String sFlowVersion =  CurComp.getParameter("FlowVersion"));
	String sFlag =  CurComp.getParameter("Flag"));
	if(sFlowNo==null) sFlowNo="";
	if(sFlowVersion==null) sFlowVersion="";
	if(sFlag==null) sFlag = "N";
   	
   	String sTempletNo = "FlowCatalogInfo";
   	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	
   	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sFlowNo+","+sFlowVersion);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
	String sButtons[][] = {
		{"true","","Button","保存","保存修改","saveRecord()","","","",""},
		{("Y".equals(sFlag) ? "false" : "true"),"","Button","返回","返回列表页面","goBack()","","","",""}
	};
%>
<%@include file="/Frame/resources/include/ui/include_info.jspf" %>
<script type="text/javascript">
	var bIsInsert = false; //标记DW是否处于“新增状态”
	
	function saveRecord(){
       as_save("myiframe0","");
       reloadself();
	}
    
	function saveRecordAndAdd(){
       var sAAEnabled = getItemValue(0,getRow(),"AAEnabled");
		if(sAAEnabled == "1"){ //是否进行授权设置
			sAAPolicyName = getItemValue(0,getRow(),"AAPolicyName");
			if (typeof(sAAPolicyName)=="undefined" || sAAPolicyName.length==0){
				alert("请选择授权方案！"); 
				return;
			}
		}else{
			//将所填写的授权方案置为空字符串
			setItemValue(0,0,"AAPolicy","");
			setItemValue(0,0,"AAPolicyName",""); 
		}
       as_save("myiframe0","newRecord()");        
	}
	
	function newRecord(){
        OpenComp("FlowCatalogInfo","/Common/Configurator/FlowManage/FlowCatalogInfo.jsp","","_self","");
	}

	function goBack(){
		AsControl.OpenView("/Common/Configurator/FlowManage/FlowCatalogList.jsp","","_self");
	}
	
	/*~[Describe=弹出授权方案选择窗口;InputParam=无;OutPutParam=无;]~*/
	function getPolicyID(){
		var sParaString = "Today"+",<%=StringFunction.getToday()%>";
		setObjectValue("SelectPolicy",sParaString,"@AAPolicy@0@AAPolicyName@1",0,0,"");
	}
	
	function initRow(){
		if (getRowCount(0)==0){
			as_add("myiframe0");
			setItemValue(0,0,"InputUserID","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"InputOrgID","<%=CurUser.getOrgID()%>");
			setItemValue(0,0,"InputDate","<%=com.amarsoft.app.base.util.DateHelper.getToday()%>");
			bIsInsert = true;
		}
	}

	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow();
</script>	
<%@ include file="/Frame/resources/include/include_end.jspf"%>