<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String agencyType = CurPage.getParameter("AgencType");
	if(agencyType == null) agencyType = "";


	ASObjectModel doTemp = new ASObjectModel("AgencyList");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //����ΪGrid���
	//dwTemp.ReadOnly = "1";	 //�༭ģʽ
	dwTemp.setPageSize(10);
	dwTemp.genHTMLObjectWindow(agencyType);
	
	String sButtons[][] = {
			{"true","","Button","����","����","newRecord()","","","","btn_icon_add",""},
			{"true","","Button","����","�鿴","viewAndEdit()","","","","btn_icon_detail",""},
			{"true","","Button","ɾ��","ɾ��","deleteRecord()","","","","btn_icon_delete",""},
		};
%> 
<script type="text/javascript">
/*~[Describe=������¼;InputParam=��;OutPutParam=��;]~*/
	function newRecord(){
		OpenPage("/CustomerManage/PartnerManage/AgencyInfo.jsp","_self","");
	}
	
	/*~[Describe=ɾ����¼;InputParam=��;OutPutParam=��;]~*/
	function deleteRecord(){
		var serialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(serialNo)=="undefined" || serialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		
		if(confirm(getHtmlMessage('2')))//�������ɾ������Ϣ��
		{
			as_delete(0);
			//as_del(0);
		}
	}

	/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
	function viewAndEdit()
	{
		var serialNo = getItemValue(0,getRow(),"SerialNo");
		
		if (typeof(serialNo)=="undefined" || serialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		
		OpenPage("/CustomerManage/PartnerManage/AgencyInfo.jsp?SerialNo="+serialNo, "_self","");
	}

</script>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%><%@
 include file="/Frame/resources/include/include_end.jspf"%>
