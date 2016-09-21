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
	dwTemp.Style="1";      	     //--����ΪGrid���--
	//dwTemp.MultiSelect = true;	 //��ѡ
	//dwTemp.ShowSummary="1";	 	 //����
	dwTemp.ReadOnly = "1";	 //ֻ��ģʽ
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
			//0���Ƿ�չʾ 1��	Ȩ�޿���  2�� չʾ���� 3����ť��ʾ���� 4����ť�������� 5����ť�����¼�����	6��	7��	8��	9��ͼ�꣬CSS�����ʽ 10�����
			{"true","All","Button","����","����","add()","","","","btn_icon_add",""},
			{"true","","Button","����","����","edit()","","","","btn_icon_detail",""},
			{"true","","Button","ɾ��","ɾ��","if(confirm('ȷʵҪɾ����?'))as_delete(0,'alert(getRowCount(0))')","","","","btn_icon_delete",""},
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
			alert("��������Ϊ�գ�");
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
								<th width="50%">������Ŀ����</th>
								<th width="50%">������Ŀ��Ϣ</th>
			</thead>
			<tbody>
<!-- 			<tr> -->
<!-- 				<td class="info_group_backgourd_2 info_group_backgourd_3">��Ŀ����</td><td class="info_group_backgourd_2 info_group_backgourd_3">��Ŀ��Ϣ</td> -->
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