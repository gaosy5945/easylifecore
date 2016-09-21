<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>

<%
	//���ҳ�����	
	String sObjectType = CurPage.getParameter("ObjectType");
	String sObjectNo = CurPage.getParameter("ObjectNo");
	//����ֵת���ɿ��ַ���
	if(sObjectType == null) sObjectType = "";
	if(sObjectNo == null) sObjectNo = "";
	
	//ͨ����ʾģ�����ASDataObject����doTemp
	ASObjectModel doTemp = new ASObjectModel("OperateTypeList","");
	
	//����DataWindow����	
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	
	//����DW��� 1:Grid 2:Freeform
	dwTemp.Style="1";   
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(20);  //��������ҳ
	
	//�����Ƿ�ֻ�� 1:ֻ�� 0:��д
    //dwTemp.ReadOnly="1";
	
	//����HTMLDataWindow
	dwTemp.genHTMLObjectWindow(sObjectNo+","+sObjectType);
	
    String sButtons[][] = {
		{"true","All","Button","����","����","newRecord()","","","",""},	
		{"true","","Button","����","����","viewDetail()","","","",""},	
		{"true","All","Button","ɾ��","ɾ��","deleteRecord()","","","",""},	
	};
%> 

<%@include file="/Frame/resources/include/ui/include_list.jspf"%>

<script type="text/javascript">
	function newRecord(){
		var dialogStyle="dialogWidth=500px;dialogHeight=400px;center:yes;resizable:yes;scrollbars:no;status:no;help:no";
		AsControl.PopComp("/CreditManage/CreditApply/OperateTypeInfo.jsp","ObjectType=<%=sObjectType%>&ObjectNo=<%=sObjectNo%>",dialogStyle);
		//popComp("SortFlagInfo","/CreditManage/CreditApply/SortFlagInfo.jsp","TypeNo="+sTypeNo+"&ObjectNo="+sObjectNo,"dialogWidth=400px;dialogHeight=300px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		reloadSelf();	
	}

	function viewDetail(){
		var dialogStyle="dialogWidth=500px;dialogHeight=400px;center:yes;resizable:yes;scrollbars:no;status:no;help:no";
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
	        alert(getMessageText('AWEW1001')); //��ѡ��һ����Ϣ��
	        return;
	    }
		AsControl.PopComp("/CreditManage/CreditApply/OperateTypeInfo.jsp","SerialNo="+sSerialNo,dialogStyle);
		reloadSelf();
	}

	function deleteRecord(){
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
	        alert(getMessageText('AWEW1001')); //��ѡ��һ����Ϣ��
	        return;
	    }
		if(!confirm("ȷ��ɾ����Ϣ��")) return;
		as_delete('myiframe0');
	}
</script>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info08;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script type="text/javascript">	
</script>
<%/*~END~*/%>
<%@ include file="/Frame/resources/include/include_end.jspf"%>