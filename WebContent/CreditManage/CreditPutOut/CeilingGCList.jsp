<%@page import="com.amarsoft.app.base.util.ObjectWindowHelper"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	

	ASObjectModel doTemp = ObjectWindowHelper.createObjectModel("CeilingGCList",BusinessObject.createBusinessObject(),CurPage);
	doTemp.setDataQueryClass("com.amarsoft.app.als.awe.ow.processor.impl.html.ALSListHtmlGenerator");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--����ΪGrid���--
	dwTemp.ReadOnly = "1";	 //ֻ��ģʽ
	//dwTemp.MultiSelect = true; //�����ѡ
	dwTemp.setPageSize(10);
	dwTemp.setParameter("UserID", CurUser.getUserID());
	dwTemp.setParameter("OrgID", CurUser.getOrgID());
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
			{"true","All","Button","�鿴����","�鿴����","view()","","","",""},
			{"true","All","Button","��Ч","��Ч","validate()","","","",""}
		};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function view(){
		//AsCredit.openFunction("CeilingGCView", "SerialNo="+serialNo+"&ContractSerialNo="+contractSerialNo, "", "");
		var serialNo=getItemValue(0,getRow(),"SerialNo");
		if(typeof(serialNo)=="undefined" || serialNo.length==0) 
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return ;
		}
		AsControl.PopComp("/BusinessManage/GuarantyManage/CeilingGCInfo.jsp", "SerialNo="+serialNo, "dialogWidth:780px;dialogHeight:520px;resizable:yes");
		reloadSelf();
	}
	
	function validate(){
		var serialNo = getItemValue(0,getRow(),"SerialNo");
		if(typeof(serialNo)=="undefined" || serialNo.length==0){ 
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return ;
		}
		if(!confirm("ȷ����Ч��ѡ�ĵ�����ͬ��")) return;
		
		var returnValue = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.credit.putout.action.CeilingGCAction", "validateContract", "SerialNo="+serialNo);
		if(returnValue == "true"){
			alert("��Ч��ɣ�");
		}
		else{
			alert(returnValue);
		}
		reloadSelf();
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
