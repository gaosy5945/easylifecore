<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	//<!---------Ԥ���ͻ��б�-------------->
	String cstrisklevel = DataConvert.toString(CurPage.getParameter("cstrisklevel"));
	
	String inputorgid = CurPage.getParameter("inputorgid");
	String industrytype = CurPage.getParameter("industrytype");
		
	String sIndustrytype = "";
	String sInputorgid = "";
	
	ASObjectModel doTemp = new ASObjectModel("RiskWarningCustomerInfo");
	if(inputorgid == null){
		sIndustrytype  = DataConvert.toString(CurPage.getParameter("industrytype"));
		//ͨ����ҵ���Ͳ�ѯ
		doTemp.appendJboWhere(" and ind.INDUSTRYTYPE = :INDUSTRYTYPE");
	}else if(industrytype == null){
		sInputorgid = DataConvert.toString(CurPage.getParameter("inputorgid"));
		//ͨ�����������ѯ
		doTemp.appendJboWhere(" and O.inputorgid = :inputorgid");
	}
	
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--����ΪGrid���--
	dwTemp.ReadOnly = "1";	 //ֻ��ģʽ
	dwTemp.setPageSize(10);
	if(inputorgid == null){
		//ͨ����ҵ���Ͳ�ѯ
		dwTemp.genHTMLObjectWindow(cstrisklevel+","+sIndustrytype);
	}else if(industrytype == null){
		//ͨ�����������ѯ
		dwTemp.genHTMLObjectWindow(cstrisklevel+","+sInputorgid);
	}
	
	
	/* dwTemp.setParameter("inputorgid",inputorgid);
	dwTemp.setParameter("cstrisklevel", cstrisklevel); */

	String sButtons[][] = {
			//0���Ƿ�չʾ 1��	Ȩ�޿���  2�� չʾ���� 3����ť��ʾ���� 4����ť�������� 5����ť�����¼�����	6��	7��	8��	9��ͼ�꣬CSS�����ʽ 10�����
			{"true","All","Button","Ԥ������","Ԥ������","detail()","","","","",""},
		};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function add(){
		 var sUrl = "";
		 AsControl.OpenPage(sUrl,'_self','');
	}
	function edit(){
		 var sUrl = "";
		 var sPara = getItemValue(0,getRow(0),'SerialNo');
		 
		AsControl.OpenPage(sUrl,'SerialNo=' +sPara ,'_self','');
	}
	
	function detail(){
		var sUrl = "BusinessManage/RiskWarningManage/CustomerRiskWarning.jsp";
		var sPara = getItemValue(0,getRow(0),'CUSTOMERID');
		if(typeof(sPara)=="undefined" || sPara.length==0 ){
			alert("��������Ϊ�գ�");
			return ;
		 }
		AsControl.PopComp(sUrl,"sCustomerId="+sPara, "resizable=yes;dialogWidth=1200px;dialogHeight=1200px;center:yes;status:no;statusbar:no");				
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
