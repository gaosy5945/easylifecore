<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%><%
	String PG_TITLE = "��ծ�ʲ�����"; // ��������ڱ��� <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;��ծ�ʲ�����&nbsp;&nbsp;"; //Ĭ�ϵ�����������
	String PG_CONTNET_TEXT = "��������б�";//Ĭ�ϵ�����������
	String PG_LEFT_WIDTH = "200";//Ĭ�ϵ�treeview���

	//�������
	String  sSerialNo = "";//��ծ��ˮ��		
	String sAssetSerialNo="";//�ʲ���ˮ��
	String  sObjectType = "AssetInfo";
	String  sAssetType = "10";//����
	String  sAssetStatus = "02";//01/02:δ�������;03/04:�ѵ���/���������.�����ܹ���������̨��.

	//����������
	sSerialNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("SerialNo"));
	if (sSerialNo == null)  sSerialNo = "";
	sAssetSerialNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("AssetSerialNo"));
	if (sAssetSerialNo == null)  sAssetSerialNo = "";
	
	String sSql = "";
	ASResultSet rsTemp = null;
	//���ݵ�ծ�ʲ���ˮ�Ż�ȡ�ʲ�����AssetType/AssetStatus
	sSql = " select AI.AssetType,DA.Status from ASSET_INFO AI,NPA_DEBTASSET DA where DA.ASSETSERIALNO=AI.SerialNo and DA.SerialNo = :SerialNo and DA.AssetSerialNo = :AssetSerialNo";
	SqlObject so = null;
	so = new SqlObject(sSql);
	so.setParameter("SerialNo",sSerialNo).setParameter("AssetSerialNo", sAssetSerialNo);
	rsTemp = Sqlca.getASResultSet(so);
	if (rsTemp.next()){
		sAssetType  = DataConvert.toString(rsTemp.getString("AssetType"));
		if (sAssetType == null) sAssetType = "10"; 
		sAssetStatus  = DataConvert.toString(rsTemp.getString("Status"));
		if (sAssetStatus == null) sAssetStatus = "01"; //������
	}
	rsTemp.getStatement().close();		

	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"��ծ�ʲ����������б�","right");
	tviTemp.TriggerClickEvent = true; //�Ƿ��Զ�����ѡ���¼�

	//������ͼ�ṹ:����sEnterPath�Ĳ�ͬ,�����Ƿ���ʾ����̨��.
	String sSqlTreeView  = " from CODE_LIBRARY where CodeNo= 'PDAInfoList' and IsInUse='1'";
	/*if((sAssetStatus.equals("02")) || (sAssetStatus.equals("01")))  //δ����/����׼�����,����ʾ����̨��,������Ҳһ��.
	{
		sSqlTreeView = " from CODE_LIBRARY where CodeNo= 'PDAInfoList'  and ItemNo in ('01','02','03','06','08','19')";
	}else  //"03/04":��ʾ������Ŀ,���Ǳ䶯����б�������ʾ���ƵĲ�ͬ.
	{	//���ѵ����ʲ���,���ݵ������/����Ĳ�ͬ,���䶯̨�ʵ���ʾ����Ҳ��ͬ,���ǵ���ͬһ��ҳ��		
		if (sFlag.equals("010"))  //�������
		{
			sSqlTreeView = " from CODE_LIBRARY where CodeNo= 'PDAInfoList' and ItemNo<>'18' ";
		}else  //�������
		{
			sSqlTreeView = " from CODE_LIBRARY where CodeNo= 'PDAInfoList' and ItemNo<>'16' ";
		}
	}
*/
	tviTemp.initWithSql("SortNo","ItemName","ItemDescribe","","",sSqlTreeView,"Order By SortNo",Sqlca);
	//����������������Ϊ��
	//ID�ֶ�(����),Name�ֶ�(����),Value�ֶ�,Script�ֶ�,Picture�ֶ�,From�Ӿ�(����),OrderBy�Ӿ�,Sqlca
%><%@include file="/Resources/CodeParts/View04.jsp"%>
<script type="text/javascript"> 
	function OpenChildComp(sCompID,sURL,sParameterString){
		sParaStringTmp = "";
		sLastChar=sParameterString.substring(sParameterString.length-1);
		if(sLastChar=="&") sParaStringTmp=sParameterString;
		else sParaStringTmp=sParameterString+"&";

		sParaStringTmp += "ToInheritObj=y&OpenerFunctionName="+getCurTVItem().name;
		OpenComp(sCompID,sURL,sParaStringTmp,"right");
	}	

	/*~[Describe=treeview����ѡ���¼�;InputParam=��;OutPutParam=��;]~*/
	function TreeViewOnClick(){
		var sCurItemID = getCurTVItem().id;
		var sCurItemName = getCurTVItem().name;
		var sCurItemDescribe = getCurTVItem().value;

		var sSerialNo="<%=sSerialNo%>";
		var sAssetSerialNo="<%=sAssetSerialNo%>";
		var sAssetType="<%=sAssetType%>";			
		var sObjectType="<%=sObjectType%>";
		var sAssetStatus="<%=sAssetStatus%>";
		sCurItemDescribe = sCurItemDescribe.split("@");
		sCurItemDescribe1=sCurItemDescribe[0];  //����������ֶ�����@�ָ��ĵ�1����
		sCurItemDescribe2=sCurItemDescribe[1]; //����������ֶ�����@�ָ��ĵ�2����
		//����
		if (sCurItemDescribe2=="goBack"){
			self.close();
		}else if (sCurItemDescribe2=="PDABasicInfo") //������Ϣ
		{
			OpenChildComp(sCurItemDescribe2,sCurItemDescribe1,"ComponentName="+sCurItemName+"&SerialNo="+sSerialNo+"&AssetSerialNo="+sAssetSerialNo+"&AssetType="+sAssetType+"&ObjectType="+sObjectType+"&AssetStatus="+sAssetStatus);		
			setTitle(sCurItemName);
		}else if (sCurItemDescribe2=="PDARelativeContractList") //��غ�ͬ��Ϣ
		{
			OpenChildComp(sCurItemDescribe2,sCurItemDescribe1,"ComponentName="+sCurItemName+"&SerialNo="+sSerialNo+"&AssetSerialNo="+sAssetSerialNo+"&AssetStatus="+sAssetStatus);
			setTitle(sCurItemName);
		}else if(sCurItemDescribe1 != "null" && sCurItemDescribe1 != "root")
		{
			OpenChildComp(sCurItemDescribe2,sCurItemDescribe1,"ComponentName="+sCurItemName+"&ObjectType="+sObjectType+"&SerialNo="+sSerialNo+"&AssetSerialNo="+sAssetSerialNo+"&AssetStatus="+sAssetStatus);
			if (sCurItemDescribe2=="PDABalanceChangeList")
				setTitle(sCurItemName+"(***�����ݴӻ��ϵͳ��ȡ***)")
			else
				setTitle(sCurItemName);
		}
	}
	
	/*~[Describe=����treeview;InputParam=��;OutPutParam=��;]~*/
	function startMenu(){
		<%=tviTemp.generateHTMLTreeView()%>
	}

	startMenu();
	expandNode('root');
</script>
<%@ include file="/IncludeEnd.jsp"%>