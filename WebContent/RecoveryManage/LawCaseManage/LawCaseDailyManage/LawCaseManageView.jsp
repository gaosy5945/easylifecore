<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%><%
	String PG_TITLE = "��������"; // ��������ڱ��� <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;����������Ϣ&nbsp;&nbsp;"; //Ĭ�ϵ�����������
	String PG_CONTNET_TEXT = "��������б�";//Ĭ�ϵ�����������
	String PG_LEFT_WIDTH = "200";//Ĭ�ϵ�treeview���

	//���������Sql��䡢��������
	String sSql = "";
	String sLawCaseType = "";
	String 	sPigeonholeDate ="";
	//����������(������ˮ��)	
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	if(sSerialNo == null) sSerialNo = "";
	String sFinishType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("FinishType",3));
	if(sFinishType == null) sFinishType = "";
	//��ȡ��������
	sSql =  " select LawCaseType from LAWCASE_INFO where SerialNo =:SerialNo ";
   	sLawCaseType = Sqlca.getString(new SqlObject(sSql).setParameter("SerialNo",sSerialNo)); 
	//��ȡ�鵵����
	sSql =  " select PigeonholeDate from LAWCASE_INFO where SerialNo =:SerialNo ";
	sPigeonholeDate = Sqlca.getString(new SqlObject(sSql).setParameter("SerialNo",sSerialNo)); 
	if(sPigeonholeDate ==null) sPigeonholeDate="";
   	
	//����Treeview
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"���������б�","right");
	tviTemp.TriggerClickEvent=true; //�Ƿ��Զ�����ѡ���¼�

	//������ͼ�ṹ
	//���ݲ�ͬ�İ�������LawCaseType�Ĳ�ͬ����ʾ��ͬ�����β˵�
	if(sLawCaseType.equals("01"))	//һ�㰸��
	{
		String sSqlTreeView = " from CODE_LIBRARY where CodeNo = 'CaseInfoList1' and IsInUse = '1' ";
		tviTemp.initWithSql("SortNo","ItemName","ItemDescribe","","",sSqlTreeView,"Order By SortNo",Sqlca);
		//����������������Ϊ��
		//ID�ֶ�(����),Name�ֶ�(����),Value�ֶ�,Script�ֶ�,Picture�ֶ�,From�Ӿ�(����),OrderBy�Ӿ�,Sqlca
	}
	if(sLawCaseType.equals("02"))	//����/�ٲð���
	{
		String sSqlTreeView = " from CODE_LIBRARY where CodeNo= 'CaseInfoList2' and IsInUse = '1' ";
		tviTemp.initWithSql("SortNo","ItemName","ItemDescribe","","",sSqlTreeView,"Order By SortNo",Sqlca);
	}
	//if(sLawCaseType.equals("05"))	//�Ʋ�����
	//{
	//	String sSqlTreeView = " from CODE_LIBRARY where CodeNo= 'CaseInfoList5' and IsInUse = '1' ";
	//	tviTemp.initWithSql("SortNo","ItemName","ItemDescribe","","",sSqlTreeView,"Order By SortNo",Sqlca);
	//}
%><%@include file="/Resources/CodeParts/View04.jsp"%>
<script type="text/javascript"> 
	/*~[Describe=treeview����ѡ���¼�;InputParam=��;OutPutParam=��;]~*/
	function openChildComp(sCompID,sURL,sParameterString){
		sParaStringTmp = "";
		sLastChar=sParameterString.substring(sParameterString.length-1);
		if(sLastChar=="&") sParaStringTmp=sParameterString;
		else sParaStringTmp=sParameterString+"&";

		sParaStringTmp += "ToInheritObj=y&OpenerFunctionName="+getCurTVItem().name;
		OpenComp(sCompID,sURL,sParaStringTmp,"right");
	}
	
	function TreeViewOnClick(){
		var sCurItemID = getCurTVItem().id;
		var sCurItemName = getCurTVItem().name;
		var sCurItemDescribe = getCurTVItem().value;
		sCurItemDescribe = sCurItemDescribe.split("@");
		sCurItemDescribe1=sCurItemDescribe[0];
		sCurItemDescribe2=sCurItemDescribe[1];
		var sBookType=sCurItemDescribe[2];	//̨������
		sSerialNo = "<%=sSerialNo%>";
		sLawCaseType = "<%=sLawCaseType%>";
		if(sCurItemID!="root"){
			if(sCurItemDescribe2 == "Back"){
				self.close();
				opener.location.reload();
			}else if(sCurItemDescribe1 != "null" && sCurItemDescribe1 != "root"){
				if(sCurItemDescribe2 == "DocumentList"){
					openChildComp(sCurItemDescribe2,sCurItemDescribe1,"ComponentName="+sCurItemName+"&PigeonholeDate=<%=sPigeonholeDate%>&FinishType=<%=sFinishType%>&ObjectType=LawcaseInfo&ObjectNo="+sSerialNo,OpenStyle);
				}else
					openChildComp(sCurItemDescribe2,sCurItemDescribe1,"ComponentName="+sCurItemName+"&PigeonholeDate=<%=sPigeonholeDate%>&FinishType=<%=sFinishType%>&BookType="+sBookType+"&SerialNo="+sSerialNo+"&LawCaseType="+sLawCaseType,OpenStyle);
				setTitle(sCurItemName);
			} 
		}
	}
	
	/*~[Describe=����treeview;InputParam=��;OutPutParam=��;]~*/
	function startMenu(){
		<%=tviTemp.generateHTMLTreeView()%>
	}

	startMenu();
	expandNode('root');
	//expandNode('010');
	//expandNode('030001');	
	selectItem('010');
	//if("<%=sLawCaseType%>" == "01"){
    //            openChildComp("CaseFrame","/RecoveryManage/LawCaseManage/LawCaseDailyManage/CaseFrame.jsp","ComponentName=��������&SerialNo=<%=sSerialNo%>&LawCaseType=<%=sLawCaseType%>",OpenStyle);
    //            setTitle("��������");
   	// }

</script>
<%@ include file="/IncludeEnd.jsp"%>