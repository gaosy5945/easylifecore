<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_info.jspf"%><%
	String PG_TITLE = "��֤������Ϣ";
	String sSerialno=CurPage.getParameter("Serialno");
	String sDono=CurPage.getParameter("Dono");
	if(sSerialno==null) sSerialno="";
	
	ASObjectModel doTemp = new ASObjectModel("ValidateInfo");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	doTemp.setDefaultValue("Dono",sDono);
	dwTemp.genHTMLObjectWindow(sSerialno);

	String sButtons[][] = {
		{"true","","Button","����","","saveRecord()","","","",""},
	};
%><%@include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	//�����ʼ�����ز�����������ʮ
	var params=new Array(10);
	<%
		String[] sAttributes={"Param4","Param5","Param6","Param7","Param8","Param9","Param10"};
		for(int i=0;i<sAttributes.length;i++){%>
			params[<%=i%>] = document.getElementById("A_div_<%=doTemp.getColumnAttribute(sAttributes[i],"COLINDEX")%>").parentNode.parentNode;
			params[<%=i%>].style.display='none';
		<%}
	%>
	
	//��������
	function saveRecord(){
		as_save("myiframe0","top.refreshMe()");
	}

	//ѡ��ͨ����֤����
	function selectValidate(){
		AsDialog.SetGridValue("SelectValidate","","ValidatorName=ValidatorName");
		var sValidatorName=getItemValue(0,0,"ValidatorName");
		showAttribute(sValidatorName);
	}

	//�������
	function insertVariable(IdName){
		var value=prompt("�����������","");
		if(value!=null && value!="undefined" &&value!=""){
			document.getElementById(IdName).value="$Const:JboManager="+value;
		}
	}

	//����ͨ����֤���������ж��Ƿ���ʾ����
	function showAttribute(validatorName){
		var param3 = document.getElementById("Title_<%=doTemp.getColumnAttribute("Param3","COLINDEX")%>");
		var param4 = document.getElementById("Title_<%=doTemp.getColumnAttribute("Param4","COLINDEX")%>");
		if("Class"==validatorName){
			for (var i = 0; i < params.length; i++) {
				params[i].style.display='';
			}
			document.getElementById("PARAM1").value="";
			param3.innerHTML="������ &nbsp;";
			param4.innerHTML="������ &nbsp;";
		}else if("Require"==validatorName){
			for (var i = 0; i < params.length; i++) {
				params[i].style.display='none';
			}
			params[1].style.display='';
			document.getElementById("PARAM1").value="";
		}else if("Unique"==validatorName){
			for (var i = 0; i < params.length; i++) {
				if(i<5)
					params[i].style.display='';
				else
					params[i].style.display='none';
			}
			param3.innerHTML="jbomanager���� &nbsp;";
			param4.innerHTML="jbo�ؼ��� &nbsp;";
			document.getElementById("PARAM1").value="com.amarsoft.awe.dw.ui.validator.classrule.UniqueRule";
		}else{
			for (var i = 0; i < params.length; i++) {
				params[i].style.display='none';
			}
			document.getElementById("PARAM1").value="";
		}
	}
	var sValidatorName=getItemValue(0,0,"ValidatorName");
	showAttribute(sValidatorName);
</script>
<%@include file="/Frame/resources/include/include_end.jspf"%>