<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "�Ѵ�������Ϣ�б�"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	String sSql = "";
	
	//����������

	//���ҳ�����	    
    String sQuaryName = CurPage.getParameter("QuaryName");
    String sQuaryValue = CurPage.getParameter("QuaryValue");
    String sBack = CurPage.getParameter("Back");
	//����ֵת��Ϊ���ַ���
	if(sQuaryName == null) sQuaryName = "";
	if(sQuaryValue == null) sQuaryValue = "";
	if(sBack == null) sBack = "";
	
%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%
	//ͨ��DWģ�Ͳ���ASDataObject����doTemp
    String sTempletNo = "";
	
	if(sQuaryName.equals("OrgNo"))
	{
		sTempletNo = "SupplyLawCaseList";//ģ�ͱ��
	}
	
	if(sQuaryName.equals("PersonNo"))
	{
		sTempletNo = "SupplyLawCaseList1";//ģ�ͱ��
	}
			 
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	//��ѯ��������ʱ���ӻ������û����ƣ������ϰ����ճ�������һ��  
    doTemp.WhereClause += " and LI.MANAGEORGID = '"+CurOrg.getOrgID()+"' AND LI.MANAGEUSERID = '"+CurUser.getUserID()+"'";
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(10);

	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sQuaryValue+","+sQuaryName+","+sBack);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List04;Describe=���尴ť;]~*/%>
	<%
	//����Ϊ��
	//0.�Ƿ���ʾ
	//1.ע��Ŀ�������(Ϊ�����Զ�ȡ��ǰ���)
	//2.����(Button/ButtonWithNoAction/HyperLinkText/TreeviewItem/PlainText/Blank)
	//3.��ť����
	//4.˵������
	//5.�¼�
	//6.��ԴͼƬ·��
	String sButtons[][] = {
				{"true","","Button","����","����","viewAndEdit()","","","",""},
				{"true","","Button","����","����","goBack()","","","",""}
			};
	%>
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">

	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
	function viewAndEdit()
	{
		//��ð�����ˮ��
		var sSerialNo=getItemValue(0,getRow(),"SerialNo");	
		var sLawCaseType=getItemValue(0,getRow(),"LawCaseType");	
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}else
		{
			sObjectType = "LawCase";
			sObjectNo = sSerialNo;			
			var sFunctionID="";
			if(sLawCaseType == "01" ){
				sFunctionID = "CaseInfoList1";
			}else{
				sFunctionID = "CaseInfoList2";
			}
			
			AsCredit.openFunction(sFunctionID,"SerialNo="+sObjectNo+"&LawCaseType="+sLawCaseType);	
			reloadSelf();	
		}
	}

	/*~[Describe=����;InputParam=��;OutPutParam=��;]~*/
	function goBack()
	{		
		self.close();
		<%-- sBack = "<%=sBack%>";
		if(sBack == "1")
			OpenPage("/RecoveryManage/Public/AgencyList.jsp?rand="+randomNumber(),"_self","");
		if(sBack == "2")
			OpenPage("/RecoveryManage/Public/AgentList.jsp?rand="+randomNumber(),"_self","");
		if(sBack == "3")
			OpenPage("/RecoveryManage/Public/CourtList.jsp?rand="+randomNumber(),"_self","");
		if(sBack == "4")
			OpenPage("/RecoveryManage/Public/CourtPersonList.jsp?rand="+randomNumber(),"_self",""); --%>
	}
	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">

	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List07;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script type="text/javascript">
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>
<%/*~END~*/%>


<%@	include file="/IncludeEnd.jsp"%>
