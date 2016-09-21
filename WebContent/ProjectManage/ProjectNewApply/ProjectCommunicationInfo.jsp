<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%><%
	/*
        Author: undefined 2016-01-12
        Content: 示例详情页面
        History Log: 
    */
	String prjSerialno = CurPage.getParameter("prjSerialno");
	if(prjSerialno == null) prjSerialno = "";

	String sTempletNo = "ProjectCommunicationInfo";//--模板号--
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	//doTemp.setColTips("", "测试");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	//dwTemp.ReadOnly = "-2";//只读模式
	dwTemp.genHTMLObjectWindow(prjSerialno);
	
	String sButtons[][] = {
		{"true","All","Button","保存","保存所有修改","saveRecord()","","","",""}
		//{"true","All","Button","返回","返回列表","returnList()","","","",""}
	};
	sButtonPosition = "north";
%><%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	function saveRecord(){
		//保存项目协议的关联关系和运营商之间的关系
		var customerID = getItemValue(0,0,"CUSTOMERID");
		var values = RunJavaMethodTrans("com.amarsoft.app.als.customer.partner.model.ProjectCommProvider","establishProjectCommRela","customerID="+customerID+",prjSerialNo="+"<%=prjSerialno%>");//传入的数据是客户的ID和协议的编号
		if(values=="false") {
			alert("当前协议已经和该运营商关联,请重新选择");
			return;
		}
		//as_save(0);
	}

	
	function returnList(){
		 AsControl.OpenView("<%=""%>", "","_self","");
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>