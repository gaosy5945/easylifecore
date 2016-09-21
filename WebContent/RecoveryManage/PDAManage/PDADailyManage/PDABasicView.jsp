<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%><%
	String PG_TITLE = "抵债资产详情"; // 浏览器窗口标题 <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;抵债资产详情&nbsp;&nbsp;"; //默认的内容区标题
	String PG_CONTNET_TEXT = "请点击左侧列表";//默认的内容区文字
	String PG_LEFT_WIDTH = "200";//默认的treeview宽度

	//定义变量
	String  sSerialNo = "";//抵债流水号		
	String sAssetSerialNo="";//资产流水号
	String  sObjectType = "AssetInfo";
	String  sAssetType = "10";//房产
	String  sAssetStatus = "02";//01/02:未抵入进入;03/04:已抵入/处置完进入.决定能够看到处置台帐.

	//获得组件参数
	sSerialNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("SerialNo"));
	if (sSerialNo == null)  sSerialNo = "";
	sAssetSerialNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("AssetSerialNo"));
	if (sAssetSerialNo == null)  sAssetSerialNo = "";
	
	String sSql = "";
	ASResultSet rsTemp = null;
	//根据抵债资产流水号获取资产类型AssetType/AssetStatus
	sSql = " select AI.AssetType,DA.Status from ASSET_INFO AI,NPA_DEBTASSET DA where DA.ASSETSERIALNO=AI.SerialNo and DA.SerialNo = :SerialNo and DA.AssetSerialNo = :AssetSerialNo";
	SqlObject so = null;
	so = new SqlObject(sSql);
	so.setParameter("SerialNo",sSerialNo).setParameter("AssetSerialNo", sAssetSerialNo);
	rsTemp = Sqlca.getASResultSet(so);
	if (rsTemp.next()){
		sAssetType  = DataConvert.toString(rsTemp.getString("AssetType"));
		if (sAssetType == null) sAssetType = "10"; 
		sAssetStatus  = DataConvert.toString(rsTemp.getString("Status"));
		if (sAssetStatus == null) sAssetStatus = "01"; //待处置
	}
	rsTemp.getStatement().close();		

	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"抵债资产基本详情列表","right");
	tviTemp.TriggerClickEvent = true; //是否自动触发选中事件

	//定义树图结构:根据sEnterPath的不同,决定是否显示处置台帐.
	String sSqlTreeView  = " from CODE_LIBRARY where CodeNo= 'PDAInfoList' and IsInUse='1'";
	/*if((sAssetStatus.equals("02")) || (sAssetStatus.equals("01")))  //未抵入/已批准拟抵入,不显示处置台帐,申请中也一样.
	{
		sSqlTreeView = " from CODE_LIBRARY where CodeNo= 'PDAInfoList'  and ItemNo in ('01','02','03','06','08','19')";
	}else  //"03/04":显示所有项目,但是变动余额有表内外显示名称的不同.
	{	//对已抵入资产中,根据抵入表内/表外的不同,余额变动台帐的显示名称也不同,但是调用同一个页面		
		if (sFlag.equals("010"))  //抵入表内
		{
			sSqlTreeView = " from CODE_LIBRARY where CodeNo= 'PDAInfoList' and ItemNo<>'18' ";
		}else  //抵入表外
		{
			sSqlTreeView = " from CODE_LIBRARY where CodeNo= 'PDAInfoList' and ItemNo<>'16' ";
		}
	}
*/
	tviTemp.initWithSql("SortNo","ItemName","ItemDescribe","","",sSqlTreeView,"Order By SortNo",Sqlca);
	//参数从左至右依次为：
	//ID字段(必须),Name字段(必须),Value字段,Script字段,Picture字段,From子句(必须),OrderBy子句,Sqlca
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

	/*~[Describe=treeview单击选中事件;InputParam=无;OutPutParam=无;]~*/
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
		sCurItemDescribe1=sCurItemDescribe[0];  //代码表描述字段中用@分隔的第1个串
		sCurItemDescribe2=sCurItemDescribe[1]; //代码表描述字段中用@分隔的第2个串
		//返回
		if (sCurItemDescribe2=="goBack"){
			self.close();
		}else if (sCurItemDescribe2=="PDABasicInfo") //基本信息
		{
			OpenChildComp(sCurItemDescribe2,sCurItemDescribe1,"ComponentName="+sCurItemName+"&SerialNo="+sSerialNo+"&AssetSerialNo="+sAssetSerialNo+"&AssetType="+sAssetType+"&ObjectType="+sObjectType+"&AssetStatus="+sAssetStatus);		
			setTitle(sCurItemName);
		}else if (sCurItemDescribe2=="PDARelativeContractList") //相关合同信息
		{
			OpenChildComp(sCurItemDescribe2,sCurItemDescribe1,"ComponentName="+sCurItemName+"&SerialNo="+sSerialNo+"&AssetSerialNo="+sAssetSerialNo+"&AssetStatus="+sAssetStatus);
			setTitle(sCurItemName);
		}else if(sCurItemDescribe1 != "null" && sCurItemDescribe1 != "root")
		{
			OpenChildComp(sCurItemDescribe2,sCurItemDescribe1,"ComponentName="+sCurItemName+"&ObjectType="+sObjectType+"&SerialNo="+sSerialNo+"&AssetSerialNo="+sAssetSerialNo+"&AssetStatus="+sAssetStatus);
			if (sCurItemDescribe2=="PDABalanceChangeList")
				setTitle(sCurItemName+"(***该数据从会计系统获取***)")
			else
				setTitle(sCurItemName);
		}
	}
	
	/*~[Describe=生成treeview;InputParam=无;OutPutParam=无;]~*/
	function startMenu(){
		<%=tviTemp.generateHTMLTreeView()%>
	}

	startMenu();
	expandNode('root');
</script>
<%@ include file="/IncludeEnd.jsp"%>