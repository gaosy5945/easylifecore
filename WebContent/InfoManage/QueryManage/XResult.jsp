<%@ page contentType="text/html; charset=GBK"%>
<%@ page import="com.amarsoft.xquery.*,org.w3c.dom.*"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author: 
		Tester:
		Content: �Բ�ѯ�������д�������Sql
		Input Param:
		     type:��ѯ����
                GroupList;;Other;	:�����б�
 				SummaryList;;Other;	:�����б�
 				OrderList;;Other;	:�����б�
 				DisplayList;;Other;	:��ʾ�б�
		Output param:
		History Log: 

	 */
	%>
<%/*~END~*/%>


<script>
	//��ʾ�Ŀ���
	var aw = screen.availWidth;
	var ah = screen.availHeight;
	window.moveTo(0, 0);
	window.resizeTo(aw, ah);
</script>
    
    
<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ò�������ѯ;]~*/%>
<%
	String header[][]= null;
	XQuery query = new XQuery(request.getRealPath("")+"/InfoManage/QueryManage/",(String)session.getValue("queryType"));
	Vector colList = query.getAllColumnsList();
	//��������������ѯ��·���Ͳ�ѯ����
	ASQuery asq = new ASQuery(request);
	String mforgid = request.getParameter("BD.MFORGID as BDMFORGID;String;Where;like");
	if(mforgid == null || "".equals(mforgid)) mforgid = CurUser.getOrgID();
	String whereSql = asq.genWhere();
	boolean flag = false;
	int all = 0;
	if(whereSql != null && !"".equals(whereSql.trim())){
		flag = true;
		whereSql = whereSql.replaceAll("BD.MFORGID", "'"+mforgid+"'");
		whereSql = whereSql.replaceAll("where","");
		whereSql += " and exists(select 1 from sys_org_belong where orgid = '"+mforgid+"' and BD.MFORGID=belongorgid) ";
		
		String orgID = Sqlca.getString("select oi.orgid from org_info oi,org_belong ob where oi.orgid = ob.orgid and ob.belongorgid='"+CurUser.getOrgID()+"' AND oi.orglevel = '2' ");
		String selectDate = request.getParameter("NOTCONDITION_SelectDate");
		
		if(orgID == null || "".equals(orgID))
		{
			ASResultSet rs = Sqlca.getASResultSet(new SqlObject("select count(*) from DOC_ATTACHMENT DA where fileType = 'DZ01' and BeginTime like :BeginDate and da.InputOrg = '9900' ").setParameter("BeginDate", selectDate+"%").setParameter("OrgID", orgID));
			if(rs.next())
			{
				all = rs.getInt(1);
			}
			rs.close();
		}
		else{
			ASResultSet rs = Sqlca.getASResultSet(new SqlObject("select count(*) from DOC_ATTACHMENT DA where fileType = 'DZ01' and BeginTime like :BeginDate and exists(select 1 from org_belong where orgid = :OrgID and belongorgid=da.InputOrg)").setParameter("BeginDate", selectDate+"%").setParameter("OrgID", orgID));
			if(rs.next())
			{
				all = rs.getInt(1);
			}
			rs.close();
		}
		if(all < 5)
		{
			String attachmentNo = DBKeyHelp.getSerialNo("DOC_ATTACHMENT", "ATTACHMENTNO");
			PreparedStatement pstmLog=Sqlca.getConnection().prepareStatement("insert into Doc_Attachment(DocNo,AttachmentNo,FileName,ContentType,InputTime,FileSaveMode,doccontent,InputOrg,InputUser,FILETYPE,CONTENTSTATUS,BeginTime,contentlength) "
									+"values(?,?,?,'application/octet-stream',?,'Disk',?,?,?,?,?,?,?)");
			StringBufferInputStream in = new StringBufferInputStream(whereSql);
			pstmLog.setString(1, "DZ"+attachmentNo);
			pstmLog.setString(2, attachmentNo);
			pstmLog.setString(3, "�嵥����");
			pstmLog.setString(4, StringFunction.getTodayNow());
			pstmLog.setBinaryStream(5, in,in.available());
			pstmLog.setString(6, CurUser.getOrgID());
			pstmLog.setString(7, CurUser.getUserID());
			pstmLog.setString(8, "DZ01");
			pstmLog.setString(9, "0");
			pstmLog.setString(10, selectDate+" "+StringFunction.getNow());
			pstmLog.setInt(11, 1);
			pstmLog.execute();
			pstmLog.close();
			in.close();
		}
	}
	
 %>
<%/*~END~*/%>
<script type="text/javascript">
	var flag = <%=flag%>;
	var all = <%=all%>;
	if(flag)
	{
		if(all >= 5)
		{
			alert("���ݲ�ѯ����̫�࣬��������ԡ�");
		}
		else{
			alert("�������������Ժ��ڡ��ҵĶ��ơ������ء�");
		}
	}
	else{
		alert("��ѡ�����ݲ�ѯ������");
	}

</script>
<%@ include file="/IncludeEnd.jsp"%>