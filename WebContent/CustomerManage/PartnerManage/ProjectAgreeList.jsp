<%@page import="com.amarsoft.app.base.util.SystemHelper"%>
<%@page import="com.amarsoft.app.base.util.ObjectWindowHelper"%>
<%@page import="com.amarsoft.app.base.util.DateHelper"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%-- <script type="text/javascript" src="<%=sWebRootPath%>/Common/FunctionPage/js/MultipleObjectWindow_Info.js"></script> --%>
<%-- <script type="text/javascript" src="<%=sWebRootPath%>/Common/FunctionPage/js/MultipleObjectWindow_List.js"></script> --%>
<%-- <script type="text/javascript" src="<%=sWebRootPath%>/Common/FunctionPage/js/MultipleObjectWindow.js"></script> --%>
<%	
	String customerID = CurPage.getParameter("CustomerID");
	if(customerID == null) customerID = "";
	String listType =  CurPage.getParameter("ListType");
	if(listType == null) listType = "";
	
	String flag="true";
	//检查CustomerList的状态，如果状态时02，有效项目
	List<BusinessObject> boList = BusinessObjectManager.createBusinessObjectManager().loadBusinessObjects("jbo.customer.CUSTOMER_LIST", "CustomerID=:CustomerID and ListType=:ListType", "CustomerID",customerID,"ListType",listType);
	if(boList.get(0).getAttribute("Status").getString().equals("2")) flag="false";
	
	ASObjectModel doTemp = new ASObjectModel("ProjectAgreeList");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	
// 	ASObjectWindow dwTemp = ObjectWindowHelper.createObjectWindow_List("ProjectAgreeList", SystemHelper.getPageComponentParameters(CurPage), CurPage, request);
// 	ASDataObject doTemp=dwTemp.getDataObject();
	doTemp.setLockCount(2); //锁定两列
	
	dwTemp.setPageSize(18);
	doTemp.setDefaultValue("STATUS", "11");
	dwTemp.genHTMLObjectWindow(customerID);

	String sButtons[][] = {
			//0、是否展示 1、	权限控制  2、 展示类型 3、按钮显示名称 4、按钮解释文字 5、按钮触发事件代码	6、	7、	8、	9、图标，CSS层叠样式 10、风格
			{flag,"All","Button","新增","新增","addProject()","","","","btn_icon_add",""},
			{"false","All","Button","保存","保存","saveRecord()","","","","",""},
			{"true","All","Button","详情","详情","viewRecord()","","","","",""},
			{"true","All","Button","删除","删除","del()","","","","btn_icon_delete",""},
			{flag,"All","Button","批量导入","批量导入","batchImport()","","","","btn_icon_add",""},
		};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript" src="<%=sWebRootPath%>/ProjectManage/js/ProjectManage.js"></script>
<script type="text/javascript">
	function viewRecord(){
		var merchandiseID = getItemValue(0,0,'merchandiseid');
		var prjSerialNo = getItemValue(0,0,'SerialNo');
		var prjRelativeSerialNo = getItemValue(0,0,'v.PRSERIALNO');
		AsCredit.openFunction("ProjectInfoMerchandise", "merchandiseID="+merchandiseID+"&SerialNo="+prjSerialNo+"&prjRelativeSerialNo="+prjRelativeSerialNo,"");
	}
	//新增页面
	function addProject(){
		var pageURL = '/CustomerManage/PartnerManage/ProjectMerchandise.jsp';
		var dialogStyle = "dialogWidth=450px;dialogHeight=450px;resizable=1;scrollbars=0;status:y;maximize:0;help:0;";
		var returnValue = AsControl.PopComp(pageURL, 'CustomerID=<%=customerID%>&listType=<%=listType%>', dialogStyle);
		
		if(typeof(returnValue)=="undefined" || returnValue=="null" || returnValue==null || returnValue=="_CANCEL_" ){
			return;	
		}
		var merchandiseID = returnValue.split("@")[0];//商品ID
		var prjSerialNo = returnValue.split("@")[1];//项目信息ID
		var prjRelativeSerialNo = returnValue.split("@")[2];//关联关系的ID
		AsCredit.openFunction("ProjectInfoMerchandise", "merchandiseID="+merchandiseID+"&SerialNo="+prjSerialNo+"&prjRelativeSerialNo"+prjRelativeSerialNo,"");
		reloadSelf();
	}
	function batchImport(){
		var pageURL = "/AppConfig/FileImport/FileSelector.jsp";
		var parameter = "";
		parameter = "clazz=jbo.import.excel.MERCHANDISE_LIST&CustomerID="+'<%=customerID%>'+"&UserID="+'<%=CurUser.getUserID()%>'+"&OrgID="+'<%=CurOrg.getOrgID()%>&ListType='+'<%=listType%>';
	    var dialogStyle = "dialogWidth=650px;dialogHeight=350px;resizable=1;scrollbars=0;status:y;maximize:0;help:0;";
	    var sReturn = AsControl.PopComp(pageURL, parameter, dialogStyle);
	    reloadSelf();
	}
	function add(){		
		var serialNo = '<%=DBKeyHelp.getSerialNo("PRJ_BASIC_INFO", "SerialNo")%>';
		setItemValue(0,getRow(),"SERIALNO",serialNo);
		setItemValue(0,getRow(),"AGREEMENTNO",serialNo);
		setItemValue(0,getRow(),"CUSTOMERID",'<%=customerID%>');
		setItemValue(0,getRow(),"STATUS",'11');
		setItemValue(0,getRow(),"CURRENCY",'CNY');
		setItemValue(0,getRow(),"INPUTUSERID",'<%=CurUser.getUserID()%>');
		setItemValue(0,getRow(),"INPUTORGID",'<%=CurUser.getOrgID()%>');
		setItemValue(0,getRow(),"TEMPSAVEFLAG",'0');
		setItemValue(0,getRow(),"UPDATEUSERID",'<%=CurUser.getUserID()%>');
		setItemValue(0,getRow(),"UPDATEDATE",'<%=StringFunction.getToday()%>');
	}
	function saveRecord()
	{
		as_save("reloadSelf()");
	}
	function del(){
		if(confirm('确实要删除吗?')){
			as_delete(0);
		}
	}
	/*~[Describe=日历选择;InputParam=无;OutPutParam=无;]~*/
	function selectIDExpiry()
	{
		var sEffectDate = PopPage("/FixStat/SelectDate.jsp?rand="+randomNumber(),"","dialogWidth=300px;dialogHeight=250px;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no");
		if(typeof(sEffectDate)!="undefined")
		{
			setItemValue(0,getRow(),"EFFECTDATE",sEffectDate);
		}
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
