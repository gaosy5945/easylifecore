<%@ page contentType="text/html; charset=GBK"%><%@ include file="/IncludeBegin.jsp"%><%
	/*
		页面说明: DataWindow数据过滤器示例页面
	 */
	String PG_TITLE = "DataWindow数据过滤器示例页面";

	//通过DW模型产生ASDataObject对象doTemp
	ASDataObject doTemp = new ASDataObject("ExampleList",Sqlca);
	
	//生成查询框，这里除ApplySum，其他的查询条件(字段)在DW模型(显示模板)里勾选“可查询”
//	doTemp.setFilter(Sqlca,"1","ApplySum","Operators=BetweenNumber;DOFilterHtmlTemplate=Number");//数字区间条件
//	doTemp.setFilter(Sqlca,"2","InputUser","Operators=EqualsString;HtmlTemplate=PopSelect");
	
	//初始化不显示列表数据,haveReceivedFilterCriteria()获取是否接收到filter过滤条件的状态
	//if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause+=" and 1=2";
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写

	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	<%/*~[Describe=查询条件弹出对话框;]~*/%>
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
		}else if(sColName.toUpperCase()=="CUSTOMERTYPE"){ // 配置在模板中
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
					nos += "|"+item[0]; // 必须以“|”做分隔符
					names += "|"+item[1]; // 可以用任意符号做分隔符，作为显示使用
				}
				
				oMyObj.value = nos.substring(1);
				oMyObj2.value = names.substring(1)
			}
		}
	}

	$(document).ready(function(){
		AsOne.AsInit();
		init();
		my_load(2,0,'myiframe0');
		//展开查询区域
		if(<%=!"true".equals(CurPage.getParameter("DWInSearch"))%>)
			showFilterArea();
	});
</script>
<%@ include file="/IncludeEnd.jsp"%>