<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%><%
	String PG_TITLE = "ҳ�����ʱ����־"; // ��������ڱ��� <title> PG_TITLE </title>
	String sHeaders[][] = {
										{"UserName","�û�����"},
										{"JspName","�û����ʵ�ҳ��"},
										{"BeginTime","��ʼ����ʱ��"},
										{"EndTime","�˳�ϵͳʱ��"},
										{"TimeConsuming","ҳ������ʱ��"},
									}; 
 	String sSql = "select SessionID,RuntimeID,Userid,getUserName(Userid) as UserName,JspName, BeginTime,EndTime,TimeConsuming from user_runtime where 1=1 ";
	//����Sql���ɴ������
	ASDataObject doTemp = new ASDataObject(sSql);	
	doTemp.UpdateTable = "USER_RUNTIME";
	doTemp.setHeader(sHeaders);	
    doTemp.setKey("SessionID",true);
	doTemp.setVisible("SessionID,RuntimeID,UserID",false);	
	
	doTemp.setHTMLStyle("UserName,TimeConsuming"," style={width:80px} ");
	doTemp.setHTMLStyle("JspName"," style={width:300px} ");
	//���ö��뷽ʽ
	doTemp.setAlign("TimeConsuming","3");
	doTemp.setAlign("UserName,BeginTime,EndTime","2");
	doTemp.setAlign("JspName","1");
	doTemp.setCheckFormat("TimeConsuming","2");
	//���ɲ�ѯ��
	doTemp.setColumnAttribute("UserName,BeginTime,EndTime","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause+=" and 1=2";
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����ΪGrid���
	dwTemp.ReadOnly = "1"; //����Ϊֻ��
	dwTemp.setPageSize(20); 	//��������ҳ
	
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
				
	String sButtons[][] = {};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>
<%@include file="/IncludeEnd.jsp"%>