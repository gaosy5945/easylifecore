 <%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String functionId = CurPage.getParameter("FunctionID");
	if(functionId == null) functionId = "";
	ASObjectModel doTemp = new ASObjectModel("SysFunctionLibraryList");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //设置为Grid风格
	dwTemp.ReadOnly = "0";	 //编辑模式
	dwTemp.setPageSize(10);
	dwTemp.genHTMLObjectWindow(functionId);
	
	String sButtons[][] = {
			{"true","","Button","新增","新增","add()","","","","",""},
			{"true","","Button","保存","保存","saveRecord()","","","","",""},
			{"true","","Button","详情","详情","viewDetail()","","","","",""},
			{"true","","Button","复制","复制","copy()","","","","",""},
			{"true","","Button","删除","删除","if(confirm('确实要删除吗?'))as_delete(0,'')","","","","",""},
		};
%> 
<script type="text/javascript">
	function add(){
		 editStyle=parent.window.getItemValue(0,getRow(),"EditStyle");
		 AsControl.PopComp("/AppConfig/FunctionManage/SysFunctionLibraryInfo.jsp","FunctionID=<%=functionId%>&EditStyle="+editStyle,"");
		 reloadSelf();
	}

	function saveRecord(){
		as_save("0","");
	}
	function setValue(){
		setItemValue(0,getRow(),"ItemNo","10");
	}

	function copy(){
		var functionItemSerialNo = getItemValue(0,getRow(),"SERIALNO");		
		if (typeof(functionItemSerialNo)=="undefined" || functionItemSerialNo.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		
		var result = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.businessobject.web.BusinessObjectWebMethod", "simpleCopyBusinessObject"
				, "ObjectType=jbo.sys.SYS_FUNCTION_LIBRARY,ObjectNo="+functionItemSerialNo);
		if(result == "false"){
			alert("已存在复制信息！");
		} else {
			reloadSelf();
		}
	};

	function viewDetail(){
		var serialNo = getItemValue(0,getRow(),"SerialNo");
		var editStyle=parent.window.getItemValue(0,getRow(),"EditStyle");
		if (typeof(serialNo)=="undefined" || serialNo.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		 AsControl.PopComp("/AppConfig/FunctionManage/SysFunctionLibraryInfo.jsp","FunctionID=<%=functionId%>&SerialNo="+serialNo+"&EditStyle="+editStyle,"");
		 reloadSelf();
	}
</script>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%><%@
 include file="/Frame/resources/include/include_end.jspf"%>
 