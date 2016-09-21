<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String authSerialNo = CurPage.getParameter("AuthSerialNo");
	if(authSerialNo == null || authSerialNo == "undefined") authSerialNo = "";
	ASObjectModel doTemp = new ASObjectModel("RuleSceneList");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--����ΪGrid���--
	dwTemp.ReadOnly = "1";	 //ֻ��ģʽ
	dwTemp.setParameter("AuthSerialNo", authSerialNo);
	dwTemp.setPageSize(10);
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
			{"true","","Button","������Ȩģ��","������Ȩ����","newRecord()","","","",""},
			{"true","","Button","�鿴��Ȩģ������","�༭��Ȩ����","editRecord()","","","",""},
			{"true","","Button","ɾ����Ȩģ��","ɾ����Ȩ����","deleteRecord()","","","",""},
			};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	/*~[Describe=������¼;InputParam=��;OutPutParam=��;]~*/
	function newRecord(){
		AsControl.PopView("/Common/Configurator/Authorization/RuleSceneInfo.jsp","AuthSerialNo=<%=authSerialNo%>","dialogWidth:750px;dialogHeight:700px;resizable:yes;scrollbars:no;status:no;help:no");
		reloadSelf();
	}
	
	/*~[Describe=�༭��¼;InputParam=��;OutPutParam=��;]~*/
	function editRecord(){
		var serialNo = getItemValue(0,getRow(),"SerialNo");		//--��ˮ����
		if(typeof(serialNo)=="undefined" || serialNo.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ!
		}else{
			AsControl.PopView("/Common/Configurator/Authorization/RuleSceneInfo.jsp","AuthSerialNo=<%=authSerialNo%>&SerialNo="+serialNo,"dialogWidth:750px;dialogHeight:700px;resizable:yes;scrollbars:no;status:no;help:no");
			reloadSelf();
		}
	}
	/*~[Describe=ɾ����¼;InputParam=��;OutPutParam=��;]~*/
	function deleteRecord(){
		var serialNo = getItemValue(0,getRow(),"SerialNo");		//--��ˮ����
		if(typeof(serialNo)=="undefined" || serialNo.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ!
		}else if(confirm(getHtmlMessage('2'))){//�������ɾ������Ϣ��
			as_delete('myiframe0');
		}
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
