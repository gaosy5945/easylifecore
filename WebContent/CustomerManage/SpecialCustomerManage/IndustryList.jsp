<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	

	String sTempletNo = CurPage.getParameter("DoNoTemplet"); //ģ����
	
	ASDataObject doTemp = new ASDataObject(sTempletNo);
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      //����ΪGrid���
	//dwTemp.ReadOnly = "1";//ֻ��ģʽ
	String orgID = CurUser.getOrgID();
	Vector vTemp = dwTemp.genHTMLDataWindow(orgID);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

  String sButtons[][] = {
          {"true","All","Button","����","����","newIndustryInfo()","","","",""},
          {"true","All","Button","�޸�","�޸�","modifyInfo()","","","",""}
      };
      
%>
<%@ include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">

	/*~[Describe=����;InputParam=��;OutPutParam=��;]~*/
	function newIndustryInfo(){
		OpenPage("/CustomerManage/SpecialCustomerManage/IndustryInfo.jsp", "_self","");
		reloadSelf();
	}
	
	/*~[Describe=��ҵ����;InputParam=��;OutPutParam=��;]~*/
	function modifyInfo(){
		var itemNo = getItemValue(0,getRow(),"ITEMNO");
		if (typeof(itemNo)=="undefined" || itemNo.length==0) 
		{
			alert("��ѡ��һ����ҵ��");
			return;
		}else{
			OpenPage("/CustomerManage/SpecialCustomerManage/IndustryInfo.jsp?ItemNo="+ itemNo, "_self","");
			reloadSelf();
		}
	}
	
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
