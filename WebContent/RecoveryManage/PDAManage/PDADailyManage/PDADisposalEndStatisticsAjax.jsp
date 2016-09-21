
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMDAJAX.jsp"%>


<%
	String DASerialNo = DataConvert.toRealString(iPostChange,CurPage.getParameter("ObjectNo")); //资产流水号
	String sObjectType = DataConvert.toRealString(iPostChange,CurPage.getParameter("ObjectType"));
	String sAssetSerialNo = DataConvert.toRealString(iPostChange,CurPage.getParameter("AssetSerialNo"));
	//将空值转化为空字符串
	if(DASerialNo == null) DASerialNo = "";
	if(sObjectType == null) sObjectType = "";
	if(sAssetSerialNo == null) sAssetSerialNo = "";
	
	//定义变量
	String sSql = "";
	String sReturnValue="";
	double  dSum1 = 0;//资产入账价值
	double  dSum2 = 0;//累计出租回收金额
	double  dSum3 = 0;//累计处置回收金额
	double  dSum4 = 0;//累计费用支付金额
	double  dSum01 = 0;//累计费用支付金额_支付
	double  dSum02 = 0;//累计费用支付金额_回收
	double  dSum5 = 0;//累计处置净收入
	ASResultSet rs = null;
	SqlObject so = null;

 	//资产入账价值:人民币
 	sSql = "select sum(da.CREDITEDAMOUNT) from npa_debtasset da where da.SerialNo=:SerialNo";
	so = new SqlObject(sSql).setParameter("SerialNo",DASerialNo);
	rs = Sqlca.getASResultSet(so);
	if (rs.next()){
		dSum1=rs.getDouble(1);	
	}
	rs.getStatement().close(); 

 	//累计出租回收金额:人民币
	sSql = 	"select sum(ndt.interestamount) from npa_debtasset_transaction ndt,npa_debtasset da where ndt.debtassetserialno=da.serialno and da.SerialNo=:SerialNo and ndt.objecttype = 'Lease' ";
	so = new SqlObject(sSql).setParameter("SerialNo",DASerialNo);
	rs = Sqlca.getASResultSet(so);
	if (rs.next()){
		dSum2=rs.getDouble(1);
	}
	rs.getStatement().close(); 
 	//累计处置回收金额:人民币
	sSql = 	"select sum(ndt.interestamount) from npa_debtasset_transaction ndt,npa_debtasset da where ndt.debtassetserialno=da.serialno and da.SerialNo=:SerialNo and ndt.objecttype = 'Disposal' ";
	so = new SqlObject(sSql).setParameter("SerialNo",DASerialNo);
	rs = Sqlca.getASResultSet(so);
	if (rs.next()) dSum3=rs.getDouble(1);
	rs.getStatement().close(); 
	
	//累计费用支付金额_支付
	sSql = 	"select sum(nfl.feeamount) from NPA_FEE_LOG nfl,asset_info ai where nfl.ObjectType = 'jbo.preservation.NPA_FEE_LOG' and nfl.ObjectNo =:AssetSerialNo and ai.SerialNo = nfl.ObjectNo  and nfl.direction = '01' ";
	so = new SqlObject(sSql).setParameter("AssetSerialNo",sAssetSerialNo);
	rs = Sqlca.getASResultSet(so);
	if (rs.next()) dSum01=rs.getDouble(1);
	rs.getStatement().close(); 
 	
	//累计费用支付金额_回收
	sSql = 	"select sum(nfl.feeamount) from NPA_FEE_LOG nfl,asset_info ai where nfl.ObjectType = 'jbo.preservation.NPA_FEE_LOG' and nfl.ObjectNo =:AssetSerialNo and ai.SerialNo = nfl.ObjectNo  and nfl.direction = '02' ";
	so = new SqlObject(sSql).setParameter("AssetSerialNo",sAssetSerialNo);
	rs = Sqlca.getASResultSet(so);
	if (rs.next()) dSum02=rs.getDouble(1);
	rs.getStatement().close(); 
	
	dSum4 = dSum02 - dSum01;

	dSum5 = dSum2 + dSum3 - dSum4;
%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Part02;Describe=返回值处理;]~*/%>
<%	
	ArgTool args = new ArgTool();
	args.addArg(dSum1+"");
	args.addArg(dSum2+"");
	args.addArg(dSum3+"");
	args.addArg(dSum4+"");
	args.addArg(dSum5+"");
	sReturnValue = args.getArgString();
%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Part03;Describe=返回值;]~*/%>
<%	
	out.println(sReturnValue);
%>
<%/*~END~*/%>

<%@ include file="/IncludeEndAJAX.jsp"%>