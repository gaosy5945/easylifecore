<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	ASObjectModel doTemp = new ASObjectModel("ProjectListForQuery");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //����ΪGrid���
	//dwTemp.ReadOnly = "1";	 //�༭ģʽ
	dwTemp.setPageSize(20);
	dwTemp.genHTMLObjectWindow(CurUser.getOrgID());
	
	String sButtons[][] = {
			{"true","","Button","����","����","viewTab()","","","","btn_icon_detail",""},
		};
%> 
<script type="text/javascript">

	/*~[Describe=ʹ��OpenComp������;InputParam=��;OutPutParam=��;]~*/
	function viewTab(){
		var serialNo = getItemValue(0,getRow(0),"SerialNo");
		var customerID = getItemValue(0,getRow(0),"CustomerID");
		 if (typeof(serialNo)=="undefined" || serialNo.length==0){
	         alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
	         return;
	     }
		//������ҳ��
		popComp("","/CustomerManage/PartnerManage/ProjectTab.jsp","SerialNo="+serialNo+"&CustomerID="+customerID,"");
		reloadSelf();
	}
</script>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%><%@
 include file="/Frame/resources/include/include_end.jspf"%>
