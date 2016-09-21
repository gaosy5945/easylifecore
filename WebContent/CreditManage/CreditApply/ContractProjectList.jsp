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
	dwTemp.Style="1";      	     //--����ΪGrid���--
	dwTemp.ReadOnly = "1";	 //ֻ��ģʽ
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
			//0���Ƿ�չʾ 1��	Ȩ�޿���  2�� չʾ���� 3����ť��ʾ���� 4����ť�������� 5����ť�����¼�����	6��	7��	8��	9��ͼ�꣬CSS�����ʽ 10�����
			{"true","All","Button","����","����","addProject()","","","","btn_icon_add",""},
			{"true","","Button","����","����","edit()","","","","btn_icon_detail",""},
			{"true","All","Button","ɾ��","ɾ��","deleteproject()","","","","btn_icon_delete",""},
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
			alert("��ѡ��һ����Ϣ��");
			return;
		}
	    AsCredit.openFunction("ProjectInfoTree", "SerialNo="+serialNo+"&RightType="+"ReadOnly");
	}
	function deleteproject(){
		var SerialNo = getItemValue(0,getRow(0),"SerialNo");
		if (typeof(SerialNo)=="undefined" || SerialNo.length==0){
			alert("��ѡ��һ����Ҫɾ����¼��");
			return;
		}
		
		if(confirm("ȷ��ɾ��")){
			result = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.credit.apply.action.RelativeProject", "deleteProject", "SerialNo=" + SerialNo);
			if (result != "true") {
				alert(result);
				return;
			}
			if (result == "true") {
				alert("ɾ���ɹ�!");
				reloadSelf();
			}
		}else{
			return;
		}
		
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
