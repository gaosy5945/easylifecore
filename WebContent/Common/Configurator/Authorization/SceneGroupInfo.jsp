<%@page import="com.amarsoft.app.base.util.DateHelper"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%><%
	String PG_TITLE = "��Ȩ�����Ϣ"; // ��������ڱ��� <title> PG_TITLE </title>
	//����������
	String sGroupID = CurPage.getParameter("GroupID");
	String sSortNo = "";
	//����ֵת���ɿ��ַ���
	if(sGroupID.length()==0) {
		//---------��GroupIdΪ��ʱ,��Ϊ��������,���������
		DecimalFormat format = new DecimalFormat("00");
		String sortBase = DateHelper.getCurDateByFormat("yyMMddHH");		//����Ź���yyMMddHHxx00
		ASResultSet resultset = Sqlca.getASResultSet("select count(*) as RowCount from SADRE_SCENEGROUP O where O.SORTNO like '"+sortBase+"%'");
		if(resultset.next()){
			int rowCount = resultset.getInt("RowCount");
			sSortNo = sortBase+format.format(++rowCount)+"01";
		}
		resultset.getStatement().close();
	}
		
	//ͨ����ʾģ�����ASDataObject����doTemp
	String sTempletNo = "AuthorGroupInfo";
	//����ģ�����������ݶ���	
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request); 
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sGroupID);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
		
	String sButtons[][] = {
		{"true","","Button","����","����","doCreation()","","","",""},
	};
%><%@include file="/Frame/resources/include/ui/include_info.jspf" %>
<script language=javascript>
	/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecord(sPostEvents){                
        <%if (sGroupID==null || sGroupID.length()==0){%>//��ʾֻ�������Ż����»�ȡ��ˮ
			initSerialNo();
		<%}%>
        as_save("myiframe0",sPostEvents);
        parent.reloadSelf();
    }
	
	/*~[Describe=����һ�����������¼;InputParam=��;OutPutParam=��;]~*/
	function doCreation(){
		saveRecord("doReturn()");
	}
	
	function doReturn(){
		top.returnValue = getItemValue(0,0,"GROUPID");
	}
								
	/*~[Describe=ҳ��װ��ʱ����DW���г�ʼ��;InputParam=��;OutPutParam=��;]~*/
	function initRow(){
		if (getRowCount(0)==0){
			as_add("myiframe0");//����һ���ռ�¼			
			setItemValue(0,0,"SORTNO","<%=sSortNo%>");
		}
    }
	
	/*~[Describe=��ʼ����ˮ���ֶ�;InputParam=��;OutPutParam=��;]~*/
	function initSerialNo(){
		var sTableName = "SADRE_SCENEGROUP";//����
		var sColumnName = "GROUPID";//�ֶ���
		var sPrefix = "";//ǰ׺
								
		//ʹ��GetSerialNo.jsp����ռһ����ˮ��
		//var sSerialNo = PopPage("/Common/ToolsB/GetSerialNo.jsp?TableName="+sTableName+"&ColumnName="+sColumnName+"&Prefix="+sPrefix,"","resizable=yes;dialogWidth=0;dialogHeight=0;center:no;status:no;statusbar:no");
		var sSerialNo = getSerialNo(sTableName,sColumnName,sPrefix);
		//����ˮ�������Ӧ�ֶ�
		setItemValue(0,getRow(),sColumnName,sSerialNo);
	}

	initRow();
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>