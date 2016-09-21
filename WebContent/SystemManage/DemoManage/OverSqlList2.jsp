<%@page import="java.sql.Connection"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%!
public String exportData(Transaction Sqlca,String filePath,String sql) throws Exception
{
	File dir = new File(filePath);
	if (!dir.exists()) {
		dir.mkdirs();
	}
	File file = new File(filePath+"/specialdatadown.csv");
	FileOutputStream os = new FileOutputStream(file);
	if(!file.exists()){
		file.createNewFile();
	}
	PreparedStatement ps = Sqlca.getConnection().prepareStatement(sql);
	ResultSet rs = ps.executeQuery();
	ResultSetMetaData rsmd = rs.getMetaData();
	int colcount = rsmd.getColumnCount();
	String header = "";
	for(int i=1;i<=colcount;i++)
	{
		header += ","+rsmd.getColumnName(i);
	}
	if("".equals(header))
	{
		throw new Exception("��ѯ���ֶΣ�");
	}else
	{
		header = header.substring(1);
	}
	//д���ͷ
	os.write(header.getBytes());
	os.write("\r\n".getBytes());
	while(rs.next()){
		StringBuffer sb = new StringBuffer();
		for(int i = 1;i <= colcount;i++){
			if(i > 1){
				sb.append(",");
			}
			String type = rsmd.getColumnTypeName(i);
			String value = "";
			if("CLOB".equals(type)){
				Clob clob = rs.getClob(i);
				if(clob != null){
					long ln = clob.length();
					if(ln <= 3000) value = clob.getSubString(1, (int)ln);
					else value = clob.getSubString(1, 3000);
				}
			}else if("NUMBER".equals(type)){
				value = DataConvert.toMoney(rs.getDouble(i)).replaceAll(",", "");
			}else{
				value = DataConvert.toString(rs.getString(i));
				try{
					Double.parseDouble(value);
					value = "["+value+"]";
				}catch(Exception e){
					//�����ֶ�
				}
			}
			if(value == null) value = "";
			if(value.indexOf(",") != -1){
				//��s����Ӣ�Ķ��ţ������滻Ϊ���Ķ���(���ķ��Ų��ᵼ��CSV����һ��)
				value = value.replaceAll(",","��");
			}
			sb.append(value);
		}
		sb.append("\r\n");
		os.write(sb.toString().getBytes());
		os.flush();
	}
	rs.close();
	ps.close();
	os.close();
	return filePath+"/specialdatadown.csv";
}


public static Map<String, Object> splitResult(Transaction Sqlca,String sql,int curPageNum) throws Exception
{
	Map<String, Object> map = new HashMap<String, Object>();
	PreparedStatement pre = null;
	ResultSet rs = null;
	ResultSetMetaData rsmd = null;
	Connection conn = null;
	ArrayList<String> colHeaderList = new ArrayList<String>();//��ű�ͷ
	ArrayList<ArrayList<String>> tabDataList = new ArrayList<ArrayList<String>>();//��ű�����
	ArrayList<String> dataList = null;
	conn = Sqlca.getConnection();
	String sSql = "select * from (select RowNum rn,tmp.* from ("+sql+") tmp)where rn between 1+25*("+curPageNum+"-1) and 25*"+curPageNum;
	pre = conn.prepareStatement(sSql);
	rs = pre.executeQuery();
	rsmd = rs.getMetaData();
	int columnCount = rsmd.getColumnCount();
	for(int i=1;i<=columnCount;i++)
	{
		colHeaderList.add(rsmd.getColumnName(i));
	}
	map.put("ColHeaderList", colHeaderList);
	while(rs.next())
	{
		dataList = new ArrayList<String>();
		for(int j=0;j<colHeaderList.size();j++)
		{
			dataList.add(rs.getString(colHeaderList.get(j)));
		}
		tabDataList.add(dataList);
	}
	map.put("TabDataList", tabDataList);
	rs.close();
	pre.close();
	//��ȡ�ܹ���ҳ��
	//String s = Sqlca.getString("select count(*) from ("+sql+")");
	int s = 0;
	pre = conn.prepareStatement(sql);
	rs = pre.executeQuery();
	while(rs.next())
	{
		s++;
	}
	pre.close();
	rs.close();
	int totalCount = Integer.valueOf(s+"");
	int pageSize = 0;
	if(totalCount%25==0)
	{
		pageSize = totalCount/25;
	}else
	{
		pageSize = totalCount/25 + 1;
	}
	map.put("PageNum", pageSize);//�ܹ�����ҳ
	map.put("PageSize", s);//�ܹ��ļ�¼
	map.put("CurPageNum",curPageNum);//��ǰ�ǵڼ�ҳ
	return map;
}
%>
<%
	//���������SQL���
	String sSqlContent = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SqlContent"));
	if(sSqlContent==null||sSqlContent.length()==0)
	{
		sSqlContent = "select sysdate from dual";  
	}
	String curPageNum = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CurPageNum"));
	if(curPageNum==null||curPageNum.length()==0)
	{
		curPageNum = "1";  
	}
	String dowLoadFlag = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("DowLoadFlag"));
	String downloadPath = CurConfig.getConfigure("DWDownloadFilePath");
	sSqlContent = SpecialTools.amarsoft2Real(sSqlContent);
	if("1".equals(dowLoadFlag))
	{
		downloadPath = exportData(Sqlca,downloadPath,sSqlContent);
		dowLoadFlag = "2";
	}
	Map<String, Object> map = null;
	ArrayList<String> colHeaderList = null;
	ArrayList<ArrayList> tabDataList = null;
	try
	{
		map = splitResult(Sqlca, sSqlContent,Integer.valueOf(curPageNum));
		colHeaderList = (ArrayList)map.get("ColHeaderList");
		tabDataList = (ArrayList)map.get("TabDataList");
	}catch(Exception e)
	{
		e.printStackTrace();
	}
