<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%><%
    String PG_TITLE = "���ܼ�����ͻ�������Ϣ"   ; // ��������ڱ��� <title> PG_TITLE </title>  
    //����������    ���ͻ�����    
    String sGroupID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("GroupID"));
	if(sGroupID == null) sGroupID = "";

	//ȡ��ģ���
    String sTempletNo = "GroupMemberOuterGuarantyList";
	String sTempletFilter = "1=1";
	ASDataObject doTemp = new ASDataObject(sTempletNo,sTempletFilter,Sqlca);
	
	//���ӹ����� 
    doTemp.generateFilters(Sqlca);
    doTemp.parseFilterData(request,iPostChange);
    CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
    
    //����DataWindow
    ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
    dwTemp.setPageSize(25); //������datawindows����ʾ������
    dwTemp.Style="1"; //����DW��� 1:Grid 2:Freeform
    dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
    
    //����HTMLDataWindow
    Vector vTemp = dwTemp.genHTMLDataWindow(sGroupID);
    for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));    

    String sButtons[][] = {
		{"true","","Button","����","����","viewClue()","","","","btn_icon_detail"},
	};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script language=javascript>
	function viewClue(){
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");//--������Ϣ���
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else{
	   		var sGuarantyType= getItemValue(0,getRow(),"GuarantyType");//��������
			var sContractType = getItemValue(0,getRow(),"ContractType");//������ͬ����	010��һ�㵣����020����߶��
			if(sContractType="020"){//�������߶��
				//PopPage("/CreditManage/CreditAssure/ApplyAssureInfo2.jsp?SerialNo="+sSerialNo+"&GuarantyType="+sGuarantyType+"&BackToClose=true","","dialogWidth=800px;dialogHeight=800px;");
				//AsControl.PopComp("/CreditManage/CreditAssure/CreditHAssureContract/HAContractInfo.jsp","SerialNo="+sSerialNo+"&GuarantyType="+sGuarantyType+"&RightType=ReadOnly","dialogWidth=800px;dialogHeight=800px;resizable=yes;maximize:yes;help:no;status:no;scrollbar:no;");
				AsControl.PopComp("/CreditManage/CreditAssure/ApplyAssureInfo2.jsp","SerialNo="+sSerialNo+"&GuarantyType="+sGuarantyType+"&BackToClose=true","dialogWidth=800px;dialogHeight=650px;");			
			}else{
				//PopPage("/CreditManage/CreditAssure/ApplyAssureInfo1.jsp?SerialNo="+sSerialNo+"&GuarantyType="+sGuarantyType+"&BackToClose=true","","dialogWidth=800px;dialogHeight=800px;");
				//AsControl.PopComp("/CreditManage/CreditAssure/CreditHAssureContract/GAContractInfo.jsp","SerialNo="+sSerialNo+"&GuarantyType="+sGuarantyType+"&RightType=ReadOnly","dialogWidth=800px;dialogHeight=800px;resizable=yes;maximize:yes;help:no;status:no;scrollbar:no;");
				AsControl.PopComp("/CreditManage/CreditAssure/ApplyAssureInfo1.jsp","SerialNo="+sSerialNo+"&GuarantyType="+sGuarantyType+"&BackToClose=true","dialogWidth=800px;dialogHeight=650px;");			
			}
		}
	}

    AsOne.AsInit();
    init(); 
    var bHighlightFirst = true;//�Զ�ѡ�е�һ����¼
    my_load(2,0,'myiframe0');
</script>
<%@ include file="/IncludeEnd.jsp"%>