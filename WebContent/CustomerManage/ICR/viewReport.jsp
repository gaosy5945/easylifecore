<%@ page contentType="text/html; charset=GBK"%>
<%@
 include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
	String reportsn = CurPage.getParameter("ReportSN");
	SqlObject so = new SqlObject("select FileName,FilePath from icrp_reportmaininfo where Reportsn = :ReportSN ");
	so.setParameter("ReportSN", reportsn);
	ASResultSet rs = Sqlca.getASResultSet(so);
	if(rs.next())
	{
		String filePath = rs.getString("FilePath");
		File f = new File(filePath+"/"+reportsn+".html");
		if(f.exists())
		{
			BufferedReader in = new BufferedReader(new FileReader(f));
			String s;
			while((s=in.readLine()) !=null){
				out.println(s);
			}
			in.close();
		}
		else
		{
			out.println("文件不存在！");
		}
	}
	rs.close();
 %>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
