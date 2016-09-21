<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String sBDType = CurPage.getParameter("Status");// 010-��׷��Ȩ�����ʲ�,020-��׷��Ȩ�����ʲ�,030-���峥�����ʲ�
	if(sBDType == null) sBDType = "";
	String sWhereClause = ""; //Where����
	
	ASObjectModel doTemp = new ASObjectModel("VerificationAssetList");
	
	
	if("010".equals(sBDType)){
		sWhereClause = " and O.BUSINESSSTATUS = 'L52' and O.WRITEOFFPRINCIPALAMOUNT <> (select v.nvl(v.sum(LB.APPLYPRINCIPAL),'0.00')  from jbo.preservation.LAWCASE_BOOK LB where LB.BOOKTYPE='210' AND LB.LAWCASESERIALNO=O.serialno) ";	
	} else if("020".equals(sBDType)){
		sWhereClause = " and O.BUSINESSSTATUS = 'L51' and O.WRITEOFFPRINCIPALAMOUNT <> (select v.nvl(v.sum(LB.APPLYPRINCIPAL),'0.00')  from jbo.preservation.LAWCASE_BOOK LB where LB.BOOKTYPE='210' AND LB.LAWCASESERIALNO=O.serialno) ";	
		//sRitghtType = "&RightType=ReadOnly";
	} else	{
		sWhereClause = " and O.BUSINESSSTATUS in ('L51','L52') and O.WRITEOFFPRINCIPALAMOUNT = (select v.nvl(v.sum(LB.APPLYPRINCIPAL),'0.00')  from jbo.preservation.LAWCASE_BOOK LB where LB.BOOKTYPE='210' AND LB.LAWCASESERIALNO=O.serialno) ";
	}
	doTemp.setJboWhere(doTemp.getJboWhere() + sWhereClause);	
	
	String role = "PLBS0020";String role1 = "PLBS0052";
	if(CurUser.hasRole(role)&&!CurUser.hasRole(role1)){
		doTemp.appendJboWhere(" and ACCT_TRANSACTION.InputUserID='"+CurUser.getUserID()+"' ");
	}
	
	doTemp.setDataQueryClass("com.amarsoft.app.als.awe.ow.processor.impl.html.ALSListHtmlGenerator");
	
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	
	dwTemp.Style="1";      	     //--����ΪGrid���--
	dwTemp.ReadOnly = "1";	 //ֻ��ģʽ
	dwTemp.setPageSize(10);
	dwTemp.setParameter("OrgId", CurUser.getOrgID());
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
			//0���Ƿ�չʾ 1��	Ȩ�޿���  2�� չʾ���� 3����ť��ʾ���� 4����ť�������� 5����ť�����¼�����	6����ݼ�	7��	8��	9��ͼ�꣬CSS�����ʽ 10�����
			{String.valueOf(!sBDType.equals("030")),"All","Button","��������","ѡ���ͬ����","verification()","","","",""},//
			{"true","","Button","��������","ѡ���ͬ����","viewfication()","","","",""},//
			{"true","","Button","��ͬ����","�鿴�Ŵ���ͬ��������Ϣ���������Ϣ����֤����Ϣ�ȵ�","viewAndEdit()","","","",""},
			{"true","","Button","ծȨ�䶯��¼","�鿴���ռ�¼","my_Record()","","","",""},
	};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	
	/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=SerialNo;]~*/
	function viewAndEdit()
	{
		var sContractNo = getItemValue(0,getRow(),"CONTRACTSERIALNO");  //��ͬ��ˮ�Ż������
		if (typeof(sContractNo) == "undefined" || sContractNo.length == 0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}
		AsCredit.openFunction("ContractInfo","ObjectType=jbo.app.BUSINESS_CONTRACT&ObjectNo="+sContractNo+"&RightType=ReadOnly");
		reloadSelf();
	}
	
	
	//���ռ�¼
	function my_Record()
	{
		var sUrl = "/RecoveryManage/NPAManage/NPADailyManage/PDARecoverRecordList.jsp";
	    var sSerialNo = getItemValue(0,getRow(),"SERIALNO");
	    var sContractArtificialNo = getItemValue(0,getRow(),"CONTRACTARTIFICIALNO");
	    //sFinishDate = getItemValue(0,getRow(),"FinishDate");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		} else {   
			var sBDType = "<%=sBDType%>";
			if (sBDType=="030") {
				AsControl.PopComp(sUrl, "BDSerialNo="+sSerialNo+"&ContractArtificialNo="+sContractArtificialNo+"&BDType="+sBDType, "", "");
			} else {
				AsControl.PopComp(sUrl, "BDSerialNo="+sSerialNo+"&ContractArtificialNo="+sContractArtificialNo, "", "");
			}
		}
		reloadSelf();
	}
	
	function verification(){
		var sBDSerialNo = "";
		var sBusinessStatus = "";
		//VerificationSelectList
		var sStyle = "dialogWidth:800px;dialogHeight:680px;resizable:yes;scrollbars:no;status:no;help:no";
	    var returnValue = AsDialog.SelectGridValue("VerificationSelectList","<%=CurUser.getOrgID()%>","SERIALNO",'','',sStyle,'','1');
	    if(!returnValue || returnValue == "_CANCEL_" || returnValue == "_CLEAR_")
			return ;
	    else sBDSerialNo = returnValue;
	    var status = "<%=sBDType%>";
	    if(status=="010"){
	    	sBusinessStatus = "L52";	
		} else if(status=="020"){
			sBusinessStatus = "L51";
		}
		AsControl.PopComp("/RecoveryManage/NPAManage/NPADailyManage/VerificationAddInfo.jsp", "SerialNo="+sBDSerialNo+"&BusinessStatus="+sBusinessStatus, "", "");
		reloadSelf();
	}
	
	function viewfication(){
		var sBDSerialNo =  getItemValue(0,getRow(),"SERIALNO");
		if(typeof(sBDSerialNo)=="undefined" || sBDSerialNo.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		var sBusinessStatus = getItemValue(0,getRow(0),"BUSINESSSTATUS");
		var inputUserID = getItemValue(0,getRow(),"InputUserID");
		var rightType = "<%=CurPage.getParameter("RightType")%>";
		if(inputUserID!="<%=CurUser.getUserID()%>"){
			rightType = "ReadOnly";
		}
		var status = "<%=sBDType%>";
		if (status=="030") {
			AsControl.PopComp("/RecoveryManage/NPAManage/NPADailyManage/VerificationAddInfo.jsp", "SerialNo="+sBDSerialNo+"&BusinessStatus="+sBusinessStatus+"&RightType=ReadOnly", "", "");
		} else {
			AsControl.PopComp("/RecoveryManage/NPAManage/NPADailyManage/VerificationAddInfo.jsp", "SerialNo="+sBDSerialNo+"&BusinessStatus="+sBusinessStatus+"&RightType="+rightType, "", "");
		}
		reloadSelf();
	}
	
	$(document).ready(function(){
	});
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
