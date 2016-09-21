<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	/*
		--页面说明: 示例列表页面--
	 */
	String PG_TITLE = "企业客户信息列表";
	//获得页面参数
	//String sInputUser =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("InputUser"));
	//if(sInputUser==null) sInputUser="";
	String sInputUserId = CurUser.getUserID();
	String sCustomerType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerType"));//客户类型
	if(sCustomerType==null) sCustomerType="";
	//通过DW模型产生ASDataObject对象doTemp
	String sTempletNo = "EntCustomerList";//模型编号
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);

	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	doTemp.multiSelectionEnabled=true;
	if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause += " and CI.InputUserId = '"+sInputUserId+"'";
	doTemp.setHTMLStyle("ondblclick", "viewCustomer");
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(10);

	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sCustomerType);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
			//0、是否展示 1、	权限控制  2、 展示类型 3、按钮显示名称 4、按钮解释文字 5、按钮触发事件代码	6、快捷键	7、	8、	9、图标，CSS层叠样式 10、风格
			{"true","All","Button","企业客户新增","企业客户新增","newCustomer()","","","","",""},
			{"true","All","Button","企业客户详情","企业客户详情","viewCustomer()","","","","",""},
			{"true","All","Button","企业客户删除","企业客户删除","delete()","","","","",""},
			{"true","All","Button","查询ECIF号","查询ECIF号","selectECIF()","","","","",""},
			};
%>
<%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	//企业客户新增
	function newCustomer(){
		var sCustomerType = "<%=sCustomerType%>";
	    AsControl.PopComp("/CustomerManage/MyCustomer/EntCustomer/NewCustomer.jsp","CustomerType="+sCustomerType,"resizable=yes;dialogWidth=500px;dialogHeight=400px;center:yes;status:no;statusbar:no");
	}

	//企业客户信息详情
	function viewCustomer(){
		var sCustomerID = getItemValue(0,getRow(0),"CUSTOMERID");
		var sCustomerName = getItemValue(0,getRow(0),"CUSTOMERNAME");
		if(typeof(sCustomerID)=="undefined" || sCustomerID.length==0){
			alert("请选择一条信息！");
		}else{
			AsCredit.openFunction("EntCustomerTree","CustomerID="+sCustomerID+"&CustomerName="+sCustomerName);
		}
	}

	$(document).ready(function(){
		AsOne.AsInit();
		init();
		my_load(2,0,'myiframe0');
	});
</script>	
<%@ include file="/IncludeEnd.jsp"%>
