<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMDAJAX.jsp"%>
<%
	//获取页面参数
	String sAssetType = DataConvert.toRealString(iPostChange,CurPage.getParameter("AssetType")); 
	String sSerialNo = DataConvert.toRealString(iPostChange,CurPage.getParameter("SerialNo")); 
	String sAssetSerialNo = DataConvert.toRealString(iPostChange,CurPage.getParameter("AssetSerialNo")); 
	//将空值转化为空字符串
	if(sAssetType == null) sAssetType = "";
	if(sSerialNo == null) sSerialNo = "";	
	if(sAssetSerialNo == null) sAssetSerialNo = "";	
	
	//定义变量	
	String sSql="";
	SqlObject so = null;
	
	sSql = "delete asset_info where serialno=:SerialNo";
	so = new SqlObject(sSql);
	so.setParameter("SerialNo",sAssetSerialNo);
	Sqlca.executeSQL(so);
	
	//删除关联合同信息  删除关联诉讼信息 
	sSql = "delete npa_debtasset_object DAO where Debtassetserialno=:SerialNo and Objecttype in('jbo.preservation.LAWCASE_INFO' , 'Business_Contract')";
	so = new SqlObject(sSql);
	so.setParameter("SerialNo",sSerialNo);
	Sqlca.executeSQL(so);

	//删除保险记录信息jbo.app.INSURANCE_INFO  where .ObjectType = '#ObjectType' and INSURANCE_INFO.ObjectNo = '#ObjectNo' and ASSET_INFO.SerialNo = INSURANCE_INFO.ObjectNo 
	/* sSql = "delete INSURANCE_INFO where serialno=:SerialNo and ObjectNo=:AssetSerialNo";
	so = new SqlObject(sSql);
	so.setParameter("SerialNo",sSerialNo);
	so.setParameter("AssetSerialNo",sAssetSerialNo);
	Sqlca.executeSQL(so); */

	//删除价值评估信息‘jbo.app.ASSET_EVALUATE’where ai.serialno=ae.assetserialno and ae.assetserialno='#AssetSerialNo'  
	/* sSql = "delete asset_evaluate  where  assetSerialNo=:AssetSerialNo";
	so = new SqlObject(sSql);
	so.setParameter("AssetSerialNo",sAssetSerialNo);
	Sqlca.executeSQL(so); */

	// 删除价值变动信息‘jbo.app.ASSET_EVENT’ where ai.serialno=ae.assetserialno and ae.assetserialno='#AssetSerialNo' 
	/* sSql = "delete ASSET_EVENT  where assetSerialNo=:AssetSerialNo";
	so = new SqlObject(sSql);
	so.setParameter("AssetSerialNo",sAssetSerialNo);
	Sqlca.executeSQL(so); */

	//删除抵债处置、出租台账 where dao.debtassetserialno=da.serialno and dat.debtassetserialno=dao.serialno and da.serialno='#SerialNo' and dao.objecttype='#ObjectType'  
	//from npa_debtasset da,npa_debtasset_transaction dat,npa_debtasset_object dao 
	/* sSql = "delete npa_debtasset where serialno=:SerialNo and assetSerialNo=:AssetSerialNo and ObjectType in（:ObjectType）";
	so = new SqlObject(sSql);
	so.setParameter("SerialNo",sSerialNo);
	so.setParameter("AssetSerialNo",sAssetSerialNo);
	so.setParameter("AssetSerialNo","Lease','Disposal");
	Sqlca.executeSQL(so); */

	//删除抵债收现台账 from npa_debtasset da,npa_debtasset_transaction dat, npa_debtasset_object dao,asset_info ai 
	//where dao.debtassetserialno = da.serialno and ai.serialno=da.assetserialno and dat.debtassetserialno=dao.serialno and dao.objecttype = '#ObjectType' and da.serialno='#ObjectNo' 
	/* sSql = "delete npa_debtasset_object where debtassetserialno=:SerialNo and ObjectType=:ObjectType";
	so = new SqlObject(sSql);
	so.setParameter("SerialNo",sSerialNo);
	so.setParameter("ObjectType","Cash");
	Sqlca.executeSQL(so); */

	//s删除资产税费台账where NPA_FEE_LOG.ObjectType = '#ObjectType'and NPA_FEE_LOG.ObjectNo = '#ObjectNo'and ASSET_INFO.SerialNo = NPA_FEE_LOG.ObjectNo 
	sSql = "delete NPA_FEE_LOG where ObjectNo=:SerialNo and ObjectType=:ObjectType";
	so = new SqlObject(sSql);
	so.setParameter("SerialNo",sSerialNo);
	so.setParameter("ObjectType","jbo_preservation.NPA_FEE_LOG");
	Sqlca.executeSQL(so);
	
	//删除文档信息 //DOCNO=DL.DOCNO and OBJECTTYPE=:OBJECTTYPE and OBJECTNO=:OBJECTNO 
	/* sSql = "delete DOC_RELATIVE where OBJECTTYPE=:OBJECTTYPE and assetSerialNo=:AssetSerialNo";
	so = new SqlObject(sSql);
	so.setParameter("OBJECTTYPE","jbo.app.ASSET_INFO");
	so.setParameter("AssetSerialNo",sAssetSerialNo);
	Sqlca.executeSQL(so); */

	//最后删除抵债信息
	sSql = "delete npa_debtasset where serialno=:SerialNo and assetSerialNo=:AssetSerialNo";
	so = new SqlObject(sSql);
	so.setParameter("SerialNo",sSerialNo);
	so.setParameter("AssetSerialNo",sAssetSerialNo);
	Sqlca.executeSQL(so);
	
%>

<%@ include file="/IncludeEndAJAX.jsp"%>
