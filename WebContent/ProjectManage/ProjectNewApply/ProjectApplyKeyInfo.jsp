<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
	String PG_TITLE = "关键信息"; // 浏览器窗口标题 <title> PG_TITLE </title>
	//获得组件参数	：申请流水号、对象类型、对象编号、业务类型、客户类型、客户ID
	
	String templateNo = CurPage.getParameter("TemplateNo");

	//将空值转化成空字符串
	if(templateNo == null) templateNo = "";	
	

	ASObjectModel doTemp = new ASObjectModel(templateNo,"");
	
	
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写
	
	dwTemp.genHTMLObjectWindow("");
	String sButtons[][] = {
		{"true","","Button","保存","保存","saveRecord()","","","",""},
	};
%><%@include file="/Frame/resources/include/ui/include_info.jspf" %>
<script type="text/javascript">
	/*~[Describe=保存;InputParam=后续事件;OutPutParam=无;]~*/
	function saveRecord(){
		//as_save(0);
		if(!iV_all("myiframe0"))return;
		var para = "";
		
		para+=getItemValue(0,getRow(),"SerialNo")+",";
		para+=getItemValue(0,getRow(),"CustomerID")+",";
		para+=getItemValue(0,getRow(),"CustomerName")+",";
		para+=getItemValue(0,getRow(),"CertType")+",";
		para+=getItemValue(0,getRow(),"CertTypeName")+",";
		para+=getItemValue(0,getRow(),"CertID")+",";
		para+=getItemValue(0,getRow(),"ProjectType")+",";
		para+=getItemValue(0,getRow(),"ProjectTypeName")+",";
/* 		para+=getItemValue(0,getRow(),"InputUserID")+",";
		para+=getItemValue(0,getRow(),"InputUserName")+",";
		para+=getItemValue(0,getRow(),"InputOrgID")+",";
		para+=getItemValue(0,getRow(),"InputOrgName")+","; */
		para+="<%=CurUser.getUserID()%>,";
		para+="<%=CurUser.getOrgID()%>";

		var customer = AsControl.RunASMethod("ProjectManage","InitProjectApplyInfo",para);
		if(typeof(customer) == "undefined" || customer.length == 0 || customer.indexOf("@") == -1)
		{
			return;
		}
		else
		{
			var flag = customer.split("@")[0];
			var serialNo = customer.split("@")[1];
			var customerID = customer.split("@")[2];
			var functionID = customer.split("@")[3];
			var flowSerialNo = customer.split("@")[4];
			var taskSerialNo = customer.split("@")[5];
			var msg = customer.split("@")[6];
			setItemValue(0,getRow(),"CustomerID",customerID);
			setItemValue(0,getRow(),"SerialNo",serialNo);
			alert(msg);
			if(flag == "true")
			{
				top.returnValue = flag+"@"+taskSerialNo+"@"+flowSerialNo+"@"+functionID;
				top.close();
			}
		}
	}
	
	//选择合作方客户
	function selectCustomer(){
		var sParaString = "UserID"+","+AsCredit.userId;	   
		setObjectValue("SelectPartnerCustomer",sParaString,"@CustomerID@0@CustomerName@1@CertType@2@CertID@3",0,0,"");
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>