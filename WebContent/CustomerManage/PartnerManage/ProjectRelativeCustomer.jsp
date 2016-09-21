<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String serialNo = CurPage.getParameter("SerialNo");
	if(serialNo == null) serialNo = "";
	
	ASObjectModel doTemp = new ASObjectModel("ProjectRelativeCustomer");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //设置为Grid风格
	dwTemp.ReadOnly = "0";	 //编辑模式
	dwTemp.setPageSize(10);
	dwTemp.genHTMLObjectWindow(serialNo);
	
	String sButtons[][] = {
			{"true","All","Button","引入","引入客户","add()","","","","btn_icon_add",""},
			{"true","All","Button","保存","保存","save()","","","","btn_icon_detail",""},
			{"true","All","Button","删除","删除","if(confirm('确实要删除吗?'))as_delete(0)","","","","btn_icon_delete",""},
		};
%> 
<script type="text/javascript">
	function add(){
		var returnValue = setObjectValue("SelectOrgCustomer","","");
		if(typeof(returnValue) == "undefined" || returnValue == "_CLEAR_"){
			return;
		}
		returnValue = returnValue.split("@");
		var param = "objectNo=<%=serialNo%>,accessoryNo="+returnValue[0]+",accessoryType=Customer,accessoryName="+returnValue[1];
		var flag = RunJavaMethod("com.amarsoft.app.als.customer.partner.action.ProjectRelativeAction","initRelative",param);
		if(flag == "true"){
			alert("引入成功");
			reloadSelf();
		}else{
			alert("引入失败");
		}
		
	}
	function save(){
		as_save(0);
	}
</script>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%><%@
 include file="/Frame/resources/include/include_end.jspf"%>
