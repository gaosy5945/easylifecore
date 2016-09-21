<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%@page import="com.amarsoft.are.jbo.BizObjectManager"%>
<%@page import="com.amarsoft.are.jbo.JBOTransaction"%>
<%@page import="com.amarsoft.are.jbo.BizObject"%>
<%@page import="com.amarsoft.are.jbo.JBOFactory"%>
<%@page import="com.amarsoft.app.base.util.DateHelper"%>
<%@include file="/Common/FunctionPage/jspf/MultipleObjectRecourse.jspf"%>
<%	
	/*
        Author: undefined 2016-01-12
        Tester:
        Content: 
        Input Param:
        Output param:
        History Log: 
    */
	/* ASObjectModel doTemp = new ASObjectModel("SimulationPaymentSchedule");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--设置为Grid风格--
	//dwTemp.MultiSelect = true;	 //多选
	//dwTemp.ShowSummary="1";	 	 //汇总
	dwTemp.ReadOnly = "1";	 //只读模式
	dwTemp.setPageSize(10);
	dwTemp.genHTMLObjectWindow(""); */
	
	
	String CustomerID = CurPage.getParameter("CustomerID");
	if(CustomerID == null) CustomerID = "";
	String startDate = DateHelper.getBusinessDate().substring(0, 8) + "01";
	String endDate = DateHelper.getEndDateOfMonth(DateHelper.getBusinessDate());
	String sql = "SELECT sum(payprincipalamt) as principalamt,sum(payinterestamt) as interestamt FROM acct_payment_schedule "+
			"where objecttype='jbo.acct.ACCT_LOAN' and objectno in "+
			"(select serialno from acct_loan where contractserialno in "+
			"(SELECT objectno FROM prj_relative where objecttype='jbo.app.BUSINESS_CONTRACT' and serialno in "+
			"(select serialno from prj_basic_info where customerid=:customerid))) "+
			"and  paydate>="+startDate+" and paydate<="+endDate;
	ASResultSet rs = Sqlca.getASResultSet(new SqlObject(sql).setParameter("customerid",CustomerID)); 
	String principalAmt = "0.00";
	String interestAmt = "0.00";
	if(rs.next()){
		principalAmt = rs.getString("principalamt");
		interestAmt = rs.getString("interestamt");
	}
	rs.getStatement().close();
	if(principalAmt == null) principalAmt = "0.00";
	if(interestAmt == null) interestAmt = "0.00";
	
	

	String sButtons[][] = {
			//0、是否展示 1、	权限控制  2、 展示类型 3、按钮显示名称 4、按钮解释文字 5、按钮触发事件代码	6、	7、	8、	9、图标，CSS层叠样式 10、风格
			{"true","All","Button","新增","新增","add()","","","","btn_icon_add",""},
			{"true","","Button","详情","详情","edit()","","","","btn_icon_detail",""},
			{"true","","Button","删除","删除","if(confirm('确实要删除吗?'))as_delete(0,'alert(getRowCount(0))')","","","","btn_icon_delete",""},
		};
%>
<%-- <%@include file="/Frame/resources/include/ui/include_list.jspf"%> --%>
<script type="text/javascript">
	function add(){
		 var sUrl = "";
		 AsControl.OpenView(sUrl,'','_self','');
	}
	function edit(){
		 var sUrl = "";
		 var sPara = getItemValue(0,getRow(0),'SerialNo');
		 if(typeof(sPara)=="undefined" || sPara.length==0 ){
			alert("参数不能为空！");
			return ;
		 }
		AsControl.OpenView(sUrl,'SerialNo=' +sPara ,'_self','');
	}
</script>
<html>
	<head>
		<title></title>
	</head>
<body class="pagebackground" style="overflow-x: scroll">
	<div class="creditcheck_main">
		<table class="list_data_tablecommon">
			<thead class='list_topdiv_header'>
								<th width="50%">当月项目本金</th>
								<th width="50%">当月项目利息</th>
			</thead>
			<tbody>
<!-- 			<tr> -->
<!-- 				<td class="info_group_backgourd_2 info_group_backgourd_3">项目本金</td><td class="info_group_backgourd_2 info_group_backgourd_3">项目利息</td> -->
<!-- 			</tr> -->
			<tr>
				<td align="center"  vAlign="middle" class="list_all_td"><%=principalAmt%></td><td align="center"  vAlign="middle" class="list_all_td"><%=interestAmt%></td>
			</tr>	
			</tbody>
		</table>
	</div>
</body>
</html>
<%@ include file="/Frame/resources/include/include_end.jspf"%>