<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
	<%
	/*
		Author:
		Tester:
		Content: ѡ���ʼ����������
		Input Param:
		Output param:
		History Log: 

	 */
	%>
<%/*~END~*/%>
<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "ѡ���ʼ����������"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>
<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%
	//�������
	//����������
	String area = CurPage.getParameter("Area");
     area="Land";//Ĭ��Ϊ��½
%>
<%/*~END~*/%>
<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
	<%
	//ͨ����ʾģ�����ASDataObject����doTemp
	String sTempletNo = "ChooseInitDate";
	String sTempletFilter = "1=1";
	ASObjectModel doTemp = new ASObjectModel(sTempletNo,"");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	
	//����HTMLDataWindow
	dwTemp.genHTMLObjectWindow("");
	%>
<%/*~END~*/%>
<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info04;Describe=���尴ť;]~*/%>
	<%
	//����Ϊ��
		//0.�Ƿ���ʾ
		//1.ע��Ŀ�������(Ϊ�����Զ�ȡ��ǰ���)
		//2.����(Button/ButtonWithNoAction/HyperLinkText/TreeviewItem/PlainText/Blank)
		//3.��ť����
		//4.˵������
		//5.�¼�
		//6.��ԴͼƬ·��
	String sButtons[][] = {
			{"true","","Button","��ʼ��","��ʼ��","doSure()","","","",""},
			{"true","","Button","ȡ��","ȡ��","javascript:top.close();","","","",""},
		};
	%> 
<%/*~END~*/%>
<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=Info05;Describe=����ҳ��;]~*/%>
<%@include file="/Frame/resources/include/ui/include_info.jspf" %>
<%/*~END~*/%>
<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info06;Describe=���尴ť�¼�;]~*/%>
	<script type="text/javascript">
	//---------------------���尴ť�¼�------------------------------------

	/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function doSure()
	{
		var sBeginDate = getItemValue(0,0,"BeginDate");
		var sEndDate = getItemValue(0,0,"EndDate");
		//var datePara = sBeginDate+"@"+sEndDate;
		//alert(datePara);
		if(sBeginDate>=sEndDate){
			alert("��ʼ���ڱ���С�ڽ������ڡ�");
			return;
		}
		var years = sEndDate.substring(0,4) - sBeginDate.substring(0,4);
		if(years > 1){
			alert("ʱ����̫�����޸ģ�");
			return;
		}
		//sReturn=AsCredit.runFunction("BizInitDay","Area=<%=area%>&BeginDate="+sBeginDate+"&EndDate="+sEndDate);
		sReturn = AsControl.RunJavaMethodTrans("com.amarsoft.app.als.sys.holiday.BizInitDay","run","Area="+"<%=area%>"+",BeginDate="+sBeginDate+",EndDate="+sEndDate);
		top.returnValue = sReturn;
		top.close();
	}
	
	</script>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info08;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script type="text/javascript">	
</script>	
<%/*~END~*/%>

<%@ include file="/Frame/resources/include/include_end.jspf"%>
