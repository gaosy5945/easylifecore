<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%><%
	String PG_TITLE = "产品分类标志位"; // 浏览器窗口标题 <title> PG_TITLE </title>
	//获得组件参数：产品编号
	String sTypeNo = CurComp.getParameter("TypeNo");
	String sObjectNo = CurComp.getParameter("ObjectNo");

	//通过显示模版产生ASDataObject对象doTemp
	String sTempletNo = "SortFlagInfo";
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sObjectNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"true","","Button","确定","保存所有修改","saveRecord()","","","",""},
		{"false","","Button","返回","返回列表页面","goBack()","","","",""}
	};
%>
<%@include file="/Frame/resources/include/ui/include_info.jspf" %>
<script type="text/javascript">
	/*~[Describe=保存;InputParam=后续事件;OutPutParam=无;]~*/
	function saveRecord(){
		//分别获取三个字段的值
		sLiquidity = getItemValue(0,getRow(),"IsLiquidity");
		sFixed = getItemValue(0,getRow(),"IsFixed");
		sProject = getItemValue(0,getRow(),"IsProject");
		//标志位的取值逻辑校验
		sReturn = RunJavaMethod("ProductSort","CheckSortFlag","IsLiquidity="+sLiquidity+",IsFixed="+sFixed+",IsProject="+sProject);
		var sReturn = sReturn.split("@");
		if(sReturn[0]=="FALSE"){
			alert(sReturn[1]);
			return;
		}
		as_save("myiframe0");
		top.close();
	}
	
	/*~[Describe=返回列表页面;InputParam=无;OutPutParam=无;]~*/
	function goBack(){
		top.close();
	}
	/*~[Describe=页面装载时，对DW进行初始化;InputParam=无;OutPutParam=无;]~*/
	function initRow(){
		if (getRowCount(0) == 0){
			as_add("myiframe0");//新增记录
		}
    }    
	initRow();
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>