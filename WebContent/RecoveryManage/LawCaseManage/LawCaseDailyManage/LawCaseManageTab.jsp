<%@ page contentType="text/html; charset=GBK"%><%@
include file="/IncludeBegin.jsp"%><%
	/* 
	--页面说明： 通过数组定义生成Tab框架页面示例--
	*/
	
	//定义tab数组：
	//参数：0.是否显示, 1.标题，2.URL，3，参数串
	String sTabStrip[][] = new String[10][4];
	/*  {
		{"true", "待诉讼案件", "/RecoveryManage/LawCaseManage/LawCaseDailyManage/LawCaseManageList.jsp", "ItemID=010"},
		{"true", "已诉讼案件", "/RecoveryManage/LawCaseManage/LawCaseDailyManage/LawCaseManageList.jsp", "ItemID=020"},
		{"true", "取消诉讼案件", "/RecoveryManage/LawCaseManage/LawCaseDailyManage/LawCaseManageList.jsp", "ItemID=030"},
	};  */
	 SqlObject so = null;
	ASResultSet rs = null;
	String CodeNo= "CaseList";
	String sUrl="";
	String sParm="";
	String sItemDescribefrom="";
	String sItemName="";
	String sSql = "select SortNo,ItemName,ItemDescribe from CODE_LIBRARY where CodeNo=:CodeNo and IsInUse = '1'";
	so = new SqlObject(sSql).setParameter("CodeNo",CodeNo);
	rs = Sqlca.getASResultSet(so);
	int i=0;
	while (rs.next()){
		sItemName=rs.getString(2);
		sItemDescribefrom = rs.getString(3);
		sUrl=sItemDescribefrom.split("@")[0];
		sParm=sItemDescribefrom.split("@")[2].split("&")[1];
		sTabStrip[i][0]="true";
		sTabStrip[i][1]=sItemName;
		sTabStrip[i][2]=sUrl;
		sTabStrip[i][3]=sParm;
		i++;
	}
	rs.getStatement().close(); 

%><%@ include file="/Resources/CodeParts/Tab01.jsp"%>
<%@ include file="/IncludeEnd.jsp"%>
