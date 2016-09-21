<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	ASObjectModel doTemp = new ASObjectModel("LimitContractList");
	doTemp.setJboWhereWhenNoFilter(" and O.ContractStatus = '02' ");

	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--����ΪGrid���--
	dwTemp.ReadOnly = "1";	 //ֻ��ģʽ
	dwTemp.setPageSize(15);
	
	dwTemp.setParameter("OrgID", CurUser.getOrgID());
	dwTemp.setParameter("UserID", CurUser.getUserID());
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
			//0���Ƿ�չʾ 1��	Ȩ�޿���  2�� չʾ���� 3����ť��ʾ���� 4����ť�������� 5����ť�����¼�����	6��	7��	8��	9��ͼ�꣬CSS�����ʽ 10�����
			{"true","","Button","�鿴����","�鿴����","edit()","","","","",""},
			{"true","","Button","���Ͷ�ȵ�����","���Ͷ�ȵ�����","send()","","","","",""},
			{"true","","Button","�����˻�������","�����˻�������","sendAccount()","","","","",""},
			{"true","","Button","��ӡ�ſ�֪ͨ��","��ӡ�ſ�֪ͨ��","print()","","","","",""},
		};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">

	function edit(){
		 var serialNo = getItemValue(0,getRow(0),"SerialNo");
		 if(typeof(serialNo)=="undefined" || serialNo.length==0 ){
			alert("��ѡ��һ����¼��");
			return ;
		 }
		
		AsCredit.openFunction("ContractInfo","ObjectType=jbo.app.BUSINESS_CONTRACT&ObjectNo="+serialNo+"&RightType=ReadOnly","");
	}
	
	function send(){
		var serialNo = getItemValue(0,getRow(0),"SerialNo");
		if(typeof(serialNo)=="undefined" || serialNo.length==0 ){
			alert("��ѡ��һ����¼��");
			return ;
		}
		
		if(!confirm("ȷ�����ͷſ����룿")) return;
		var returnValue = AsControl.RunJavaMethodTrans("com.amarsoft.app.lending.bizlets.SendCLInfo","send","ContractNo="+serialNo); 
		alert(returnValue);
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
			var returnValue = AsControl.RunJavaMethodTrans("com.amarsoft.app.lending.bizlets.SendAccountInfo","send","ObjectNo="+serialNo+",ObjectType=jbo.app.BUSINESS_CONTRACT"); 
			alert(returnValue);
		//}catch(e){}
		reloadSelf();
	}
	
	function print(){
		var businessType = getItemValue(0,getRow(),"BUSINESSTYPE");
		var contractSerialNo = getItemValue(0,getRow(),"SERIALNO");
		if(typeof(contractSerialNo) == "undefined" || contractSerialNo.length == 0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		if(businessType == '666'){//�ж�Ϊ�����׶��
			AsControl.OpenView("/BillPrint/XdyApplyPass.jsp","SerialNo="+contractSerialNo,"_blank");//�����׶�ȼ����ɴ��������Ϣ��
		}else if(businessType == '500' || businessType == '502'){ //�ж�Ϊ�����׶��
			AsControl.OpenView("/BillPrint/RzyApplyPass.jsp","SerialNo="+contractSerialNo,"_blank");//�����׶�ȼ����ɴ��������Ϣ��
		} else {
			alert("��ѡ�������׻��������׶�ȼ�¼");
		}
	}
	
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
