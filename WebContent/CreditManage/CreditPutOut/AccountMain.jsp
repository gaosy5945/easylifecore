<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%><%
	String PG_TITLE = "�Ż���������"; // ��������ڱ��� <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;�Ż���������&nbsp;&nbsp;"; //Ĭ�ϵ�����������
	String PG_CONTNET_TEXT = "��������б�";//Ĭ�ϵ�����������
	String PG_LEFT_WIDTH = "200";//Ĭ�ϵ�treeview���

	//�������
	String sSqlTreeView = "",sBusinessType = "",sTypesortNo = "";
	String sSql="";
	//����������	
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("SerialNo"));
	if(sSerialNo == null) sSerialNo = "";

	//����Treeview
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"�Ż������","right");
	tviTemp.TriggerClickEvent=true; //�Ƿ��Զ�����ѡ���¼�
	
	//��ȡ��ͬ����Ӧ��ҵ��Ʒ��
	sSql="select BusinessType from BUSINESS_CONTRACT where SerialNo=:SerialNo";
	sBusinessType = Sqlca.getString(new SqlObject(sSql).setParameter("SerialNo",sSerialNo));
	//��ȡҵ��Ʒ������Ӧ���Ƿ����������־
	sSql="select TypesortNo from BUSINESS_TYPE where TypeNo=:TypeNo";
	sTypesortNo = Sqlca.getString(new SqlObject(sSql).setParameter("TypeNo",sBusinessType));
	if(sTypesortNo == null) sTypesortNo = "";
	//������ͼ�ṹ
	if(sTypesortNo.equals("1")) //�Ƿ����������־��1���ǣ�2����
	{
		sSqlTreeView = "from CODE_LIBRARY where CodeNo= 'AccountMain' and IsInUse = '1' ";
	}else if(sTypesortNo.equals("2")) //�Ƿ����������־��1���ǣ�2����
	{
		sSqlTreeView = "from CODE_LIBRARY where CodeNo= 'AccountMain' and ItemNo in ('0030','0040')  and IsInUse = '1' ";
	}
	
	tviTemp.initWithSql("SortNo","ItemName","ItemDescribe","","",sSqlTreeView,"Order By SortNo",Sqlca);
	//����������������Ϊ��
	//ID�ֶ�(����),Name�ֶ�(����),Value�ֶ�,Script�ֶ�,Picture�ֶ�,From�Ӿ�(����),OrderBy�Ӿ�,Sqlca
%><%@include file="/Resources/CodeParts/View04.jsp"%>
<script type="text/javascript"> 
	function openChildComp(sCompID,sURL,sParameterString){
		sParaStringTmp = "";
		sLastChar=sParameterString.substring(sParameterString.length-1);
		if(sLastChar=="&") sParaStringTmp=sParameterString;
		else sParaStringTmp=sParameterString+"&";

		sParaStringTmp += "ToInheritObj=y&OpenerFunctionName="+getCurTVItem().name;
		OpenComp(sCompID,sURL,sParaStringTmp,"right");
	}
	
	//treeview����ѡ���¼�
	function TreeViewOnClick(){
		var sCurItemName = getCurTVItem().name;
		var sCurItemDescribe = getCurTVItem().value;
		sCurItemDescribe = sCurItemDescribe.split("@");
		sCurItemDescribe1=sCurItemDescribe[0];
		sCurItemDescribe2=sCurItemDescribe[1];
		var sCurItemDescribe3=sCurItemDescribe[2];
		sSerialNo = "<%=sSerialNo%>";
		if(typeof(sCurItemDescribe3)!="undefined" && sCurItemDescribe3.length > 0){
			OpenComp(sCurItemDescribe2,sCurItemDescribe1,"ComponentName="+sCurItemName+"&AccountType="+sCurItemDescribe3+"&ObjectNo="+sSerialNo,"right");
		}
		setTitle(getCurTVItem().name);
	}
	
	function startMenu(){
		<%=tviTemp.generateHTMLTreeView()%>
	}

	startMenu();
	expandNode('root');
</script>
<%@ include file="/IncludeEnd.jsp"%>