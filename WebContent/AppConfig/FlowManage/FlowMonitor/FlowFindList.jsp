<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		Describe: ���������ѯ
	 */
	String PG_TITLE = "���������ѯ"; // ��������ڱ��� <title> PG_TITLE </title>
	//���ҳ�����
	String sFlowType = CurPage.getParameter("FlowType");
    if(sFlowType == null) sFlowType = "";

	String sHeaders[][] = 	{
							   		{"SerialNo","������ˮ��"},
							   		{"ObjectNo","ҵ����ˮ��"},
                               {"PhaseNo","���̽׶κ�"},
                               {"PhaseName","���̽׶�����"},
                               {"UserName","������"},                              
                               {"OrgName","�������"},
                               {"BeginTime","��ʼ����"},
                               {"EndTime","��ֹ����"},
                               {"PhaseAction","����"}
							};
	String sSql = " select SerialNo,ObjectType,ObjectNo,PhaseNo,PhaseName, "+
                  " UserName,OrgName,BeginTime,EndTime,PhaseAction "+
                  " from FLOW_TASK where 1=1 ";
	//������������������Ӧ�Ĳ�ѯ����
	if(sFlowType.equals("01"))//����ҵ������
		sSql += " and FlowNo = 'CreditFlow' "+
				" and ObjectNo in (select "+
				" SerialNo from BUSINESS_APPLY "+
				" where OperateOrgID in (select OrgID from ORG_INFO where SortNo like '"+CurOrg.getSortNo()+"%'))";
	if(sFlowType.equals("02"))//���������������
		sSql += " and FlowNo = 'ApproveFlow' "+
				" and ObjectNo in (select "+
				" SerialNo from BUSINESS_APPROVE "+
				" where OperateOrgID in (select OrgID from ORG_INFO where SortNo like '"+CurOrg.getSortNo()+"%'))";
	if(sFlowType.equals("03"))//�Ŵ�����
		sSql += " and FlowNo = 'PutOutFlow' "+
				" and ObjectNo in (select "+
				" SerialNo from BUSINESS_PUTOUT "+
				" where OperateOrgID in (select OrgID from ORG_INFO where SortNo like '"+CurOrg.getSortNo()+"%'))";
	sSql += " and UserID <> 'system' ";
	//��sSql�������ݴ������
	ASDataObject doTemp = new ASDataObject(sSql);	
	doTemp.setHeader(sHeaders);
	//�����ֶβ��ɼ���
	doTemp.setVisible("ObjectType",false);
	//���ò�ѯ����
	doTemp.setFilter(Sqlca,"1","ObjectNo","");
	doTemp.setFilter(Sqlca,"2","PhaseName","Operators=BeginsWith,EndWith,Contains,EqualsString;");
	doTemp.setFilter(Sqlca,"3","UserName","Operators=BeginsWith,EndWith,Contains,EqualsString;");
	doTemp.setFilter(Sqlca,"4","OrgName","Operators=BeginsWith,EndWith,Contains,EqualsString;");
    
    //������������
    doTemp.GroupClause = " group by ObjectNo ";
    doTemp.OrderClause = " order by BeginTime ";
    
    doTemp.appendHTMLStyle("","style=\"cursor:pointer\" ondblclick=\"javascript:parent.viewAndEdit()\"");
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����ΪGrid���
	dwTemp.ReadOnly = "1"; //����Ϊֻ��

	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"true","","Button","�鿴ҵ������","�鿴ҵ������","viewAndEdit()","","","",""}
	};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	function viewAndEdit(){
		//��ȡ�������ͺͶ�����
		var sObjectType = getItemValue(0,getRow(),"ObjectType");
		var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		if(typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else{
			OpenObject(sObjectType,sObjectNo,"002");
		}
	}
	
	AsOne.AsInit();
	init();
	var bHighlightFirst = true;//�Զ�ѡ�е�һ����¼
	my_load(2,0,'myiframe0');
	showFilterArea();
</script>
<%@	include file="/IncludeEnd.jsp"%>