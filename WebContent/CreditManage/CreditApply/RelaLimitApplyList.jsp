<%@page import="com.amarsoft.app.als.credit.model.CreditObjectAction"%>
<%@page import="com.amarsoft.app.als.credit.common.model.CreditConst"%>
<%@page import="com.amarsoft.are.jbo.BizObject"%>
<%@page import="com.amarsoft.are.lang.StringX"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author: xfliu 2014-04-13
		Tester:
		Describe: 
		Input Param:
		Output Param:
		HistoryLog:
	 */
	%>
<%/*~END~*/%>





<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "�������������Ϣ�б�"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//�������

	//���ҳ�����
	String packageNo = CurPage.getParameter("ObjectNo");//��������
	if(StringX.isSpace(packageNo)) packageNo = "";
	String objectType = CurPage.getParameter("ObjectType");
	if(StringX.isSpace(objectType)) objectType = "CreditApply";
	BizObject bo = null;
	String applyType = "";
	if(CreditConst.CREDITOBJECT_APPLY_REAL.equals(objectType)){
		//bo = com.amarsoft.app.als.process.action.GetApplyParams.getApplyParams(packageNo);
		CreditObjectAction coa=new CreditObjectAction(packageNo,objectType);
		applyType = coa.getString("ApplyType");
	}
	if(StringX.isSpace(applyType)) applyType = "";
%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%
	ASObjectModel doTemp = new ASObjectModel("RelaLimitApplyList");
	//����datawindow
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      //����ΪGrid���
	dwTemp.ReadOnly = "1"; //����Ϊֻ
	dwTemp.genHTMLObjectWindow(objectType+","+packageNo);

%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List04;Describe=���尴ť;]~*/%>
	<%
	String sButtons[][] = {
		{"false","All","Button","����","����������Ϣ","newRecord()","","","",""},
		{"true","","Button","����","�鿴��������","viewAndEdit()","","","",""},
		{"false","All","Button","ɾ��","ɾ������","deleteRecord()","","","",""},
	};
	if(CreditConst.CREDITOBJECT_APPLY_REAL.equals(objectType)){
		sButtons[0][0] = "true";
		sButtons[2][0] = "true";
	}
	%>
<%/*~END~*/%>

<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">
	/*~[Describe=������¼;InputParam=��;OutPutParam=��;]~*/
	function newRecord(){
		var applyType = "<%=applyType%>";	
		var packageNo = "<%=packageNo%>";
		var style = "dialogWidth=550px;dialogHeight=480px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;";
		var compID = "NewApply";
		var compURL = "/CreditManage/CreditApply/NewApplyInfo.jsp";
		var returnMessage = popComp(compID,compURL,"ApplyType="+applyType+"&PackageNo="+packageNo,style);
		if(!returnMessage|| returnMessage=="_CANCEL_") return;
		returnMessage = returnMessage.split("@");
		var objectNo=returnMessage[0];
		var objectType=returnMessage[1];
        //���������������ˮ�ţ��������������
		var paramString = "ObjectType="+objectType+"&ObjectNo="+objectNo;
		AsControl.OpenObjectTab(paramString);
		reloadSelf();
	}

	/*~[Describe=ɾ����¼;InputParam=��;OutPutParam=��;]~*/
	function deleteRecord(){
		var serialNo = getItemValue(0,getRow(),"SerialNo");
		if (!serialNo){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		if(confirm("ȷ��ȡ���ñ������¼��")){
			var objectType = "<%=objectType%>";
			var returnMessage = RunJavaMethodTrans("com.amarsoft.app.als.credit.apply.action.InitializeApply","delRecord","ObjectNo="+serialNo+",ObjectType="+objectType);
			if(returnMessage == "SUCCESS"){
				alert("ȡ������ɹ���");
			}else{
				alert("ȡ������ʧ�ܣ�");
			}
			reloadSelf();
		}
	}
	
	/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
	function viewAndEdit(){
		var serialNo = getItemValue(0,getRow(),"SerialNo");
		if (!serialNo){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		var paramString = "ObjectType=<%=objectType%>&ObjectNo="+serialNo;
		AsControl.OpenObjectTab(paramString);
		reloadSelf();
	}	
	</script>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List07;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script type="text/javascript">
</script>
<%/*~END~*/%>

<%@ include file="/Frame/resources/include/include_end.jspf"%>
