<%@ page contentType="text/html; charset=GBK"%>
<%@ page import="com.amarsoft.xquery.*,org.w3c.dom.*"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author: 
		Tester:
		Content: 对查询条件进行处理，生成Sql
		Input Param:
		     type:查询类型
                GroupList;;Other;	:分组列表
 				SummaryList;;Other;	:汇总列表
 				OrderList;;Other;	:排序列表
 				DisplayList;;Other;	:显示列表
		Output param:
		History Log: 

	 */
	%>
<%/*~END~*/%>


<script>
	//显示的控制
	var aw = screen.availWidth;
	var ah = screen.availHeight;
	window.moveTo(0, 0);
	window.resizeTo(aw, ah);
</script>
    
    
<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量、获得参数及查询;]~*/%>
<%
	String header[][]= null;
	XQuery query = new XQuery(request.getRealPath("")+"/InfoManage/QueryManage/",(String)session.getValue("queryType"));
	Vector colList = query.getAllColumnsList();
	//获得组件参数，查询的路径和查询类型
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
			pstmLog.setString(3, "清单定制");
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
			alert("数据查询请求太多，请改日再试。");
		}
		else{
			alert("请求已受理，请稍后在【我的定制】中下载。");
		}
	}
	else{
		alert("请选择数据查询条件。");
	}

</script>
<%@ include file="/IncludeEnd.jsp"%>