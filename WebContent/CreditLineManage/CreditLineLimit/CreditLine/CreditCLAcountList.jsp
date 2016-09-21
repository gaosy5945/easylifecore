<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	ASObjectModel doTemp = new ASObjectModel("CLAcountList");
	
	//doTemp.setJboWhereWhenNoFilter(" and 1=2 ");
	doTemp.getCustomProperties().setProperty("JboWhereWhenNoFilter"," and 1=2 ");
	doTemp.setDataQueryClass("com.amarsoft.app.als.awe.ow.processor.impl.html.ALSListHtmlGenerator");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	
	dwTemp.Style="1";      	     //--����ΪGrid���--
	dwTemp.ReadOnly = "1";	 //ֻ��ģʽ
	dwTemp.setPageSize(20);
	dwTemp.setParameter("OrgID", CurUser.getOrgID());
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
			//0���Ƿ�չʾ 1��	Ȩ�޿���  2�� չʾ���� 3����ť��ʾ���� 4����ť�������� 5����ť�����¼�����	6��	7��	8��	9��ͼ�꣬CSS�����ʽ 10�����
			{"true","All","Button","�������","�������","view()","","","","",""},
			{"false","","Button","������/�����׶�Ȳ�ѯ","������/�����׶�Ȳ�ѯ","QueryCoreCL()","","","","",""},
			{"false","","Button","��ʷǩ�����","��ʷǩ�����","opinionLast()","","","","",""},
			{"true","","Button","����","����Excel","Export()","","","",""},
		};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript" src="<%=sWebRootPath%>/CreditLineManage/CreditLineLimit/js/CreditLineManage.js"></script>
<script type="text/javascript">
	function view(){
		var SerialNo = getItemValue(0,getRow(0),"SerialNo");
		if(typeof(SerialNo)=="undefined" || SerialNo.length==0)  {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return ;
		}
		var clSerialNo = getItemValue(0,getRow(0),"SerialNo");
		var BusinessType = getItemValue(0,getRow(0),"BusinessType");
		var RightType = "ReadOnly";
		var ApplySerialNo = getItemValue(0,getRow(0),"ApplySerialNo");
		AsCredit.openFunction("CLViewMainInfo","SerialNo="+SerialNo+"&CLSerialNo="+clSerialNo+"&BusinessType="+BusinessType+"&ObjectNo="+ApplySerialNo+"&ObjectType=jbo.app.BUSINESS_APPLY"+"&RightType="+RightType);
	}
	function opinionLast(){
		var serialNo = getItemValue(0,getRow(0),'SerialNo');
		if(typeof(serialNo) == "undefined" || serialNo.length == 0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		} 
		var BusinessType = getItemValue(0,getRow(0),'BusinessType');
		var ApplySerialNo = getItemValue(0,getRow(0),'ApplySerialNo');
		var flowSerialNo = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.apply.action.QueryFlowSerialNo","queryFlowSerialNo","ApplySerialNo="+ApplySerialNo);
		var returnValue = AsControl.RunASMethod("BusinessManage","QueryBusinessInfo","<%=CurUser.getUserID()%>");
		var productType3 = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.apply.action.ProductIDtoProductType","getRalativeProductType","ProductID="+BusinessType);
		if(productType3 == '02' && returnValue == "false"){
			alert("��û��Ȩ�޲鿴��Ӫ��������ʷǩ�������");
			return;
		}else{
			AsControl.PopView("/CreditManage/CreditApprove/CreditApproveList.jsp", "FlowSerialNo="+flowSerialNo);
		}
	}
	function QueryCoreCL(){
		var SerialNo = getItemValue(0,getRow(0),"SerialNo");
		var BusinessType = getItemValue(0,getRow(0),"BusinessType");
		
		if(typeof(SerialNo) == "undefined" || SerialNo.length == 0){
			alert("��ѡ��һ����Ϣ��");
			return;
		}
		AsControl.PopPage("/CreditLineManage/CreditLineLimit/CreditLine/CreditCLJump.jsp","SerialNo="+SerialNo+"&BusinessType="+BusinessType,"resizable=yes;dialogWidth=1000px;dialogHeight=550px;center:yes;status:no;statusbar:no");
	}
	
	function Export(){
		if(s_r_c[0] > 1000){
			alert("���������������������1000���ڡ�");
			return;
		}
		as_defaultExport();
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
