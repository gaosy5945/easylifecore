<%@ page contentType="text/html; charset=GBK"%><%@
include file="/IncludeBegin.jsp"%><%
	/* 
	--ҳ��˵���� ͨ�����鶨������Tab���ҳ��ʾ��--
	*/
	
	//����tab���飺
	//������0.�Ƿ���ʾ, 1.���⣬2.URL��3��������
	String sTabStrip[][] = new String[10][4];
	/*  {
		{"true", "�����ϰ���", "/RecoveryManage/LawCaseManage/LawCaseDailyManage/LawCaseManageList.jsp", "ItemID=010"},
		{"true", "�����ϰ���", "/RecoveryManage/LawCaseManage/LawCaseDailyManage/LawCaseManageList.jsp", "ItemID=020"},
		{"true", "ȡ�����ϰ���", "/RecoveryManage/LawCaseManage/LawCaseDailyManage/LawCaseManageList.jsp", "ItemID=030"},
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
