<%@page import="com.amarsoft.app.base.util.ObjectWindowHelper"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String ObjectNo = CurPage.getParameter("ObjectNo");
	if(ObjectNo == null) ObjectNo = "";
	String ObjectType = CurPage.getParameter("ObjectType");
	if(ObjectType == null) ObjectType = "";
	String RelativeType = "";
/* 	ASObjectModel doTemp = new ASObjectModel("ApplyProjectList");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request); */
	BusinessObject inputParameter =BusinessObject.createBusinessObject();
	inputParameter.setAttributeValue("RelativeType", RelativeType);
	ASObjectModel doTemp = ObjectWindowHelper.createObjectModel("ContractProjectList",inputParameter,CurPage);
	doTemp.setDataQueryClass("com.amarsoft.app.als.awe.ow.processor.impl.html.ALSListHtmlGenerator");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--设置为Grid风格--
	dwTemp.ReadOnly = "1";	 //只读模式
	dwTemp.setPageSize(10);
	if("jbo.app.BUSINESS_APPLY".equals(ObjectType)){
		RelativeType = "01";
	}else{
		RelativeType = "02";
	}
	dwTemp.setParameter("RelativeType", RelativeType);
	dwTemp.setParameter("ObjectNo", ObjectNo);
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
			//0、是否展示 1、	权限控制  2、 展示类型 3、按钮显示名称 4、按钮解释文字 5、按钮触发事件代码	6、	7、	8、	9、图标，CSS层叠样式 10、风格
			{"true","All","Button","引入","引入","addProject()","","","","btn_icon_add",""},
			{"true","","Button","详情","详情","edit()","","","","btn_icon_detail",""},
			{"true","All","Button","删除","删除","deleteproject()","","","","btn_icon_delete",""},
		};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function addProject(){	
		var objectNo = "<%=ObjectNo%>";
		var objectType = "<%=ObjectType%>";
		var relativeType = "<%=RelativeType%>";
		var returnValue =AsDialog.SelectGridValue("SelectProjects", "", "SERIALNO@PROJECTTYPE@PROJECTNAME@STATUS", "", true);
		if(!returnValue || returnValue == "_CANCEL_" || returnValue == "_CLEAR_")
			return ;
		returnValue = returnValue.split("~");
		for(var i in returnValue){
			if(typeof returnValue[i] ==  "string" && returnValue[i].length > 0 ){
				var parameter = returnValue[i].split("@");
				var result = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.credit.apply.action.RelativeProject", "importProjects",
						"SerialNo=" + parameter[0]+",ObjectType=" + objectType+",ObjectNo="+objectNo+",RelativeType="+relativeType);
			}
		}
		reloadSelf();
	}
	function edit(){
		var serialNo =  getItemValue(0,getRow(0),"PBISERIALNO");
		if(typeof(serialNo) == "undefined" || serialNo.length == 0){
			alert("请选择一条信息！");
			return;
		}
	    AsCredit.openFunction("ProjectInfoTree", "SerialNo="+serialNo+"&RightType="+"ReadOnly");
	}
	function deleteproject(){
		var SerialNo = getItemValue(0,getRow(0),"SerialNo");
		if (typeof(SerialNo)=="undefined" || SerialNo.length==0){
			alert("请选择一条所要删除记录！");
			return;
		}
		
		if(confirm("确认删除")){
			result = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.credit.apply.action.RelativeProject", "deleteProject", "SerialNo=" + SerialNo);
			if (result != "true") {
				alert(result);
				return;
			}
			if (result == "true") {
				alert("删除成功!");
				reloadSelf();
			}
		}else{
			return;
		}
		
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
