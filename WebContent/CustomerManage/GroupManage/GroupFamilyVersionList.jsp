<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%><%
    String PG_TITLE = "���ż��׸������"   ; // ��������ڱ��� <title> PG_TITLE </title>  
    //����������    ���ͻ�����    
    String sGroupID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("GroupID"));
	if(sGroupID == null) sGroupID = "";

	//ȡ��ģ���
    String sTempletNo = "GroupApproveOpinionListX";
	String sTempletFilter = "1=1";
	ASDataObject doTemp = new ASDataObject(sTempletNo,sTempletFilter,Sqlca);
    
    //����DataWindow
    ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
    dwTemp.setPageSize(20); //������datawindows����ʾ������
    dwTemp.Style="1"; //����DW��� 1:Grid 2:Freeform
    dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
    
    //����HTMLDataWindow
    Vector vTemp = dwTemp.genHTMLDataWindow(sGroupID);
    for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));    

    String sButtons[][] = {
		//ֻ�м��ż��ױ������ʾ�ð�ť
		{"false","","Button","�鿴�������","���׸����������","viewOpinions()","","","",""},
		{"true","","Button","�鿴�汾����","���װ汾����","viewGroupStemma()","","","",""}
	};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script language=javascript>
	function viewOpinions(){
		//��ü��ſͻ�ID
		sGroupID = getItemValue(0,getRow(),"GroupID");
		sFamilySEQ = getItemValue(0,getRow(),"FamilySEQ");    			  //���º���װ汾�ţ��£�
		sOldFamilySEQ = getItemValue(0,getRow(),"OldFamilySEQ");    			  //����ǰ���װ汾�ţ��ɣ�
		if (typeof(sGroupID)=="undefined" || sGroupID.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		
		sCompURL = "/CustomerManage/GroupManage/FamilyVersionApprove/FamilyVersionOpinionView.jsp";
		PopComp("FamilyVersionOpinionView",sCompURL,"GroupID="+sGroupID+"&FamilySeq="+sFamilySEQ+"&OldFamilySEQ="+sOldFamilySEQ+"&EditRight=Readonly","");
		reloadSelf();
	}
	/*~[Describe=�鿴���ż�����Ϣ;InputParam=��;OutPutParam=SerialNo;]~*/
	function viewGroupStemma(){
		//��ȡҵ����Ϣ
		sGroupID="<%=sGroupID%>";     //���ſͻ����
		sFamilySEQ = getItemValue(0,getRow(),"FamilySEQ");    			  //���º���װ汾�ţ��£�
		sOldFamilySEQ = getItemValue(0,getRow(),"OldFamilySEQ");    			  //���º���װ汾�ţ��£�
		if(typeof(sFamilySEQ)=="undefined" || sFamilySEQ.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}

		//var sArgs="GroupID="+ sGroupID+"&FamilySEQ="+sFamilySEQ+"&OldFamilySEQ="+sOldFamilySEQ;
		//���ż�����Ϣ
		//PopComp("FamilyVersionInternalList","/CustomerManage/GroupManage/FamilyVersionApprove/FamilyVersionInternalList1.jsp",sArgs,"");
		//PopComp("GroupCustomerFamily","/CustomerManage/GroupManage/GroupCustomerFamily.jsp","GroupID="+sGroupID+"&RightType=ReadOnly","");
		PopComp("GroupCustomerFamily","/CustomerManage/GroupManage/GroupCustomerFamilyList.jsp","GroupID="+sGroupID+"&FamilySEQ="+sFamilySEQ+"&RightType=ReadOnly","");
		reloadSelf();
	}

    AsOne.AsInit();
    init(); 
    var bHighlightFirst = true;//�Զ�ѡ�е�һ����¼
    my_load(2,0,'myiframe0');
</script>
<%@ include file="/IncludeEnd.jsp"%>