<%@ page contentType="text/html; charset=GBK"%>
<%@page import="com.amarsoft.dict.als.object.Item"%>
<%@page import="com.amarsoft.app.als.credit.common.model.CreditConst"%>
<%@
 include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String phaseNo=CurPage.getParameter("PhaseNo");
	if(phaseNo==null) phaseNo="0010";
	ASObjectModel doTemp = new ASObjectModel("QuickApplyList");
	doTemp.appendJboWhere(" and BusinessSource='"+CreditConst.BUSINESS_SOURCE_0101+"' "+
							"and (not exists  (select * from "+FlowConst.JBO_FLOWOBJECT+" FO1 where FO1.ObjectType='CreditApply' and FO1.ObjectNo=O.SerialNO)"+
									" or exists (select * from "+FlowConst.JBO_FLOWOBJECT+" FO2 where FO2.ObjectType='CreditApply' and FO2.PhaseNo='0003'  and FO2.ObjectNo=O.SerialNO))");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //����ΪGrid���
	//dwTemp.ReadOnly = "1";	 //�༭ģʽ
	dwTemp.setPageSize(20);
	dwTemp.genHTMLObjectWindow(CurUser.getUserID());
	
	String sButtons[][] = {
			{"true","","Button","����","����","add()","","","","",""},
			{"true","","Button","����","����","viewAndEdit()","","","","",""},
			{"true","","Button","ɾ��","ɾ��","delRecord()","","","","",""},
			{"true","","Button","�ύ","�ύ","doSubmit()","","","","",""},
		};
%> 

<%@page import="com.amarsoft.app.als.sys.tools.SystemConst"%>
<%@page import="com.amarsoft.app.als.workflow.model.FlowConst"%><script type="text/javascript">
	function add(){
		var sCompID = "QuickApplyInfo";
		var sCompURL = "/CreditManage/QuickApply/QuickApplyInfo.jsp";
		var sReturn = popComp(sCompID,sCompURL,"","dialogWidth=550px;dialogHeight=480px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		reloadSelf();		
	}

	function viewAndEdit(){
		var sObjectType = getItemValue(0,getRow(),"ObjectType");
		var sObjectNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		var sParamString = "ObjectType=CreditApply&ObjectNo="+sObjectNo;
		AsControl.OpenObjectTab(sParamString);
		reloadSelf();		
	}

	function doSubmit(){
		var sObjectNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		//����ҵ���Ƿ��Ѿ��ύ�ˣ�����û��򿪶����������ظ������������Ĵ���
		sReturn=AsCredit.doAction("0020","objectType=CreditApply");
		AsTask.doSubmit(sObjectNo,"CreditApply","<%=CurUser.getUserID()%>");
		reloadSelf();
	}
	 
	function delRecord(){
		if(!confirm('ȷʵҪɾ����?')) return;
		var returnValue = AsTask.delRecord("2014051400000007","CreditApply");
		if(returnValue == "SUCCESS"){
			alert("ɾ���ɹ���");
		}else{
			alert("ɾ��ʧ�ܣ�");
		}
		reloadSelf();
	}
</script>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%><%@
 include file="/Frame/resources/include/include_end.jspf"%>
