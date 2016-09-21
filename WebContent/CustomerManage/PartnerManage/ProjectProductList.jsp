<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	

	String serialNo = CurPage.getParameter("SerialNo");	

	ASObjectModel doTemp = new ASObjectModel("ProjectProduct");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //设置为Grid风格
	//dwTemp.ReadOnly = "1";	 //编辑模式
	dwTemp.setPageSize(10);
	dwTemp.genHTMLObjectWindow(serialNo);
	
	String sButtons[][] = {
			{"true","","Button","引入方案产品","引入方案产品","add()","","","","btn_icon_add",""},
			{"true","","Button","删除引入方案产品","删除引入方案产品","deleteRecord()","","","","btn_icon_delete",""},
		};
%> 
<script type="text/javascript">
	/*引入方案*/
	function add(){
		if(getRowCount(0)!="0")
		{
			alert("只能引入一个方案产品。");
			return;
		}
		var returnValue = setObjectValue("SelectAllBusinessType","","",0,0,"");
		if(typeof(returnValue)=="undefined"||returnValue==""||returnValue=="_CLEAR_"){return;}
		returnValue = returnValue.split("@");
		var param = "objectNo=<%=serialNo%>,accessoryNo=" + returnValue[0] + ",accessoryName=" + returnValue[1] +",accessoryType=Product";
		var flag = RunJavaMethod("com.amarsoft.app.als.customer.partner.action.ProjectRelativeAction","initRelative",param);
		if(flag == "true")
		{
			alert("引入成功。");
			reloadSelf();
		}else
		{
			alert("引入失败。");
		}
	}
	/*删除记录*/
	function deleteRecord(){
		if(confirm('确实要删除吗?')){
			as_delete(0);
		}
	}
</script>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%><%@
 include file="/Frame/resources/include/include_end.jspf"%>
