<%@page import="com.amarsoft.are.lang.StringX"%>
<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
	
	String objectNo = DataConvert.toString(CurPage.getParameter("ObjectNo"));
	String objectType = DataConvert.toString(CurPage.getParameter("ObjectType"));
	String serialNo = DataConvert.toString(CurPage.getParameter("SerialNo"));

	String sTempletNo = "AcctFeeLogInfo";//ģ���
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	
	//���÷���ѡ��
	doTemp.setDDDWJbo("FEESERIALNO","jbo.acct.ACCT_FEE,SERIALNO,FEENAME,ObjectType='"+objectType+"' and ObjectNo='"+objectNo+"'");
	//�˻���Ϣѡ��
	doTemp.setDDDWJbo("Account","jbo.acct.ACCT_DEPOSIT_ACCOUNTS,SERIALNO,ACCOUNTNAME,ObjectType='"+objectType+"' and ObjectNo='"+objectNo+"'");
	
	doTemp.setHtmlEvent("Account", "onChange", "setAccountInfo");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	//dwTemp.ReadOnly = "-2";//ֻ��ģʽ
	dwTemp.genHTMLObjectWindow(serialNo);
	String sButtons[][] = {
		{"true","All","Button","����","���������޸�","asSave()","","","",""},
		{"true","All","Button","����","�����б�","returnList()","","","",""}
	};
	//sButtonPosition = "south";
%>
<%@
include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	function asSave(){
		setItemValue(0,0,"ObjectNo","<%=objectNo%>");
		setItemValue(0,0,"ObjectType","<%=objectType%>");
		as_save(0);
	}

	function returnList(){
		OpenPage("/AssetTransfer/AcctFeeLogList.jsp", "_self");
	}
	
	function setAccountInfo(){
		var sAccount = getItemValue(0,0,"Account");
		if(typeof(sAccount) == 'undefined' || sAccount.length == 0){
			return;
		}
		
		var sJavaClass = "com.amarsoft.app.als.assetTransfer.action.AssetTransferAction";
		var sJavaMethod = "setAccountInfo";
		var sParamString = "serialNos="+sAccount;
		
		var sReturn = RunJavaMethodTrans(sJavaClass,sJavaMethod,sParamString);
		
		if(typeof(sAccount) != 'undefined' && sAccount.length != 0){
			setItemValue(0,0,"RECIEVEACCOUNTNAME",sReturn.split('@')[0]);//�տ��˻�����
			setItemValue(0,0,"RECIEVEACCOUNTTYPE",sReturn.split('@')[1]);//�տ��˻�����
			setItemValue(0,0,"RECIEVEACCOUNTNO",sReturn.split('@')[2]);//�տ��˺�
			setItemValue(0,0,"RECIEVEACCOUNTCCY",sReturn.split('@')[3]);//�տ��˻�����
		}
		
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
