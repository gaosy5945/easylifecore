<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
 <style>
 /*ҳ��С����ʽ*/
.list_div_pagecount{
	font-weight:bold;
}
/*�ܼ���ʽ*/
.list_div_totalcount{
	font-weight:bold;
}
 </style>
<%  
    String prjSerialNo = CurPage.getParameter("SerialNo");
    if(prjSerialNo == null)  prjSerialNo = "";
    //String MarginSerialNo = CurPage.getParameter("MarginSerialNo");
    //if(MarginSerialNo == null) MarginSerialNo = "";  
    String AccountNo = CurPage.getParameter("AccountNo");
    if(AccountNo == null) AccountNo = "";  
	String ProjectType = CurPage.getParameter("ProjectType");
	if(ProjectType == null) ProjectType = "";
	String CustomerID = CurPage.getParameter("CustomerID");
	if(CustomerID == null) CustomerID = "";
	
	String MarginSerialNo = "";
	ASResultSet rs = Sqlca.getASResultSet(new SqlObject("select serialNo from clr_margin_info where objectno =:ProjectSerialNo and objecttype = 'jbo.prj.PRJ_BASIC_INFO'").setParameter("ProjectSerialNo",prjSerialNo));
	if(rs.next()){
		MarginSerialNo=rs.getString("serialNo");
			if(MarginSerialNo == null) {
				MarginSerialNo = "";
			}
		}
	rs.getStatement().close();
	
  ASObjectModel doTemp = new ASObjectModel("ProjectMarginDetailList");
  ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);

  //dwTemp.Style="1";             //--����ΪGrid���--
  dwTemp.ReadOnly = "1";   //�ɱ༭ģʽ
  dwTemp.ShowSummary = "1";
  if(!"0107".equals(ProjectType)){
    doTemp.setVisible("CustomerName", false);
  }
  dwTemp.setParameter("MarginSerialNo", MarginSerialNo);
  dwTemp.genHTMLObjectWindow("");

  String sButtons[][] = {
      //0���Ƿ�չʾ 1��  Ȩ�޿���  2�� չʾ���� 3����ť��ʾ���� 4����ť�������� 5����ť�����¼�����  6��  7��  8��  9��ͼ�꣬CSS�����ʽ 10�����
      {"true","All","Button","����","����","add()","","","","",""},
      {"true","","Button","����","����","edit()","","","","",""},
      {"true","All","Button","ɾ��","ɾ��","if(confirm('ȷʵҪɾ����?'))as_delete(0)","","","","",""},
      };
%>
<HEAD>
<title>��֤�������ϸ</title>
</HEAD>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript" src="<%=sWebRootPath%>/ProjectManage/js/ProjectManage.js"></script>
<script type="text/javascript">
  function add(){
		var sReturn = ProjectManage.selectMarginInfo("<%=prjSerialNo%>");
		sReturn = sReturn.split("@");
		if(sReturn[0] == "MarginEmpty"){
		   alert("���ȱ��汣֤����Ϣ��");
		   return;
		 }else{
		    AsControl.OpenPage("/ProjectManage/ProjectNewApply/ProjectMarginDetailInfo.jsp","WSerialNo=&AccountNo="+sReturn[1]+"&MarginSerialNo="+sReturn[0]+"&ProjectType="+"<%=ProjectType%>"+"&CustomerID="+"<%=CustomerID%>"+"&ProjectSerialNo="+"<%=prjSerialNo%>","_self","");
		    reloadSelf();		    	
		 }
  }
  
  function edit(){
    var SerialNo = getItemValue(0,getRow(0),"SerialNo");
    if(typeof(SerialNo) == "undefined" || SerialNo.length == 0){
      alert("��ѡ��һ����Ϣ��");
    }
    AsControl.OpenPage("/ProjectManage/ProjectNewApply/ProjectMarginDetailInfo.jsp","WSerialNo="+SerialNo+"&MarginSerialNo="+"<%=MarginSerialNo%>"+"&ProjectSerialNo="+"<%=prjSerialNo%>"+"&ProjectType="+"<%=ProjectType%>","_self","");
    reloadSelf();
  }
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
