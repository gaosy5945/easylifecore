<%
/* 
 * Author:  zqliu
 * Tester:
 *
 * Content:   直接插入一条资产纪录
 * Input Param:
 *		AssetType：资产类型
 *		SerialNo：资产类型
 * Output param:
 * History Log:  
 *	      
 */
%>

<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMDAJAX.jsp"%>
<%
	//获取页面参数
	String sAssetType = DataConvert.toRealString(iPostChange,CurPage.getParameter("AssetType")); 
	String sAISerialNo = DataConvert.toRealString(iPostChange,CurPage.getParameter("AISerialNo")); 
	String sDASerialNo = DataConvert.toRealString(iPostChange,CurPage.getParameter("DASerialNo")); 
	//将空值转化为空字符串
	if(sAssetType == null) sAssetType = "";
	if(sAISerialNo == null) sAISerialNo = "";	
	if(sDASerialNo == null) sDASerialNo = "";	
	
	//定义变量	
	String sSql="";
	SqlObject so = null;
	
	sSql = "insert into asset_info "+
			"  (serialNo, assettype, inputuserid, inputorgid, inputdate,updatedate,COUNTRYCODE) "+
			"  values  (:SerialNo,:AssetType,:InputUserID,:InputOrgID,:InputDate,:UpdateData,:COUNTRYCODE)";
	so = new SqlObject(sSql);
	so.setParameter("SerialNo",sAISerialNo);
	so.setParameter("AssetType",sAssetType);
	so.setParameter("InputUserID",CurUser.getUserID());
	so.setParameter("InputOrgID",CurOrg.getOrgID());
	so.setParameter("InputDate",StringFunction.getToday());
	so.setParameter("UpdateData",StringFunction.getToday());
	so.setParameter("COUNTRYCODE","CHN");//COUNTRYCODE
	Sqlca.executeSQL(so);
	
	sSql = "insert into npa_debtasset "+
			"  (serialNo, assetserialno, status, manageuserid, manageorgid, inputuserid, inputorgid,inputdate,Currency,expiateaMount) "+
			"  values(:SerialNo,:AssetSerialNo,:Status,:ManageUserId,:ManageOrgId,:InputUserId,:InputOrgId,:InputDate,:Currency,:expiateaMount)";
	so = new SqlObject(sSql);
	so.setParameter("SerialNo",sDASerialNo);
	so.setParameter("AssetSerialNo",sAISerialNo);
	so.setParameter("Status","01");
	so.setParameter("ManageUserID",CurUser.getUserID());
	so.setParameter("ManageOrgID",CurOrg.getOrgID());
	so.setParameter("InputUserID",CurUser.getUserID());
	so.setParameter("InputOrgID",CurOrg.getOrgID());
	so.setParameter("InputDate",StringFunction.getToday());
	so.setParameter("Currency","CNY");
	so.setParameter("expiateaMount","0.00");
	Sqlca.executeSQL(so);
	
	
%>

<%@ include file="/IncludeEndAJAX.jsp"%>
