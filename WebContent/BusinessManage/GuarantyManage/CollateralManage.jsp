 <%@page import="com.amarsoft.app.als.guaranty.model.GuarantyFunctions"%>
<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String PG_TITLE = "ѺƷ̨��"; // ��������ڱ��� <title> PG_TITLE </title>
	String userID = CurUser.getUserID();
	
	
	ASObjectModel doTemp = new ASObjectModel("CollateralManage");
		
	//ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	doTemp.getCustomProperties().setProperty("JboWhereWhenNoFilter"," and 1=2 ");
	doTemp.setDataQueryClass("com.amarsoft.app.als.awe.ow.processor.impl.html.ALSListHtmlGenerator");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	
	dwTemp.Style="1";      	     //����ΪGrid���
	dwTemp.setParameter("InputOrgID", CurUser.getOrgID());
	dwTemp.setPageSize(20);
	dwTemp.genHTMLObjectWindow("");
	
	String sButtons[][] = {
			{"true","All","Button","ѺƷ����","ѺƷ����","view()","","","",""},
			{"true","All","Button","ȡ������","ȡ������","cancel()","","","",""},
	};

%> 
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function view(){
		var serialNo = getItemValue(0,getRow(),"SerialNo");
		var assetType = getItemValue(0,getRow(),"AssetType");
		if(typeof(serialNo) == "undefined" || serialNo.length == 0){
			alert("��ѡ��һ��ѺƷ��Ϣ��");
			return;
		}
		if(assetType.length==0){
			alert("������Ϣ��������");
			return;
		}
		
		var templateNo = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.credit.apply.action.CollateralTemplate", "getTemplate", "ItemNo="+assetType);
		templateNo = templateNo.split("@");
		if(templateNo[0]=="false"){
			alert("δ����ѺƷ����"+assetType+"��ģ�壡");
			return;
		}
		AsCredit.openFunction("CollateralManage", "AssetSerialNo="+serialNo+"&TemplateNo="+templateNo[1], "");
		reloadSelf();
	}
	
	/*~[Describe=ȡ������;InputParam=��;OutPutParam=��;]~*/
	function cancel(){
		var assetSerialNo = getItemValue(0,getRow(),"SerialNo");
		if(typeof(assetSerialNo)=="undefined" || assetSerialNo.length==0)  {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return ;
		}
		
		var assetEvaInfo = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.guaranty.model.CollateralEva", "getEvaInfo","AssetSerialNo="+assetSerialNo);
		if(assetEvaInfo=="false") {
			alert("û�й�ֵ����");
			return;
		}
		
		var flowSerialNo = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.guaranty.model.CollateralEva",
				"getEvaFlow","SerialNo="+assetSerialNo);
		
		if(flowSerialNo == "false"){
			var sReturn = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.guaranty.model.CollateralEva",
					"delEva","SerialNo="+assetSerialNo);
			
			alert("����ȡ���ɹ�!");
			return;
		}
		
		if(!confirm("ȡ������󲻿ɻָ�����ȷ�ϣ�")) return;
		var returnValue = AsControl.RunASMethod("WorkFlowEngine","DeleteBusiness",flowSerialNo);
	
		if(typeof(returnValue) == "undefined" || returnValue.length == 0 || returnValue == "Null") return;
		if(returnValue == "true")
		{
			alert("����ȡ���ɹ�!");
			reloadSelf();
		}
		else
		{
			alert(returnValue.split("@")[1]);
		}
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
 