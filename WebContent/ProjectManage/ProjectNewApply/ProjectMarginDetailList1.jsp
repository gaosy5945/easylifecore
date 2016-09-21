<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%  
    String prjSerialNo = CurPage.getParameter("SerialNo");
    if(prjSerialNo == null)  prjSerialNo = "";
    String MarginSerialNo = CurPage.getParameter("MarginSerialNo");
    if(MarginSerialNo == null) MarginSerialNo = "";  
    String AccountNo = CurPage.getParameter("AccountNo");
    if(AccountNo == null) AccountNo = "";  
  String ProjectType = CurPage.getParameter("ProjectType");
  if(ProjectType == null) ProjectType = "";
  String CustomerID = CurPage.getParameter("CustomerID");
  if(CustomerID == null) CustomerID = "";
  String ReadFlag = CurPage.getParameter("ReadFlag");
  if(ReadFlag == null) ReadFlag = "";
  String FlagType = CurPage.getParameter("FlagType");
  if(FlagType == null) FlagType = ""; 
    
  ASObjectModel doTemp = new ASObjectModel("ProjectMarginDetailList1");
  ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);

  dwTemp.Style="1";             //--����ΪGrid���--
  dwTemp.ReadOnly = "1";   //�ɱ༭ģʽ
  if(!"0107".equals(ProjectType)){
    doTemp.setVisible("CustomerName", false);
  }
  dwTemp.setParameter("MarginSerialNo", MarginSerialNo);
  dwTemp.genHTMLObjectWindow("");

  String sButtons[][] = {
      //0���Ƿ�չʾ 1��  Ȩ�޿���  2�� չʾ���� 3����ť��ʾ���� 4����ť�������� 5����ť�����¼�����  6��  7��  8��  9��ͼ�꣬CSS�����ʽ 10�����
      {"ReadOnly".equals(ReadFlag)?"false":"true","All","Button","����","����","add()","","","","",""},
      {"true","","Button","����","����","edit()","","","","",""},
      {"ReadOnly".equals(ReadFlag)?"false":"true","All","Button","ɾ��","ɾ��","if(confirm('ȷʵҪɾ����?'))as_delete(0)","","","","",""},
      };
  //�����ڵ�������׶β鿴��Ϣʱ���������ܰ�ť������
  if("DocType".equals(FlagType)){
	  sButtons[0][0]="false";
	  sButtons[1][0]="false";
	  sButtons[2][0]="false";
  }
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript" src="<%=sWebRootPath%>/ProjectManage/js/ProjectManage.js"></script>
<script type="text/javascript">
  function add(){
	  
		 AsControl.OpenPage("/ProjectManage/ProjectNewApply/ProjectMarginDetailInfo1.jsp","SerialNo=&ProjectSerialNo="+"<%=prjSerialNo%>"+"&ProjectType="+"<%=ProjectType%>"+"&CustomerID="+"<%=CustomerID%>","_self","");
		 reloadSelf();
  }
  
  function edit(){
    var SerialNo = getItemValue(0,getRow(0),"SerialNo");
    if(typeof(SerialNo) == "undefined" || SerialNo.length == 0){
      alert("��ѡ��һ����Ϣ��");
    }
    AsControl.OpenPage("/ProjectManage/ProjectNewApply/ProjectMarginDetailInfo1.jsp","SerialNo="+SerialNo+"&MarginSerialNo="+"<%=MarginSerialNo%>","_self","");
    reloadSelf();
  }
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
