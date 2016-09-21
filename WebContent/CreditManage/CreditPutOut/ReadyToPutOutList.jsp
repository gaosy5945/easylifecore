<%@page import="com.amarsoft.app.workflow.interdata.ApplyData"%>
<%@page import="com.amarsoft.app.base.util.DateHelper"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String putOutStatus = DataConvert.toString(CurPage.getParameter("PutOutStatus"));
	String flag = DataConvert.toString(CurPage.getParameter("Flag"));
	String OperateOrgID = CurUser.getOrgID();
	
	
	String orgList = "";
	ASResultSet rs = Sqlca.getASResultSet(new SqlObject("select OrgList from FLOW_ORGMAP where FlowOrgMapType = '01' and OrgID = :OrgID").setParameter("OrgID", CurUser.getOrgID()));
	if(rs.next())
	{
		orgList = rs.getString(1);
	}
	rs.close();
	
	ASObjectModel doTemp = new ASObjectModel("ReadyToPutOutList");
	if("02".equals(putOutStatus)){
		doTemp.appendJboWhere("and PutOutDate <> '"+DateHelper.getBusinessDate()+"' and PutOutStatus = '03' and OperateOrgID in('"+orgList.replaceAll(",","','")+"','"+CurUser.getOrgID()+"')");
	}else if("03".equals(putOutStatus)){
		doTemp.appendJboWhere("and PutOutDate = '"+DateHelper.getBusinessDate()+"' and PutOutStatus = '03' and OperateOrgID in('"+orgList.replaceAll(",","','")+"','"+CurUser.getOrgID()+"')");
	}else{
		doTemp.appendJboWhere(" and PutOutStatus in ('"+putOutStatus.replaceAll(",","','")+"') and OperateOrgID in('"+orgList.replaceAll(",","','")+"','"+CurUser.getOrgID()+"')");
	}
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--����ΪGrid���--
	dwTemp.ReadOnly = "1";	 //ֻ��ģʽ
	dwTemp.setPageSize(15);
	dwTemp.setParameter("OperateOrgID", OperateOrgID);
	dwTemp.setParameter("PutOutStatus", putOutStatus);
	dwTemp.genHTMLObjectWindow(OperateOrgID+","+putOutStatus);

	String sButtons[][] = {
			//0���Ƿ�չʾ 1��	Ȩ�޿���  2�� չʾ���� 3����ť��ʾ���� 4����ť�������� 5����ť�����¼�����	6��	7��	8��	9��ͼ�꣬CSS�����ʽ 10�����
			{"true","All","Button","�ϸ���Ǩ��δ���˴���ſ����","�ϸ���Ǩ��δ���˴���ſ����","OldLoanOperate()","","","",""},
			{"true","All","Button","�鿴����","�鿴����","view()","","","",""},
			{("1".equals(flag) ? "true" : "false"),"All","Button","���ͷſ�����","���ͷſ�����","send()","","","",""},
			//{("1".equals(flag) ? "true" : "false"),"All","Button","��ӡ�ſ������","��ӡ�ſ������","print()","","","",""},
			{("2".equals(flag) ? "true" : "false"),"All","Button","���·��ͷſ�����","���·��ͷſ�����","send()","","","",""},
			//{("2".equals(flag) ? "true" : "false"),"All","Button","�����˻�������","�����˻�������","sendAccount()","","","",""},
			{("2".equals(flag) ? "true" : "false"),"All","Button","��ӡ�ſ�֪ͨ��","��ӡ�ſ�֪ͨ��","print()","","","",""},
			{("2".equals(flag) ? "true" : "false"),"All","Button","��ӡ���˴�����ƾ֤","��ӡ���˴�����ƾ֤","printDueBill()","","","",""},
			{("2".equals(flag) ? "true" : "false"),"All","Button","��ӡ�������","��ӡ�������","printBusinessApprove()","","","",""},
			{"false","All","Button","��������","����","backout()","","","",""},
			{"true","All","Button","��ֹ�ſ�","��ֹ�ſ�","cancel()","","","",""},
		};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function cancel(){
		var applySerialNo = getItemValue(0, getRow(), "ApplySerialNo");
		if(typeof(applySerialNo) == "undefined" || applySerialNo.length == 0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		if(!AsCredit.newConfirm("��ȷ��������ҵ������ֹ�ſ�","δ����","������")) return;
		if(!confirm("���ٴ�ȷ���Ƿ���ֹ�ſ")) return;
		var returnValue = AsControl.RunJavaMethodTrans("com.amarsoft.app.als.credit.apply.action.UpdateStatusForCancelPutOut","update","ApplySerialNo="+applySerialNo);
		if(returnValue == "true"){
			alert("��ֹ�ɹ���");
			reloadSelf();
		}
	}
	function OldLoanOperate(){
		var result = AsControl.PopView("/CreditManage/CreditPutOut/OldLoanOperateList.jsp","","resizable=yes;dialogWidth=950px;dialogHeight=600px;center:yes;status:no;statusbar:no");
		if(typeof(result) == "undefined" || result.length == 0){
			return;
		}else{
			result = result.split("@");
			if(result[0] == "true"){
				var BCSerialNo = result[1];
				var returnValue = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.credit.putout.action.InitGDPutout","initGDPutout","SerialNo="+BCSerialNo); 
				if(returnValue.split("@")[0] == "true"){
					var BPSerialNo = returnValue.split("@")[2];
				       if("<%=flag%>" == "1"){
				               AsControl.OpenView("/BillPrint/LoanFksh.jsp","SerialNo="+BPSerialNo,"_blank");//�ſ������
				        }else if("<%=flag%>" == "2"){
				               AsControl.OpenView("/BillPrint/LoanGrant.jsp","SerialNo="+BPSerialNo,"_blank");//�ſ�֪ͨ��
					    }
				}	
			}
		}
	}
	function view(){
		var serialNo = getItemValue(0,getRow(),"SerialNo");
		if(typeof(serialNo) == "undefined" || serialNo.
				length == 0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		} 
		AsControl.PopView("/CreditManage/CreditPutOut/CreditPutOutInfo.jsp", "ObjectNo="+serialNo+"&ObjectType=jbo.app.BUSINESS_PUTOUT&RightType=ReadOnly","");
	}
	function send(){
		var serialNo = getItemValue(0,getRow(),"SerialNo");//������ˮ��
		if(typeof(serialNo) == "undefined" || serialNo.length == 0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		} 
		if(!confirm("ȷ�����ͷſ����룿")) return;
		//try{
			var returnValue = AsControl.RunJavaMethodTrans("com.amarsoft.app.lending.bizlets.SendLoanInfo","Determine","PutoutNo="+serialNo); 
			alert(returnValue.split("@")[1]);
		//}catch(e){}
		reloadSelf();
	}
	
	function sendAccount(){
		var serialNo = getItemValue(0,getRow(),"SerialNo");//������ˮ��
		if(typeof(serialNo) == "undefined" || serialNo.length == 0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		} 
		if(!confirm("ȷ�����������˻���")) return;
		//try{
			var returnValue = AsControl.RunJavaMethodTrans("com.amarsoft.app.lending.bizlets.SendAccountInfo","send","ObjectNo="+serialNo+",ObjectType=jbo.app.BUSINESS_PUTOUT"); 
			alert(returnValue);
		//}catch(e){}
		reloadSelf();
	}
	
	function print(){
		var serialNo = getItemValue(0,getRow(),"SerialNo");
		if(typeof(serialNo) == "undefined" || serialNo.length == 0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		if('<%=flag%>' == '1'){
			AsControl.OpenView("/BillPrint/LoanFksh.jsp","SerialNo="+serialNo,"_blank");//�ſ������
		}else if('<%=flag%>' == '2'){
			AsControl.OpenView("/BillPrint/LoanGrant.jsp","SerialNo="+serialNo,"_blank");//�ſ�֪ͨ��
		}
	}
	function printDueBill(){
		var serialNo = getItemValue(0,getRow(),"SerialNo");
		if(typeof(serialNo) == "undefined" || serialNo.length == 0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		AsControl.OpenView("/BillPrint/DueBillForm.jsp","SerialNo="+serialNo,"_blank");//���˴�����ƾ֤
	}
	
	function printBusinessApprove(){
		var BusinessType = getItemValue(0,getRow(0),'BUSINESSTYPE');
		var contractSerialNo = getItemValue(0,getRow(0),'CONTRACTSERIALNO');
		if(typeof(contractSerialNo) == "undefined" || contractSerialNo.length == 0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		} 
		if(typeof(BusinessType) == "undefined" || BusinessType.length == 0){
			alert("������ƷΪ�գ�");//������Ʒ����Ϊ�գ�
			return;
		} 
		var applySerialNo = getItemValue(0,getRow(0),"APPLYSERIALNO");
		var PRODUCTTYPE3 = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.apply.action.ProductIDtoProductType","getRalativeProductType"
				,"ProductID="+BusinessType);
		if(PRODUCTTYPE3 == "01" && BusinessType != "555" && BusinessType != "999"){ 
			AsCredit.openFunction("PrintConsumeLoanApprove","SerialNo="+applySerialNo);//������������������
		}else if(PRODUCTTYPE3 == "02"){
			AsControl.OpenView("/BillPrint/BusinessApprove.jsp","SerialNo="+applySerialNo,"_blank");//��Ӫ��������������
		}else if(BusinessType == "555" || BusinessType == "999"){
			AsControl.OpenView("/BillPrint/ApplyDtl1For555.jsp","SerialNo="+applySerialNo,"_blank");//�������Ŷ�ȴ������������
		}
		
	}
	
	function backout(){
		var tranTellerNo = "92261005";
		var branchId = "2261";
		var bussType = "0";
		var duebillSerialNo = getItemValue(0,getRow(),"DuebillSerialNo");
		var actTranDate = "<%=com.amarsoft.app.base.util.DateHelper.getBusinessDate()%>";
		var hostSeqNo = "";
		if(typeof(duebillSerialNo) == "undefined" || duebillSerialNo.length == 0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		} 
		if(!confirm("ȷ�������ñʷſ����룿")) return;
		//���ô���ų����ӿ�
		var returnValue = AsControl.RunASMethod("PutOutSend","LoanDstrCncl",tranTellerNo+","+branchId+","+bussType+","+duebillSerialNo+","+actTranDate+","+hostSeqNo);
		if(typeof(returnValue) == "undefined" || returnValue.length == 0 || returnValue == "Null") return;
		if(returnValue.split("@")[0] == "false") alert(returnValue.split("@")[1]);
		else
		{
			alert(returnValue.split("@")[1]);
			reloadSelf();
		} 
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
