<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	//<!----------Ԥ���ź��б�----------------->
    String sSignallevel = DataConvert.toString(CurPage.getParameter("signallevel"));
    String industrytype = CurPage.getParameter("industrytype");
    String inputorgid = CurPage.getParameter("inputorgid");
	
	ASObjectModel doTemp = new ASObjectModel("RiskWarningSignalList");
   
	String sIndustrytype = "";
	String sInputorgid ="";
	
	
	if(inputorgid == null){
		sIndustrytype = DataConvert.toString(industrytype);
		//ͨ����ҵ���Ͳ�ѯ
		doTemp.appendJboWhere(" and ind.INDUSTRYTYPE = :industrytype");
	}else if(industrytype == null){
		sInputorgid = DataConvert.toString(inputorgid);
		//ͨ�����������ѯ
		doTemp.appendJboWhere(" and O.INPUTORGID = :inputorgid");
	}
	
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--����ΪGrid���--
	dwTemp.ReadOnly = "1";	 //ֻ��ģʽ
	dwTemp.setPageSize(10);
	if(inputorgid == null){
		//����Ϊ ��ҵ����
		//dwTemp.setParameter("industrytype",industrytype);
		dwTemp.genHTMLObjectWindow(sSignallevel+","+sIndustrytype);
	}else if(industrytype == null){
		//����Ϊ�������
		//dwTemp.setParameter("inputorgid",inputorgid);
		dwTemp.genHTMLObjectWindow(sSignallevel+","+sInputorgid);
	}else{
		dwTemp.genHTMLObjectWindow("");
	}	
	

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
		 if(typeof(sPara)=="undefined" || sPara.length==0 ){
			alert("��������Ϊ�գ�");
			return ;
		 }
		AsControl.OpenPage(sUrl,'SerialNo=' +sPara ,'_self','');
	}
	
	function detail(){
		var sUrl = "BusinessManage/RiskWarningManage/CustomerRiskWarning.jsp";
		var sPara = getItemValue(0,getRow(0),'CUSTOMERID');
		if(typeof(sPara)=="undefined" || sPara.length==0 ){
			alert("��������Ϊ�գ�");
			return ;
		 }
		AsControl.PopComp(sUrl,"sCustomerId="+sPara,"");				
		
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
