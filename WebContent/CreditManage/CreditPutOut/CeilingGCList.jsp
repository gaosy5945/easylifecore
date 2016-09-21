<%@page import="com.amarsoft.app.base.util.ObjectWindowHelper"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	

	ASObjectModel doTemp = ObjectWindowHelper.createObjectModel("CeilingGCList",BusinessObject.createBusinessObject(),CurPage);
	doTemp.setDataQueryClass("com.amarsoft.app.als.awe.ow.processor.impl.html.ALSListHtmlGenerator");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--设置为Grid风格--
	dwTemp.ReadOnly = "1";	 //只读模式
	//dwTemp.MultiSelect = true; //允许多选
	dwTemp.setPageSize(10);
	dwTemp.setParameter("UserID", CurUser.getUserID());
	dwTemp.setParameter("OrgID", CurUser.getOrgID());
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
			{"true","All","Button","查看详情","查看详情","view()","","","",""},
			{"true","All","Button","生效","生效","validate()","","","",""}
		};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function view(){
		//AsCredit.openFunction("CeilingGCView", "SerialNo="+serialNo+"&ContractSerialNo="+contractSerialNo, "", "");
		var serialNo=getItemValue(0,getRow(),"SerialNo");
		if(typeof(serialNo)=="undefined" || serialNo.length==0) 
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return ;
		}
		AsControl.PopComp("/BusinessManage/GuarantyManage/CeilingGCInfo.jsp", "SerialNo="+serialNo, "dialogWidth:780px;dialogHeight:520px;resizable:yes");
		reloadSelf();
	}
	
	function validate(){
		var serialNo = getItemValue(0,getRow(),"SerialNo");
		if(typeof(serialNo)=="undefined" || serialNo.length==0){ 
			alert(getHtmlMessage('1'));//请选择一条信息！
			return ;
		}
		if(!confirm("确认生效所选的担保合同？")) return;
		
		var returnValue = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.credit.putout.action.CeilingGCAction", "validateContract", "SerialNo="+serialNo);
		if(returnValue == "true"){
			alert("生效完成！");
		}
		else{
			alert(returnValue);
		}
		reloadSelf();
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
