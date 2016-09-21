<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%><%
	String PG_TITLE = "授信额度详情"; // 浏览器窗口标题 <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;授信额度详情&nbsp;&nbsp;"; //默认的内容区标题
	String PG_CONTNET_TEXT = "请点击左侧列表";//默认的内容区文字
	String PG_LEFT_WIDTH = "200";//默认的treeview宽度
	
	//获得组件参数
	//合同流水号
	String sBCSerialNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	String sViewID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ViewID"));
	if(sBCSerialNo==null) sBCSerialNo="";
	//获得页面参数	
	String sSql = " select LineID from CL_INFO where BCSerialNo=:BCSerialNo and (ParentLineID is null or ParentLineID='' or ParentLineID=' ') ";
	//获得授信额度总协议号
	String sParentLineID = Sqlca.getString(new SqlObject(sSql).setParameter("BCSerialNo",sBCSerialNo));
	
	String sSql1 = " select BusinessType from business_contract where serialno=:serialno";
	//获得业务品种
	String sBusinessType = Sqlca.getString(new SqlObject(sSql1).setParameter("serialno",sBCSerialNo));
	
	if(sParentLineID==null) sParentLineID="";
	if(sBusinessType==null) sBusinessType="";

	//定义Treeview
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"授信额度详情","right");
	tviTemp.TriggerClickEvent=true; //是否自动触发选中事件
	
	int iOrder = 1;
	//tviTemp.insertPage("root","概览","",iOrder++);
	tviTemp.insertPage("root","授信额度基本信息","",iOrder++);
	if( sBusinessType.equals("3005")||sBusinessType.equals("3010")){
		tviTemp.insertPage("root","授信额度分配","",iOrder++);
	}
%><%@include file="/Resources/CodeParts/View04.jsp"%>
<script type="text/javascript"> 
	//treeview单击选中事件	
	function TreeViewOnClick(){
		var sCurItemID = getCurTVItem().id;
		var sCurItemname = getCurTVItem().name;
		if(sCurItemname=="授信额度基本信息"){
			OpenComp("CreditLineInfo","/CreditManage/CreditLine/CreditLineInfo.jsp","ToInheritObj=y&SerialNo=<%=sBCSerialNo%>","right");
		}
		if(sCurItemname=="授信额度分配"){
			OpenComp("SubCreditLineList","/CreditManage/CreditLine/SubCreditLineList.jsp","ToInheritObj=y&ParentLineID=<%=sParentLineID%>","right");
		}
		setTitle(getCurTVItem().name);
	}
	
	function startMenu(){
		<%=tviTemp.generateHTMLTreeView()%>
	}

	startMenu();
	selectItemByName("授信额度基本信息");
	expandNode('root');	
</script>
<%@ include file="/IncludeEnd.jsp"%>