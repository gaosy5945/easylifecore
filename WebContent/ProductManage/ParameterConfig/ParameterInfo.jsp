<%@page import="com.amarsoft.app.base.util.SystemHelper"%>
<%@page import="com.amarsoft.app.base.util.ObjectWindowHelper"%>
<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_info.jspf"%>
<%@include file="/Common/FunctionPage/jspf/MultipleObjectRecourse.jspf" %>
<style>
	.test{
		background-color: red;
	}
</style>
 <%
	/*
		页面说明: 示例列表页面
	 */
	String PG_TITLE = "产品参数详情";
	String parameterID = CurPage.getParameter("ParameterID");		//参数编号
	if(parameterID==null) parameterID="";
	String rightType = CurPage.getParameter("RightType");		
	BusinessObject inputParameter=SystemHelper.getPageComponentParameters(CurPage);
	ASObjectWindow dwTemp =ObjectWindowHelper.createObjectWindow_Info("PRD_ParameterInfo", inputParameter, CurPage, request);
	ASDataObject doTemp=dwTemp.getDataObject();
	doTemp.setBusinessProcess("com.amarsoft.app.als.businessobject.web.XMLBusinessObjectProcessor");
	//将ParaID作为参数传给显示模板
	dwTemp.genHTMLObjectWindow("");
	
	
	String sButtons[][] = {
		{"true","All","Button","保存","保存所有修改","save()","","","",""}	
	};

%><%@
include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">	
	
	function save(){
		as_save("reloadLeft()");
	}
	
	function reloadLeft(){
		parent.reloadSelf();
	}

	function init(){
		if ("<%=parameterID%>"==""){
			setItemValue(0,getRow(),"InputUserID","<%=CurUser.getUserID()%>");
			setItemValue(0,getRow(),"InputDate","<%=StringFunction.getToday()%>");
			setItemValue(0,getRow(),"UpdateDate","<%=StringFunction.getToday()%>");
		}
		changeDataType();
	}
	
	function changeDataType(){
		var dataType=getItemValue(0,0,"DATATYPE");
		if(dataType=="4"){//选项
			showItem(0,"CODESCRIPT");
			showItemRequired(0,"CODESCRIPT");
			
			showItem(0,"CODESOURCE");
			showItemRequired(0,"CODESOURCE");
			
			showItem(0,"SELECTTYPE");
			showItemRequired(0,"SELECTTYPE");
			var selectType = getItemValue(0,0,"SELECTTYPE");
			if(selectType=="01"){//列表选择
				showItem(0,"SELECTSCRIPT");
				showItemRequired(0,"SELECTSCRIPT");
			}
			else if(selectType=="01"||selectType=="02"){//树图选择
				showItem(0,"SELECTSCRIPT");
				hideItemRequired(0,"SELECTSCRIPT");
			}
			else{
				hideItem(0,"SELECTSCRIPT");
				hideItemRequired(0,"SELECTSCRIPT");
			}
		}
		else{
			hideItem(0,"CODESCRIPT");
			hideItem(0,"CODESOURCE");
			hideItem(0,"SELECTTYPE");
			hideItem(0,"SELECTSCRIPT");
			
			hideItemRequired(0,"CODESCRIPT");
			hideItemRequired(0,"CODESOURCE");
			hideItemRequired(0,"SELECTTYPE");
			hideItemRequired(0,"SELECTSCRIPT");
		}
		
		functionchangeDataType();//根据数据类型，选择数据有效值域可选范围
	}
	
	
	function functionchangeDataType(){
		var dataType=getItemValue(0,0,"DATATYPE");
		
		$("[name=OPERATOR]").each(function(){
		 	$(this).parent().hide();
		 	if("1"==dataType){
				if(this.value=="VALUE"){
					$(this).parent().show();
				}
		 	}
		 	else if("2"==dataType || "5"==dataType || "6"==dataType){
				if(this.value=="MINIMUMVALUE" || this.value=="MAXIMUMVALUE" || this.value=="VALUE"){
					$(this).parent().show();
				}
		 	}
		 	else if("3"==dataType){
				/* if(this.value=="JSP" || this.value=="Funct" ||this.value=="Catalog"){
					$(this).parent().show();
				} */
		 	}
		 	else if("4"==dataType){
				if(this.value=="MANDATORYVALUE" || this.value=="OPTIONALVALUE" 
						|| this.value=="EXCLUDEDVALUE"|| this.value=="VALUE"){
					$(this).parent().show();
					
				}
			}
		 	
	 	});
		
	}
</script>	

<script type="text/javascript">
init();
</script>	
<%@ include file="/Frame/resources/include/include_end.jspf"%>