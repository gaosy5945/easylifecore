<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	ASObjectModel doTemp = new ASObjectModel("DUEBILL_RISK_APPROVE");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--����ΪGrid���--
	dwTemp.MultiSelect = true;//�����ѡ
	dwTemp.ReadOnly = "1";	 //ֻ��ģʽ
	dwTemp.setPageSize(10);
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
			//0���Ƿ�չʾ 1��	Ȩ�޿���  2�� չʾ���� 3����ť��ʾ���� 4����ť�������� 5����ť�����¼�����	6��	7��	8��	9��ͼ�꣬CSS�����ʽ 10�����
			{"true","All","Button","�����϶�","�����϶�","ensure()","","","","",""},
			{"true","","Button","�����϶�","�����϶�","doubleensure()","","","","",""},
			{"true","","Button","��������","��������","viewAndEdit()","","","","",""},
			{"true","","Button","�ύ","�ύ","del()","","","","",""},
		};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
function ensure(){
	
	var recordArray = getCheckedRows(0);
	 if(recordArray.length > 1){
		 alert("���𵥱��϶�ʱֻ��ѡ��һ����Ϣ��");}else{
		 
	var serialNo=getItemValue(0,getRow(),"SerialNo");
	AsControl.PopComp("/RiskClassify/SingleConfirm.jsp", "SerialNo="+serialNo);
	reloadSelf();
	}
	}
	
function doubleensure(){
	var recordArray = getCheckedRows(0);
	 if(recordArray.length < 1){
		 alert("��ѡ�������Ϣ��");	 
	 }else{
		 		var relaSerialNos = '';
				if(typeof(recordArray) != 'undefined' && recordArray.length >= 1) {	
						for(var i = 1;i <= recordArray.length;i++){
							var serialNo = getItemValue(0,recordArray[i-1],"SERIALNO");
							relaSerialNos += "@'"+serialNo+"'";
	
					}
						}		
	 var sUrl = "/RiskClassify/DoubleConfirm.jsp";
	 OpenPage(sUrl+'?SerialNo=' + relaSerialNos,'_self','');
	//AsControl.PopComp(sUrl, "SerialNo="+relaSerialNos);
}
}

function viewAndEdit(){
	var serialNo=getItemValue(0,getRow(),"SerialNo");
	if(typeof(serialNo)=="undefined" || serialNo.length==0) 
	{
		alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		return ;
	}
	AsControl.PopComp("/RiskClassify/SingleAdjust.jsp", "SerialNo="+serialNo);
	reloadSelf();
}



	 
	 
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
