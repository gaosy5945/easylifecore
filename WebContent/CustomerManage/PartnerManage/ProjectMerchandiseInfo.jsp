<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%><%
	/*
        Author: undefined 2016-01-10
        Content: ʾ������ҳ��
        History Log: 
    */
	String baSerialNo = CurPage.getParameter("SerialNo");//ҵ����ˮ
	if(baSerialNo == null) baSerialNo = "";
	String prjSerialno = "";
	//����ҵ����ˮ��ȡ��Ŀ��ˮ
	BizObjectManager bom = JBOFactory.getBizObjectManager("jbo.prj.PRJ_BASIC_INFO");
	List <BizObject> boList =  bom.createQuery("select * from O,jbo.prj.PRJ_RELATIVE PR where O.serialno = PR.projectserialno and PR.objecttype in('jbo.app.BUSINESS_APPLY','jbo.app.BUSINESS_CONTRACT') and PR.ObjectNo=:SerialNo and PR.relativetype IN('01','02') ").setParameter("SerialNo", baSerialNo).getResultList(false);
	if(boList==null||boList.size()<1) prjSerialno="";
	else prjSerialno = boList.get(0).getKey().getAttribute(0).getString();
	String sTempletNo = "ProjectMerchandiseInfo";//--ģ���--
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	//doTemp.setColTips("", "����");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	//dwTemp.ReadOnly = "-2";//ֻ��ģʽ
	dwTemp.genHTMLObjectWindow(prjSerialno);
	
	String sButtons[][] = {
		{"false","All","Button","����","���������޸�","as_save(0)","","","",""},
		{"false","All","Button","����","�����б�","returnList()","","","",""}
	};
	sButtonPosition = "north";
%><%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	function returnList(){
		 AsControl.OpenView("", "","_self","");
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>