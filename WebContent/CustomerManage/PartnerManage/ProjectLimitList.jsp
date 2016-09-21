<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String limitType = CurPage.getParameter("LimitType");
	if(limitType==null)limitType="";
	String businesstype ="";
	if("LimitGuaranty".equals(limitType))businesstype="3040";
	if("LimitProject".equals(limitType))businesstype="3050";
	String serialNo = CurPage.getParameter("SerialNo");
	if(serialNo==null)serialNo="";
	String customerID = CurPage.getParameter("CustomerID");
	if(customerID==null)customerID="";
	
	ASObjectModel doTemp = new ASObjectModel("ProjectLimitList");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //设置为Grid风格
	//dwTemp.ReadOnly = "1";	 //编辑模式
	dwTemp.setPageSize(10);
	dwTemp.genHTMLObjectWindow(serialNo +"," + limitType);
	
	String sButtons[][] = {
			{"true","","Button","引入额度","引入额度","add()","","","","btn_icon_add",""},
			{"true","","Button","额度详情","查看详情","openWithObjectViewer()","","","","btn_icon_detail",""},
			{"true","","Button","删除额度","删除额度","deleteRecord()","","","","btn_icon_delete",""},
		};
%> 
<script type="text/javascript">
	/*引入额度*/
	function add(){
		if(getRowCount(0)!="0")
		{
			alert("只能引入一个额度。");
			return;
		}
		var sParaString = "customerID"+","+"<%=customerID%>"+","+"businesstype"+"," + "<%=businesstype%>";
		var returnValue = setObjectValue("SelectLimitContract",sParaString,"",0,0,"");
		if(typeof(returnValue)=="undefined"||returnValue==""||returnValue=="_CLEAR_"){return;}
		returnValue = returnValue.split("@");
		var param = "objectNo=<%=serialNo%>,accessoryNo=" + returnValue[0] + ",accessoryType=<%=limitType%>";
		var flag = RunJavaMethod("com.amarsoft.app.als.customer.partner.action.ProjectRelativeAction","initRelative",param);
		if(flag == "true")
		{
			alert("引入成功。");
			reloadSelf();
		}else
		{
			alert("引入失败。");
		}
	}
	/*删除记录*/
	function deleteRecord(){
		as_delete(0);
	}
	
	/*~[Describe=使用ObjectViewer打开;InputParam=无;OutPutParam=无;]~*/
	function openWithObjectViewer()
	{
		sSerialNo=getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}		
		//PopComp("CreditLineAccountInfo","/CreditManage/CreditLine/CreditLineAccountInfo.jsp","SerialNo="+sSerialNo,"","");
		openObject("BusinessContract",sSerialNo,"002");
	}
</script>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%><%@
 include file="/Frame/resources/include/include_end.jspf"%>
