
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMDAJAX.jsp"%>


<%
	String DASerialNo = DataConvert.toRealString(iPostChange,CurPage.getParameter("ObjectNo")); //�ʲ���ˮ��
	String sObjectType = DataConvert.toRealString(iPostChange,CurPage.getParameter("ObjectType"));
	String sAssetSerialNo = DataConvert.toRealString(iPostChange,CurPage.getParameter("AssetSerialNo"));
	//����ֵת��Ϊ���ַ���
	if(DASerialNo == null) DASerialNo = "";
	if(sObjectType == null) sObjectType = "";
	if(sAssetSerialNo == null) sAssetSerialNo = "";
	
	//�������
	String sSql = "";
	String sReturnValue="";
	double  dSum1 = 0;//�ʲ����˼�ֵ
	double  dSum2 = 0;//�ۼƳ�����ս��
	double  dSum3 = 0;//�ۼƴ��û��ս��
	double  dSum4 = 0;//�ۼƷ���֧�����
	double  dSum01 = 0;//�ۼƷ���֧�����_֧��
	double  dSum02 = 0;//�ۼƷ���֧�����_����
	double  dSum5 = 0;//�ۼƴ��þ�����
	ASResultSet rs = null;
	SqlObject so = null;

 	//�ʲ����˼�ֵ:�����
 	sSql = "select sum(da.CREDITEDAMOUNT) from npa_debtasset da where da.SerialNo=:SerialNo";
	so = new SqlObject(sSql).setParameter("SerialNo",DASerialNo);
	rs = Sqlca.getASResultSet(so);
	if (rs.next()){
		dSum1=rs.getDouble(1);	
	}
	rs.getStatement().close(); 

 	//�ۼƳ�����ս��:�����
	sSql = 	"select sum(ndt.interestamount) from npa_debtasset_transaction ndt,npa_debtasset da where ndt.debtassetserialno=da.serialno and da.SerialNo=:SerialNo and ndt.objecttype = 'Lease' ";
	so = new SqlObject(sSql).setParameter("SerialNo",DASerialNo);
	rs = Sqlca.getASResultSet(so);
	if (rs.next()){
		dSum2=rs.getDouble(1);
	}
	rs.getStatement().close(); 
 	//�ۼƴ��û��ս��:�����
	sSql = 	"select sum(ndt.interestamount) from npa_debtasset_transaction ndt,npa_debtasset da where ndt.debtassetserialno=da.serialno and da.SerialNo=:SerialNo and ndt.objecttype = 'Disposal' ";
	so = new SqlObject(sSql).setParameter("SerialNo",DASerialNo);
	rs = Sqlca.getASResultSet(so);
	if (rs.next()) dSum3=rs.getDouble(1);
	rs.getStatement().close(); 
	
	//�ۼƷ���֧�����_֧��
	sSql = 	"select sum(nfl.feeamount) from NPA_FEE_LOG nfl,asset_info ai where nfl.ObjectType = 'jbo.preservation.NPA_FEE_LOG' and nfl.ObjectNo =:AssetSerialNo and ai.SerialNo = nfl.ObjectNo  and nfl.direction = '01' ";
	so = new SqlObject(sSql).setParameter("AssetSerialNo",sAssetSerialNo);
	rs = Sqlca.getASResultSet(so);
	if (rs.next()) dSum01=rs.getDouble(1);
	rs.getStatement().close(); 
 	
	//�ۼƷ���֧�����_����
	sSql = 	"select sum(nfl.feeamount) from NPA_FEE_LOG nfl,asset_info ai where nfl.ObjectType = 'jbo.preservation.NPA_FEE_LOG' and nfl.ObjectNo =:AssetSerialNo and ai.SerialNo = nfl.ObjectNo  and nfl.direction = '02' ";
	so = new SqlObject(sSql).setParameter("AssetSerialNo",sAssetSerialNo);
	rs = Sqlca.getASResultSet(so);
	if (rs.next()) dSum02=rs.getDouble(1);
	rs.getStatement().close(); 
	
	dSum4 = dSum02 - dSum01;

	dSum5 = dSum2 + dSum3 - dSum4;
%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Part02;Describe=����ֵ����;]~*/%>
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

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Part03;Describe=����ֵ;]~*/%>
<%	
	out.println(sReturnValue);
%>
<%/*~END~*/%>

<%@ include file="/IncludeEndAJAX.jsp"%>