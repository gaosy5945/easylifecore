<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String estateNo = CurPage.getParameter("EstateNo");
	if(estateNo == null) estateNo = "";

	ASObjectModel doTemp = new ASObjectModel("BuildingDetailList");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //����ΪGrid���
	//dwTemp.ReadOnly = "1";	 //�༭ģʽ
	dwTemp.setPageSize(10);
	dwTemp.genHTMLObjectWindow(estateNo);
	String sButtons[][] = {
			{"true","","Button","����","����","add()","","","","btn_icon_add",""},
			{"false","","Button","����","����","edit()","","","","btn_icon_detail",""},
			{"true","","Button","ɾ��","ɾ��","if(confirm('ȷʵҪɾ����?'))as_delete(0,'mySelectRow()')","","","","btn_icon_delete",""},
		};
%> 
<script type="text/javascript">
<%/*~[Describe=������¼;]~*/%>	
	function add(){
		OpenPage("/CustomerManage/PartnerManage/BuildingDetailInfo.jsp?","rightdown","");
	}
	
	<%/*~[Describe=�����򿪼�¼;]~*/%>	
	function mySelectRow(){
		var serialNo = getItemValue(0,getRow(),"SerialNo");
		if(typeof(serialNo)=="undefined" || serialNo.length==0){
			OpenPage("/Blank.jsp","rightdown","");//���û�м�¼����� �򿪿հ�ҳ��
		}else{
			OpenPage("/CustomerManage/PartnerManage/BuildingDetailInfo.jsp?"+"PSerialNo=" + serialNo +"&EstateNo=<%=estateNo%>","rightdown");
		}
	}
	
	<%/*~[Describe=�༭��¼;]~*/%>	
	function edit(){
		var serialNo = getItemValue(0,getRow(),"SerialNo");
		if(typeof(serialNo)=="undefined" || serialNo.length==0){
			alert(getHtmlMessage('1'));
			return;
		}else{
			AsControl.OpenView("/CustomerManage/PartnerManage/BuildingDetailInfo.jsp","PSerialNo=" + serialNo +",EstateNo=<%=estateNo%>","rightdown","");
		}
	}
	AsControl.OpenView("/Blank.jsp","TextToShow=����ѡ����Ӧ����Ϣ!","rightdown","");	
</script>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%><%@
 include file="/Frame/resources/include/include_end.jspf"%>
