<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:  zqliu
		Tester:
		Content: ��ծ�ʲ������˱��
		Input Param:
				���в�����Ϊ�����������
				ComponentName	������ƣ��ѵ���/�����е��ʲ��б�
			    ComponentType		������ͣ� ListWindow
		Output param:
				ObjectNo				��ծ�ʲ����
				ObjectType			LAP_REPAYASSETINFO
		History Log: 
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "��ծ�ʲ������˱��---�ʲ��б�"; // ��������ڱ��� <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;��ծ�ʲ������˱��---�ʲ��б�&nbsp;&nbsp;";
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%
	//�������
	String sSql = "";
	
	//����������	
	String sComponentType	=DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ComponentType"));	
	
%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%	

	String sTempletNo = "AssetManageUserList";//ģ�ͱ��
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(16);  //��������ҳ
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(CurUser.getUserID());
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
				{"true","","Button","�ʲ�����","�鿴��ծ�ʲ�����","viewAndEdit()","","","",""},
				{"true","","Button","���������","���������","Change_Manager()","","","",""},
				{"true","","Button","�鿴�����¼","�鿴�����¼","Change_History()","","","",""}
			};
			
	%> 
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>



<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">
	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=�鿴�ʲ�����;InputParam=��;OutPutParam=SerialNo;]~*/
	function viewAndEdit()
	{
		//��õ�ծ�ʲ���ˮ��
		var sDASerialNo = getItemValue(0,getRow(),"SerialNo");	
		var sAISerialNo = getItemValue(0,getRow(),"AssetSerialNo");					
		if (typeof(sDASerialNo) == "undefined" || sDASerialNo.length == 0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}
		popComp("PDABasicView","/RecoveryManage/PDAManage/PDADailyManage/PDABasicView.jsp","SerialNo="+sDASerialNo+"&AssetSerialNo="+sAISerialNo,"");
		reloadSelf();
	}

	/*~[Describe=�����������Ϣ;InputParam=��;OutPutParam=SerialNo;]~*/
	function Change_Manager()
	{
		var sSerialNo=getItemValue(0,getRow(),"SerialNo");	  //��õ�ծ�ʲ���ˮ��
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��			
		}else
		{
			var sDAOSerialNo = getSerialNo("npa_debtasset_object","SerialNo","");
			var sDATSerialNo = getSerialNo("npa_debtasset_transaction","SerialNo","");
			var sManageOrgID=getItemValue(0,getRow(),"ManageOrgID");	
			var sManageOrgName=getItemValue(0,getRow(),"ManageOrgName");	
			var sManageUserID=getItemValue(0,getRow(),"ManageUserID");	
			var sManageUserName=getItemValue(0,getRow(),"ManageUserName");	
			OpenPage("/RecoveryManage/Public/ChanageManagerInfo.jsp?"+
					"ObjectType=DAChangeManager&ObjectNo="+sSerialNo+
					"&OldManagerUserId="+sManageUserID+
					"&OldManagerUserName="+sManageUserName+
					"&OldManagerOrgId="+sManageOrgID+
					"&OldManagerOrgName="+sManageOrgName+
					"&DAOSerialNo="+sDAOSerialNo+
					"&DATSerialNo="+sDATSerialNo+"&GoBackType=2","right");
		}
	}

	/*~[Describe=�鿴�����������ʷ;InputParam=��;OutPutParam=SerialNo;]~*/	
	function Change_History()
	{
		var sSerialNo=getItemValue(0,getRow(),"SerialNo");	  //��õ�ծ�ʲ���ˮ��
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��			
		}else
		{ 
			//�������ͣ�LIChangeManager ���������˱����DAChangeManager ��ծ�ʲ������˱����PDAChangeManager �Ѻ����ʲ������˱��
			OpenPage("/RecoveryManage/Public/ChangeManagerList.jsp?ObjectType=DAChangeManager&ObjectNo="+sSerialNo+"&GoBackType=2","right");
		}
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

<%@ include file="/IncludeEnd.jsp"%>
