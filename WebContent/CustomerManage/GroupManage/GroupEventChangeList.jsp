<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%><%
    String PG_TITLE = "���ſͻ������¼"   ; // ��������ڱ��� <title> PG_TITLE </title>  
    //�������
    String sGroupID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("GroupID"));//���ſͻ����
    String sEventType = CurComp.getParameter("EventType"); //��ͼ�ӽڵ����
	String sDisplayTemplet = CurComp.getParameter("DisplayTemplet");//��ʾģ����
	if(sGroupID == null) sGroupID = "";
	if(sEventType == null) sEventType = "";
	if(sDisplayTemplet == null) sDisplayTemplet = "";

    //ȡ��ģ���
    String sTempletNo = "GroupEventChange2";
	String sTempletFilter = "1=1";
	ASDataObject doTemp = new ASDataObject(sTempletNo,sTempletFilter,Sqlca);
	
	//���ӹ����� 
    doTemp.generateFilters(Sqlca);
    doTemp.parseFilterData(request,iPostChange);
    CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
    
    //����DataWindow
    ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
    dwTemp.setPageSize(20); //������datawindows����ʾ������
    dwTemp.Style="1"; //����DW��� 1:Grid 2:Freeform
    dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
    
    //����HTMLDataWindow
    Vector vTemp = dwTemp.genHTMLDataWindow(sGroupID);
    for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

    String sButtons[][] = {};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script language=javascript>
    AsOne.AsInit();
    init(); 
    var bHighlightFirst = true;//�Զ�ѡ�е�һ����¼
    my_load(2,0,'myiframe0');
</script>
<%@ include file="/IncludeEnd.jsp"%>