<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		页面说明: 示例列表页面
	 */
	String PG_TITLE = "示例列表页面";
	
	//通过DW模型产生ASDataObject对象doTemp
	ASDataObject doTemp = new ASDataObject("ExampleList",Sqlca);
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(15);

	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"true","","Button","新增","新增一条记录","newRecord()","","","",""},
		{"true","","Button","详情","查看/修改详情","viewAndEdit()","","","",""},
		{"true","","Button","删除","删除所选中的记录","deleteRecord()","","","",""},
		{"true","","Button","导出Excel","导出Excel","amarExport('myiframe0')","","","",""},
		{"true","","Button","使用ObjectViewer打开","使用ObjectViewer打开","openWithObjectViewer()","","","",""},
	};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	function filterAction(sObjectID,sFilterID,sObjectID2,sColName){
		//alert([sObjectID,sFilterID,sObjectID2,sColName]);
		var oMyObj = document.getElementById(sObjectID);
		var oMyObj2 = document.getElementById(sObjectID2);
		if(sColName.toUpperCase()=="INPUTUSER"){
			var sParaString = "SortNo,<%=CurOrg.getSortNo()%>";
			var sReturn =setObjectValue("SelectUserInOrg",sParaString,"",0,0,"");
			if(typeof(sReturn) == "undefined" || sReturn == "_CANCEL_")
				return;
			
			if(sReturn == "_CLEAR_"){
				oMyObj.value = "";
				oMyObj2.value = "";
			}else{
				sReturns = sReturn.split("@");
				oMyObj.value=sReturns[0];
				oMyObj2.value=sReturns[1];
			}
		}else if(sColName.toUpperCase()=="CUSTOMERTYPE"){
			var sReturn = AsDialog.OpenSelector("SelectCodes", "CodeNo,CustomerType", "");
			if(typeof(sReturn) == "undefined" || sReturn == "_CANCEL_")
				return;
			
			if(sReturn == "_CLEAR_"){
				oMyObj.value = "";
				oMyObj2.value = "";
			}else{
				var items = sReturn.split("~");
				var nos = "";
				var names = "";
				for(var i = 0; i < items.length; i++){
					if(!items[i]) continue;
					var item = items[i].split("@");
					nos += "|"+item[0];
					names += "|"+item[1];
				}
				
				oMyObj.value = nos.substring(1);
				oMyObj2.value = names.substring(1)
			}
		}
	}
	
	function newRecord(){
		AsControl.OpenView("/FrameCase/widget/dw/ExampleInfo.jsp","","_self","");
	}
	
	function deleteRecord(){
		var sExampleId = getItemValue(0,getRow(),"ExampleId");
		if (typeof(sExampleId)=="undefined" || sExampleId.length==0){
			alert("请选择一条记录！");
			return;
		}
		
		if(confirm("您真的想删除该信息吗？")){
			as_del("myiframe0");
			as_save("myiframe0");  //如果单个删除，则要调用此语句
		}
	}

	function viewAndEdit(){
		var sExampleId = getItemValue(0,getRow(),"ExampleId");
		if (typeof(sExampleId)=="undefined" || sExampleId.length==0){
			alert("请选择一条记录！");
			return;
		}
		AsControl.OpenView("/FrameCase/widget/dw/ExampleInfo.jsp","ExampleId="+sExampleId,"_self","");
	}
	
	<%/*~[Describe=使用ObjectViewer打开;InputParam=无;OutPutParam=无;]~*/%>
	function openWithObjectViewer(){
		var sExampleId = getItemValue(0,getRow(),"ExampleId");
		if (typeof(sExampleId)=="undefined" || sExampleId.length==0){
			alert("请选择一条记录！");
			return;
		}
		
		AsControl.OpenObject("Example",sExampleId,"001");//使用ObjectViewer以视图001打开Example，
	}

	$(document).ready(function(){
		AsOne.AsInit();
		init();
		//window.topHtml = "<span style='color:blue;display:block;width:100%;text-align:center;'>DW头上的HTML代码</span>";
		//window.bottomHtml = "<span style='color:red;margin-left:20px;'>DW尾后的HTML代码</span>";
		bHighlightFirst = true;
		my_load(2,0,'myiframe0');
	});
</script>	
<%@ include file="/IncludeEnd.jsp"%>