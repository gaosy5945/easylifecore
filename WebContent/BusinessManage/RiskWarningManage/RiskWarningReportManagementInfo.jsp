<%@page import="com.amarsoft.app.als.awe.ow.processor.impl.html.ALSInfoHtmlGenerator"%>
<%@page import="com.amarsoft.app.base.util.ObjectWindowHelper"%>
<%@page contentType="text/html; charset=GBK"%>
<%@include file="/Frame/resources/include/include_begin_info.jspf"%>
<%@include file="/Common/FunctionPage/jspf/MultipleObjectRecourse.jspf" %>
<%
	//获得组件参数
	String objectType = CurPage.getParameter("ObjectType");
	String objectNo = CurPage.getParameter("ObjectNo");
	String rightType = CurPage.getParameter("RightType");//权限
	String buttonFlag = CurPage.getParameter("ButtonFlag");
	String Flag = CurPage.getParameter("Flag");
	String docNo = CurPage.getParameter("DocNo");
	if(buttonFlag != null) rightType = "ReadOnly";
	if(objectType == null) objectType = "";
	if(objectNo == null) objectNo = "";
	if(docNo == null) docNo = "";
	
	String templeteNo =  CurPage.getParameter("InfoTempleteNo");//模板
	if(StringX.isEmpty(templeteNo)) templeteNo = "DocBusinessObjectDocumentInfo01";
	BusinessObject inputParameter = BusinessObject.createBusinessObject();
	inputParameter.setAttributeValue("ObjectType", objectType);
	inputParameter.setAttributeValue("ObjectNo", objectNo);
	inputParameter.setAttributeValue("DocNo", docNo);
	inputParameter.setAttributeValue("RightType", rightType);
	ASObjectWindow dwTemp = ObjectWindowHelper.createObjectWindow_Info(templeteNo, inputParameter, CurPage, request);
	ASDataObject doTemp = dwTemp.getDataObject();
	if("ReadOnly".equals(rightType)){
		doTemp.setReadOnly("*", true);
	}
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
		{"ReadOnly".equals(rightType)?"false":"true","","Button","保存","保存所有修改","saveRecord()","","","",""},
		{"ReadOnly".equals(rightType)?"false":"true","","Button","提交","完提交","Submit()","","","",""},
		//{"true","","Button","返回","返回","returnBack()","","","",""},
	};
%><%@include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	function saveRecord(){
   		as_save(0);
	}
	
	function Submit(){
		var docNo = getItemValue(0,getRow(),"DocNo");	
		if (typeof(docNo)=="undefined" || docNo.length==0){
			alert("请保存后再提交！");  //请选择一条记录！
			return;
		}
		var result = "";
		if(confirm("风险报告提交至负责人复核！")) {
			result = AsCredit.RunJavaMethodTrans("com.amarsoft.app.risk.RiskReportUpload", "updateSortNo", "DocNo="+docNo);
			if(result =="true"){
				alert("风险报告提交成功！");
				top.close();
			}else{
				alert("风险报告提交失败！");
			}
		}
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>