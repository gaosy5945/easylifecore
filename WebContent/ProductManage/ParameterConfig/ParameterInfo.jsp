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
		ҳ��˵��: ʾ���б�ҳ��
	 */
	String PG_TITLE = "��Ʒ��������";
	String parameterID = CurPage.getParameter("ParameterID");		//�������
	if(parameterID==null) parameterID="";
	String rightType = CurPage.getParameter("RightType");		
	BusinessObject inputParameter=SystemHelper.getPageComponentParameters(CurPage);
	ASObjectWindow dwTemp =ObjectWindowHelper.createObjectWindow_Info("PRD_ParameterInfo", inputParameter, CurPage, request);
	ASDataObject doTemp=dwTemp.getDataObject();
	doTemp.setBusinessProcess("com.amarsoft.app.als.businessobject.web.XMLBusinessObjectProcessor");
	//��ParaID��Ϊ����������ʾģ��
	dwTemp.genHTMLObjectWindow("");
	
	
	String sButtons[][] = {
		{"true","All","Button","����","���������޸�","save()","","","",""}	
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
		if(dataType=="4"){//ѡ��
			showItem(0,"CODESCRIPT");
			showItemRequired(0,"CODESCRIPT");
			
			showItem(0,"CODESOURCE");
			showItemRequired(0,"CODESOURCE");
			
			showItem(0,"SELECTTYPE");
			showItemRequired(0,"SELECTTYPE");
			var selectType = getItemValue(0,0,"SELECTTYPE");
			if(selectType=="01"){//�б�ѡ��
				showItem(0,"SELECTSCRIPT");
				showItemRequired(0,"SELECTSCRIPT");
			}
			else if(selectType=="01"||selectType=="02"){//��ͼѡ��
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
		
		functionchangeDataType();//�����������ͣ�ѡ��������Чֵ���ѡ��Χ
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