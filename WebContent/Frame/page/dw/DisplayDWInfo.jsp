<%@page import="java.util.List"%>
<%@page import="com.amarsoft.are.jbo.*"%>
<%@ page contentType="text/html; charset=GBK"%><%
	String sDoNo = request.getParameter("dono");

	JBOFactory f = JBOFactory.getFactory();
	BizObjectManager cm = f.getManager("jbo.awe.DATAOBJECT_CATALOG");
	BizObject cbo = cm.getObject(cm.getKey().setAttributeValue("DoNo", sDoNo));

	BizObjectManager lm = f.getManager("jbo.awe.DATAOBJECT_LIBRARY");
	BizObjectQuery lq = lm.createQuery("DoNo = :DoNo").setParameter("DoNo", sDoNo);
	List<BizObject> lbos = lq.getResultList(false);
%>
<html>
	<head>
		<title><%=cbo.getAttribute("DoName").getString()%></title>
		<style type="text/css">
			* {
				font-size: 12px;
			}
			table {
				border: solid #888;
				border-width: 1px 0 0 1px;
				margin: 10px 0;
			}
			th {
				/* background: #aaa; */
			}
			th, td {
				border: solid #888;
				border-width: 0 1px 1px 0;
				white-space: nowrap;
				padding-left: 10px;
			}
		</style>
	</head>
	<body>
		<table cellpadding=0 cellspacing=0 width=100% >
			<tr><th colspan="4" bgcolor="#B0C4DE"><%=cm.getManagedClass().getLabel()%>£¨<%=cm.getManagedClass().getName()%>£©</th></tr>
			<tr><th align=left>Ò³Ãæ(url):</th><td colspan="3"><%=request.getParameter("url")%></td></tr>
<%
	for(int i = 0; i < cbo.getAttributes().length; i++){
		if(i%2 == 0) out.print("<tr>");
		out.print("<th align=left>"+cbo.getAttribute(i).getLabel()+"£¨"+cbo.getAttribute(i).getName()+"£©</th>");
		out.print("<td>"+(cbo.getAttribute(i).getString()==null?"":cbo.getAttribute(i).getString())+"&nbsp;</td>");
		if(i%2 != 0) out.print("</tr>");
	}
%>
		</table>
		
		<table cellpadding=0 cellspacing=0 width=100% >
<%
	for(int j = 0; j < lbos.size(); j++){
		if(j == 0){
			out.print("<tr><th align=left colspan="+lbos.get(j).getAttributes().length+" bgcolor=#B0C4DE >"+lm.getManagedClass().getLabel()+"£¨"+lm.getManagedClass().getName()+"£©</th></tr>");
			out.print("<tr>");
			for(int i = 0; i < lbos.get(j).getAttributes().length; i++){
				out.print("<th>"+lbos.get(j).getAttribute(i).getLabel()+"£¨"+lbos.get(j).getAttribute(i).getName()+"£©</th>");
			}
			out.print("</tr>");
		}
		out.print("<tr>");
		for(int i = 0; i < lbos.get(j).getAttributes().length; i++){
			out.print("<td>"+(lbos.get(j).getAttribute(i).getString()==null?"":lbos.get(j).getAttribute(i).getString())+"&nbsp;</td>");
		}
		out.print("</tr>");
	}
%>
		</table>
	</body>
</html>