%>
<%/*~END~*/%>




<html>
	<head>
	<script type="text/javascript">
		if(<%=downloadPath.endsWith("csv")%>)
		{
			popComp("DownFile","/CreditManage/HouseFund/DownFile.jsp","FileName=<%=downloadPath.substring(1)%>&FileUrl=");
		}
		function go()
		{
			var goPageNum = document.all("goPageNum").value;
			if(goPageNum == "" || goPageNum == 0)
			{
				goPageNum = "1";
			}
			var pageNum = "<%=map.get("PageNum").toString() %>";
			if(parseInt(pageNum) < parseInt(goPageNum))
			{
				alert("��������ȷ�Ĳ�ѯҳ�����ܹ���"+pageNum+"��ҳ������");
				return;
			}
			var sSqlContent = "<%=sSqlContent%>";
			sSqlContent=real2Amarsoft(sSqlContent);
			document.all("SqlContent").value = sSqlContent;
			document.getElementById("form1").action = "<%=sWebRootPath%>/SystemManage/DemoManage/OverSqlList2.jsp?CompClientID=<%=CurComp.getClientID()%>&CurPageNum="+goPageNum;
			document.getElementById("form1").submit();
		}
		function exp()
		{
			var goPageNum = document.all("goPageNum").value;
			if(goPageNum == "" || goPageNum == 0)
			{
				goPageNum = "1";
			}
			var pageNum = "<%=map.get("PageNum").toString() %>";
			if(parseInt(pageNum) < parseInt(goPageNum))
			{
				alert("��������ȷ�Ĳ�ѯҳ�����ܹ���"+pageNum+"��ҳ������");
				return;
			}
			var sSqlContent = "<%=sSqlContent%>";
			sSqlContent=real2Amarsoft(sSqlContent);
			document.all("SqlContent").value = sSqlContent;
			document.getElementById("form1").action = "<%=sWebRootPath%>/SystemManage/DemoManage/OverSqlList2.jsp?CompClientID=<%=CurComp.getClientID()%>&DowLoadFlag=1&CurPageNum="+goPageNum;
			document.getElementById("form1").submit();
		}
	</script>
	</head>
	<body>
	<form method="post" name="form1" action="" target="SQLDetailFrame">
		<table cellSpacing=0 borderColorDark=#ffffff cellPadding=3 width="98%" align=center borderColorLight=#99999 border=1>
			<tr>
				<input type=hidden name="SqlContent" value="" >
				<%
					for(int i=0;i<colHeaderList.size();i++)
					{
				%>
				<td>
					<input tpye="text" readonly="readonly" style="border:0px;" value="<%=colHeaderList.get(i) %>"/>
				</td>
				<%
					}
				%>
			</tr>
			
			<%
				ArrayList<String> tabData = null;
				for(int j=0;j<tabDataList.size();j++)
				{
					tabData = tabDataList.get(j);
			%>
			<tr>
				<%
					for(int k=0;k<tabData.size();k++)
					{
				%>
				<td>
					<input tpye="text" readonly="readonly" style="border:0px" value="<%=tabData.get(k)==null?"":tabData.get(k) %>"/>
				</td>
				<%
					}
				%>
			</tr>
			<%
				}
			%>
		</table>
		��ǰ�ǵڡ�<%=map.get("CurPageNum").toString() %>��ҳ��
		�ܹ���<%=map.get("PageNum").toString() %>��ҳ��
		ÿҳ��ʾ��25������¼���ܹ���<%=map.get("PageSize").toString() %>������¼��
		��ת����<input type="text" size="5" name="goPageNum"/>ҳ
		<input type="button" onclick="go()" value=" GO "/>
		<input type="button" onclick="exp()" value="���������"/>
	</form>
	</body>
</html>



<%@ include file="/IncludeEnd.jsp"%>
