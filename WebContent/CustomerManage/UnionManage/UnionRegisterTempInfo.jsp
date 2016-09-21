<%@page import="com.amarsoft.are.lang.StringX"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%	
	String customerType = CurPage.getParameter("CustomerType");
	String sTempletNo = "UnionCustomerAddInfo";//模板号
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	doTemp.setReadOnly("UnionType", true);
	doTemp.setDefaultValue("UnionType", customerType);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	//dwTemp.ReadOnly = "-2";//只读模式
	dwTemp.genHTMLObjectWindow("");
	dwTemp.replaceColumn("CustomerList", "<iframe type='iframe' name=\"frame_list\" width=\"100%\" height=\"420\" frameborder=\"0\" src=\""+sWebRootPath+"/CustomerManage/UnionManage/UnionMemberImpList.jsp?CompClientID="+sCompClientID+"\"></iframe>", CurPage.getObjectWindowOutput());
	String sButtons[][] = {
		{"true","All","Button","保存","保存所有修改","saveRecord()","","","",""},
		{"true","All","Button","返回","返回列表","top.close()","","","",""}
	};
	//sButtonPosition = "south";
	
%>
<%@include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	function saveRecord(){
		if(!iV_all("0")) return; 
		var unionID = getItemValue(0,getRow(),"CUSTOMERID");
		var unionName = getItemValue(0,getRow(),"CustomerName");
		//检测客户群名称是否已经存在
		var vReturn = RunJavaMethod("com.amarsoft.app.als.customer.union.action.UnionCustomerAction","checkUnionName","unionID="+unionID+",unionName="+unionName);
		if(vReturn == "true"){
			alert("客户群名称已存在,请重新录入！");
			return;
		}
		
		var vMember = window.frames["frame_list"].vParaCust;//成员编号
		if(typeof(vMember)!="undefined" && vMember.length > 0){
			//保存成员
			var vResult = RunJavaMethodTrans("com.amarsoft.app.als.customer.union.action.UnionCustomerAction","saveUnionMember","unionID="+unionID+",customerID="+vMember+",userID=<%=CurUser.getUserID()%>,orgID=<%=CurUser.getOrgID()%>");
			if(vResult == "false"){
				alert("保存失败!");
				return;
			}
		}
		as_save(0,'returnValue();');
		
	}	
	function returnValue(){
		var unionID = getItemValue(0,getRow(),"CUSTOMERID");
		parent.returnValue = unionID;	
		top.close();
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
