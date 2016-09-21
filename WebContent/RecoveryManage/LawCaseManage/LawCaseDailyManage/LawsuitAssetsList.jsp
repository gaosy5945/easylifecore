<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:  zqliu
		Tester:
		Content: ����ʲ��б�
		Input Param:
				SerialNo:�������
				BookType��̨������				      
		Output param:
				SerialNo������ʲ����
				AssetType������ʲ�����
				ObjectNo:�����Ż򰸼����
				ObjectType:��������
		                  
	 */
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "����ʲ��б�"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%
	//�������
	String sSql = "";
		
	//������������������ˮ�š�̨�����ͣ�	
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("SerialNo"));
	String sBookType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("BookType"));
	//��ȡ��ͬ�ս�����
    String sFinishType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("FinishType"));   
    String sPigeonholeDate = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("PigeonholeDate"));   

	//����ֵת��Ϊ���ַ���
    if( sPigeonholeDate == null) sPigeonholeDate = "";
	if(sBookType == null) sBookType = "";
	if(sSerialNo == null) sSerialNo = "";
    if(sFinishType == null) sFinishType = "";
	
%>
<%/*~END~*/%>

<%
	//ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "LawsuitAssetsList";//ģ�ͱ��
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style = "1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(20);  //��������ҳ

	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sSerialNo);
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
			{"true","All","Button","����","����һ����¼","newRecord()","","","",""},
			{"true","","Button","����","�鿴/�޸�����","viewAndEdit()","","","",""},
			{"true","All","Button","ɾ��","ɾ����ѡ�еļ�¼","deleteRecord()","","","",""},
			{"true","","Button","�˳����","�˳�����ʲ���Ϣ","quitRecord()","","","",""}
			};
	
	%> 
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">

	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=������¼;InputParam=��;OutPutParam=SerialNo;]~*/
	function newRecord()
	{			
		OpenPage("/RecoveryManage/LawCaseManage/LawCaseDailyManage/LawsuitAssetsInfo.jsp?BookType=<%=sBookType%>&ObjectNo=<%=sSerialNo%>&ObjectType=LawcaseInfo&SerialNo=","right","");  
	}
	
	/*~[Describe=ɾ����¼;InputParam=��;OutPutParam=��;]~*/
	function deleteRecord()
	{
		sSerialNo=getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}
		
		if(confirm(getHtmlMessage(2))) //�������ɾ������Ϣ��
		{
			as_del("myiframe0");
			as_save("myiframe0");  //�������ɾ������Ҫ���ô����
		}
	}

	/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=SerialNo;]~*/
	function viewAndEdit()
	{
		//��ü�¼��ˮ�š�������Ż�����š��������͡�����ʲ�����
		var sSerialNo=getItemValue(0,getRow(),"SerialNo");	
		var sObjectNo=getItemValue(0,getRow(),"ObjectNo");
		var sObjectType=getItemValue(0,getRow(),"ObjectType");
		var sLawsuitAssetsType=getItemValue(0,getRow(),"AssetType");
		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}
		
		OpenPage("/RecoveryManage/LawCaseManage/LawCaseDailyManage/LawsuitAssetsInfo.jsp?PageSerialNo="+sSerialNo+"&BookType=<%=sBookType%>&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType+"","right","");

	}
	/*~[Describe=�˳����;InputParam=��;OutPutParam=SerialNo;]~*/
	function quitRecord()
	{
		//��ü�¼��ˮ��
		var sSerialNo=getItemValue(0,getRow(),"SerialNo");
		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}
		
		if(confirm(getBusinessMessage("774"))) //�ò���ʲ����Ҫ�˳������
		{
			var sReturn = RunMethod("PublicMethod","UpdateColValue","String@AssetStatus@02,ASSET_INFO,String@SerialNo@"+sSerialNo);
			if(sReturn == "TRUE") //ˢ��ҳ��
			{
				alert(getBusinessMessage("775"));//�ò���ʲ��ѳɹ��˳���⣡
				reloadSelf();
			}else
			{
				alert(getBusinessMessage("776")); //�ò���ʲ��˳����ʧ�ܣ�
				return;
			}
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
