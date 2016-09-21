<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		页面说明: 示例列表页面
	 */
	String PG_TITLE = "未结清授信业务列表";
	//获得页面参数
	String whereCondition = "";
	String sCustomerID =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CustomerID"));
	String sCustomerType =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CustomerType"));
	
	if(sCustomerID==null) sCustomerID="";
	
	//通过DW模型产生ASDataObject对象doTemp
	String sTempletNo = "CustomerLoanAfterList";//模型编号
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	String sWhere = "BC.PigeonholeDate is not null and BC.PigeonholeDate <> ' ' and (BC.FinishDate = ' ' or BC.FinishDate is null)"
			   +" and BC.BusinessType in (select BT.TypeNo from BUSINESS_TYPE BT where BT.OffSheetFlag in ('IndOn', 'IndOff', 'EntOn', 'EntOff') )";
	//add by wmzhu date:2014/04/22
	if("04".equals(sCustomerType)){//客户群时,显示的是客户群成员相关业务信息
		doTemp.FromClause += ",GROUP_MEMBER_RELATIVE GM";
		sWhere = "where BC.CustomerID=GM.MemberCustomerID and GM.GROUPID='"+sCustomerID+"' and " + sWhere;
		doTemp.setVisible("CustomerName", true);//成员名称
	}else{
		sWhere = "where BC.CustomerID='"+sCustomerID+"' and " + sWhere;
	}
	
	doTemp.WhereClause += sWhere;

	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(20);
	dwTemp.ShowSummary = "1";
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
 
	String sButtons[][] = {
		{"true","","Button","详情","查看未结清授信业务详情","viewAndEdit()","","","",""}
    };
	%>
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">

	function viewAndEdit()
	{
		sSerialNo   = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else
		{
			sCompID = "CreditTab";
			sCompURL = "/CreditManage/CreditApply/ObjectTab.jsp";
			sParamString = "ObjectType=AfterLoan&ObjectNo="+sSerialNo+"&ViewID=002";
			OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
		}
	}
   
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">


	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List07;Describe=页面装载时，进行初始化;]~*/%>
<script type="text/javascript">
	AsOne.AsInit();
	init_show();
	my_load_show(2,0,'myiframe0');
</script>
<%/*~END~*/%>


<%@	include file="/IncludeEnd.jsp"%>
