<%@ page contentType="text/html; charset=GBK"%>
<%@page import="com.amarsoft.app.base.util.ObjectWindowHelper"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String PG_TITLE = "押品选择列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	
	String flag = CurPage.getParameter("Flag");// 02 重复押品  03 疑似重复押品

	if("02".equals(flag)) PG_TITLE = "重复押品选择列表";
	else if("03".equals(flag)) PG_TITLE = "疑似重复押品选择列表";
	
	String sno = "";
	String serialNos = CurPage.getParameter("SerialNos");//疑似重复押品编号，以“,”分隔
	if(serialNos == null) serialNos = "";
	String collNo[] = serialNos.split(",");//押品系统押品编号
	for(int i = 0;i < collNo.length;i++){
		sno += "'";
		sno += collNo[i];
		sno += "',";
	}
	
	String collNames = CurPage.getParameter("CollNames");
	String collTypes = CurPage.getParameter("CollTypes");
	String collVals = CurPage.getParameter("CollVals");
	
	BusinessObject inputParameter = BusinessObject.createBusinessObject();
	ASObjectWindow dwTemp = ObjectWindowHelper.createObjectWindow_List("CollateralList2", inputParameter, CurPage, request);
	
	ASDataObject doTemp = dwTemp.getDataObject();
	dwTemp.Style="1";      	     //设置为Grid风格
	dwTemp.ReadOnly = "1";	 //编辑模式
	doTemp.setBusinessProcess("com.amarsoft.app.als.guaranty.model.CollateralProcessor");
	dwTemp.setPageSize(10);
	dwTemp.genHTMLObjectWindow("");
	
	String sButtons[][] = {
			{"true","All","Button","详情","详情","view()","","","",""},
			{"true","All","Button","引入","引入","updateColl()","","","",""},
			{"true","All","Button","取消","取消","closePage()","","","",""},
	};
	//sButtonPosition = "south";
%> 
<title><%=PG_TITLE%></title>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function view(){
		var clrID = getItemValue(0,getRow(0),"SerialNo");
		var clrTypeId = getItemValue(0,getRow(0),"CollType");
		if(typeof(clrID)=="undefined" || clrID.length == 0){
			alert("请选择一条记录！");
			return;
		}
		window.showModalDialog("<%=com.amarsoft.app.oci.OCIConfig.getProperty("GuarantyURL","")%>/ClrAssetManage/PublicService/ClrAssetRedirector.jsp?ClrID="+clrID+"&ClrTypeId="+clrTypeId,"","dialogWidth="+screen.availWidth+"px;dialogHeight="+screen.availHeight+"px;resizable=yes;maximize:yes;help:no;status:no;");
	}

	function closePage(){
		self.close();
	}
	
	function updateColl(){
		var clrSerialNo = getItemValue(0,getRow(),"SerialNo");
		if(typeof(clrSerialNo)=="undefined" || clrSerialNo.length == 0){
			alert("请选择一条记录！");
			return;
		}
		var name = getItemValue(0,getRow(),"CollName");
		if(typeof(name)=="undefined" || name.length == 0) name = "";
		var collType = getItemValue(0,getRow(),"CollType"); 
		if(typeof(collType)=="undefined" || collType.length == 0) collType = "";
		var collValue = getItemValue(0,getRow(),"CollValue");
		if(typeof(collValue)=="undefined" || collValue.length == 0) collValue = "";
		
		parent.returnValue = (clrSerialNo+"@"+name+"@"+collType+"@"+collValue);
		self.close();
	}
	
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
 