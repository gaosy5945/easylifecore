<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%><%
	String PG_TITLE = "�û�����ʱ����־";
	String sHeaders[][] = {
										{"ListID","���"},
										{"UserName","�û�����"},
										{"OrgName","��������"},
										{"BeginTime","��ʼ����ʱ��"},
										{"EndTime","�˳�ϵͳʱ��"},
									}; 
 	String sSql = "select SessionID,ListID,UserID,UserName,OrgID,OrgName,BeginTime,EndTime from user_list where 1=1 order by ListID";
	//����Sql���ɴ������
	ASDataObject doTemp = new ASDataObject(sSql);	
	doTemp.UpdateTable = "USER_LIST";
	doTemp.setHeader(sHeaders);	
    doTemp.setKey("SessionID",true);
	doTemp.setVisible("SessionID,UserID,OrgID",false);	
	
	//doTemp.setCheckFormat("BeginTime,EndTime","3");
	//���ɲ�ѯ��
	doTemp.setColumnAttribute("UserName,OrgName,BeginTime,EndTime","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause+=" and 1=2";
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
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